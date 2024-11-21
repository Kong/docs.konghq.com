To run the tests, you must first build the site by running `make build` before running `make smoke`.

Many of the tests are smoke tests to check for issues that occurred while adding caching to the site, such as ensuring that the side navigation isn't cached.

To add your own tests, look in the `tests` directory and use `home.test.js` as a sample. You specify which URL to visit and then a CSS selector to search for, before asserting that the contents match what you expect.

```javascript
test("has the 'Welcome to Kong' header", async () => {
  const $ = await fetchPage("/")
  expect($("#main")).toHaveText("Welcome to Kong Docs");
});
```