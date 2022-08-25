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
      src: "/gateway/latest/kong-production/install-options/helm-quickstart/",
      href: "/gateway/latest/kong-production/install-options/helm-quickstart/",
    },
    {
      title:
        "plugins contain a canonical link pointing to the latest version of a plugin",
      src: "/hub/kong-inc/application-registration/2.8.x.html",
      href: "/hub/kong-inc/application-registration/",
    },
    {
      title: "links to the product index when showing the index page for a specific version (kic)",
      src: "/kubernetes-ingress-controller/2.2.x/",
      href: "/kubernetes-ingress-controller/latest/",
    },
     {
      title: "links to the product index when showing the index page for a specific version (gateway)",
      src: "/gateway/2.7.x/",
      href: "/gateway/latest/",
    },
    {
      title: "plugin hub index",
      src: "/hub/",
      href: "/hub/",
    },
    {
      title: "page using moved_urls.yml to track renamed files",
      src: "/gateway-oss/2.5.x/configuration/",
      href: "/gateway/latest/reference/configuration/",
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
      src: "/hub/kong-inc/application-registration/2.8.x.html",
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

test.describe("sitemap includes", () => {
  [
    "/konnect/",
    "/gateway/latest/",
    "/mesh/latest/",
    "/kubernetes-ingress-controller/latest/",
    "/deck/latest/",
    "/gateway/latest/kong-production/install-options/helm-quickstart/",
    "/mesh/latest/installation/ecs/",
    "/kubernetes-ingress-controller/latest/deployment/k4k8s/",
    "/deck/latest/installation/",
    "/hub/kong-inc/application-registration/",
    "/gateway/changelog/",
    "/mesh/changelog/",
    "/hub/",
  ].forEach((t) => {
    test(t, async ({ page }) => {
      await page.goto("/sitemap.xml");
      const html = await page.content();
      await expect(html).toContain(`<loc>https://docs.konghq.com${t}</loc>`);
    });
  });
});


test.describe("sitemap does not include", () => {
  [
    "/gateway/2.6.x/configure/auth/kong-manager/oidc/",
    "/mesh/1.6.x/",
    "/mesh/1.1.x/overview/",
    "/deck/",
    "/gateway/",
  ].forEach((t) => {
    test(t, async ({ page }) => {
      await page.goto("/sitemap.xml");
      const html = await page.content();
      await expect(html).not.toContain(`<loc>https://docs.konghq.com${t}</loc>`);
    });
  });
});
