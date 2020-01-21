---
title: Understanding the Kong Developer Portal
---

## Introduction

The Kong Dev Portal is composed of different types of files that are stored in Kong's database and exposed through a read-only Public Dev Portal API (`:8004/files`) used by the Dev Portal Loader (`:8003`) to render your Dev Portal.

To change the appearance and functionality of your Dev Portal, you can modify the contents of the files stored in Kong's database using the Dev Portal File API on the Admin API (`:8001/files`).

## File Types

![alt text](https://konghq.com/wp-content/uploads/2018/03/diagram-partials-02.png "File types diagram")

Dev Portals served by Kong are comprised of three primary file types; **Pages**, **Partials**, and **Specifications**. The unique look, feel, and content of your Dev Portal is controlled through creating and editing these three file types.


* **Page**
    * Handlebars file.
    * Pages can be accessed by appending the Page name to your Dev Portal URL: `:8003/<page_name>`
    * Pages are indicated by `type=page` in Dev Portal File API.
* **Partial** 
    * Handlebars partial registered by name for use within a Pages and other Partials.
    * Partials can be re-used and shared between all pages using the Handlebars import statement:
        *  {% raw %} `{{> partial_name}}`{% endraw %}
    * Partials are indicated by `type=partial` in Dev Portal File API.
* **Specification**
    * Open API (Swagger) Spec files that are passed to the OpenAPI Spec Renderer and the Pages / Partials.
    * Kong Dev Portal is compatible with Swagger version 2.x and OpenAPI Spec version 3.x files.
        * Specification files **must** be in _YAML_ or _JSON_ format.
    * Specifications are indicated by `type=spec` in Dev Portal File API.

## File Requirements

* File names **must not** include the file extension, unless you wish your pages and partials to be referenced with them.
    * A **Page** with `name=guides.hbs` would be accessible at: `http://127.0.0.1:8003/guides.hbs`
    * A **Page** with `name=guides` would be accessible at: `http://127.0.0.1:8003/guides`
* File names **must** be _unique_.
    * You cannot have more than one file with the same name, even if they are of different types.
* Files **must** be of the type: `partial` or `page` or `spec`
    * Other file formats like image and video are not supported by the Files API, and must be served either from another web server or added inline.
* Pages and Partials **must** be written in _[Handlebars](https://handlebarsjs.com/)_
    * Files with the `.hbs` extension may contain HTML or [Handlebars](https://handlebarsjs.com/) code
* Specification files **must** be in _YAML_ or _JSON_ format

## Example Files

The following list describes the files that make up the Example Dev Portal being served by Kong:

### ⚠️ Important Notice

The file names displayed below reference the file name within the Example Dev Portal files archive. The file extension **must not** be included in the file name when creating, or updating files in the Dev Portal Admin API.

### Pages

These pages make up the Example Dev Portal. If authentication is enabled, these pages are accessible only to authenticated users.

* **pages/index.hbs**
    * The page that is served when when visitors access the root URL of your Dev Portal.
* **pages/about.hbs**
    * Sample 'about' page that extends the base `layout` partial.
* **pages/guides.hbs**
    * Sample 'guides' page that extends the base `layout` partial.
* **pages/404.hbs**
    * The page that visitors get when they navigate to a non-existent URL of your Dev Portal.
* **pages/documentation/index.hbs**
    * See Virtual Paths And The Specification Loader section for more information.
* **pages/documentation/loader.hbs**
    * See Virtual Paths And The Specification Loader section for more information.
* **pages/documentation/api1.hbs**
    * A static page that renders the `petstore` spec using the `spec-renderer` partial using the `spec` argument.
* **pages/documentation/api2.hbs**
    * A static page that renders the `vitals` spec using the `spec-renderer` partial using the `spec` argument.

### Partials

These partials make up the Example Dev Portal. If authentication is enabled, these pages are accessible only to authenticated users.

* **partials/layout.hbs**
    * Base layout template for the Example Developer Portal which contains references to the `header`,  `footer`,  `theme-css`,  `custom-css`, and `title` partials. The base layout can be extended using inline partial references inside of **Pages**. An example is the `about.hbs` page.
* **partials/header.hbs**
    * The default Example Dev Portal header partial for authenticated users.
* **partials/sidebar.hbs**
    * The default Example Dev Portal sidebar that is included in the `documentation/{api1,api2,loader}` pages that includes the `sidebar-spec` partial and a link to the `guides.hbs` page.
* **partials/sidebar-spec.hbs**
    * This partial renders a list of links to methods found in the specification loaded through the `spec-renderer` partial.
* **partials/spec-renderer.hbs**
    * This partial renders a specification from the Dev Portal Files API. When the `spec` argument is used it does a direct lookup for either a `json` or `yaml` spec file.
* **partials/spec-dropdown.hbs**
    * This partial renders a dropdown allowing access to all specs stored in the Dev Portal Files API, as well as illustrates how custom components can be built and utilized.
* **partials/custom-js.hbs**
    * This partial defines JavaScript that runs on all pages in the Example Dev Portal - it is “empty” and ready for you to customize

### Specifications

* **specs/petstore.json**
    * API specification file, in Swagger 2.0 and JSON format.
* **specs/vitals.yaml**
    * Another API specification file, in Swagger 2.0 and YAML format.

### Unauthenticated pages and partials

See **Adding Authentication** for more information. Some of these files are shared files. These files will be modified later. You can duplicate these and remove the shared dependency if you prefer.

## File Paths

Files can be served under nested paths, called *namespaces*, to allow further control over how your content is organized and served.

1. To serve a page named `api1` under the namespace `/documentation`:
    1. Upload a Page with `name=documentation/api1` to the Dev Portal File API
        1. We have already done this for you. You can view this file in the Example Dev Portal file archive you downloaded and sync'd earlier, you can also view it from the Dev Portal File API.
    2. Navigate in your browser to `:8003/documentation/api1`
    3. You will see the contents of the Page you just uploaded to the Dev Portal File API. This is how namespaces work.
2. In order to serve content on the namespace itself (e.g. `/documentation`) you can either:

    1. Upload a page with `name=documentation`
    2. Upload a Page with `name=documentation/index`
        1. We have already uploaded a file with this name to your Dev Portal File API earlier in the Uploading the Example Dev Portal files section. You can view this file in both the archive and inside of your Dev Portal File API.

    * Navigate in your browser to `:8003/documentation` in either of these cases to see the pages content.

### Virtual Paths and the Specification Loader

**Virtual Paths** allow you the ability to dynamically render Specification files without creating a page for each Specification.


> You may have noticed the two static Specification file pages as well as the Specification Loader `documentation/loader` within the Example Dev Portal

The inclusion of a **Specification Loader** (a file defined by `name=<namespace>/loader`),  as well as the inclusion of the `spec-renderer` partial within the Specification Loader itself, enables the following functionality:

* When the Specification Loader is present under a namespace (e.g. `/documentation/loader`) visiting a path such as `/documentation/spec-1` will attempt to render a Specification file uploaded with the name `spec-1`.
* If the Specification does not exist in the Dev Portal File API the path visited will return the **404** page.

An example Specification Loader is as follows:

> Note: while layout of the loader page is flexible the inclusion of the `spec-renderer` partial is required in order to provide spec rendering functionality. Furthermore the Dev Portal needs **all** elements of the `spec-renderer` partial to remain as is to function as expected.
![alt text](https://konghq.com/wp-content/uploads/2018/03/code-spec-renderer.png "Logo Title Text 1")
