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
    {
      title:
        "contains a canonical link pointing to the latest version of a plugin",
      src: "/hub/kong-inc/application-registration/1.0.x.html",
      href: "/hub/kong-inc/application-registration/",
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
      title: "contains a noindex tag if it's not the latest URL (index)",
      src: "/gateway/2.7.x/",
    },
    {
      title: "contains a noindex tag if it's not the latest URL (nested)",
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
    {
      title: "contains a noindex tag for old plugin versions",
      src: "/hub/kong-inc/application-registration/1.0.x.html",
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
    },
    {
      title: "index page",
      src: "/gateway/",
    },
    {
      title: "latest version of a plugin",
      src: "/hub/kong-inc/application-registration/",
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
      src: "/konnect/",
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
    "/konnect/",
    "/konnect-platform/",
    "/gateway/latest/",
    "/mesh/latest/",
    "/kubernetes-ingress-controller/latest/",
    "/deck/latest/",
    "/hub/kong-inc/application-registration/",
  ].forEach((t) => {
    test(t, async ({ page }) => {
      await page.goto("/sitemap.xml");
      const html = await page.content();
      await expect(html).toContain(t);
    });
  });
});
