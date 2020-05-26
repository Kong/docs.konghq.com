---
title: Adding and Using JavaScript Assets in Kong Dev Portal
---

### Introduction

The Kong Developer Portal ships with Vue, React, and jQuery already loaded. In order to write custom interactive webpages, you may want to make use of these libraries, or load additional JavaScript.

> Note: This guide is for adding/using javascript assets without changing server-side routing. [Learn more about a SPA to the Dev Portal](/enterprise/{{page.kong_version}}/developer-portal/theme-customization/single-page-app).

### Prerequisites

* Kong Enterprise 1.3 or later
* Portal Legacy is turned off
* The Kong Developer Portal is enabled and running
* The [kong-portal-cli tool](/enterprise/{{page.kong_version}}/developer-portal/helpers/cli) is installed locally


### Adding JS Assets
> Warning: Due to compatibility issues, avoid using any React version other than React 15 on the `layouts/system/spec-render.html` layout. We recommend using the version of React included by the default base theme.

To add javascript assets:
1. Clone the [kong-portal-templates](https://github.com/Kong/kong-portal-templates) repo.
2. Add any javascript files to the `themes/base/js` folder.
3. Deploy using the kong-portal-cli-tool.


### Loading JS Assets

You can make use of the existing Vue and jQuery in any layout/partial that includes `partials/theme/required-scripts.html` where these scripts are loaded.

By default, React is only loaded on `layouts/system/spec-render.html`.

If you want to load React or any custom JavaScript asset on all pages, you can edit `themes/partial/foot.html`.


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

Alternatively, you can load the script you need on the specific layout for each content page as needed.
