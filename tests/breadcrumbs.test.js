const { test, expect } = require("@playwright/test");

test.describe("Gateway", () => {
  test("renders nested breadcrumbs correctly (EE)", async ({ page }) => {
    await page.goto("/enterprise/2.5.x/plugin-development/custom-entities/");
    await expect(page.locator(".breadcrumb-item:nth-of-type(1)")).toHaveText(
      "Kong Konnect Platform"
    );
    await expect(page.locator(".breadcrumb-item:nth-of-type(2)")).toHaveText(
      "Kong Gateway"
    );
    await expect(page.locator(".breadcrumb-item:nth-of-type(3)")).toHaveText(
      "Plugin development"
    );
  });

  test("renders nested breadcrumbs correctly (OSS)", async ({ page }) => {
    await page.goto("/gateway-oss/2.5.x/plugin-development/custom-entities/");
    await expect(page.locator(".breadcrumb-item:nth-of-type(1)")).toHaveText(
      "Open Source"
    );
    await expect(page.locator(".breadcrumb-item:nth-of-type(2)")).toHaveText(
      "Kong Gateway (OSS)"
    );
    await expect(page.locator(".breadcrumb-item:nth-of-type(3)")).toHaveText(
      "Plugin development"
    );
  });

  test("renders nested breadcrumbs correctly (Single Sourced)", async ({
    page,
  }) => {
    await page.goto("/gateway/latest/");
    await expect(page.locator(".breadcrumb-item:nth-of-type(1)")).toHaveText(
      "Kong Konnect Platform"
    );
    await expect(page.locator(".breadcrumb-item:nth-of-type(2)")).toHaveText(
      "Kong Gateway"
    );
  });
});

test.describe("decK", () => {
  test("rrenders the index page breadcrumbs correctly", async ({ page }) => {
    await page.goto("/deck/latest/");

    await expect(page.locator(".breadcrumb-item:nth-of-type(1)")).toHaveText(
      "Open Source"
    );
    await expect(page.locator(".breadcrumb-item:nth-of-type(2)")).toHaveText(
      "decK"
    );
  });
});
