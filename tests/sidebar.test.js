const { test, expect } = require("@playwright/test");

test.describe("Module Switcher", () => {
  test("has the same products, in the same order as the top 'Docs' dropdown", async ({
    page,
  }) => {
    await page.goto("/gateway/");

    async function fetchLinksFromElement(selector) {
      return (
        await Promise.all(
          (
            await page.$$(selector)
          ).map(async (link) => {
            const r = {};
            const title = await link.innerText();
            r[title] = await link.getAttribute("href");
            return r;
          })
        )
      ).reduce((prev, current) => {
        return { ...prev, ...current };
      }, {});
    }

    const sidebarUrls = await fetchLinksFromElement("#module-list a");
    const topNavUrls = await fetchLinksFromElement(
      "#top-module-list .navbar-item-submenu a"
    );

    expect(sidebarUrls).toEqual(topNavUrls);
  });
});

test.describe("Version Switcher", () => {
  [
    {
      title: "links to the same page if it exists in previous versions",
      page: "/enterprise/2.5.x/deployment/installation/docker/",
      selector: 'a[data-version-id="2.1.x"]',
      href: "/enterprise/2.1.x/deployment/installation/docker/",
    },
    {
      title:
        "links to the root page if the page does not exist in previous versions",
      page: "/enterprise/2.5.x/deployment/installation/docker/",
      selector: 'a[data-version-id="0.34-x"]',
      href: "/enterprise/0.34-x",
    },
  ].forEach((t) => {
    test(t.title, async ({ page }) => {
      await page.goto(t.page);
      const s = await page.locator(t.selector).first();
      await expect(await s.getAttribute("href")).toEqual(
        expect.stringMatching(new RegExp(`^${t.href}$`))
      );
    });
  });
});

test.describe("Outdated version documentation", () => {
  const oldVersionSelector =
    'blockquote:has-text("You are browsing documentation for an outdated version.") a';
  const latestGatewayVersion = "3.0.x";

  test("does not show on the latest version", async ({ page }) => {
    await page.goto(`/gateway/${latestGatewayVersion}/install-and-run/rhel/`);
    await expect(await page.locator(oldVersionSelector).count()).toBe(0);
  });

  test("links to the same page in a newer version", async ({ page }) => {
    await page.goto(`/gateway/2.7.x/install-and-run/rhel/`);
    const s = await page.locator(oldVersionSelector);
    await expect(await s.count()).toBe(1);
    await expect(await s.getAttribute("href")).toEqual(
      expect.stringMatching(
        new RegExp(`^/gateway/latest/install-and-run/rhel/$`)
      )
    );
  });

  test("links to the root when the page no longer exists", async ({ page }) => {
    await page.goto(`/enterprise/0.31-x/postgresql-redhat/`);
    const s = await page.locator(oldVersionSelector);
    await expect(await s.count()).toBe(1);
    await expect(await s.getAttribute("href")).toEqual(
      expect.stringMatching(new RegExp(`^/gateway/$`))
    );
  });
});

test.describe("Sidebar section count", () => {
  const sidebarSelector = ".accordion-container > .accordion-item";

  [
    {
      title: "Gateway OSS",
      path: "/gateway-oss/2.5.x",
      count: 6,
    },
    {
      title: "Gateway Enterprise",
      path: "/enterprise/2.5.x",
      count: 10,
    },
    {
      title: "Gateway Single Sourced",
      path: "/gateway/",
      count: 7,
    },
    {
      title: "decK",
      path: "/deck/",
      count: 6,
    },
  ].forEach((t) => {
    test(t.title, async ({ page }) => {
      await page.goto(t.path);
      const s = await page.locator(sidebarSelector);
      await expect(await s.count()).toBe(t.count);
    });
  });
});

test.describe("sidenav versions", () => {
  [
    {
      title: "Root page links to /latest/",
      src: "/gateway/",
      link_text: "Install and Run",
      expected_url: "/gateway/latest/install-and-run/",
    },
    {
      title: "Versioned root page links to the correct version",
      src: "/gateway/2.7.x",
      link_text: "Install and Run",
      expected_url: "/gateway/2.7.x/install-and-run/",
    },
    {
      title: "Sub page links to latest",
      src: "/gateway/latest/admin-api/",
      link_text: "Install and Run",
      expected_url: "/gateway/latest/install-and-run/",
    },
    {
      title: "Versioned sub page links to the correct version",
      src: "/gateway/2.8.x/admin-api/",
      link_text: "Install and Run",
      expected_url: "/gateway/2.8.x/install-and-run/",
    },

  ].forEach((t) => {
    test(t.title, async ({ page }) => {
      await page.goto(t.src);
      const link = page.locator(
        `a:text("${t.link_text}")`
      );
      href = await link.getAttribute("href");
      await expect(href).toEqual(t.expected_url)
    });
  });
});
