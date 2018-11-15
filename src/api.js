const express = require('express');
const puppeteer = require('puppeteer');

const app = express();
const API_KEY = process.env.API_KEY;

function auth(req, res, next) {
  const key = req.query.api_key;
  if (API_KEY && API_KEY === key) {
    next();
  } else {
    res.status(401);
    res.send({'message': "Unauthorized"});
  }
}

app.get('/', function (req, res) {
  res.send('Hello World')
});

/**
 * Usage:
 * curl 'http://localhost:3000/convert?api_key=demo&url=https://google.com' -o output.pdf
 */
app.get('/v1/convert', auth, async (req, res) => {
  const url = req.query.url;
  const download = req.query.download || false;

  if (url) {
    const browser = await puppeteer.launch({
      executablePath: '/usr/bin/chromium-browser',
      args: ['--no-sandbox', '--disable-dev-shm-usage']
    });
    const page = await browser.newPage();
    await page.goto(url, {waitUntil: 'networkidle2'});
    const pdf = await page.pdf({
      format: 'A4',
      margin: {
        top: '50px',
        right: '50px',
        bottom: '50px',
        left: '50px'
      }
    });
    await browser.close();

    if (download) {
      const filename = new Date().getTime() + '.pdf';
      res.setHeader('Content-disposition', 'attachment; filename=' + filename);
    }
    res.contentType("application/pdf");
    res.send(pdf);

  } else {
    res.status(400);
    res.send({'message': "Parameter 'url' is required"});
  }
});

// tell the server what port to listen on
app.listen(3000, () => {
  console.log('Server started on port 3000');
});
