const puppeteer = require('puppeteer-core');
const SmartBuffer = require('smart-buffer').SmartBuffer;
const getPixels = require("get-pixels")
const findChrome = require('chrome-finder');
const awaitifyStream = require('awaitify-stream');
const { getImages } = require("./getImages");

const IMAGE_FORMAT = "png"; // "raw" or "png"

const run = async () => {
  const url = process.argv[process.argv.length - 1];

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
  await page.setUserAgent('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.100 Safari/537.36');
  await page.setViewport({width: 640, height: 480});

  // TODO: This throws an error in case the page can't be reached (e.g., when you have no network connection)
  console.error(`Navigating to ${url}`);
  await page.goto(url);

  process.on('SIGTERM', terminate);

  page.on('screencastframe', async frame => {
    const screenshot = Buffer.from(frame.data, 'base64');

    const buf = new SmartBuffer();
    if (IMAGE_FORMAT === "png") {
      buf.writeString("ip");
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

    await page.screencastFrameAck(frame.sessionId);
    console.error(`Sent frame at ${Date.now() / 1000}`);
  });

  await page.startScreencast({format: 'png', everyNthFrame: 1});
  console.error("Recording screencast...");

  const reader = awaitifyStream.createReader(process.stdin);
  while (true) {
    const size = (await reader.readAsync(4)).readUInt32BE();
    console.error(`Waiting for payload of size ${size}`);
    const command = String.fromCharCode((await reader.readAsync(1)).readUInt8());
    const payload = size > 1 ? SmartBuffer.fromBuffer(await reader.readAsync(size - 1)) : new SmartBuffer();
    console.error(`Received command ${command} with payload of size ${size}.`);

    switch (command) {
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
            const images = await page.evaluate(getImages, x, y);
            if (images.length === 0) {
              break;
            }
            const image = images[0];
            console.error({x: image.x, y: image.y, w: image.w, h: image.h});

            const buf = new SmartBuffer();
            buf.writeString("hi"); // halo image
            buf.writeInt32LE(image.x);
            buf.writeInt32LE(image.y);
            buf.writeInt32LE(image.w);
            buf.writeInt32LE(image.h);
            buf.writeBuffer(Buffer.from(image.data, 'base64'));
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
