const { test, expect } = require("@playwright/test");

test("latest page contains a version", async ({ page }) => {
  await page.goto("/gateway/latest/install-and-run/rhel/");
  await expect(page.locator(".codeblock").first()).not.toContainText("kong-enterprise-edition-.rpm");
});
