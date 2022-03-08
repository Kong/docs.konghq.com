const { test, expect } = require("@playwright/test");

test("has the 'Welcome to Kong' header", async ({ page }) => {
  await page.goto("/");
  const title = page.locator("#main");
  await expect(title).toHaveText("Welcome to Kong Docs");
});
