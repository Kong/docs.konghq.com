import { launch } from "puppeteer";
import PDFMerger from "pdf-merger-js";

async function createPDF(name, urls) {
  const merger = new PDFMerger();
  const browser = await launch({
    headless: "new",
    defaultViewport: { "width": 595, "height": 842 } // A4 size in pixels
  });
  const page = await browser.newPage();

  console.log(`Generating ./pdfs/${name}.pdf`);
  for (const url of urls) {
    console.log(`Adding ${url}`);

    await page.goto(url, {
      waitUntil: "domcontentloaded",
    });

    // Reflect CSS used for screens instead of print
    await page.emulateMediaType("screen");

    // Wait until all images and fonts have loaded
    // via https://github.blog/2021-06-22-framework-building-open-graph-images/
    await page.evaluate(async () => {
      const selectors = Array.from(document.querySelectorAll("img"));
      await Promise.all([
        document.fonts.ready,
        ...selectors.map((img) => {
          // Image has already finished loading, let’s see if it worked
          if (img.complete) {
            // Image loaded and has presence
            if (img.naturalHeight !== 0) return;

            // If the image src is the same as the page href,
            // don't wait for it to load, just pretend that it did
            if (
              img.src ===
              document.location.origin + document.location.pathname
            ) {
              return img.dispatchEvent(new CustomEvent("load")); // eslint-disable-line
            }

            // Image failed, so it has no height
            throw new Error(
              `Image failed to load: ${img.src} on ${
                document.location.origin + document.location.pathname
              }`,
            );
          }
          // Image hasn’t loaded yet, added an event listener to know when it does
          return new Promise((resolve, reject) => {
            img.addEventListener("load", resolve);
            img.addEventListener("error", reject);
          });
        }),
      ]);
    });


    // Handle OpenAPI pages that can't be rendered as PDF
    const isOpenApiPage = await page.evaluate(() => {
      return !!document.querySelector("elements-api");
    });

    if (isOpenApiPage) {
      console.log("==> Skipping OpenAPI Page");
      await page.evaluate((url) => {
        document.querySelector("body").innerHTML = `
        <h1>${document.querySelector("title").innerText}</h1>

        <p>This content is not available in PDF format. Please see ${url.replace(
          "http://localhost:8888",
          "https://docs.konghq.com",
        )} for more details</p>
        `;
      }, url);
    }

    // Add PDF only styles
    await page.addStyleTag({
      content: `
        @page { size: A4 portrait; margin: 24px; }
        pre { max-height: 100% !important; white-space: pre-wrap; }
        .code { padding-left: 0 !important; }

        .navtab-content { display: block !important } /* Expand tabbed content */
        .navtab-contents { padding: 0 !important; }
        h4 { margin-top: 0 !important; }

        .page-content-container { padding: 0 !important; }
        .content table { display: table !important; }
        .content thead { display: table-header-group !important; }
        .content tbody { display: table-row-group !important; }
        .content tr { display: table-row !important; }
        .content td { display: table-cell !important; }
        .content th { display: table-cell !important; }
      `,
    });

    // Remove mobile css class from tables
    await page.evaluate(() => {
      Array.from(document.querySelectorAll("table.mobile")).forEach((t) => {
        t.classList.remove("mobile");
      });
    });

    // Move header if we're on a plugin page
    await page.evaluate(() => {
      const header = document.querySelector(".page-header");
      if (!header) {
        return;
      }
      const content = document.querySelector(".page-content");
      content.insertBefore(header, content.firstChild);
    });

    // Convert tabs to be sequential with a header in each
    await page.evaluate(() => {
      const nodes = document.querySelectorAll("[data-navtab-id]");
      for (const n of nodes) {
        const id = n.attributes["data-navtab-id"].value;
        const content = document.querySelector(
          '[data-navtab-content="' + id + '"]',
        );
        n.innerHTML = "<h4>" + n.innerHTML + "</h4>";
        content.parentNode.insertBefore(n, content);
      }
    });

    // Remove all un-needed parts of the page
    await page.evaluate(() => {
      const toRemove = [
        ".content-header",
        ".copy-action",
        ".navtab-titles",
        "header",
        ".page--header-background",
        ".page-header",
        ".docs-sidebar",
        ".docs-toc",
        "footer",
        ".modal",
        ".feedback-widget-container",
        "#scroll-to-top-button",
        "#version-notice",
        ".toggles"
      ].join(", ");
      const elements = document.querySelectorAll(toRemove);
      for (let i = 0; i < elements.length; i++) {
        elements[i].parentNode.removeChild(elements[i]);
      }
    });

    // Remove all links
    await page.evaluate(() => {
      document
        .querySelectorAll("a")
        .forEach((n) => n.setAttribute("href", "#/"));
    });

    // Generate the PDF
    merger.add(await page.pdf({ format: "A4", preferCSSPageSize: true }));
  }

  await browser.close();
  console.log(`./pdfs/${name}.pdf Created`);
  await merger.save(`./pdfs/${name}.pdf`);
}

export default createPDF;
