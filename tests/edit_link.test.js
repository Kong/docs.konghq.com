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
      src: "/gateway/3.8.x/",
      expected:
        "https://github.com/Kong/docs.konghq.com/edit/main/app/_src/gateway/index.md",
    },
    {
      title: "Single sourced page /latest/",
      src: "/gateway/latest/",
      expected:
        "https://github.com/Kong/docs.konghq.com/edit/main/app/_src/gateway/index.md",
    },
    {
      title: "Submoduled /mesh/",
      src: "/mesh/latest/production/dp-config/dpp/",
      expected:
        "https://github.com/kumahq/kuma-website/edit/master/app/_src/production/dp-config/dpp.md",
    },
  ].forEach((t) => {
    test(t.title, async () => {
      const $ = await fetchPage(t.src)
      expect($(".github-links a").first().attr("href")).toBe(t.expected);
    });
  });
});
