---
title: API Documentation
---

Konnect APIs can be documented with a tree of Markdown files, automatically generating URL slugs for the Dev Portal when published.

{:.note}
> *API Documentation is for a single API+version, to create portal-level content, use [Custom Pages](/dev-portal/portals/customization/custom-pages) in the [Portal Editor](/dev/portal/portals/customization/portal-editor)*

## Create a new API document

1. Navigate to a specific API from [APIs](/dev-portal/apis) or [Published APIs](/dev-portal/portals/publishing)
2. Select the **Documentation** tab
3. Click **New Document**
4. Select **Start with a file** and Upload a Markdown document, or **Start with an empty document** and provide the Markdown content.

### Page structure

The `slug` and `parent` fields create a tree of documents, and builds the URL based on the slug/parent relationship. This document structure lives under a given API.

* **Page name**: the name used to populate the `title` in the front matter of the Markdown document
* **Page slug**: the `slug` used to build the URL for the document within the document structure
* **Parent page**: when creating a document, selecting a parent page creates a tree of relationships between the pages. This allows for effectively creating categories of documentation.

#### Example
* **API slug**: `routes`
* **API version**: `v3`
* **Page 1:** `about`, parent `null`
* **Page 2:** `info`, parent `about`

Generated URL for `about` page: `/apis/routes-v3}/docs/about`
Generated URL for `info` page: `/apis/routes-v3}/docs/about/info`

## Publishing and visibility

When the document is complete, toggle Published on to make the page available on your portal, assuming all parent pages are Published as well.

* The Visibility of API documents are inherited from the API's visibility and access controls. 
* If a parent page is unpublished, all child pages will also be unpublished. 
* If no parent pages are published, no API documentation will be visible, and the APIs list will navigate directly to generated specifications.

