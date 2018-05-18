---
title: Customizing the Kong Developer Portal
class: page-install-method
---

## **Customizing the look and feel of your Dev Portal**

The Dev Portal default theme is shipped with two CSS file partials:

* `partials/unauthenticated/theme-css.hbs`
    * Default styles for all theme specific elements across the Example Dev Portal.
* `partials/unauthenticated/custom-css.hbs`
    * Partial describing how to change specific parts of the portal without modifying the default theme CSS.

We strongly encourage you to use the `custom-css` over modifying `theme-css` for small changes so you don't affect the original styles.



## Working with Page Layouts

To avoid duplicating code in pages and partials, layout partials can be created and used on multiple pages that share common layout.

The Example Dev Portal includes one basic layout: `partials/layout.hbs`
{% raw %}
```handlebars
{{#if pageTitle}}
  {{> unauthenticated/title }}
{{/if}}

{{#> styles-block}}
  {{!--
    These are the default styles, but can be overridden.
  --}}
  {{> unauthenticated/theme-css}}
  {{> custom-css}}
{{/styles-block}}

{{#> header-block}}
  {{!--
    The `header` partial is the default content, but can be overridden.
  --}}
  {{> header }}
{{/header-block}}

{{#> content-block}}
  {{!-- Default content goes here. --}}
{{/content-block}}

{{#> footer-block}}
  {{!--
    The `footer` partial is the default content, but can be overridden.
  --}}
  {{> unauthenticated/footer }}
{{/footer-block}}

{{#> scripts-block}}
  {{!-- Custom scripts per page can be added.
    {{> unauthenticated/custom-js}}
   --}}
  {{> unauthenticated/auth-js auth=false}}
{{/scripts-block}}
```
{% endraw %}



## Adding Image, Video, or other file types to a Page

The Dev Portal File API serves only **Pages**, **Partials**, and **Specifications**. To add images, videos, and other file types to your pages, you must either add them inline (e.g. inline SVG) or link to the files being served by another web server.
