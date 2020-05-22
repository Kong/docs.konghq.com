---
title: Working with Templates
---

### Introduction

Kong Portal 1.3 is built on top of the `lua-resty-template` templating library, which can be viewed here: https://github.com/bungle/lua-resty-template. Basic usage of the library will be described below. Refer to the source documentation for a more in-depth look at what it can accomplish.

### Syntax
***(excerpt from lua-resty-templates documentation)***

You may use the following tags in templates:
{% raw %}
* `{{expression}}`, writes result of expression - html escaped
* `{*expression*}`, writes result of expression
* `{% lua code %}`, executes Lua code
* `{(path-to-partial)}`, include `partial` file by path, you may also supply context for the file `{(partials/header.html, { message = "Hello, World" } )}`

* `{-block-}...{-block-}`, wraps inside of a `{-block-}` to a value stored in a `blocks` table with a key `block` (in this case), see [using blocks](https://github.com/bungle/lua-resty-template#using-blocks). Don't use predefined block names `verbatim` and `raw`.
* `{-verbatim-}...{-verbatim-}` and `{-raw-}...{-raw-}` are predefined blocks whose inside is not processed by the `lua-resty-template` but the content is outputted as is.
* `{# comments #}` everything between `{#` and `#}` is considered to be commented out (i.e., not outputted or executed).
{% endraw %}

### Using Partials

Partials are snippets of html that layouts can reference. Partials have access to all the same data that its layout does, and can even call other partials.  Breaking your code into partials can help organize large pages, as well as allow different layouts share common page elements.

##### content/index.txt

{% raw %}
```
---
layout: index.html
title: Partials
header_logo: assets/images/example.jpeg
header_nav_items:
  about:
    href: /about
  guides:
    href: /guides
hero_title: Partials Info
hero_description: Partials are wicked sick!
---
```
{% endraw %}

##### layouts/index.html

{% raw %}
```html
{(partials/header.html)}
<div class="content">
  {(partials/hero.html)}
</div>
{(partials/footer.html)}
```
{% endraw %}

##### partials/header.html

{% raw %}
```html
<header class="row">
  <div class="column">
    <img src="{{page.header_logo}}"/>
  </div>
  <div class="column">
    {(partials/header_nav.html)}
  </div>
</header>
```
{% endraw %}

##### partials/header_nav.html

{% raw %}
``` html
<ul>
  {% for title, href in each(page.header_nav_items) do %}
    <li><a href="{{href}}">{{title}}</a></li>
  {% end %}
</ul>
```
{% endraw %}

##### partials/hero.html

{% raw %}
``` html
<h1>{{page.hero_title}}</h1>
<p>{{page.hero_description}}</p>
```
{% endraw %}


##### partials/hero.html

{% raw %}
``` html
<footer>
  <p>footer</p>
</footer>
```
{% endraw %}


##### Output

{% raw %}
```html
<header class="row">
  <div class="column">
    <img src="assets/images/example.jpeg"/>
  </div>
  <div class="column">
    <ul>
      <li><a href="/about">about</a></li>
      <li><a href="/guieds">guides</a></li>
    </ul>
  </div>
</header>
<h1>Partials Info</h1>
<p>Partials are wicked sick!</p>
<footer>
  <p>footer</p>
</footer>
```
{% endraw %}

### Using Blocks

Blocks can be used to embed a view or partial into another template. Blocks are particularly useful when you want different templates to share a common wrapper.

In the example below, notice that the content file is referencing `index.html`, and not `wrapper.html`.

##### content/index.txt

{% raw %}
```markdown
---
layout: index.html
title: Blocks
description: Blocks are the future!
---
```
{% endraw %}


##### layouts/index.html

{% raw %}
```html
{% layout = "layouts/wrapper.html" %}    <- syntax declaring where to find the block

{-main-}                                 <- delimiter describing what content renders in block
<div class="content">
  <h1>{{page.title}}</h1>
  <p>{{page.description}}<p>
</div>
{-main-}
```
{% endraw %}

##### layouts/wrapper.html

{% raw %}
```html
<!DOCTYPE html>
<html>
  <head>
    <title>Testing lua-resty-template blocks</title>
  </head>
  <body>
    <header>
      <p>header</p>
    </header>
    {*main*}                 <- syntax indicating where to place the block
    <footer>
      <p>footer</p>
    </footer>
  </body>
</html>
```
{% endraw %}

##### Output

{% raw %}
```html
<!DOCTYPE html>
<html>
  <head>
    <title>Testing lua-resty-template blocks</title>
  </head>
  <body>
    <header>
      <p>header</p>
    </header>
    <div class="content">
      <h1>Blocks</h1>
      <p>Blocks are the future!<p>
    </div>
    <footer>
      <p>footer</p>
    </footer>
  </body>
</html>
```
{% endraw %}

### collections
Collections are a powerful tool enabling you to render sets of content as a group.  Content rendered as a collection share a configurable route pattern, as well as a layout. Collections are configured in your portals `portal.conf.yaml` file.

The example below shows all the necessary configuration/files needed to render a basic `blog` collection made up of individual `posts`.

#### portal.conf.yaml

{% raw %}
```
name: Kong Portal
theme:
  name: base
collections:
  posts:
    output: true
    route: /:stub/:collection/:name
    layout: post.html
```
{% endraw %}

Above you can see a `collections` object was declared, which is made up of individual collection configurations. In this example, you are configuring a collection called `posts`.  The renderer looks for a root directory called `_posts` within the `content` folder for individual pages to render.  If you created another collection conf called `animals`, the renderer would look for a directory called `_animals` for content files to render.

Each configuration item is made up of a few parts:
- ###### `output`
  - **required**: false
  - **type**: `boolean`
  - **description**: This optional attribute determines whether the collections should render or not. When set to `false`, virtual routes for the collection are not created.
- ###### `route`
  - **required**: true
  - **type**: `string`
  - **default**: `none`
  - **description**: The `route` attribute is required and tells the renderer what pattern to generate collection routes from. A collection route should always include at least one valid dynamic namespace that uniquely identifies each collection member.
    - Any namespace in the route declaration which begins with `:` is considered dynamic.
    - Only certain dynamic namespaces are recognized by Kong as valid:
      - `:title`: Replaces namespace with a contents `title`, declared in headmatter.
      - `:name`: Replaces namespace with the filename of a piece of content.
      - `:collection`: Replaces namespace with name of current collection.
      - `:stub`: Replaces namespace with value of `headmatter.stub` in each contents headmatter.
- ###### `route`
    - **required**: true
      - **type**: `boolean`
      - **description**: The `layout` attribute determines what HTML layout the collections use to render. The path root is accessed from within the current themes `layouts` directory.

##### `content/_posts/post1.md`

{% raw %}
```
---
title: Post One
stub: blog
---

This is my first post!
```
{% endraw %}


##### `content/_posts/post2.md`

{% raw %}
```
---
title: Post Two
stub: blog
---

This is my second post!
```
{% endraw %}

##### `themes/base/layouts/post.html`

{% raw %}
```html
<h1>{{ page.title }}</h1>
<p>{* page.body *}</p>
```
{% endraw %}

#### Output:

##### `<kong_portal_gui_url>/blog/posts/post1`

```html
<h1>Post One</h1>
<p>This is my first post!</p>
```

##### `<kong_portal_gui_url>/blog/posts/post2`

```html
<h1>Post Two</h1>
<p>This is my second post!</p>
```
