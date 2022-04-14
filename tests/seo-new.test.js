const { test, expect } = require("@playwright/test");

test.describe("Canonical links", () => {
  [
    {
      title:
        "plugin hub index",
      src: "/hub/",
      href: "/hub/",
    },
  ].forEach((t) => {
    test(t.title, async ({ page }) => {
      await page.goto(t.src);
      const link = await page.locator("link[rel='canonical']");
      expect(await link.getAttribute("href")).toEqual(
        `https://docs.konghq.com${t.href}`
      );
    });
  });
});

test.describe("noindex links", () => {
  [
  ].forEach((t) => {
    test(t.title, async ({ page }) => {
      await page.goto(t.src);
      const link = page.locator(
        "meta[name='robots'][content='follow,noindex']"
      );
      await expect(link).toHaveCount(1);
    });
  });
});

test.describe("index links", () => {
  [
    {
      title: "plugin hub",
      src: "/hub/",
    },
  ].forEach((t) => {
    test(t.title, async ({ page }) => {
      await page.goto(t.src);
      const link = page.locator("meta[name='robots'][content='follow,index']");
      await expect(link).toHaveCount(1);
    });
  });
});

test.describe("unversioned content", () => {
  [
    {
      title: "konnect",
      src: "/gateway/changelog/",
    },
    {
      title: "konnect-platform",
      src: "/konnect-platform/",
    },
    {
      title: "contributing",
      src: "/contributing/",
    },
  ].forEach((t) => {
    test(t.title, async ({ page }) => {
      await page.goto(t.src);
      const robotsIndex = page.locator(
        "meta[name='robots'][content='follow,index']"
      );
      await expect(robotsIndex).toHaveCount(1);

      // There's no need for a canonical link with unversioned content
      const canonical = await page.locator("link[rel='canonical']");
      await expect(canonical).toHaveCount(0);
    });
  });
});

test.describe("sitemap", () => {
  [
    "/gateway/changelog/",
    "/mesh/changelog/",
  ].forEach((t) => {
    test(t, async ({ page }) => {
      await page.goto("/sitemap.xml");
      const html = await page.content();
      await expect(html).toContain(t);
    });
  });
});
