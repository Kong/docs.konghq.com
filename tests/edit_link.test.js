describe("Edit this page link", () => {
  [
    {
      title: "/app/ page",
      src: "/gateway/2.8.x/install-and-run/docker/",
      expected:
        "https://github.com/Kong/docs.konghq.com/edit/main/app/gateway/2.8.x/install-and-run/docker.md",
    },

    {
      title: "Single Sourced",
      src: "/deck/1.12.x/",
      expected:
        "https://github.com/Kong/docs.konghq.com/edit/main/src/deck/index.md",
    },
    {
      title: "/app/ page /latest/",
      src: "/gateway/latest/",
      expected:
        "https://github.com/Kong/docs.konghq.com/edit/main/src/gateway/index.md",
    },
    {
      title: "Single Sourced /latest/",
      src: "/deck/latest/",
      expected:
        "https://github.com/Kong/docs.konghq.com/edit/main/src/deck/index.md",
    },
  ].forEach((t) => {
    test(t.title, async () => {
      const $ = await fetchPage(t.src)
      expect($(".github-links a").first().attr("href")).toBe(t.expected);
    });
  });
});
