const puppeteer = require('puppeteer')
const PDFMerger = require('pdf-merger-js')

async function createPDF (name, urls) {
  const merger = new PDFMerger()
  const browser = await puppeteer.launch({ headless: true })
  const page = await browser.newPage()

  console.log(`Generating ./pdfs/${name}.pdf`)
  for (const url of urls) {
    console.log(`Adding ${url}`)

    await page.goto(url, {
      waitUntil: 'domcontentloaded'
    })

    // Wait until all images and fonts have loaded
    // via https://github.blog/2021-06-22-framework-building-open-graph-images/
    await page.evaluate(async () => {
      const selectors = Array.from(document.querySelectorAll('img'))
      await Promise.all([
        document.fonts.ready,
        ...selectors.map((img) => {
          // Image has already finished loading, let’s see if it worked
          if (img.complete) {
            // Image loaded and has presence
            if (img.naturalHeight !== 0) return
            // Image failed, so it has no height
            throw new Error('Image failed to load')
          }
          // Image hasn’t loaded yet, added an event listener to know when it does
          return new Promise((resolve, reject) => {
            img.addEventListener('load', resolve)
            img.addEventListener('error', reject)
          })
        })
      ])
    })

    // Add PDF only styles
    await page.addStyleTag({
      content: `
        @page { size: A4 portrait; margin: 24px; }
        pre { max-height: 100% !important; white-space: pre-wrap; }
        .rouge-gutter.gl {display:none !important;}
        .rouge-code { padding-left: 0 !important; }
      `
    })

    // Remove all links
    await page.evaluate(() => {
      document
        .querySelectorAll('a')
        .forEach((n) => n.setAttribute('href', '#/'))
    })

    // Generate the PDF
    merger.add(await page.pdf({ format: 'A4', preferCSSPageSize: true }))
  }

  await browser.close()
  console.log(`./pdfs/${name}.pdf Created`)
  await merger.save(`./pdfs/${name}.pdf`)
}

module.exports = createPDF
