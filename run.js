const puppeteer = require('puppeteer-core');
const SmartBuffer = require('smart-buffer').SmartBuffer;
const getPixels = require("get-pixels")
const findChrome = require('chrome-finder');
const awaitifyStream = require('awaitify-stream');
const { getElements } = require("./getElements");
const uuid = require('uuid/v1');

Array.prototype.flat = function() { return this.reduce((acc, x) => acc.concat(x), []); };
Array.prototype.flatMap = function(mapper) { return this.map(mapper).flat(); };

SmartBuffer.prototype.writeStringPrependSize = function(string) {
  const buffer = Buffer.from(string, "utf8");
  this.writeUInt32LE(buffer.length);
  this.writeBuffer(buffer);
}

const ID_ATTRIBUTE = "data-magic-mouse-id";
const IMAGE_FORMAT = "jpeg"; // "raw", "jpeg", "png"

console.error('Node.js arguments', process.argv);
console.error('Image format', IMAGE_FORMAT);

const run = async () => {
  const url = process.argv[process.argv.length - 5];
  const screenSize = {
    x: parseInt(process.argv[process.argv.length - 4], 10),
    y: parseInt(process.argv[process.argv.length - 3], 10),
  };
  const headless = process.argv[process.argv.length - 2] === "headless";
  const chromeProfilePath = process.argv[process.argv.length - 1];

  const terminate = async () => {
    console.error("Terminating...");
    // await page.stopScreencast();
    await browser.close();
    process.exit();
  };

  const sendCommand = (buffer) => {
    const lenBuffer = new Buffer(4);
    lenBuffer.writeUInt32BE(buffer.length);
    process.stdout.write(lenBuffer);
    process.stdout.write(buffer);
  }

  const browser = await puppeteer.launch({
    ignoreDefaultArgs: true,
    args: [
      '--enable-automation',
      ...(headless ? ['--headless'] : []),
      // '--start-fullscreen',
      "--force-device-scale-factor=1",
      `--user-data-dir=${chromeProfilePath}`,
    ],
    executablePath: findChrome()
  });
  const page = await browser.newPage();
  await page.setBypassCSP(true);
  await page.setUserAgent('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.100 Safari/537.36');
  await page.setViewport({width: screenSize.x, height: screenSize.y});

  process.on('SIGTERM', terminate);

  const instrumentGoogleSlides = async () => {
    if (!page.url().startsWith('https://docs.google.com/presentation')) {
      return;
    }
    console.error("Instrumenting Google Slides");
    const morphPositions = (await Promise.all(page.frames()
      .filter(frame => !frame.isDetached())
      .map(async frame => frame.evaluate((ID_ATTRIBUTE) =>
        Promise.all(Array.from(new Set(Array.from(document.querySelectorAll('.punch-viewer-svgpage g[id*="paragraph"]'))
          .map(element => element.parentNode)))
          .map(element => ({
            element,
            text: Array.from(element.querySelectorAll('g[id*="paragraph"]'))
              .map(paragraph => Array.from(paragraph.querySelectorAll('.sketchy-text-content-text text'))
                .map(text => text.textContent)
                .join(" "))
              .join("\r")
          }))
          .filter(tmp => tmp.text.startsWith('!'))
          .map(tmp => {
            let element = tmp.element;
            let path = null;
            do {
              element = element.parentNode;
              path = element.querySelector('path');
            } while (path === null);
            return {...tmp, path};
          })
          .map(async tmp => {
            const rect = tmp.path.getBoundingClientRect();

            let id = tmp.path.getAttribute(ID_ATTRIBUTE);
            if (!id) {
              id = await window.uuid();
              tmp.path.setAttribute(ID_ATTRIBUTE, id);
            }

            return {
              id,
              type: 'morph',
              x: rect.x,
              y: rect.y,
              w: rect.width,
              h: rect.height,
              data: tmp.text,
            };
          })), ID_ATTRIBUTE)))).flat();

      console.error("Google Slides Morph Positions", morphPositions);
      morphPositions.forEach(sendPortalDataCommand);
  }

  const instrumentGitHub = async () => {
    if (!page.url().startsWith('https://github.com/')) {
      return;
    }
    console.error("Instrumenting clone button");
    page.evaluate(() => {
      const bar = document.getElementsByClassName("file-navigation");
      if (bar.length === 0) {
        return;
      }

      const urlField = document.querySelector(".https-clone-options input");
      if (!urlField) {
        return;
      }
      const cloneUrl = urlField.value;
      let name = cloneUrl.split("/")[4];
      name = name.substr(0, name.length - 4);
      bar[0].insertAdjacentHTML("beforeEnd", `<span class="btn btn-sm btn-primary ml-2" onClick="gitClone('` + name + `', '` + cloneUrl + `')">Clone to Squeak</span>`);

      const normalCloneButton = document.getElementsByClassName("get-repo-select-menu");
      if (normalCloneButton.length === 0 || normalCloneButton[0].children.length === 0) {
        return;
      }
      normalCloneButton[0].children[0].classList.remove("btn-primary");
    });
  }

  const parseLDJsons = async () => {
    const ldJsons = await page.$$eval(
      'script[type="application/ld+json"]',
      nodes => nodes.map(node => JSON.parse(node.innerText)));
    console.error("LD JSON", ldJsons);
    const buf = new SmartBuffer();
    buf.writeString("s");
    buf.writeUInt32LE(ldJsons.length);
    ldJsons.forEach(ldJson => {
      const json = JSON.stringify(ldJson);
      buf.writeStringPrependSize(json);
    })
    await sendCommand(buf.toBuffer());
  }

  const ignoreExecutionContextDestroyed = (error) => {
    // Sometimes the frame is destroyed right after navigation, thus throwing an error
    // when trying to evaluate a function in the frame's context. That's why we catch
    // those errors here.
    if (!error.message.endsWith('Execution context was destroyed, most likely because of a navigation.') &&
      !error.message.endsWith('Cannot find context with specified id')) {
      throw error;
    }
  }

  page.on('framenavigated', async (frame) => {
    await new Promise(resolve => setTimeout(() => resolve(), 50));
    try {
      await parseLDJsons();
      await instrumentGoogleSlides();
      await instrumentGitHub();

      if (!frame.parentFrame()) {
        const url = page.url();
        console.error(`Navigating to ${url}`);
        const buf = new SmartBuffer();
        buf.writeString("l");
        buf.writeString(url);
        sendCommand(buf.toBuffer());
      }
    } catch (error) {
      ignoreExecutionContextDestroyed(error);
    }
  });

  page.on('domcontentloaded', async () => {
    await parseLDJsons();
    // TODO: Is this needed when we have framenavigated?
    // await instrumentGitHub();
    // await instrumentGoogleSlides();
  });

  const refreshTrackedElements = async () => {
    const trackedElements = (await Promise.all(page.frames()
      .filter(frame => !frame.isDetached())
      .map(frame => frame.evaluate(getElements, "refreshInfo").catch(error => {
        ignoreExecutionContextDestroyed(error);
        return [];
      })))).flat();
    // console.error(trackedElements);
    const buf = new SmartBuffer();
    buf.writeString("hr"); // portal refresh
    buf.writeUInt32LE(trackedElements.length);
    trackedElements.forEach(element => buf
      .writeStringNT(element.id)
      .writeInt32LE(element.x)
      .writeInt32LE(element.y)
      .writeInt32LE(element.w)
      .writeInt32LE(element.h)
    );
    sendCommand(buf.toBuffer());
  }

  page.on('screencastframe', async frame => {
    const screenshot = Buffer.from(frame.data, 'base64');

    const buf = new SmartBuffer();
    if (IMAGE_FORMAT === "png") {
      buf.writeString("ip");
      buf.writeBuffer(screenshot);
    } else if (IMAGE_FORMAT === "jpeg") {
        buf.writeString("ij");
        buf.writeBuffer(screenshot);
    } else if (IMAGE_FORMAT === "raw") {
      const pixels = await new Promise((resolve, reject) => getPixels(screenshot, 'image/png', (err, pixels) => {
        if (err) {
          reject(err);
        } else {
          resolve(pixels);
        }
      }));
      buf.writeString("ir");
      buf.writeUInt32LE(pixels.shape[0]);
      buf.writeUInt32LE(pixels.shape[1]);
      buf.writeBuffer(Buffer.from(pixels.data));
    } else {
      throw new Error(`Unsupported image format ${IMAGE_FORMAT}.`);
    }
    sendCommand(buf.toBuffer());

    await refreshTrackedElements();

    await page.screencastFrameAck(frame.sessionId);
    console.error(`Sent frame at ${Date.now() / 1000}`);
  });

  await page.exposeFunction("uuid", () => uuid());
  await page.exposeFunction("gitClone", async (name, url) => {
    console.error("GIT CLONE", name, url)
    const buf = new SmartBuffer();
    buf.writeString("g");
    buf.writeStringPrependSize(name);
    buf.writeString(url);
    await sendCommand(buf.toBuffer());
  });

  const sendPortalDataCommand = (data) => {
    const buf = new SmartBuffer();
    switch (data.type) {
      case 'img':
      case 'canvas':
        buf.writeString("hi");
        break;
      case 'pre':
        buf.writeString("hc");
        break;
      case 'morph':
        buf.writeString('hm');
        break;
    }
    buf.writeStringNT(data.id);
    buf.writeInt32LE(data.x);
    buf.writeInt32LE(data.y);
    buf.writeInt32LE(data.w);
    buf.writeInt32LE(data.h);
    switch (data.type) {
      case 'img':
      case 'canvas':
        buf.writeBuffer(Buffer.from(data.data, 'base64'));
        break;
      case 'pre':
      case 'morph':
        buf.writeString(data.data);
        break;
    }
    sendCommand(buf.toBuffer());
  }

  // TODO: This throws an error in case the page can't be reached (e.g., when you have no network connection)
  console.error(`Navigating to ${url}`);
  await page.goto(url);

  console.error('Starting screencast...');
  await page.startScreencast({format: IMAGE_FORMAT === "jpeg" ? "jpeg" : "png", everyNthFrame: 1});
  console.error("Recording screencast...");

  const reader = awaitifyStream.createReader(process.stdin);
  while (true) {
    const size = (await reader.readAsync(4)).readUInt32BE();
    console.error(`Waiting for payload of size ${size}`);
    const command = String.fromCharCode((await reader.readAsync(1)).readUInt8());
    const payload = size > 1 ? SmartBuffer.fromBuffer(await reader.readAsync(size - 1)) : new SmartBuffer();
    console.error(`Received command ${command} with payload of size ${size}.`);

    switch (command) {
      case 's': {
        const x = payload.readInt32LE();
        const y = payload.readInt32LE();
        const str = payload.readString();
        console.error(`Dropped String at ${x}@${y}: "${str}"`);

        await page.evaluateHandle((x, y, str) => {
          const field = document.elementsFromPoint(x, y)
            .find(element => ["INPUT", "TEXTAREA"].includes(element.tagName) || element.contentEditable === "true");
          if (!field) {
            return;
          }
          if (field.tagName === "INPUT") {
            field.value = str;
          } else {
            field.innerText = str;
          }
        }, x, y, str);
        break;
      } case 'f':
        const x = payload.readInt32LE();
        const y = payload.readInt32LE();
        console.error(`DROPPED MORPH AT ${x}@${y}`);

        const form = await page.evaluateHandle((x, y) => document.elementsFromPoint(x, y)
          .find(element => element.tagName === "FORM"), x, y);

        const fields = (await form.jsonValue()) !== undefined ? await form.$$("input:not([type=checkbox])") /* , select */ : [];

        const buf = new SmartBuffer();
        buf.writeString("f");
        const inputs = (await Promise.all(fields.map(async field => {
          if ((await (await field.getProperty('offsetParent')).jsonValue()) === null) {
            return undefined;
          }
          let description = await (await field.getProperty("placeholder")).jsonValue();
          if (description === undefined || description.length === 0) {
            description = await (await field.getProperty("name")).jsonValue();
          }
          if (description === undefined || description.length === 0) {
            return undefined;
          }
          const box = (await field.boxModel()).content;
          console.error(box);
          const boundingBox = {
            x: Math.round(box[0].x),
            y: Math.round(box[0].y),
            width: Math.round(box[2].x - box[0].x),
            height: Math.round(box[2].y - box[0].y),
          };
          console.error(boundingBox);
          return {
            boundingBox,
            description: description,
            id: await (await page.evaluateHandle(async (element, ID_ATTRIBUTE) => {
              let id = element.getAttribute(ID_ATTRIBUTE);
              if (!id) {
                id = await window.uuid();
                element.setAttribute(ID_ATTRIBUTE, id);
              }
              return id;
            }, field, ID_ATTRIBUTE)).jsonValue()
          }
        }))).filter(input => input !== undefined);
        buf.writeInt32LE(inputs.length);
        inputs.forEach(({boundingBox, description, id}) => {
          buf.writeInt32LE(boundingBox.x);
          buf.writeInt32LE(boundingBox.y);
          buf.writeInt32LE(boundingBox.width);
          buf.writeInt32LE(boundingBox.height);
          buf.writeStringPrependSize(description);
          buf.writeStringPrependSize(id);
        })
        sendCommand(buf.toBuffer());
        break;
      case 't':
        const id = payload.readString(payload.readInt32LE());
        const text = payload.readString(payload.readInt32LE());
        console.error(`Update Text: ${id} ${text}`);
        await page.evaluate((id, text, ID_ATTRIBUTE) => {
          const element = document.querySelector(`[${ID_ATTRIBUTE}="${id}"]`);
          if (!element) {
            return;
          }
          if (element.tagName === "INPUT") {
            element.value = text;
          } else if (element.tagName === "SELECT") {
            const option = Array.from(element.options)
              .find(option => option.innerText.toLocaleLowerCase() === text.toLocaleLowerCase());
            if (option) {
              element.value = option.value;
            }
          }
        }, id, text.trim(), ID_ATTRIBUTE);
        break;
      case 'k':
        // This command is necessary because the Squeak ProcessWrapper is unable to terminate processes.
        await terminate();
        break;
      case 'l':
        const url = payload.readString();
        console.error(`Navigating to ${url}`);
        try {
          await page.goto(url);
        } catch (error) {
          console.error(error);
        }
        break;
      case 'e':
        // TODO check read boundaries for each event type
        const eventType = payload.readUInt8();
        console.error('Received event type', eventType);
        switch (eventType) {
          case 0:
            page.mouse.up({ button: "left" });
            break;
          case 1:
            page.mouse.down({ button: "left" });
            break;
          case 2:
            page.mouse.up({ button: "right" });
            break;
          case 3:
            page.mouse.down({ button: "right" });
            break;
          case 4: {
            const x = payload.readUInt32LE();
            const y = payload.readUInt32LE();
            console.error('Moving to', x, y);
            page.mouse.move(x, y);
            break;
          } case 5:
            let squeakKeyString = payload.readString(size, "ascii");

            let keyName;
            const modifiers = [];
            if (squeakKeyString.startsWith("<Cmd-")) {
              modifiers.push("ControlLeft"); // Not a typo. Squeak send <Cmd-a> when pressing CTRL+A on Windows
              squeakKeyString = squeakKeyString.replace("Cmd-", "");
            }
            if (squeakKeyString.startsWith("<Ctrl-")) {
              modifiers.push("ControlLeft");
              squeakKeyString = squeakKeyString.replace("Ctrl-", "");
            }
            if (squeakKeyString.startsWith("<Shift-")) {
              modifiers.push("ShiftLeft");
              squeakKeyString = squeakKeyString.replace("Shift-", "");
            }

            if (squeakKeyString.length === 3 && squeakKeyString[0] === "<" && squeakKeyString[2] === ">") {
              squeakKeyString = squeakKeyString[1];
            }

            if (squeakKeyString.length > 1) {
              const conversion = {
                '<space>': 'Space',
                '<tab>': 'Tab',
                '<cr>': 'Enter',
                '<lf>': 'Enter',
                '<enter>': 'Enter',
                '<backspace>': 'Backspace',
                '<delete>': 'Delete',
                '<escape>': 'Escape',
                '<down>': 'ArrowDown',
                '<up>': 'ArrowUp',
                '<left>': 'ArrowLeft',
                '<right>': 'ArrowRight',
                '<end>': 'End',
                '<home>': 'Home',
                '<pageDown>': 'PageDown',
                '<pageUp>': 'PageUp',
                // '<euro>': '', // TODO
                '<insert>': 'Insert',
              };
              keyName = conversion[squeakKeyString];
              if (keyName === undefined) {
                console.error('Unknown key', squeakKeyString);
                break;
              }
            } else {
              keyName = squeakKeyString;
            }
            console.error('Typing', squeakKeyString, modifiers);
            try {
              await Promise.all(modifiers.map(key => page.keyboard.down(key)));
              await page.keyboard.press(keyName);
              await Promise.all(modifiers.map(key => page.keyboard.up(key)));
            } catch (error) {
              console.error(error);
            }
            break;
          case 6: {
            const x = payload.readUInt32LE();
            const y = payload.readUInt32LE();
            page.setViewport({width: x, height: y});
            break;
          } case 7: {
            const y = payload.readUInt32LE();
            console.error('scroll', y);
            page.evaluate((y) => window.scrollBy(0, y == 0 ? -20 : 20), y);
            break;
          } case 8: {
            // These are relative to the visible part of the page, not the top left corner
            const x = payload.readUInt32LE();
            const y = payload.readUInt32LE();
            console.error(`Portal event at ${x},${y}`);

            let elements;
            try {
              elements = await page.evaluate(getElements, "extractElements", x, y);
            } catch (error) {
              elements = [];
              console.error(error);
            }
            if (elements.length === 0) {
              console.error("No elements found to create a portal");
              break;
            }
            const element = elements[0];
            console.error({id: element.id, type: element.type, x: element.x, y: element.y, w: element.w, h: element.h});

            sendPortalDataCommand(element);
            break;
          } case 9: {
            console.error("go back");
            await page.goBack();
            break;
          } case 10: {
            console.error("go forward");
            await page.goForward();
            break;
          }
        }
        break;
    }
  }
};

// We catch all errors, log them to the console and exit.
run().catch(error => console.error(error));
