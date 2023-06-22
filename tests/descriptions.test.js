describe("Custom page descriptions", () => {
  [
    {
      title: "Gateway Index",
      src: "/gateway/latest/",
      expected:
        "Kong Gateway is a lightweight, fast, and flexible cloud-native API gateway. Kong is a reverse proxy that lets you manage, configure, and route requests",
    },
  ].forEach((t) => {
    test(t.title, async () => {
      const $ = await fetchPage(t.src);
      expect($("meta[name='description']").attr("content")).toBe(t.expected);
    });
  });
});
