const puppeteer = require('puppeteer');
const util = require("util");

const wait = util.promisify(setTimeout);

(async () => {
  const browser = await puppeteer.launch();
  const page = await browser.newPage();
  await page.setViewport({width: 640, height: 480});
  await page.goto('https://google.com');

  console.error('hello');
  let currentStdinBuffer;
  process.stdin.on('data', chunk => {
    currentStdinBuffer = currentStdinBuffer ? Buffer.concat([currentStdinBuffer, chunk]) : chunk;

    if (currentStdinBuffer.length > 0) {
      const command = String.fromCharCode(currentStdinBuffer.readUInt8(0));
      const size = currentStdinBuffer.readUInt32BE(1);
      console.error('Received command', command, currentStdinBuffer.length, size);
      let x, y;
      switch (command) {
        case 'e':
          // TODO check read boundaries for each event type
          const eventType = currentStdinBuffer.readUInt8(5);
          console.error('Received event type', eventType);
          switch (eventType) {
            case 0:
              page.mouse.up();
              break;
            case 1:
              page.mouse.down();
              break;
            case 2:
              x = currentStdinBuffer.readUInt32LE(6);
              y = currentStdinBuffer.readUInt32LE(10);
              console.error('Moving to', x, y);
              page.mouse.move(x, y);
              break;
            case 3:
              // page.keyboard.down();
              break;
            case 4:
              // page.keyboard.up();
              break;
            case 5:
              x = currentStdinBuffer.readUInt32LE(6);
              y = currentStdinBuffer.readUInt32LE(10);
              page.setViewport({width: x, height: y});
              break;
          }
      }
      // TODO not very clean, should slice the buffer to the extent that we read
      currentStdinBuffer = null;
    }
  });

  process.on('SIGTERM', async () => {
    await browser.close();
    process.exit();
  });

  while(true) {
    const screenshot = await page.screenshot({});
    process.stdout.write("i");
    const buf = new Buffer(4);
    buf.writeUInt32BE(screenshot.length);
    process.stdout.write(buf)
    process.stdout.write(screenshot);
    await wait(20);
  }

})();
