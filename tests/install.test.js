const { test, expect } = require("@playwright/test");

test("latest page contains a version", async ({ page }) => {
  await page.goto("/gateway/latest/kong-production/install-options/linux/rhel/");
  await expect(page.locator(".codeblock").first()).not.toContainText("kong-enterprise-edition-.rpm");
});
