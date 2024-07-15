describe("Canonical links", () => {
  [
    {
      title:
        "contains a canonical link pointing to itself if it's the latest version",
      src: "/gateway/latest/install/kubernetes/proxy/",
      href: "/gateway/latest/install/kubernetes/proxy/",
    },
    {
      title:
        "plugins contain a canonical link pointing to the latest version of a plugin",
      src: "/hub/kong-inc/application-registration/2.8.x/",
      href: "/hub/kong-inc/application-registration/",
    },
    {
      title: "links to the product index when showing the index page for a specific version (kic)",
      src: "/kubernetes-ingress-controller/2.5.x/",
      href: "/kubernetes-ingress-controller/latest/",
    },
     {
      title: "links to the product index when showing the index page for a specific version (gateway)",
      src: "/gateway/2.7.x/",
      href: "/gateway/latest/",
    },
    {
      title: "plugin hub index",
      src: "/hub/",
      href: "/hub/",
    },
  ].forEach((t) => {
    test(t.title, async () => {
      const $ = await fetchPage(t.src);
      await expect($("head link[rel='canonical']").attr("href")).toBe(
        `https://docs.konghq.com${t.href}`
      );
    }, 15000);
  });
});

describe("noindex links", () => {
  [
    {
      title: "contains a noindex tag if it's not the latest URL (index)",
      src: "/gateway/2.7.x/",
    },
    {
      title: "contains a noindex tag if it's not the latest URL (nested)",
      src: "/gateway/2.7.x/install-and-run/",
    },
    {
      title: "contains a noindex tag for old plugin versions",
      src: "/hub/kong-inc/application-registration/2.8.x/",
    },
  ].forEach((t) => {
    test(t.title, async () => {
      const $ = await fetchPage(t.src);
      await expect($("meta[name='robots'][content='follow,noindex']")).toHaveCount(1);
    });
  });
});

describe("index links", () => {
  [
    {
      title: "latest page",
      src: "/gateway/latest/install-and-run/docker/",
    },
    {
      title: "index page",
      src: "/gateway/",
    },
    {
      title: "latest version of a plugin",
      src: "/hub/kong-inc/application-registration/",
    },
  ].forEach((t) => {
    test(t.title, async () => {
      const $ = await fetchPage(t.src);
      await expect($("meta[name='robots'][content='follow,index']")).toHaveCount(1);
    });
  });
});

describe("unversioned content", () => {
  [
    {
      title: "konnect",
      src: "/konnect/",
    },
    {
      title: "contributing",
      src: "/contributing/",
    },
  ].forEach((t) => {
    test(t.title, async () => {
      const $ = await fetchPage(t.src);
      await expect($("meta[name='robots'][content='follow,index']")).toHaveCount(1);

      // Even unversioned content has a canonical link now
      await expect($("link[rel='canonical']")).toHaveCount(1);
    });
  });
});

describe("sitemap includes", () => {
  [
    "/konnect/",
    "/gateway/latest/",
    "/mesh/latest/",
    "/kubernetes-ingress-controller/latest/",
    "/deck/latest/",
    "/gateway/latest/install/kubernetes/proxy/",
    "/mesh/latest/installation/ecs/",
    "/deck/latest/installation/",
    "/hub/kong-inc/application-registration/",
    "/gateway/changelog/",
    "/mesh/changelog/",
    "/hub/",
    "/hub/plugins/compatibility/",
    "/hub/plugins/license-tiers/",
    "/hub/plugins/overview/",
  ].forEach((t) => {
    test(t, async () => {
      const page = await fetchPageRaw("/sitemap-index/default.xml");
      await expect(page.includes(`<loc>https://docs.konghq.com${t}</loc>`)).toBe(true);
    });
  });
});


describe("sitemap does not include", () => {
  [
    "/mesh/1.6.x/",
    "/mesh/1.1.x/overview/",
    "/deck/",
    "/gateway/",
  ].forEach((t) => {
    test(t, async () => {
      const page = await fetchPageRaw("/sitemap-index/default.xml");
      await expect(page.includes(`<loc>https://docs.konghq.com${t}</loc>`)).toBe(false);
    });
  });
});
