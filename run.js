const puppeteer = require('puppeteer');
const util = require("util");

const wait = util.promisify(setTimeout);

(async () => {
  const browser = await puppeteer.launch();
  const page = await browser.newPage();
  await page.goto('https://google.com');

  for (let i = 0; i < 100; i++) {
    const screenshot = await page.screenshot({});
    process.stdout.write("i");
    const buf = new Buffer(4);
    buf.writeUInt32BE(screenshot.length);
    process.stdout.write(buf)
    process.stdout.write(screenshot);
    await wait(20);
  }

  await browser.close();
})();