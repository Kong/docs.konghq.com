---
title: Custom Pages
---

Pages are highly customizable using Markdown Components (MDC), allowing to create nested page structures to organize pages and generate URLs/slugs. Visibility controls and Publishing status allow you to stage new Pages, and/or restrict access to logged-in Developers.

To get started creating Pages, navigate to your Dev Portal and select [**Portal Editor**](/dev-portal/portals/customization/portal-editor/) from the left sidebar.

{:.note}
> *Pages are built using Markdown Components (MDC). Additional documentation on syntax, as well as tools for generating components, are available on a [dedicated MDC site](https://portaldocs.konghq.com/).*

## Page structure

On the left panel inside Portal Editor, you'll see a list of Pages in your Dev Portal. The name for each page is a `slug`, and will be used to build the URL for that page. If pages are nested, the slugs will be combined to build the URL.
This allows you to organize pages, and convey that organization in the URLs of your Pages.

Example: `about` has a child page, `contact`. The URL for the `contact` page would be `/about/contact`

{:.note}
> *Coming soon: auto-generated navigation MDC components for your Page structure*

### Create a new Page
* In the Dev Portal editor, click **New page** in the sidebar.
* Give the Page a "slug". This will be used in constructing the path. Hit Enter.
* The page will be created, and display in Preview.
* Edit the content of your Page in the middle panel, and you'll see a Live Preview in the right panel.

{:.note}
> *Pages will be created with the Default Visibility as set in your [Settings](/dev-portal/portals/settings/general)*

{:.note}
> *At the bottom of preview, the generated URL for your page will be shown*

{:.note}
> *`home` is a special page representing the `/` path. If this page is deleted, you'll need to create it from the Pages API.*

{:.important}
> Custom pages are limited to 1,000,000 characters.

#### Reserved paths

The Portal requires a number of reserved paths from the root of the URL to properly function.
You cannot override these paths with custom pages or other functionality.

| Path | Description | RegExp
|:------|:-------|:-------|
| `/login/*` | Login | `^/login(?:\/.*)?` |
| `/register` | Registration | `^/register` |
| `/forgot-password` | Forgot password | `^/forgot-password` |
| `/reset-password` | Reset password | `^/reset-password` |
| `/logout` | Log out | `^/logout` |
| `/apps/*` | Developer applications | `^/apps` |
| `/api/v*/` | Portal API | `^/api\/v\d+\/.*` |
| `/_proxy/*` | Proxied APIs | `^/_proxy/.*` |
| `/api/*` | Nuxt server endpoints | `^/api\/(?!v\d+\/).*` |
| `/_api/*` | Nuxt server endpoints | `^/_api\/.*` |
| `/npm/*` | CDN Proxy | `^/npm\/.*` |
| `/_preview-mode/*` | Konnect previews | `^/_preview-mode\/.*` |

### Modify a Page

In the middle panel, you can make changes to your MDC content, and instantly see the live Preview.

Once you have completed your changes, be sure to click **Save**.

{:.note}
> *To rename a Page's slug, click the 'three dots' menu, and click Rename*

### Publishing a Page

Newly created pages are in `Draft` status by default. With the Page selected on the left sidebar, click **Publish** in the top right corner, and your Page will be published to the Dev Portal.

### Change Page visibility

In the top right corner, click the menu with three dots. You can toggle from `Private` to `Public`, and vice versa.

{:.note}
> * **Coming soon:** RBAC settings for Pages.*

## Create a Child Page

In order to create pages in a nested structure (generating URLs in a folder-style), you can create **Child Pages**. CLick the three dots menu next to any Page, and select **Create Child Page**. As with creating any Page, provide a name/slug, and your Page will be created.

## Meta tags
To affect page metadata/descriptions (meta tags like  `description` `og:description`), use the `description` field in Page front matter.

### Front matter example

```
---
title: Home
description: Start building and innovating with our APIs
---
```

With the above front matter, the portal will render the following HTML tags for your page:

```
<title>Home | Developer Portal</title>
<meta name="description" content="Start building and innovating with our APIs">
<meta property="og:title" content="Home | Developer Portal">
<meta property="og:description" content="Start building and innovating with our APIs">
```

### OpenGraph

The Dev Portal will automatically generate an Open Graph image for each page on the site which utilizes a default design, and incorporates your brand color and light or dark color mode, along with the page's title and description. This image may be utilized in search results and when sharing links that render page previews (e.g. on X or other social sites).

If you would like to provide a custom Open Graph image, you may do so in the page's front matter by providing the `image` property as a string:

```
---
title: Home
description: Start building and innovating with our APIs
image: https://example.com/images/my-image.png
---
```

If you would like more control over the image, the front matter property also accepts an object interface:

```
---
title: Home
description: Start building and innovating with our APIs
image:
  url: https://example.com/images/my-image.png
  alt: A description of the image
  width: 300px
  height: 200px
---
```
