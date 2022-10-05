describe("Gateway", () => {
  test("renders nested breadcrumbs correctly (EE)", async () => {
    const $ = await fetchPage(
      "/enterprise/2.5.x/plugin-development/custom-entities/"
    );
    await expect($(".breadcrumb-item:nth-of-type(1)")).toHaveTextAllowingWhitespace(
      "Home"
    );
    await expect($(".breadcrumb-item:nth-of-type(2)")).toHaveTextAllowingWhitespace(
      "Kong Enterprise"
    );
    await expect($(".breadcrumb-item:nth-of-type(3)")).toHaveTextAllowingWhitespace(
      "Plugin Development"
    );
  });

  test("renders nested breadcrumbs correctly (OSS)", async () => {
    const $ = await fetchPage(
      "/gateway-oss/2.5.x/plugin-development/custom-entities/"
    );
    await expect($(".breadcrumb-item:nth-of-type(1)")).toHaveTextAllowingWhitespace(
      "Home"
    );
    await expect($(".breadcrumb-item:nth-of-type(2)")).toHaveTextAllowingWhitespace(
      "Kong Gateway (OSS)"
    );
    await expect($(".breadcrumb-item:nth-of-type(3)")).toHaveTextAllowingWhitespace(
      "Plugin Development"
    );
  });

  test("renders nested breadcrumbs correctly (Single Sourced)", async () => {
    const $ = await fetchPage("/gateway/latest");
    await expect($(".breadcrumb-item:nth-of-type(1)")).toHaveTextAllowingWhitespace(
      "Home"
    );
    await expect($(".breadcrumb-item:nth-of-type(2)")).toHaveTextAllowingWhitespace(
      "Kong Gateway"
    );
  });
});

describe("decK", () => {
  test("renders the index page breadcrumbs correctly", async () => {
    const $ = await fetchPage("/deck/latest/");

    await expect($(".breadcrumb-item:nth-of-type(1)")).toHaveTextAllowingWhitespace(
      "Home"
    );
    await expect($(".breadcrumb-item:nth-of-type(2)")).toHaveTextAllowingWhitespace(
      "decK"
    );
  });
});
