const puppeteer = require('puppeteer');
const util = require("util");
const SmartBuffer = require('smart-buffer').SmartBuffer;
const getPixels = require("get-pixels")

const wait = util.promisify(setTimeout);

const IMAGE_FORMAT = "raw"; // "raw" or "png"

(async () => {
  const browser = await puppeteer.launch({
    ignoreDefaultArgs: [
      "--hide-scrollbars", // show scrollbars
      "--mute-audio", // enable audio
      // "--headless", // launch browser in normal window

      // Other possible flags to remove-
      // "--disable-renderer-backgrounding", "--disable-features", "--disable-dev-shm-usage", "--disable-background-networking"
    ],
    // I read somewhere that this makes it faster.
    // args: ["--proxy-server='direct://'", '--proxy-bypass-list=*'],
    executablePath: "/usr/bin/chromium-browser"
  });
  const page = await browser.newPage();
  await page.setUserAgent('Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/69.0.3497.100 Safari/537.36');
  await page.setViewport({width: 640, height: 480});
  await page.goto('https://google.com');

  let currentStdinBuffer = new SmartBuffer();
  process.stdin.on('data', async chunk => {
    currentStdinBuffer.writeBuffer(chunk);

    while (currentStdinBuffer.length) {
      const command = String.fromCharCode(currentStdinBuffer.readUInt8());
      const size = currentStdinBuffer.readUInt32BE();
      console.error('Received command', command, currentStdinBuffer.length, size);
      let x, y;
      switch (command) {
        case 'e':
          // TODO check read boundaries for each event type
          const eventType = currentStdinBuffer.readUInt8();
          console.error('Received event type', eventType);
          switch (eventType) {
            case 0:
              page.mouse.up({ button: "left" });
              break;
            case 1:
              page.mouse.down({ button: "left" });
              break;
            case 2:
              x = currentStdinBuffer.readUInt32LE();
              y = currentStdinBuffer.readUInt32LE();
              console.error('Moving to', x, y);
              page.mouse.move(x, y);
              break;
            case 3:
              const squeakKeyString = currentStdinBuffer.readString(size, "ascii");
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
            case 4:
              x = currentStdinBuffer.readUInt32LE();
              y = currentStdinBuffer.readUInt32LE();
              page.setViewport({width: x, height: y});
              break;
          }
          break;
      }
      // Construct a new buffer with the remaining content.
      currentStdinBuffer = SmartBuffer.fromBuffer(currentStdinBuffer.readBuffer());
    }
  });

  process.on('SIGTERM', async () => {
    await page.stopScreencast();
    await browser.close();
    process.exit();
  });

  page.on('screencastframe', async frame => {
    const screenshot = Buffer.from(frame.data, 'base64');

    if (IMAGE_FORMAT === "png") {
      const buf = new SmartBuffer();
      buf.writeString("ip");
      buf.writeUInt32BE(screenshot.length);
      process.stdout.write(buf.toBuffer());
      process.stdout.write(screenshot);
    } else if (IMAGE_FORMAT === "raw") {
      const pixels = await new Promise((resolve, reject) => getPixels(screenshot, 'image/png', (err, pixels) => {
        if (err) {
          reject(err);
        } else {
          resolve(pixels);
        }
      }));
      const buf = new SmartBuffer();
      buf.writeString("ir");
      buf.writeUInt32BE(pixels.shape[0]);
      buf.writeUInt32BE(pixels.shape[1]);
      process.stdout.write(buf.toBuffer());
      process.stdout.write(Buffer.from(pixels.data));
    } else {
      throw new Error(`Unsupported image format ${IMAGE_FORMAT}.`);
    }

    await page.screencastFrameAck(frame.sessionId);
    console.error(Date.now() / 1000);
  });

  await page.startScreencast({format: 'png', everyNthFrame: 10});
  console.error("Recording screencast...");
})();
