const puppeteer = require('puppeteer-core');
const SmartBuffer = require('smart-buffer').SmartBuffer;
const getPixels = require("get-pixels")
const findChrome = require('chrome-finder');
const awaitifyStream = require('awaitify-stream');
const { getElements } = require("./getElements");
const uuid = require('uuid/v1');

const ID_ATTRIBUTE = "data-magic-mouse-id";
const IMAGE_FORMAT = "jpeg"; // "raw", "jpeg", "png"

const run = async () => {
  const url = process.argv[process.argv.length - 3];
  const screenSize = {
    x: parseInt(process.argv[process.argv.length - 2], 10),
    y: parseInt(process.argv[process.argv.length - 1], 10),
  };

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
    ignoreDefaultArgs: [
      "--hide-scrollbars", // show scrollbars
      "--mute-audio", // enable audio
      // "--headless", // launch browser in normal window

      // Other possible flags to remove
      // "--disable-renderer-backgrounding", "--disable-features", "--disable-dev-shm-usage", "--disable-background-networking"
    ],
    // I read somewhere that this makes it faster.
    // args: ["--proxy-server='direct://'", '--proxy-bypass-list=*'],
    executablePath: findChrome()
  });
  const page = await browser.newPage();
  await page.setBypassCSP(true);
  await page.setUserAgent('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.100 Safari/537.36');
  await page.setViewport({width: screenSize.x, height: screenSize.y});

  process.on('SIGTERM', terminate);

  page.on('framenavigated', (frame) => {
    const url = page.url();
    if (frame.parentFrame()) {
      console.error(`IGNORE: sub-frame navigating to ${url}`);
      return;
    }
    console.error(`Navigating to ${url}`);
    const buf = new SmartBuffer();
    buf.writeString("l");
    buf.writeString(url);
    sendCommand(buf.toBuffer());
  })
  page.on('domcontentloaded', async () => {
    console.error("domcontentloaded");
    const ldJsons = await page.$$eval(
      'script[type="application/ld+json"]',
      nodes => nodes.map(node => JSON.parse(node.innerText)));
    console.error("LD JSON", ldJsons);
    const buf = new SmartBuffer();
    buf.writeString("s");
    buf.writeUInt32LE(ldJsons.length);
    ldJsons.forEach(ldJson => {
      const json = JSON.stringify(ldJson);
      // We need to get the length of the string in its encoded form, not when it is still a JS string, since
      // "物".length == 1 whereas Buffer.from("物").length == 3.
      const strBuf = Buffer.from(json);
      buf.writeUInt32LE(strBuf.length);
      buf.writeBuffer(strBuf);
    })
    await sendCommand(buf.toBuffer());

    if (page.url().startsWith('https://github.com/')) {
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
  });

  const refreshTrackedElements = async () => {
    const trackedElements = await page.evaluate(getElements, "refreshInfo");
    console.error(trackedElements);
    const buf = new SmartBuffer();
    buf.writeString("hr"); // halo refresh
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
    const strBuf = Buffer.from(name);
    buf.writeUInt32LE(strBuf.length);
    buf.writeBuffer(strBuf);
    buf.writeString(url);
    await sendCommand(buf.toBuffer());
  });

  // TODO: This throws an error in case the page can't be reached (e.g., when you have no network connection)
  console.error(`Navigating to ${url}`);
  await page.goto(url);

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
      case 'f':
        const x = payload.readInt32LE();
        const y = payload.readInt32LE();
        console.error(`DROPPED MORPH AT ${x}@${y}`);

        const form = await page.evaluateHandle((x, y) => document.elementsFromPoint(x, y)
          .find(element => element.tagName === "FORM"), x, y);

        const fields = await form.$$("input, select");

        const buf = new SmartBuffer();
        buf.writeString("f");
        buf.writeInt32LE(fields.length);
        const inputs = await Promise.all(fields.map(async field => {
          let description = await (await field.getProperty("placeholder")).jsonValue();
          if (description === undefined) {
            description = await (await field.getProperty("name")).jsonValue();
          }
          return {
            boundingBox: await field.boundingBox(),
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
        }));
        inputs.forEach(({boundingBox, description, id}) => {
          buf.writeInt32LE(boundingBox.x);
          buf.writeInt32LE(boundingBox.y);
          buf.writeInt32LE(boundingBox.width);
          buf.writeInt32LE(boundingBox.height);

          const strBuf = Buffer.from(description);
          buf.writeUInt32LE(strBuf.length);
          buf.writeBuffer(strBuf);

          const strBuf2 = Buffer.from(id);
          buf.writeUInt32LE(strBuf2.length);
          buf.writeBuffer(strBuf2);
        })
        sendCommand(buf.toBuffer());
        break;
      case 't':
        const id = payload.readString(payload.readInt32LE());
        const text = payload.readString(payload.readInt32LE());
        console.error(`Update Text: ${id} ${text}`);
        await page.evaluate((id, text, ID_ATTRIBUTE) => {
          const element = document.querySelector(`[${ID_ATTRIBUTE}="${id}"]`);
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
        await page.goto(url);
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
          case 2: {
            const x = payload.readUInt32LE();
            const y = payload.readUInt32LE();
            console.error('Moving to', x, y);
            page.mouse.move(x, y);
            break;
          } case 3:
            const squeakKeyString = payload.readString(size, "ascii");
            let keyName;
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
            } else {
              keyName = squeakKeyString;
            }
            console.error('Typing', squeakKeyString, keyName);

            await page.keyboard.press(keyName);
            break;
          case 4: {
            const x = payload.readUInt32LE();
            const y = payload.readUInt32LE();
            page.setViewport({width: x, height: y});
            break;
          } case 5: {
            const y = payload.readUInt32LE();
            console.error('scroll', y);
            page.evaluate((y) => window.scrollBy(0, y == 0 ? -20 : 20), y);
            break;
          } case 6: {
            // These are relative to the visible part of the page, not the top left corner
            const x = payload.readUInt32LE();
            const y = payload.readUInt32LE();
            console.error(`Halo event at ${x},${y}`);

            const elements = await page.evaluate(getElements, "extractElements", x, y);
            if (elements.length === 0) {
              break;
            }
            const element = elements[0];
            console.error({id: element.id, type: element.type, x: element.x, y: element.y, w: element.w, h: element.h});

            const buf = new SmartBuffer();
            switch (element.type) {
              case 'img':
              case 'canvas':
                buf.writeString("hi");
                break;
              case 'pre':
                buf.writeString("hc");
                break;
            }
            buf.writeStringNT(element.id);
            buf.writeInt32LE(element.x);
            buf.writeInt32LE(element.y);
            buf.writeInt32LE(element.w);
            buf.writeInt32LE(element.h);
            switch (element.type) {
              case 'img':
              case 'canvas':
                buf.writeBuffer(Buffer.from(element.data, 'base64'));
                break;
              case 'pre':
                buf.writeString(element.data);
                break;
            }
            sendCommand(buf.toBuffer());
            break;
          }
        }
        break;
    }
  }
};

// We catch all errors, log them to the console and exit.
run().catch(error => console.error(error));
