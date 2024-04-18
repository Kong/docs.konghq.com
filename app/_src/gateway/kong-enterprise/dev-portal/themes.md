---
title: Themes Files
content-type: reference
---

## Theme files
### Themes directory structure
Theme files allow you to determine the look and feel of the Dev Portal using HTML, CSS, and JavaScript. The theme directory contains different instances of portal themes. The theme that is used during rendering is determined by configuring the `theme.name` in the `portal.conf.yaml` file. For example, if you set `theme.name` to `best-theme`, the Dev Portal loads theme files in `themes/best-theme/**`.

A theme file is composed of the following directories:
- **assets/**: Contains static assets that layouts and partials reference during rendering. Includes CSS, JS, font, and image files.
- **layouts/**: Contains HTML page templates that `content` references via the `layout` attribute in `headmatter`
- **partials/**: Contains HTML partials that are referenced by layouts.
- **theme.conf.yaml**: Sets the color and font defaults that are available to templates as CSS variables. It also determines which options are available on the Kong Manager appearance page.

## Theme assets

### Path
- **format:** `theme/*/assets/**/*`

### Description
The asset directory contains CSS, JavaScript, fonts, and images for your templates to reference.

To access asset files from your templates, keep in mind that {{site.base_gateway}} assumes a path from the root of your selected theme.

| Asset Path | HREF Element |
|--------------------------|---------------------------|
| `themes/light-theme/assets/images/image1.jpeg` | `<img src="assets/images/image1">` |
| `themes/light-theme/assets/js/my-script.js` | `<script src="assets/js/my-script.js"></script>` |
| `themes/light-theme/assets/styles/my-styles.css` | `<link href="assets/styles/normalize.min.css" rel="stylesheet" />` |

{:.note}
> **Note:** Image files uploaded to the `theme/*/assets/` directory should either be a `svg` text string or `base64` encoded. `base64` images are decoded when served.

## Theme layouts

### Path
- **format:** `theme/*/layouts/**/*`
- **file extensions:** `.html`

### Description
Layouts act as the HTML skeleton of the page you want to render. Each file in the layouts directory must have an `html` file type. They can exist as vanilla `html` or reference partials and parent layouts via the portals templating syntax. Layouts also have access to the `headmatter` and `body` attributes set in `content`.

This example shows what a typical layout can look like:

{% raw %}
```html
<div class="homepage">
  {(partials/header.html)}       <- syntax for calling a partial within a template
  <div class="page">
    <div class="row">
      <h1>{{page.title}}</h1>    <- 'title' retrieved from page headmatter
    </div>
    <div class="row">
      <p>{{page.body}}</p>       <- 'body' retrieved from page body
    </div>
  </div>
  {(partials/footer.html)}
</div>
```
{% endraw %}

To learn more about the templating syntax used in this example, see the [template guide](/gateway/{{page.release}}/kong-enterprise/dev-portal/working-with-templates/).

## Theme partials

### Path
- **format:** `theme/*/partials/**/*`
- **file extensions:** `.html`

### Description
Partials are very similar to layouts: they share the same syntax, can call other partials within themselves, and have access to the same data/helpers during rendering. Partials are differentiated from layouts in that layouts call on partials to build the page, but partials cannot call on layouts.

This example shows the `header.html` partial referenced from previous example:

{% raw %}
```html
<header>
  <div class="row">
    <div class="column">
      <img src="{{page.logo}}">      <- can access the same page data the parent layout
    </div>
    <div class="column">
      {(partials/header_nav.html)}   <- partials can call other partials
    </div>
  </div>
</header>
```
{% endraw %}

## Theme configuration file

### Path
- **format:** `theme/*/theme.conf.yaml`
- **file extensions:** `.yaml`

### Description
The theme configuration file determines color, font, and image values that a theme makes available to templates and CSS during rendering. It is required in the root of every theme. There can only be one theme configuration file. It must be named `theme.conf.yaml` and it must be a direct child of the themes root directory.
