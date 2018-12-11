---
title: Known Limitations - Developer Portal
---

# Introduction

The Dev Portal is built with customization of content, look, feel, and structure in mind. That being said there are a few things to keep in mind while building to ensure everything works as expected.

* When a user requests a particular page to access that they are not authorized to view, the Dev Portal will check for the same filename under the '***unauthenticated***' namespace to serve instead. For this reason the '***unauthenticated***' namespace is reserved, and should be used explicitly for authentication.
* The `spec-renderer` plays an integral part in (you guessed it) spec rendering. You will get best results by utilizing the partial for spec rendering needs, or if completely necessary closely following the pattern established by it.
* The Dev Portal routing mechanism seeks out **index.hbs** and** loader.hbs** files to inform certain behaviour (see **File Paths**).  Use these filenames only when you the seek specific functionality they bring to avoid unwanted side affects.
* You cannot upload two files with the same name (regardless of file type).
* The Dev Portal loader only supports template types: `specification`, `partial`, or `page` (while the file API *will* accept other template types, the loader will not recognize them).
* The Dev Portal File API can only fetch a total of 100 files of each type (`specification`, `partial`, or `page`) stored in Kong and served to your Dev Portal.
* The handlebars loader will not serve content that is *not* of file type:
    * `.hbs`  - layout, styles, JavaScript.
        * Media like images, SVGs, and videos should encoded and inserted inline or hosted elsewhere and referenced.
        * Custom JS and CSS (or supported pre-processors) should be nested in `<style>` or `<script>` tags (or served through a CDN) and placed in a partial.
    * `.json` or `.yaml` - spec files.
* Swagger 2 and OpenAPI 3 are the only spec formats currently formatted.
* `<meta>`  and `<head>` tags are not modifiable via html, you can accomplish this through custom JS included as a handlebars partial.
* Spec renderer must render API specification served by the Files API - it cannot reference an API served via URL.
* Content in Markdown format is not currently supported.
