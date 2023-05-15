describe("Canonical links", () => {
  [
    {
      title: "links to the latest available page in /gateway/ when it exists",
      src: "/enterprise/2.3.x/admin-api/",
      href: "/gateway/latest/admin-api/",
    },
    {
      title:
        "links to the latest available version when the page does not exist in /latest/",
      src: "/enterprise/2.3.x/property-reference/",
      href: "/enterprise/2.5.x/property-reference/",
    },
    {
      title:
        "contains a canonical link pointing to itself if it's the latest version",
      src: "/gateway/latest/install/kubernetes/helm-quickstart/",
      href: "/gateway/latest/install/kubernetes/helm-quickstart/",
    },
    {
      title:
        "plugins contain a canonical link pointing to the latest version of a plugin",
      src: "/hub/kong-inc/application-registration/2.8.x/",
      href: "/hub/kong-inc/application-registration/",
    },
    {
      title: "links to the product index when showing the index page for a specific version (kic)",
      src: "/kubernetes-ingress-controller/2.2.x/",
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
    {
      title: "page using moved_urls.yml to track renamed files",
      src: "/gateway-oss/2.5.x/configuration/",
      href: "/gateway/latest/reference/configuration/",
    },
  ].forEach((t) => {
    test(t.title, async () => {
      const $ = await fetchPage(t.src);
      await expect($("head link[rel='canonical']").attr("href")).toBe(
        `https://docs.konghq.com${t.href}`
      );
    }, 7000);
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
      title: "contains a noindex tag if it's a gateway-oss page",
      src: "/gateway-oss/2.5.x/",
    },
    {
      title: "contains a noindex tag if it's an enterprise page",
      src: "/enterprise/2.5.x/",
    },
    {
      title: "contains a noindex tag if it's a getting-started-guide page",
      src: "/getting-started-guide/2.5.x/prepare/",
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
    "/gateway/latest/install/kubernetes/helm-quickstart/",
    "/mesh/latest/installation/ecs/",
    "/kubernetes-ingress-controller/latest/deployment/k4k8s/",
    "/deck/latest/installation/",
    "/hub/kong-inc/application-registration/",
    "/gateway/changelog/",
    "/mesh/changelog/",
    "/hub/",
  ].forEach((t) => {
    test(t, async () => {
      const page = await fetchPageRaw("/sitemap.xml");
      await expect(page.includes(`<loc>https://docs.konghq.com${t}</loc>`)).toBe(true);
    });
  });
});


describe("sitemap does not include", () => {
  [
    "/gateway/2.6.x/configure/auth/kong-manager/oidc/",
    "/mesh/1.6.x/",
    "/mesh/1.1.x/overview/",
    "/deck/",
    "/gateway/",
  ].forEach((t) => {
    test(t, async () => {
      const page = await fetchPageRaw("/sitemap.xml");
      await expect(page.includes(`<loc>https://docs.konghq.com${t}</loc>`)).toBe(false);
    });
  });
});
