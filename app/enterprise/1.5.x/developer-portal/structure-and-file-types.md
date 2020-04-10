---
title: Developer Portal Structure and File Types
book: developer-portal
chapter: 4
---

## Introduction

The Kong Portal templates have been completely revamped to allow for easier customization, clearer separation of concerns between content and layouts, and more powerful hooks into Kong lifecycle/data.  Under the hood we have implemented a flat file CMS built on top of the `https://github.com/bungle/lua-resty-template` library.  This system should feel familiar for anyone who has worked with projects like `jekyll`, `kirby cms`, or `vuepress` in the past.

>Note: To follow along with this guide, it is best to clone the [portal-tempalates-repo](https://github.com/Kong/kong-portal-templates) and check out the `master` branch. This guide makes the assumption that you are working within a single workspace (the templates repo can host many different sets of portal files per workspace).  Navigate to the `workspaces/default` directory from root to view the default workspaces portal files.

## Directory Structure

Navigate to `workspaces/default` from the kong-portal-templates root directory to access the default portals template files. The relative file structure in this directory directly maps to the file `path` schema attribute.  (`content/homepage.txt` here maps to `content/homepage.txt` in Kong).

From `workspaces/default` we can see the different elements that make up a single instance of the kong developer portal:
- **content/**
  - The content directory contains files that determine both site structure of the Kong Dev Portal as well as the dynamic content that renders within each page.
- **specs/**
  - Specs are similar to content in that they contain the data needed to render dynamic content on the page.  In the case of `specs` the files contain valid OAS or Swagger to be rendered as a spec.
- **themes/**
  - The theme directory contains different themes to be applied to the content of the portal.  Each theme contains html templates, assets, and a config file which sets global styles available to the theme.
- **portal.conf.yaml**
  - This config file determines which theme the portal uses to render, the name of the portal, as well configuration for special behavior such as redirect paths for user actions like login/logout.
- **router.conf.yaml (optional)**
  - This optional config file overrides the portals default routing system with hardcoded values.  This is useful for implementing single page applications, as well as for setting a static site structure.

## Portal Configuration File

#### Path
- **format:** `portal.conf.yaml`
- **file extensions:** `.yaml`

#### Description
The Portal Configuration File determines which theme the portal uses to render, the name of the portal, as well as configuration for special behavior such as redirect paths for user actions like login/logout.  It is required in the root of every portal.  There can only be one Portal Configuration File, it must be named `portal.conf.yaml`, and it must be a direct child of the root directory. 

#### Example

```yaml
name: Kong Portal
theme:
  name: light-theme
redirect:
  unauthenticated: login
  unauthorized: unauthorized
  login: dashboard
  logout: ''
  pending_approval: ''
  pending_email_verification: ''
collections:
  posts:
    output: true
    route: /:stub/:collection/:name
    layout: post.html
```

- `name`:
  - **required**: true
  - **type**: `string`
  - **description**: The name attribute is used for meta information, such as setting a title for your portal in the browser tab.
  - **example**: `Kong Portal`
- `theme`
  - **required**: true
  - **type**: `object`
  - **description**: The theme object is used for declaring which theme you would like your portal to render, as well as theme style overrides. While the overrides are not required, declaring which theme you would like to use is.
- `redirect`
  - **required**: true
  - **type**: `object`
  - **description**: The redirect object informs kong how to redirect the user after certain actions. If one of these values is not set, Kong serves a default template based off of the action. Each key represents the name of the action taking place, the value represents the route to which the application redirects the user. 
- `collections`
  - **required**: false
  - **type**: `object`
  - **description**: Collections are a powerful tool enabling you to render sets of content as a group.  Content rendered as a collection share a configurable route pattern, as well as a layout. For more information check out the [collections](/enterprise/{{page.kong_version}}/developer-portal/working-with-templates/#collections) section of our [Working with Templates](/enterprise/{{page.kong_version}}/developer-portal/working-with-templates) guide.


## Router Configuration File (Optional)

#### Path
- **format:** `router.conf.yaml`
- **file extensions:** `.yaml`

#### Description
This optional config file overrides the portals default routing system with hardcoded values.  This is useful for implementing single page applications, as well as for setting a static site structure.  There can only be one Router Configuration File, it must be named `router.conf.yaml`, and it must be a direct child of the root directory.

#### Example
The `router.conf.yaml` file expects sets of key value pairs.  The key should be the route you wish to set, the value should be the content file path you wish that route to resolve to. Routes should begin with a backslash.  `/*` is a reserved route and acts as a catchall/wildcard, if the requested route is not explicitly defined in the config file the portal will resolve to the wildcard route if present.

```yaml
/*: content/index.txt
/about: content/about/index.txt
/dashboard: content/dashboard.txt
```

## Content Files

#### Path
- **format:** `content/**/*`
- **file extensions:** `.txt`, `.md`, `.html`, `.yaml`, `.json`

#### Description
Content files establish portal site structure, as well as provide its accompanying HTML layout with metadata and dynamic content at the time of render. Content files can be nested in as many subdirectories as desired as long as the parent directory is `content/`.

In addition to providing metainfo and content for the current page at time of render, content files determine the path at which a piece of content can be accessed in the browser.

| Content Path | Portal URL |
|-------------|---------------------------|
| `content/index.txt` | `http://portal_gui_url/` |
| `content/about.txt` | `http://portal_gui_url/about` |
| `content/documentation/index.txt` | `http://portal_gui_url/documentation` |
| `content/documentation/spec_one.txt` | `http://portal_gui_url/documentation/spec_one` |

#### Contents
```
---
title: homepage
layout: homepage.html
readable_by: [red, blue]
---

Welcome to the homepage!
```

File contents can be broken down into two parts: `headmatter` and `body`

##### headmatter

The first thing to notice in the example files contents are the two sets of `---` delimiters at the start.  The text contained within these markers is called `headmatter` and always gets parsed and validated as valid `yaml`.  `headmatter` contains information necessary for a file to render successfully, as well as any information you would like to access within a template.  Kong parses any valid `yaml` key-value pair and becomes available within the content's coinciding HTML template. There are a few reserved attributes that have special meaning to Kong at the time of render. They are as follows:

- `title`:
  - **required**: false
  - **type**: `string`
  - **description**: The title attribute is not necessary but is recommended. When set this will set the title of a page in the browser tab.
  - **example**: `homepage`
- `layout`
  - **required**: true
  - **type**: `string`
  - **description**: The layout attribute is required for each piece of content, and determines what html layout to use in order to render the page.  This attribute assumes  a root of the current themes layout directory (`themes/<theme-name>/layouts`).
  - **example**: `bio.html` or `team/about.html`
- `readable_by`
  - **required**: false
  - **type**: `array` (multiple), `string` (singular)
  - **description**: The optional `readable_by` attribute determines which developers can access a piece of content.  In the case of the example above, only developers with rbac roles of "red" or "blue" may access the `/homepage` route.
  - **example**: `[red, blue]` (multiple), `red` (singular)

- `route`
  - **required**: false
  - **type**: `string`
  - **description**: This optional attribute overrides the generated route Kong assigns to content, and replaces it with the route included here.
  - **example**: `route: /example/dog` renders the example page above at `<url>/example/dog` instead of the auto generated `/homepage` route.
- `output`
  - **required**: false
  - **type**: `boolean`
  - **default**: `true`
  - **description**: This optional attribute is `true` by default and determines whether a piece of content should be rendered. (no route or page gets created when this value is set to `false`)
- `stub`
  - **required**: false
  - **type**: `string`
  - **description**: Used by `collection` config to determine custom routing.  You can read more about Collections in the collections section of the _working with templates_ guide.

##### body
The information located under headmatter represents the content body.  Body content is freeform and gets parsed as by the file extension included in the file path.  In the case of the example above, the file is `.txt` and is available in the template as such.

## Spec Files

#### Path
- **format:** `specs/**/*`
- **file extensions:** `.yaml`, `.json`

#### Description
Specs are similar to `content` files in that they provide the dynamic data needed to render a page, as well as any metadata a user wishes to provide as `headmatter`.  The format in which these are provided to the Portal differs from `content` files, which can be seen in the example below.

>It is recommended to keep spec folder structure flat.  Spec files must be valid OAS or Swagger `.yaml`/`.yml` or `.json` files.

#### Contents

```
swagger: "2.0"
info:
  version: 1.0.0
  title: Swagger Petstore
  license:
    name: MIT
host: petstore.swagger.io
basePath: /v1
x-headmatter
  - key1: val1
  - key2: val2
...
```

Spec file contents themselves should be valid OAS or Swagger specifications.  If you would like to inject headmatter into the specification, you can do so by including an `x-headmatter` key to the root of the spec object.  This may be useful if you wanted to for example provide your own renderer template via `x-headmatter.layout` or override the specs default route via `x-headmatter.route`. 

Example:
```
swagger: "2.0"
info:
  version: 1.0.0
  title: Swagger Petstore
  license:
    name: MIT
host: petstore.swagger.io
basePath: /v1
x-headmatter:
  layout: custom/my-spec-renderer.html         <- Custom Layout
  route: my-special-route/myfirstspec          <- Custom Route
...
```

Specs are a collection meaning their `layout` and `route` are determined by the portal configuration and not the file itself.  Specs are rendered by default by the `system/spec-renderer.html` layout, under the route pattern `/documentation/:name` where name is the name of the particular spec file.  So a spec with a path of `specs/myfirstspec.json` renders in the portal as `/documentation/myfirstspec`.  If you would like to overwrite the hardcoded spec collection config, you can do so by including your own in `portal.conf.yaml`.  Check out the Collections section of our `Working with Templates` guide to learn more.

## Theme Files
#### Themes Directory Structure
The theme directory contains different instances of portal themes, each one of which determines the look and feel of the developer portal via html/css/js.  Which theme is used at time of render is determined by setting `theme.name` within `portal.conf.yaml`.  (setting `theme.name` to `best-theme` causes the portal to load theme files under `themes/best-theme/**`).

Each theme file is compromised of a few different folders:
- **assets/**
  - The assets directory contains static assets that layouts/partials will reference at time of render.  Includes CSS, JS, font, and image files.
- **layouts/**
  - The layouts directory contains html page templates that `content` reference via the `layout` attribute in headmatter (see `content` section).
- **partials/**
  - The partials directory contains html partials to be referenced by layouts. Can be compared to how layouts and partials interacted in the legacy portal. 
- **theme.conf.yaml**
  - This config file sets color and font defaults available to templates for reference as css variables.  It also determines what options are available in the Kong Manager Appearance page.

#### Theme Assets

##### Path
- **format:** `theme/*/assets/**/*`

##### Description
The asset folder contains css/js/fonts/images for your templates to reference.

To access asset files from your templates, keep in mind that Kong assumes a path from the root of your selected theme.

| Asset Path | Href Element |
|--------------------------|---------------------------|
| `themes/light-theme/assets/images/image1.jpeg` | `<img src="assets/images/image1">` |
| `themes/light-theme/assets/js/my-script.js` | `<script src="assets/js/my-script.js"></script>` |
| `themes/light-theme/assets/styles/my-styles.css` | `<link href="assets/styles/normalize.min.css" rel="stylesheet" />` |

>Note: Image files uploaded to the `theme/*/assets/` directory should either be a svg text string or `base64` encoded, 'base64` images will be decoded when served.

#### Theme Layouts

##### Path
- **format:** `theme/*/layouts/**/*`
- **file extensions:** `.html`

##### Description
Layouts act as the html skeleton of the page you wish to render.  Each file within the layouts directory must have an `html` filetype.  They can exist as vanilla `html`, or can reference partials and parent layouts via the portals templating syntax.  Layouts also have access to the `headmatter` and `body` attributes set in `content`.

The example below shows what a typical layout could look like.

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

To learn more about the templating syntax used in this example check out our [templating guide](/enterprise/{{page.kong_version}}/developer-portal/working-with-templates).

#### Theme Partials

##### Path
- **format:** `theme/*/partials/**/*`
- **file extensions:** `.html`

##### Description
Partials are very similar to layouts: they share the same syntax, can call other partials within themselves, and have access to the same data/helpers at time of render.  The thing that differentiates partials from layouts it that layouts call on partials to build the page, but partials cannot call on layouts.

The example below shows the `header.html` partial referenced from the example above:

{% raw %}
```html
<header>
  <div class="row">
    <div class="column>
      <img src="{{page.logo}}">      <- can access the same page data the parent layout
    </div>
    <div class="column">
      {(partials/header_nav.html)}   <- partials can call other partials
    </div>
  </div>
</header>
```
{% endraw %}

#### Theme Configuration File

##### Path
- **format:** `theme/*/theme.conf.yaml`
- **file extensions:** `.yaml`

##### Description
The Theme Configuration File determines color/font/image values a theme makes available for templates/CSS at the time of render.  It is required in the root of every theme.  There can only be one Theme Configuration File, it must be named `theme.conf.yaml`, and it must be a direct child of the themes root directory.




