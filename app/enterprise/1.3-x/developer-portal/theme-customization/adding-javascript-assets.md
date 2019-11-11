---
title: Adding and Using Javascript Assets in Kong Dev Portal
---

### Introduction

The Kong Developer Portal ships with Vue, React, and jQuery already loaded. In order to write custom interactive webpages, you may wish to make use of these libraries, or load additional javascript.

Note: This guide is for adding/using javascript assets without changing server-side routing. [Learn more about a SPA to the Dev Portal](/enterprise/{{page.kong_version}}/developer-portal/theme-customization/single-page-app).

### Prerequisites

* Kong Enterprise 1.3 or later
* Portal Legacy is turned off
* The Developer Portal is enabled and running
* kong-portal-cli tool is installed locally


### Adding JS Assets
Warning: Due to compatibility issues, avoid using any React other than React 15 on the `layouts/system/spec-render.html` layout. We recommend if using react, to use the version of react included by the default base theme. If using a different version of react, be sure not to load it on to `layouts/system/spec-render.html`

To add javascript assets:
1. Clone down the kong-portal-templates repo.
2. Add any javascript files to the `themes/base/js` folder.
3. Deploy using the kong-portal-cli-tool.


### Loading JS Assets

You can make use of the existing Vue, and jQuery in any layout/partial that includes `partials/theme/required-scripts.html` where the these scripts are loaded.

By default React is only loaded on `layouts/system/spec-render.html`

if you want to load React or any custom javascript asset on all pages, you can edit `themes/partial/foot.html`

For example if you want to load react on every page, change `themes/partial/foot.html` to be:

{% raw %}
```
{% layout = "layouts/_base.html" %}

{-main-}
  {(partials/header.html)}

  <div class="page">
    {* blocks.content *}
  </div>

  {(partials/footer.html)}
  <script src="assets/js/third-party/react.min.js"></script>

{-main-}
```
{% endraw %}

Alternatively you can load the script you need on the specific layout for each content page as needed.