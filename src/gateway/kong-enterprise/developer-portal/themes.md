---
title: Themes Files
content-type: reference
---

## Theme files
### Themes directory structure
The theme directory contains different instances of portal themes, each one of which determines the look and feel of the Dev Portal via HTML/CSS/JavaScript.  Which theme is used at time of render is determined by setting `theme.name` within `portal.conf.yaml`. Setting `theme.name` to `best-theme` causes the portal to load theme files under `themes/best-theme/**`.

A theme file is composed of a few different directory:
- **assets/**
  - The assets directory contains static assets that layouts/partials will reference at time of render. Includes CSS, JS, font, and image files.
- **layouts/**
  - The layouts directory contains HTML page templates that `content` reference via the `layout` attribute in `headmatter`.
- **partials/**
  - The partials directory contains HTML partials to be referenced by layouts. Can be compared to how layouts and partials interacted in the legacy portal.
- **theme.conf.yaml**
  - This config file sets color and font defaults available to templates for reference as CSS variables. It also determines what options are available in the Kong Manager Appearance page.

### Theme assets

#### Path
- **format:** `theme/*/assets/**/*`

#### Description
The asset directory contains CSS/JavaScript/fonts/images for your templates to reference.

To access asset files from your templates, keep in mind that Kong assumes a path from the root of your selected theme.

| Asset Path | HREF Element |
|--------------------------|---------------------------|
| `themes/light-theme/assets/images/image1.jpeg` | `<img src="assets/images/image1">` |
| `themes/light-theme/assets/js/my-script.js` | `<script src="assets/js/my-script.js"></script>` |
| `themes/light-theme/assets/styles/my-styles.css` | `<link href="assets/styles/normalize.min.css" rel="stylesheet" />` |

>Note: Image files uploaded to the `theme/*/assets/` directory should either be a `svg` text string or `base64` encoded, `base64` images will be decoded when served.

### Theme layouts

#### Path
- **format:** `theme/*/layouts/**/*`
- **file extensions:** `.html`

#### Description
Layouts act as the HTML skeleton of the page you want to render. Each file within the layouts directory must have an `html` file type. They can exist as vanilla `html`, or can reference partials and parent layouts via the portals templating syntax. Layouts also have access to the `headmatter` and `body` attributes set in `content`.

This example shows what a typical layout could look like.

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

To learn more about the templating syntax used in this example, check out our [templating guide](/gateway/{{page.kong_version}}/developer-portal/working-with-templates).

### Theme partials

#### Path
- **format:** `theme/*/partials/**/*`
- **file extensions:** `.html`

#### Description
Partials are very similar to layouts: they share the same syntax, can call other partials within themselves, and have access to the same data/helpers at time of render. The thing that differentiates partials from layouts it that layouts call on partials to build the page, but partials cannot call on layouts.

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

### Theme configuration file

#### Path
- **format:** `theme/*/theme.conf.yaml`
- **file extensions:** `.yaml`

#### Description
The theme configuration file determines color/font/image values a theme makes available for templates/CSS at the time of render. It is required in the root of every theme. There can only be one theme configuration file, it must be named `theme.conf.yaml`, and it must be a direct child of the themes root directory.
