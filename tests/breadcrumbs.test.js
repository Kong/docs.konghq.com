describe("Gateway", () => {
  test("renders nested breadcrumbs correctly (Single Sourced)", async () => {
    const $ = await fetchPage("/gateway/latest");

    const $homeIcon = $(".breadcrumb-item:nth-of-type(1)").find("img");
    await expect($homeIcon.attr("src")).toBe(
      "/assets/images/icons/documentation/hub/icn-breadcrumbs.svg"
    );

    await expect($homeIcon.attr("alt")).toBe("Home icon");

    await expect($(".breadcrumb-item:nth-of-type(2)")).toHaveTextAllowingWhitespace(
      "Kong Gateway"
    );
  });
});

describe("decK", () => {
  test("renders the index page breadcrumbs correctly", async () => {
    const $ = await fetchPage("/deck/latest/");

    const $homeIcon = $(".breadcrumb-item:nth-of-type(1)").find("img");
    await expect($homeIcon.attr("src")).toBe(
      "/assets/images/icons/documentation/hub/icn-breadcrumbs.svg"
    );

    await expect($homeIcon.attr("alt")).toBe("Home icon");

    await expect($(".breadcrumb-item:nth-of-type(2)")).toHaveTextAllowingWhitespace(
      "decK"
    );
  });
});
