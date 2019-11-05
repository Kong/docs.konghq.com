---
title: Developer Portal Structure and File Types
book: developer-portal
chapter: 4
---

### Introduction

The Kong Portal templates have been completely revamped to allow for easier customization, clearer separation of concerns between content and layouts, and more powerful hooks into Kong lifecycle/data.  Under the hood we have implemented a flat file CMS built on top of the `https://github.com/bungle/lua-resty-template` library.  This system should feel familiar for anyone who has worked with projects like `jekyll`, `kirby cms`, or `vuepress` in the past.

>Note: To follow along with this guide, it is best you clone down the [portal-tempalates-repo](https://github.com/Kong/kong-portal-templates) and checkout the `dev-master` branch. This guide will make the assumption that you are working within a single workspace (the templates repo can host many different sets of portal files per workspace).  Navigate to the `workspaces/default` directory from root to view the default workspaces portal files.


### Directory Structure

Navigate to `workspaces/default` from the kong-portal-templates root directory to access the default portals template files. The relative file structure in this directory will directly map to the file `path` schema attribute.  (`content/homepage.txt` here will map to `content/homepage.txt` in Kong).

From `workspaces/default` we can see the different elements that make up a single instance of the kong developer portal:
- **content**
  - The content directory contains files that determine both site structure of the Kong Dev Portal as well as the dynamic content that will be rendered within each page.
- **specs**
  - Specs are similar to content in that they contain the data needed to render dynamic content on the page.  In the case of `specs` the files contain valid OAS or Swagger to be rendered as a spec.
- **themes**
  - The theme directory contains different themes to be applied to the content of the portal.  Each theme contains html templates, assets, and a config file which sets global styles available to the theme.
- **portal.conf.yaml**
  - This config file determines which theme the portal uses to render, the name of the portal, as well configuration for special behavior such as redirect paths for user actions like login/logout.


#### `portal.conf.yaml`

The `portal.conf.yaml` file determines which theme the portal uses to render, the name of the portal, as well configuration for special behavior such as redirect paths for user actions like login/logout.  It is required in the root of every portal.

Example:
```
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
```

- ###### `name`:
  - **required**: true
  - **type**: `string`
  - **description**: The name attribute is used for meta information, such as setting a title for your portal in the browser tab.
  - **example**: `Kong Portal`
- ###### `theme`
  - **required**: true
  - **type**: `object`
  - **description**: The theme object is used for declaring which theme you would like your portal to render, as well as theme style overrides. While the overrides are not required, declaring which theme you would like to use is.
- ###### `redirect`
  - **required**: true
  - **type**: `object`
  - **description**: The redirect object informs kong how to redirect the user after certain actions.  If one of these values is not set, Kong will serve a default template based off of the action.

#### `content/`
Content files establish portal site structure, as well as provide its accompanying html template with metadata and dynamic content at time of render. Below is an example of a basic content file:

##### path
`content/homepage.txt`

The path of a piece of content determines not only how a file is parsed, but the route in which it will render in the portal site structure.  Below are examples of file paths and how they will be rendered in the portal:
  - `content/index.txt` -> `/`
  - `content/homepage.txt` -> `/homepage`
  - `content/guides/index.txt` -> `/guides`
  - `content/guides/howtocode.txt` -> `/guides/howtocode`


##### contents
```
---
title: homepage
layout: homepage.html
readable_by: [red, blue]
---

Welcome to the homepage!
```

Content can be broken down into two parts:

##### headmatter

The first thing you will notice in the example files contents are the two sets of `---` delimeters at the start.  The text contained within these markers is called `headmatter` and will always be parsed and validated as valid `yaml`.  `headmatter` contains information necessary for a file to render successfully, as well as any information you would like to access within a template.  Any valid `yaml` key value pair will be parsed by Kong and made available within the contends coinciding html template. There are a few reserved attributes that have special meaning to Kong at time of render. They are as follows:

- ###### `title`:
  - **required**: false
  - **type**: `string`
  - **description**: The title attribute is not necessary but is recommended. When set this will set the title of a page in the browser tab.
  - **example**: `homepage`
- ###### `layout`
  - **required**: true
  - **type**: `string`
  - **description**: The layout attribute is required for each piece of content, and determines what html layout to use in order to render the page.  This attribute assumes  a root of the current themes layout directory (`themes/<theme-name>/layouts`).
  - **example**: `bio.html` or `team/about.html`
- ###### `readable_by`
  - **required**: false
  - **type**: `array` (multiple), `string` (singular)
  - **description**: The optional readable_by attribute determines which developers can access a piece of content.  In the case of the example above, only developers with rbac roles of "red" or "blue" may access the `/homepage` route.
  - **example**: `[red, blue]` (multiple), `red` (singular)

- ###### `route`
  - **required**: false
  - **type**: `string`
  - **description**: This optional attribute overrides the generated route Kong assigns to content, and replaces it with the route included here.
  - **example**: `route: /example/dog` will render the example page above at `<url>/example/dog` instead of the auto generated `/homepage` route.
- ###### `output`
  - **required**: false
  - **type**: `boolean`
  - **default**: `true`
  - **description**: This optional attribute is `true` by default and determines whether a piece of content should be rendered. (no route or page will be created when set to `false`)
- ###### `stub`
  - **required**: false
  - **type**: `string`
  - **description**: Used by `collection` config to determine custom routing.  You can read more about Collections in the collections section of this guide.

##### body
The information located under headmatter represents the content body.  Body content is freeform and will be parsed as by the file extension included in the file path.  In the case of the example above, the file is `.txt` and will be available in the template as such.

#### `specs/`
Specs are similar to `content` files in that they provide the dynamic data needed to render a page, as well as any metadata a user wishes to provide as `headmatter`.  The format in which these are provided to the Portal differs from `content` files, which can be seen in the example below:

#### path
`specs/myfirstspec.yaml`

Pathing for specs is very simple, it is recommended to keep spec folder structure flat.  Spec files must be valid OAS or Swagger `.yaml` or `.json` files.

#### contents
```
swagger: "2.0"
layout: system/spec-renderer.html
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

Spec file contents themselves should be valid OAS or Swagger specifications.  If you would like to inject headmatter to the specification, you can do so by including an `x-headmatter` key to the root of the spec object.  This may be useful if you wanted to for example provide your own renderer template via `headmatter.layout` or override the specs default route via `headmatter.route`. 

Example:
```
swagger: "2.0"
layout: system/spec-renderer.html
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

Specs are a collection meaning their `layout` and `route` are determined by portal configuration and not the file itself.  Specs are rendered with the `system/spec-renderer.html` layout, under the route pattern `/documentation/:name` where name is the name of the particular spec file.  So a spec with a path of `specs/myfirstspec.json` will render in the portal as `/documentation/myfirstspec`.  If you would like to overwrite the hard coded spec collection config, you can do so by including your own in `portal.conf.yaml`.


#### `themes/<theme-name>/...`
The theme directory contains different instances of portal themes, each one of which determines the look and feel of the developer portal via html/css/js.  Which theme is used at time of render is determined by setting `theme.name` within `portal.conf.yaml`.  (setting `theme.name` to `best-theme` will cause the portal to load theme files under `themes/best-theme/**`).

Each theme file is compromised of a few different folders:
- **assets/**
  - The assets directory contains static assets that layouts/partials will reference at time of render.  Includes CSS, JS, font, and image files.
- **layouts/**
  - The layouts directory contains html page templates that `content` reference via the `layout` attribute in headmatter (see `content` section).
- **partials/**
  - The partials directory contains html partials to be referenced by layouts. Can be compared to how layouts and partials interacted in the legacy portal. 
- **theme.conf.yaml**
  - This config file sets color and font defaults available to templates for reference as css variables.  It also determines what options are available in the Kong Manager Appearance page.

#### assets
The asset folder contains css/js/fonts/images for your templates to reference.  To access asset files from your templates, keep in mind that Kong assumes a path from the root of your selected theme.

- Examples:
  - `themes/light-theme/assets/images/image1.jpeg` -> `<img src="assets/images/image1">`
  - `themes/light-theme/assets/js/my-script.js` -> `<script src="assets/js/my-script.js"></script>`
  - `themes/light-theme/assets/styles/my-styles.css` -> `<link href="assets/styles/normalize.min.css" rel="stylesheet" />`

#### layouts
Layouts act as the html skeleton of the page you wish to render.  Each file within the layouts directory must have an `html` filetype.  They can exist as vanilla `html`, or can reference partials and parent layouts via the portals templating syntax.  Layouts also have access to the `headmatter` and `body` attributes set in `content`.

The example below shows what a typical layout could look like.

```
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

To learn more about the templating syntax used in this example check out the `templating` section.

#### partials
Partials are very similar to layouts: they share the same syntax, can call other partials within themselves, and have access to the same data/helpers at time of render.  The thing that differentiates partials from layouts it that layouts call on partials to build the page, but partials cannot call on layouts.

The example below shows the `header.html` partial referenced from the example above:

```
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
