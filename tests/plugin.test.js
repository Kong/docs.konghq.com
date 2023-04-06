// These tests ensure that the generated plugin samples are correct
// We had a caching issue previously where they all showed the same information
describe("plugin shows the correct sample", () => {
  // Set a baseline on a common plugin (basic-auth)
  test("basic-auth (kong inc)", async () => {
    const $ = await fetchPage("/hub/kong-inc/basic-auth/reference/");
    await expect($(".navtab-content").first()).toContainText(
      '--data "name=basic-auth"'
    );
  });

  // Make sure that a different plugin shows the correct name too
  // In case we cached basic-auth by coincidence
  test("cors (kong inc)", async () => {
    const $ = await fetchPage("/hub/kong-inc/cors/reference/");
    await expect($(".navtab-content").first()).toContainText(
      '--data "name=cors"'
    );
  });

  // Show a community plugin too
  test("salt (community)", async () => {
    const $ = await fetchPage("/hub/salt/salt/reference/");
    await expect($(".content").first()).toContainText(
      '--data "name=salt-agent"'
    );
  });
});
