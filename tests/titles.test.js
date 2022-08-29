const { test, expect } = require("@playwright/test");

test.describe("Page titles", () => {
  [
    {
      title: "Docs page",
      src: "/gateway/2.8.x/install-and-run/docker/",
      expected: "Install Kong Gateway on Docker - v2.8.x | Kong Docs",
    },
    {
      title: "Plugin Page (generated)",
      src: "/hub/kong-inc/application-registration/",
      expected: "Portal Application Registration plugin | Kong Docs",
    },
  ].forEach((t) => {
    test(t.title, async ({ page }) => {
      await page.goto(t.src);
      expect(await page.title()).toEqual(t.expected);
    });
  });
});
