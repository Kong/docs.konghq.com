---
title: Markdown Rendering Module
---

## Introduction

The Kong Developer Portal supports
[Github-flavored markdown](https://github.github.com/gfm/) (GFM) that can be
used in lieu of the [templates](/enterprise/{{page.kong_version}}/developer-portal/working-with-templates). Instead of having to
create an HTML layout and partials for your templates, you can use custom CSS
with the improved markdown rendering module. The extended markdown support
improves rendering significantly, especially for tables.

## Prerequisites

* Kong Enterprise 2.1 or later
* Access to Kong Manager
* The Developer Portal is enabled and running

## Specify the markdown rendering module in a document

1. Create a markdown file for your Dev Portal documentation.
2. Call the markdown module using the `layout` parameter.
3. Specify the `.css` file you want to use. You can use the default Github `.css` as shown, or specify your own custom `.css`.

   - All markdown CSS classes should be prepended by `.markdown-body`.  This is
     to ensure that markdown styles do not bleed into other areas of the portal.
   - The `.css` file should be placed in the current theme's `/assets` directory.
   - The renderer assumes the `.css` path will begin from the `/assets`
     directory. See the example below.
   - Other classes defined in any other Dev Portal CSS external to the
     `markdown.css` may pollute your rendered markdown. If you want to unset
     particular styles, you can do so using the
     `/assets/style/markdown-fixes.css` file.

### Example

`/content/markdown-example.md`

```
---
layout: system/markdown.html
css: assets/style/markdown.css
---
```
