---
title: Portal Editor
---

Portal Editor provides you with a variety of tools for creating highly customized content for your Dev Portal. Navigate to a specific Dev Portal, and select **Portal Editor** from the left sidebar.

{:.note}
> *Pages are built using Markdown Components (MDC). Additional documentation on syntax, as well as tools for generating components, are available on a [dedicated MDC site](https://portaldocs.konghq.com/).*

## Pages

Pages provide a nested structure of page slugs which allows you to organize Pages, and automatically builds your URLs. Pages are highly customizable using Markdown Components (MDC). 

[Get started with Pages](/dev-portal/portals/customization/custom-pages)

## Preview panel

Preview will automatically show what your Page should look like when Developers view your Dev Portal. In the event that it fails to refresh after editing the Page, there is a refresh button next to the generated URL at the bottom. 

### Generated URL

[Custom Pages](/dev-portal/portals/customization/portal-editor) allow you to define a page structure/tree that organizes your pages and generates the page URL based on page `slug`s. The generated URL is shown at the bottom of the Preview pane.

### Viewports

There are three icons above Preview that will allow you to test adaptive designs in some pre-defined viewports.

* Desktop
* Tablet
* Mobile

### Preview limitations

Preview will only show `Visibility:Public` assets like APIs and Menus, as Preview is not fully representing a logged-in Developer context. However, `Visibility: Private` pages will be previewable.

**Examples:**
* `Private` Pages can be displayed in Preview
* `Private` APIs will not be displayed when using the `:apis-list` MDC component
* `Private` Menus in header/footer will not be displayed

## Appearance

Basic appearance settings like brand colors, logo, and favicon can be customized to easiliy convey your branding. For advanced needs, you can also create Custom CSS that applies custom styles to your Dev Portal.

You'll find the Appearance icon in the left sidebar of Portal Editor.

[Customize Appearance](/dev-portal/portals/appearance)

## Additional Customization

Some items like top navigation and SEO optimization/`robots.txt` are availabe in [Customization](/dev-portal/portals/customization), outside of Portal Editor.