const { test, expect } = require("@playwright/test");

// These tests ensure that the generated plugin samples are correct
// We had a caching issue previously where they all showed the same information
test.describe("plugin shows the correct sample", () => {
  // Set a baseline on a common plugin (basic-auth)
  test("basic-auth (kong inc)", async ({ page }) => {
    await page.goto("/hub/kong-inc/basic-auth/");
    await expect(page.locator(".navtab-content").first()).toContainText(
      '--data "name=basic-auth"'
    );
  });

  // Make sure that a different plugin shows the correct name too
  // In case we cached basic-auth by coincidence
  test("cors (kong inc)", async ({ page }) => {
    await page.goto("/hub/kong-inc/cors/");
    await expect(page.locator(".navtab-content").first()).toContainText(
      '--data "name=cors"'
    );
  });

  // Show a community plugin too
  test("salt (community)", async ({ page }) => {
    await page.goto("/hub/salt/salt/");
    await expect(page.locator(".content").first()).toContainText(
      '--data "name=salt-agent"'
    );
  });
});
