---
title: Markdown Rendering Module
---

## Introduction

The Kong Developer Portal supports
[Github-flavored Markdown](https://github.github.com/gfm/) (GFM) that can be
used instead of the [templates](/enterprise/{{page.kong_version}}/developer-portal/working-with-templates). Instead of 
creating an HTML layout and partials for your templates, you can write custom CSS
with the improved markdown rendering module. Extended markdown support
improves rendering significantly, especially for tables.

## Prerequisites

* Kong Enterprise 2.1 or later
* Access to Kong Manager
* The Developer Portal enabled and running

## Specify the markdown rendering module in a document

1. Create a markdown file for your Dev Portal documentation, and add it to the `content` directory. If you're unfamiliar with markdown, see GitHub's guide to [Mastering Markdown](https://guides.github.com/features/mastering-markdown/). For very basic layout, see the example.
2. Call the markdown module by specifying the `layout` parameter.
3. Specify the `.css` file you want to use. You can use the default GitHub `.css` as shown, or specify your own custom `.css`.

   - All markdown CSS classes should be prepended by `.markdown-body`.  This is
     to ensure that Markdown styles do not bleed into other areas of the portal.
   - The `.css` file should be placed in the current theme's `/assets` directory.
   - The renderer assumes that the `.css` path begins with the `/assets`
     directory. See the example.
   - Other classes defined in any other Dev Portal CSS external to the
     `markdown.css` may pollute your rendered markdown. To unset
     particular styles, work with the
     `/assets/style/markdown-fixes.css` file.

### Example

`/content/markdown-example.md`

```
---
layout: system/markdown.html
css: assets/style/markdown.css
---

# H1

Note the extra line to start a paragraph.

## H2

**Bolded content**

### H3

Best practice is to nest no deeper than H3.

Example table content

Best practice is to keep tables in Markdown as small and simple as possible.

| Column Name | Column Description |
| :--- | :--- |
| Markdown Column | Example description that works in a table |
```
