const { test, expect } = require("@playwright/test");

test.describe("Canonical links", () => {
  [
    {
      title: "links to the latest available page in /gateway/ when it exists",
      src: "/enterprise/2.3.x/admin-api/",
      href: "/gateway/latest/admin-api/",
    },
    {
      title:
        "links to the latest available version when the page does not exist in /latest/",
      src: "/enterprise/2.3.x/property-reference/",
      href: "/enterprise/2.5.x/property-reference/",
    },
    {
      title:
        "contains a canonical link pointing to itself if it's the latest version",
      src: "/gateway/latest/install-and-run/docker/",
      href: "/gateway/latest/install-and-run/docker/",
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
    {
      title: "contains a noindex tag if it's not the latest URL",
      src: "/gateway/2.7.x/install-and-run/",
    },
    {
      title: "contains a noindex tag if it's a gateway-oss page",
      src: "/gateway-oss/2.5.x/",
    },
    {
      title: "contains a noindex tag if it's an enterprise page",
      src: "/enterprise/2.5.x/",
    },
    {
      title: "contains a noindex tag if it's a getting-started-guide page",
      src: "/getting-started-guide/2.5.x/prepare/",
    },
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
      title: "latest page",
      src: "/gateway/latest/install-and-run/docker/",
      expected: 0,
    },
  ].forEach((t) => {
    test(t.title, async ({ page }) => {
      await page.goto(t.src);
      const link = page.locator("meta[name='robots'][content='follow,index']");
      await expect(link).toHaveCount(1);
    });
  });
});
