const puppeteer = require('puppeteer')
const PDFMerger = require('pdf-merger-js')

async function createPDF (name, urls) {
  const merger = new PDFMerger()
  const browser = await puppeteer.launch({
    headless: true,
    defaultViewport: null
  })
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

            // If the image src is the same as the page href,
            // don't wait for it to load, just pretend that it did
            if (img.src === (document.location.origin + document.location.pathname)) {
              return img.dispatchEvent(new CustomEvent("load")); // eslint-disable-line
            }

            // Image failed, so it has no height
            throw new Error(`Image failed to load: ${img.src} on ${document.location.origin + document.location.pathname}`)
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
        .code { padding-left: 0 !important; }

        .navtab-content { display: block !important } /* Expand tabbed content */
        .navtab-contents { padding: 0 !important; }
        h4 { margin-top: 0 !important; }
      `
    })

    // Move header if we're on a plugin page
    await page.evaluate(() => {
      const header = document.querySelector('.page-header')
      if (!header) {
        return
      }
      const content = document.querySelector('.page-content')
      content.insertBefore(header, content.firstChild)
    })

    // Move page content to be in body
    await page.evaluate(() => {
      const content = document.querySelector('.page-content')
      document.querySelector('body').innerHTML = content.innerHTML
    })

    // Convert tabs to be sequential with a header in each
    await page.evaluate(() => {
      const nodes = document.querySelectorAll('[data-navtab-id]')
      for (const n of nodes) {
        const id = n.attributes['data-navtab-id'].value
        const content = document.querySelector(
          '[data-navtab-content="' + id + '"]'
        )
        n.innerHTML = '<h4>' + n.innerHTML + '</h4>'
        content.parentNode.insertBefore(n, content)
      }
    })

    // Remove all un-needed parts of the page
    await page.evaluate(() => {
      const toRemove = [
        '.content-header',
        '.copy-action',
        '.navtab-titles'
      ].join(', ')
      const elements = document.querySelectorAll(toRemove)
      for (let i = 0; i < elements.length; i++) {
        elements[i].parentNode.removeChild(elements[i])
      }
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
