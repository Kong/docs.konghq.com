---
title: Custom Pages
---

# Custom Pages

Pages are highly customizable using Markdown Components (MDC), allowing to create nested page structures to organize pages and generate URLs/slugs. Visibility controls and Publishing status allow you to stage new Pages, and/or restrict access to logged-in Developers.

To get started creating Pages, navigate to your Dev Portal and select [**Portal Editor**](portal-editor) from the left sidebar.

## Page structure

On the left panel inside Portal Editor, you'll see a list of Pages in your Dev Portal. The name for each page is a `slug`, and will be used to build the URL for that page. If pages are nested, the slugs will be combined to build the URL.
This allows you to organize pages, and convey that organization in the URLs of your Pages.

Example: `about` has a child page, `contact`. The URL for the `contact` page would be `/about/contact`

{:.note}
> *Coming soon: auto-generated navigation MDC components for your Page structure*

### Create a new Page
* Click `+` at the top
* Give the Page a "slug". This will be used in constructing the path. Hit Enter.
* The page will be created, and display in Preview.
* Edit the content of your Page in the middle panel, and you'll see a Live Preview in the right panel.

{:.note}
> *Pages will be created with the Default Visibility as set in your [Settings](../settings/general)*

{:.note}
> *At the bottom of preview, the generated URL for your page will be shown*

{:.note}
> *`home` is a special page representing the `/` path. If this page is deleted, you'll need to create it from the Pages API.*

### Modify a Page

Pages are built using Markdown Components (MDC). Additional documentation on syntax, as well as tools for generating components, are available on a [dedicated MDC site](https://portaldocs.konghq.com/).

In the middle panel, you can make changes to your MDC content, and instantly see the live Preview. 

Once you have completed your changes, be sure to click **Save**.

{:.note}
> *To rename a Page's slug, click the 'three dots' menu, and click Rename*

### Publishing a Page

Newly created pages are in `Draft` status by default. With the Page selected on the left sidebar, click **Publish** in the top right corner, and your Page will be published to the Dev Portal.

### Change Page visibility

In the top right corner, click the menu with three dots. You can toggle from `Private` to `Public`, and vice versa.

{:.note}
> * Fine-grained RBAC is currently not supported in Beta Dev Portals, but will be coming soon

## Create a Child Page

In order to create pages in a nested structure (generating URLs in a folder-style), you can create **Child Pages**. CLick the three dots menu next to any Page, and select **Create Child Page**. As with creating any Page, provide a name/slug, and your Page will be created.