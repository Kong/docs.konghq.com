// These tests ensure that the generated plugin samples are correct
// We had a caching issue previously where they all showed the same information
describe("plugin shows the correct sample", () => {
  // Set a baseline on a common plugin (basic-auth)
  test("basic-auth (kong inc)", async () => {
    const $ = await fetchPage("/hub/kong-inc/basic-auth/how-to/basic-example/");
    await expect($(".navtab-content")).toContainText(
      '"name": "basic-auth"'
    );
  });

  // Make sure that a different plugin shows the correct name too
  // In case we cached basic-auth by coincidence
  test("cors (kong inc)", async () => {
    const $ = await fetchPage("/hub/kong-inc/cors/how-to/basic-example/");
    await expect($(".navtab-content")).toContainText(
      '"name": "cors"'
    );
  });

  // Show a community plugin too
  test("salt (community)", async () => {
    const $ = await fetchPage("/hub/salt/salt/how-to/basic-example/");
    await expect($(".content")).toContainText(
      '"name": "salt-agent"'
    );
  });
});
