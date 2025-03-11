const { toArray } = require("lodash");

describe("Version Switcher", () => {
  [
    {
      title: "links to the same page if it exists in previous versions",
      page: "/gateway/3.8.x/install/docker/",
      selector: 'a[data-version-id="3.7.x"]',
      href: "/gateway/3.7.x/install/docker/",
    },
    {
      title:
        "links to the root page if the page does not exist in previous versions",
      page: "/gateway/3.8.x/production/logging/ai-analytics/",
      selector: 'a[data-version-id="3.6.x"]',
      href: "/gateway/3.6.x/",
    },
  ].forEach((t) => {
    test(t.title, async () => {
      const $ = await fetchPage(t.page);
      await expect($(t.selector).attr("href")).toMatch(
        new RegExp(`^${t.href}$`)
      );
    });
  });
});

describe("Older version documentation", () => {
  const oldVersionSelector =
    'blockquote:contains("You are browsing documentation for an older version.") a';
  const latestGatewayVersion = "2.8.x";

  test("does not show on the latest version", async () => {
    const $ = await fetchPage(
      `/gateway/${latestGatewayVersion}/install/linux/rhel/`
    );
    await expect($(oldVersionSelector)).toHaveCount(0);
  });

  test("links to the same page in a newer version", async () => {
    const $ = await fetchPage(`/gateway/3.6.x/install/docker/`);
    const s = $(oldVersionSelector);
    await expect(s).toHaveCount(1);
    console.log(s.attr("href"))
    await expect(s.attr("href")).toMatch(
      new RegExp(`^/gateway/latest/install/docker/$`)
    );
  });
});

describe("Sidebar section count", () => {
  const sidebarSelector = ".sidebar-container > .sidebar-item";

  [
    {
      title: "Gateway Single Sourced",
      path: "/gateway/latest/",
      count: 11,
    },
    {
      title: "decK",
      path: "/deck/",
      count: 8,
    },
  ].forEach((t) => {
    test(t.title, async () => {
      const $ = await fetchPage(t.path);
      await expect($(sidebarSelector)).toHaveCount(t.count);
    });
  });
});

describe("sidenav versions", () => {
  [
    {
      title: "Root page links to /latest/",
      src: "/gateway/latest/",
      link_text: "Get Kong",
      expected_url: "/gateway/latest/get-started/",
    },
    {
      title: "Versioned root page links to the correct version",
      src: "/gateway/3.7.x/",
      link_text: "Using docker run",
      expected_url: "/gateway/3.7.x/install/docker/",
    },
    {
      title: "Sub page links to latest",
      src: "/gateway/latest/admin-api/",
      link_text: "Get Kong",
      expected_url: "/gateway/latest/get-started/",
    },
    {
      title: "Versioned sub page links to the correct version",
      src: "/gateway/2.8.x/admin-api/",
      link_text: "Docker",
      expected_url: "/gateway/2.8.x/install-and-run/docker/",
    },
  ].forEach((t) => {
    test(t.title, async () => {
      const $ = await fetchPage(t.src);
      const link = $(`a:contains("${t.link_text}")`);
      await expect(link.attr("href")).toBe(t.expected_url);
    });
  });
});
