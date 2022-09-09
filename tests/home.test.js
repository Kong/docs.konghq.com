test("has the 'Welcome to Kong' header", async () => {
  const $ = await fetchPage("/")
  expect($("#main")).toHaveText("Welcome to Kong Docs");
});