---
title: Working with Templates
badge: enterprise
---

Kong Portal is built on top of the `lua-resty-template` templating library, which can be viewed here: [https://github.com/bungle/lua-resty-template](https://github.com/bungle/lua-resty-template). Basic usage of the library will be described below. Refer to the source documentation for a more in-depth look at what it can accomplish.

## Syntax
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

## Show custom properties

You may work with custom properties in your OpenAPI spec. To expose custom properties in Dev Portal, change the property `showExtensions` to `true` in the `spec-renderer.html` file. By default, `showExtensions` is `false`.

## Partials

Partials are snippets of html that layouts can reference. Partials have access to all the same data that its layout does, and can even call other partials.  Breaking your code into partials can help organize large pages, as well as allow different layouts share common page elements.

### content/index.txt

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

### layouts/index.html

{% raw %}
```html
{(partials/header.html)}
<div class="content">
  {(partials/hero.html)}
</div>
{(partials/footer.html)}
```
{% endraw %}

### partials/header.html

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

### partials/header_nav.html

{% raw %}
``` html
<ul>
  {% for title, href in each(page.header_nav_items) do %}
    <li><a href="{{href}}">{{title}}</a></li>
  {% end %}
</ul>
```
{% endraw %}

### partials/hero.html

{% raw %}
``` html
<h1>{{page.hero_title}}</h1>
<p>{{page.hero_description}}</p>
```
{% endraw %}


### partials/hero.html

{% raw %}
``` html
<footer>
  <p>footer</p>
</footer>
```
{% endraw %}


Output:

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

## Blocks

Blocks can be used to embed a view or partial into another template. Blocks are particularly useful when you want different templates to share a common wrapper.

In the example below, notice that the content file is referencing `index.html`, and not `wrapper.html`.

### content/index.txt

{% raw %}
```markdown
---
layout: index.html
title: Blocks
description: Blocks are the future!
---
```
{% endraw %}


### layouts/index.html

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

### layouts/wrapper.html

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

Output:

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

## Collections
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
- `output`
  - **required**: false
  - **type**: `boolean`
  - **description**: This optional attribute determines whether the collections should render or not. When set to `false`, virtual routes for the collection are not created.
- `route`
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
- `layout`
    - **required**: true
      - **type**: `boolean`
      - **description**: The `layout` attribute determines what HTML layout the collections use to render. The path root is accessed from within the current themes `layouts` directory.

### content/_posts/post1.md

{% raw %}
```
---
title: Post One
stub: blog
---

This is my first post!
```
{% endraw %}


### content/_posts/post2.md

{% raw %}
```
---
title: Post Two
stub: blog
---

This is my second post!
```
{% endraw %}

### themes/base/layouts/post.html

{% raw %}
```html
<h1>{{ page.title }}</h1>
<p>{* page.body *}</p>
```
{% endraw %}

Output:

From `<kong_portal_gui_url>/blog/posts/post1`:

```html
<h1>Post One</h1>
<p>This is my first post!</p>
```

From `<kong_portal_gui_url>/blog/posts/post2`:

```html
<h1>Post Two</h1>
<p>This is my second post!</p>
```


## Kong Template Helpers - Lua API
Kong Template Helpers are a collection of objects that give access to your portal data at the time of render and provide powerful integrations into Kong.

Globals:

- [`l`](#lkey-fallback) - Locale helper, first version, gets values from the currently active page.
- [`each`](#eachlist_or_table) - Commonly used helper to iterate over lists or tables.
- [`print`](#printany) - Commonly used helper to print lists / tables.
- [`markdown`](#printany) - Commonly used helper to print lists / tables.
- [`json_decode`](#json_decode) - Decode JSON to Lua table.
- [`json_encode`](#json_encode) - Encode Lua table to JSON.

Objects:

- [`portal`](#portal) - The portal object refers to the current workspace portal being accessed.
- [`page`](#page) - The page object refers to the currently active page and its contents.
- [`user`](#user) - The user object represents the currently logged in developer accessing the Kong Portal.
- [`theme`](#theme) - The theme object represents the currently active theme and its variables.
- [`tbl`](#tbl) = Table helper methods. Examples: `map`, `filter`, `find`, `sort`.
- [`str`](#str) = String helper methods. Examples: `lower`, `upper`, `reverse`, `endswith`.
- [`helpers`](#helpers) - Helper functions simplify common tasks or provide easy shortcuts to Kong Portal methods.


Terminology / Definitions:

- `list` - Also referred to commonly as an array (`[1, 2, 3]`) in Lua is a table-like object (`{1, 2, 3}`). Lua list index starts at `1` not `0`. Values can be accessed by array notation (`list[1]`).
- `table` - Also commonly known as an object or hashmap (`{1: 2}`) in Lua looks like (`{1 = 2}`). Values can be accessed by array or dot notation (`table.one or table["one"]`).

### l(key, fallback)

Returns the current translation by key from the currently active page.

#### Return Type
{% raw %}

```lua
string
```
{% endraw %}

#### Usage

Using `content/en/example.txt`:

{% raw %}
```yaml
---
layout: example.html

locale:
  title: Welcome to {{portal.name}}
  slogan: The best developer portal ever created.
---
```
{% endraw %}


Using `content/es/example.txt`:

{% raw %}
```yaml
---
layout: example.html

locale:
  title: Bienvenido a {{portal.name}}
  slogan: El mejor portal para desarrolladores jamás creado.
---
```
{% endraw %}


Using `layouts/example.html`:

{% raw %}
```lua
<h1>{* l("title", "Welcome to" .. portal.name) *}</h1>
<p>{* l("slogan", "My amazing developer portal!") *}</p>
<p>{* l("powered_by", "Powered by Kong.") *}</p>
```
{% endraw %}


Output:

For `en/example`:

{% raw %}
```html
<h1>Welcome to Kong Portal</h1>
<p>The best developer portal ever created.</p>
<p>Powered by Kong.</p>
```
{% endraw %}


For `es/example`:

{% raw %}
```html
<h1>Bienvenido a Kong Portal</h1>
<p>El mejor portal para desarrolladores jamás creado.</p>
<p>Powered by Kong.</p>
```
{% endraw %}


#### Notes

- `l(...)` is a helper from the `page` object. It can be also accessed via `page.l`. However, `page.l` does not support template interpolation (for example, `{{portal.name}}` will not work.)

### each(list_or_table)

Returns the appropriate iterator depending on what type of argument is passed.

#### Return Type

```lua
Iterator
```

#### Usage

Template (List):

{% raw %}
```lua
{% for index, value in each(table) do %}
<ul>
  <li>Index: {{index}}</li>
  <li>Value: {{ print(value) }}</li>
</ul>
{% end %}
```
{% endraw %}


Template (Table):

{% raw %}
```lua
{% for key, value in each(table) do %}
<ul>
  <li>Key: {{key}}</li>
  <li>Value: {{ print(value) }}</li>
</ul>
{% end %}
```
{% endraw %}

### print(any)

Returns stringified output of input value.

#### Return Type

```lua
string
```

#### Usage

Template (Table):

{% raw %}
```lua
<pre>{{print(page)}}</pre>
```
{% endraw %}

### markdown(string)

Returns HTML from the markdown string passed as an argument. If a string argument is not valid markdown, the function will return the string as is. To render properly, the helper should be used with raw `{* *}` delimiters.

#### Return Type

```lua
string
```

#### Usage

Template (string as arg):

{% raw %}
```lua
<pre>{* markdown("##This is Markdown") *}</pre>
```
{% endraw %}

Template (content val as arg):

{% raw %}
```lua
<pre>{* markdown(page.description) *}</pre>
```
{% endraw %}

### json_encode(object)

JSON encodes Lua table passed as argument

#### Return Type

```lua
string
```

#### Usage

Template:

{% raw %}
```lua
<pre>{{ json_encode({ dog = cat }) }}</pre>
```
{% endraw %}

### json_decode(string)

Decodes JSON string argument to Lua table

#### Return Type

```lua
table
```

#### Usage

Template:

{% raw %}
```lua
<pre>{{ print(json_encode('{"dog": "cat"}')) }}</pre>
```
{% endraw %}

### portal

`portal` gives access to data relating to the current portal, this includes things like portal configuration, content, specs, and layouts.

  - [`portal.workspace`](#portalworkspace)
  - [`portal.url`](#portalurl)
  - [`portal.api_url`](#portalapi_url)
  - [`portal.auth`](#portalauth)
  - [`portal.specs`](#portalspecs)
  - [`portal.specs_by_tag`](#portalspecs_by_tag)
  - [`portal.developer_meta_fields`](#portaldeveloper_meta_fields)


You can access the current workspace's portal config directly on the `portal` object like so:

```lua
portal[config_key] or portal.config_key
```

For example `portal.auth` is a portal config value. You can find a list of config values by reading the portal section of `kong.conf`.

#### From kong.conf

The portal only exposes config values that start with  `portal_`, and they can be access by removing the `portal_` prefix.

Some configuration values are modified or customized, these customizations are documented under the [Portal Members](#portal-members) section.

##### portal.workspace

Returns the current portal's workspace.

##### Return Type

```lua
string
```

##### Usage

Template:

{% raw %}
```hbs
{{portal.workspace}}
```
{% endraw %}

Output:

```html
default
```

#### portal.url

Returns the current portal's url with workspace.

##### Return Type

```lua
string
```

##### Usage

Template:

{% raw %}
```hbs
{{portal.url}}
```
{% endraw %}

Output:

```html
http://127.0.0.1:8003/default
```

#### portal.api_url

Returns the configuration value for `portal_api_url` with
the current workspace appended.

##### Return Type

```lua
string or nil
```

##### Usage

Template:

{% raw %}
```hbs
{{portal.api_url}}
```
{% endraw %}

Output when `portal_api_url = http://127.0.0.1:8004`:

```html
http://127.0.0.1:8004/default
```

#### portal.auth

Returns the current portal's authentication type.

##### Return Type

```lua
string
```

##### Usage

**Printing a value**

Input:

{% raw %}
```hbs
{{portal.auth}}
```
{% endraw %}

Output when `portal_auth = basic-auth`:

```html
basic-auth
```

**Checking if authentication is enabled**

Input:

{% raw %}
```hbs
{% if portal.auth then %}
  Authentication is enabled!
{% end %}
```
{% endraw %}

Output when `portal_auth = basic-auth`:

```html
Authentication is endabled!
```

#### portal.specs

Returns an array of specification files contained within the current portal.

##### Return type

```lua
array
```

##### Usage

**Viewing a content value**

Template:

{% raw %}
```hbs
<pre>{{ print(portal.specs) }}</pre>
```
{% endraw %}

Output:

```lua
{
  {
    "path" = "content/example1_spec.json",
    "content" = "..."
  },
  {
    "path" = "content/documentation/example1_spec.json",
    "content" = "..."
  },
  ...
}
```

**Looping through values**

Template:

{% raw %}
```hbs
{% for _, spec in each(portal.specs) %}
  <li>{{spec.path}}</li>
{% end %}
```
{% endraw %}

Output:

```hbs
  <li>content/example1_spec.json</li>
  <li>content/documentation/example1_spec.json</li>
```

**Filter by path**

Template:

{% raw %}
```hbs
{% for _, spec in each(helpers.filter_by_path(portal.specs, "content/documentation")) %}
  <li>{{spec.path}}</li>
{% end %}
```
{% endraw %}

Output:

```hbs
  <li>content/documentation/example1_spec.json</li>
```

#### portal.developer_meta_fields

Returns an array of developer meta fields available/required by Kong to register a developer.

#### Return Type

```lua
array
```

##### Usage

**Printing a value**

Template:

{% raw %}
```hbs
{{ print(portal.developer_meta_fields) }}
```
{% endraw %}

Output:

{% raw %}
```lua
{
  {
    label    = "Full Name",
    name     = "full_name",
    type     = "text",
    required = true,
  },
  ...
}
```
{% endraw %}

**Looping through values**

Template:

{% raw %}
```hbs
{% for i, field in each(portal.developer_meta_fields) do %}
<ul>
  <li>Label: {{field.label}}</li>
  <li>Name: {{field.name}}</li>
  <li>Type: {{field.type}}</li>
  <li>Required: {{field.required}}</li>
</ul>
{% end %}
```
{% endraw %}

Output:

```html
<ul>
  <li>Label: Full Name</li>
  <li>Name: full_name</li>
  <li>Type: text</li>
  <li>Required: true</li>
</ul>
...
```

### page

`page` gives access to data relating to the current page, which includes things like page url, path, breadcrumbs, and more.

  - [`page.route`](#pageroute)
  - [`page.url`](#pageurl)
  - [`page.breadcrumbs`](#pagebreadcrumbs)
  - [`page.body`](#pagebody)

When you create a new content page, you are able to define key-values. Here you are going to learn how to access those values and a few other interesting things.

You can access the key-values you define directly on the `page` object like so:

{% raw %}
```lua
page[key_name] or page.key_name
```
{% endraw %}

You can also access nested keys like so:

```lua
page.key_name.nested_key
```
{% raw %}
Be careful! To avoid output errors, make sure that the `key_name` exists before accessing `nested_key` as shown below:
```hbs
{{page.key_name and page.key_name.nested_key}}
```
{% endraw %}

#### page.route

Returns the current page's route/path.

##### Return Type

```lua
string
```

##### Usage

Template:

{% raw %}
```hbs
{{page.route}}
```
{% endraw %}

Output, given url is `http://127.0.0.1:8003/default/guides/getting-started`:

```html
guides/getting-started
```

#### page.url

Returns the current page's url.

##### Return Type

```lua
string
```

##### Usage

Template:

{% raw %}
```hbs
{{page.url}}
```
{% endraw %}

Output, given url is `http://127.0.0.1:8003/default/guides/getting-started`:

```html
http://127.0.0.1:8003/default/guides/getting-started
```

#### page.breadcrumbs

Returns the current page's breadcrumb collection.

##### Return Type

```lua
table[]
```

##### Item Properties

- `item.path` - Full path to item, no forward-slash prefix.
- `item.display_name` - Formatted name.
- `item.is_first` - Is this the first item in the list?
- `item.is_last` - Is this the last item in the list?

##### Usage

Template:

{% raw %}
```hbs
<div id="breadcrumbs">
  <a href="">Home</a>
  {% for i, crumb in each(page.breadcrumbs) do %}
    {% if crumb.is_last then %}
      / {{ crumb.display_name }}
    {% else %}
      / <a href="{{crumb.path}}">{{ crumb.display_name }}</a>
    {% end %}
  {% end %}
</div>
```
{% endraw %}

#### page.body

Returns the body of the current page as a string. If the route's content file has a `.md` or `.markdown` extension, the body will be parsed from markdown to html.

##### Return Type

```lua
string
```

##### Usage for .txt, .json, .yaml, .yml templates

`index.txt`:

```hbs
This is text content.
```

Template:
{% raw %}
```hbs
<h1>This is a title</h1>
<p>{{ page.body) }}</p>
```
{% endraw %}

Output:
```
> # This is a title
> This is text content.
```

##### Usage for .md, .markdown templates

Template (markdown):
Use the raw delimiter syntax `{* *}` to render markdown within a template.

`index.txt`
```hbs
# This is a title
This is text content.
```

Template:
```hbs
{* page.body *}
```

Output:
```
> # This is a title
> This is text content.
```

### user

`user` gives access to data relating to the currently authenticated user.  User object is only applicable when `KONG_PORTAL_AUTH` is enabled.

  - [`user.is_authenticated`](#useris_authenticated)
  - [`user.has_role`](#userhas_role)
  - [`user.get`](#userget)


#### user.is_authenticated

Returns `boolean` value as to the current user's authentication status.

##### Return Type

```lua
boolean
```

##### Usage

Template:

{% raw %}
```hbs
{{print(user.is_authenticated)}}
```
{% endraw %}

Output:

```html
true
```

#### user.has_role

Returns `true` if a user has a role given as an argument.

##### Return Type

```lua
boolean
```

##### Usage

Template:

{% raw %}
```hbs
{{print(user.has_role("blue"))}}
```
{% endraw %}

Output:

```html
true
```

#### user.get

Takes developer attribute as an argument and returns value if present.

##### Return Type

```lua
any
```

##### Usage

Template:

{% raw %}
```hbs
{{user.get("email")}}
{{print(user.get("meta"))}}
```
{% endraw %}

Output:

```html
example123@konghq.com
{ "full_name" = "example" }
```


### theme

The `theme` object exposes values set in your `theme.conf.yaml` file.  In addition, any variable overrides contained in `portal.conf.yaml` will be included as well.

  - [`theme.colors`](#usercolors)
  - [`theme.color`](#usercolor)
  - [`theme.fonts`](#userfonts)
  - [`theme.font`](#userfont)


#### theme.colors

Returns a table of color variables and their values as key-value pairs.

##### Return Type

```lua
table
```

##### Usage

`theme.conf.yaml`:

```yaml
name: Kong
colors:
  primary:
    value: '#FFFFFF'
    description: 'Primary Color'
  secondary:
    value: '#000000'
    description: 'Secondary Color'
  tertiary:
    value: '#1DBAC2'
    description: 'Tertiary Color'
```

Template:

{% raw %}
```lua
{% for k,v in each(theme.colors) do %}
  <p>{{k}}: {{v}}</p>
{% end %}
```
{% endraw %}

Output:

```html
<p>primary: #FFFFFF</p>
<p>secondary: #000000</p>
<p>tertiary: #1DBAC2</p>
```

#### theme.color

Description

Takes color var by string argument, returns value.

##### Return Type

```lua
string
```

##### Usage

`theme.conf.yaml`:

```yaml
name: Kong
colors:
  primary:
    value: '#FFFFFF'
    description: 'Primary Color'
  secondary:
    value: '#000000'
    description: 'Secondary Color'
  tertiary:
    value: '#1DBAC2'
    description: 'Tertiary Color'
```

Template:

{% raw %}
```lua
<p>primary: {{theme.color("primary")}}</p>
<p>secondary: {{theme.color("secondary")}}</p>
<p>tertiary: {{theme.color("tertiary")}}</p>
```
{% endraw %}

Output:

```html
<p>primary: #FFFFFF</p>
<p>secondary: #000000</p>
<p>tertiary: #1DBAC2</p>
```


#### theme.fonts

Returns table of font vars and their values as key-value pairs.

##### Return Type

```lua
table
```

##### Usage

`theme.conf.yaml`:

```yaml
name: Kong
fonts:
  base: Roboto
  code: Roboto Mono
  headings: Lato
```

Template:

{% raw %}
```lua
{% for k,v in each(theme.fonts) do %}
  <p>{{k}}: {{v}}</p>
{% end %}
```
{% endraw %}

Output:

```html
<p>base: Roboto</p>
<p>code: Roboto Mono</p>
<p>headings: Lato</p>
```

#### theme.font

Takes font name by string argument, returns value.

##### Return Type

```lua
string
```

##### Usage

`theme.conf.yaml`:

```yaml
name: Kong
fonts:
  base: Roboto
  code: Roboto Mono
  headings: Lato
```

Template:

{% raw %}
```lua
<p>base: {{theme.font("base")}}</p>
<p>code: {{theme.font("code")}}</p>
<p>headings: {{theme.font("headings")}}</p>
```
{% endraw %}

Output:

```html
<p>base: #FFFFFF</p>
<p>code: #000000</p>
<p>headings: #1DBAC2</p>
```

### str

Table containing useful string helper methods.

#### Usage

`.upper()` example:

{% raw %}
```lua
<pre>{{ str.upper("dog") }}</pre>
```
{% endraw %}

#### Methods
##### str.[byte](https://www.gammon.com.au/scripts/doc.php?lua=string.byte)
##### str.[char](https://www.gammon.com.au/scripts/doc.php?lua=string.char)
##### str.[dump](https://www.gammon.com.au/scripts/doc.php?lua=string.dump)
##### str.[find](https://www.gammon.com.au/scripts/doc.php?lua=string.find)
##### str.[format](https://www.gammon.com.au/scripts/doc.php?lua=string.format)
##### str.[gfind](https://www.gammon.com.au/scripts/doc.php?lua=string.gfind)
##### str.[gmatch](https://www.gammon.com.au/scripts/doc.php?lua=string.gmatch)
##### str.[gsub](https://www.gammon.com.au/scripts/doc.php?lua=string.gsub)
##### str.[len](https://www.gammon.com.au/scripts/doc.php?lua=string.len)
##### str.[lower](https://www.gammon.com.au/scripts/doc.php?lua=string.lower)
##### str.[match](https://www.gammon.com.au/scripts/doc.php?lua=string.match)
##### str.[rep](https://www.gammon.com.au/scripts/doc.php?lua=string.rep)
##### str.[reverse](https://www.gammon.com.au/scripts/doc.php?lua=string.reverse)
##### str.[sub](https://www.gammon.com.au/scripts/doc.php?lua=string.sub)
##### str.[upper](https://www.gammon.com.au/scripts/doc.php?lua=string.upper)
##### str.[isalpha](https://stevedonovan.github.io/Penlight/api/libraries/pl.stringx.html#isalpha)
##### str.[isdigit](https://stevedonovan.github.io/Penlight/api/libraries/pl.stringx.html#isdigit)
##### str.[isalnum](https://stevedonovan.github.io/Penlight/api/libraries/pl.stringx.html#isalnum)
##### str.[isspace](https://stevedonovan.github.io/Penlight/api/libraries/pl.stringx.html#isspace)
##### str.[islower](https://stevedonovan.github.io/Penlight/api/libraries/pl.stringx.html#islower)
##### str.[isupper](https://stevedonovan.github.io/Penlight/api/libraries/pl.stringx.html#isupper)
##### str.[startswith](https://stevedonovan.github.io/Penlight/api/libraries/pl.stringx.html#startswith)
##### str.[endswith](https://stevedonovan.github.io/Penlight/api/libraries/pl.stringx.html#endswith)
##### str.[join](https://stevedonovan.github.io/Penlight/api/libraries/pl.stringx.html#join)
##### str.[splitlines](https://stevedonovan.github.io/Penlight/api/libraries/pl.stringx.html#splitlines)
##### str.[split](https://stevedonovan.github.io/Penlight/api/libraries/pl.stringx.html#split)
##### str.[expandtabs](https://stevedonovan.github.io/Penlight/api/libraries/pl.stringx.html#expandtabs)
##### str.[lfind](https://stevedonovan.github.io/Penlight/api/libraries/pl.stringx.html#lfind)
##### str.[rfind](https://stevedonovan.github.io/Penlight/api/libraries/pl.stringx.html#rfind)
##### str.[replace](https://stevedonovan.github.io/Penlight/api/libraries/pl.stringx.html#replace)
##### str.[count](https://stevedonovan.github.io/Penlight/api/libraries/pl.stringx.html#count)
##### str.[ljust](https://stevedonovan.github.io/Penlight/api/libraries/pl.stringx.html#ljust)
##### str.[rjust](https://stevedonovan.github.io/Penlight/api/libraries/pl.stringx.html#rjust)
##### str.[center](https://stevedonovan.github.io/Penlight/api/libraries/pl.stringx.html#center)
##### str.[lstrip](https://stevedonovan.github.io/Penlight/api/libraries/pl.stringx.html#lstrip)
##### str.[rstrip](https://stevedonovan.github.io/Penlight/api/libraries/pl.stringx.html#rstrip)
##### str.[strip](https://stevedonovan.github.io/Penlight/api/libraries/pl.stringx.html#strip)
##### str.[splitv](https://stevedonovan.github.io/Penlight/api/libraries/pl.stringx.html#splitv)
##### str.[partition](https://stevedonovan.github.io/Penlight/api/libraries/pl.stringx.html#partition)
##### str.[rpartition](https://stevedonovan.github.io/Penlight/api/libraries/pl.stringx.html#rpartition)
##### str.[at](https://stevedonovan.github.io/Penlight/api/libraries/pl.stringx.html#at)
##### str.[lines](https://stevedonovan.github.io/Penlight/api/libraries/pl.stringx.html#lines)
##### str.[title](https://stevedonovan.github.io/Penlight/api/libraries/pl.stringx.html#title)
##### str.[shorten](https://stevedonovan.github.io/Penlight/api/libraries/pl.stringx.html#shorten)
##### str.[quote_string](https://stevedonovan.github.io/Penlight/api/libraries/pl.stringx.html#quote_string)


### tbl

Table containing useful table helper methods

#### Usage

`.map()` example:
{% raw %}
```lua
{% tbl.map({"dog", "cat"}, function(item) %}
  {% if item ~= "dog" then %}
    {% return true %}
  {% end %}
{% end) %}
```
{% endraw %}

#### Methods
##### tbl.[getn](https://www.gammon.com.au/scripts/doc.php?lua=table.getn)
##### tbl.[setn](https://www.gammon.com.au/scripts/doc.php?lua=table.setn)
##### tbl.[maxn](https://www.gammon.com.au/scripts/doc.php?lua=table.maxn)
##### tbl.[insert](https://www.gammon.com.au/scripts/doc.php?lua=table.insert)
##### tbl.[remove](https://www.gammon.com.au/scripts/doc.php?lua=table.remove)
##### tbl.[concat](https://www.gammon.com.au/scripts/doc.php?lua=table.concat)
##### tbl.[map](https://stevedonovan.github.io/Penlight/api/libraries/pl.tablex.html#map)
##### tbl.[foreach](https://stevedonovan.github.io/Penlight/api/libraries/pl.tablex.html#foreach)
##### tbl.[foreachi](https://stevedonovan.github.io/Penlight/api/libraries/pl.tablex.html#foreachi)
##### tbl.[sort](https://stevedonovan.github.io/Penlight/api/libraries/pl.tablex.html#sort)
##### tbl.[sortv](https://stevedonovan.github.io/Penlight/api/libraries/pl.tablex.html#sortv)
##### tbl.[filter](https://stevedonovan.github.io/Penlight/api/libraries/pl.tablex.html#filter)
##### tbl.[size](https://stevedonovan.github.io/Penlight/api/libraries/pl.tablex.html#size)
##### tbl.[index_by](https://stevedonovan.github.io/Penlight/api/libraries/pl.tablex.html#index_by)
##### tbl.[transform](https://stevedonovan.github.io/Penlight/api/libraries/pl.tablex.html#transform)
##### tbl.[range](https://stevedonovan.github.io/Penlight/api/libraries/pl.tablex.html#range)
##### tbl.[reduce](https://stevedonovan.github.io/Penlight/api/libraries/pl.tablex.html#reduce)
##### tbl.[index_map](https://stevedonovan.github.io/Penlight/api/libraries/pl.tablex.html#index_map)
##### tbl.[makeset](https://stevedonovan.github.io/Penlight/api/libraries/pl.tablex.html#makeset)
##### tbl.[union](https://stevedonovan.github.io/Penlight/api/libraries/pl.tablex.html#union)
##### tbl.[intersection](https://stevedonovan.github.io/Penlight/api/libraries/pl.tablex.html#intersection)
##### tbl.[count_map](https://stevedonovan.github.io/Penlight/api/libraries/pl.tablex.html#count_map)
##### tbl.[set](https://stevedonovan.github.io/Penlight/api/libraries/pl.tablex.html#set)
##### tbl.[new](https://stevedonovan.github.io/Penlight/api/libraries/pl.tablex.html#new)
##### tbl.[clear](https://stevedonovan.github.io/Penlight/api/libraries/pl.tablex.html#clear)
##### tbl.[removevalues](https://stevedonovan.github.io/Penlight/api/libraries/pl.tablex.html#removevalues)
##### tbl.[readonly](https://stevedonovan.github.io/Penlight/api/libraries/pl.tablex.html#readonly)
##### tbl.[update](https://stevedonovan.github.io/Penlight/api/libraries/pl.tablex.html#update)
##### tbl.[copy](https://stevedonovan.github.io/Penlight/api/libraries/pl.tablex.html#copy)
##### tbl.[deepcopy](https://stevedonovan.github.io/Penlight/api/libraries/pl.tablex.html#deepcopy)
##### tbl.[icopy](https://stevedonovan.github.io/Penlight/api/libraries/pl.tablex.html#icopy)
##### tbl.[move](https://stevedonovan.github.io/Penlight/api/libraries/pl.tablex.html#move)
##### tbl.[insertvalues](https://stevedonovan.github.io/Penlight/api/libraries/pl.tablex.html#insertvalues)
##### tbl.[deepcompare](https://stevedonovan.github.io/Penlight/api/libraries/pl.tablex.html#deepcompare)
##### tbl.[compare](https://stevedonovan.github.io/Penlight/api/libraries/pl.tablex.html#compare)
##### tbl.[compare_no_order](https://stevedonovan.github.io/Penlight/api/libraries/pl.tablex.html#compare_no_order)
##### tbl.[find](https://stevedonovan.github.io/Penlight/api/libraries/pl.tablex.html#find)
##### tbl.[find_if](https://stevedonovan.github.io/Penlight/api/libraries/pl.tablex.html#find_if)
##### tbl.[search](https://stevedonovan.github.io/Penlight/api/libraries/pl.tablex.html#search)
##### tbl.[keys](https://stevedonovan.github.io/Penlight/api/libraries/pl.tablex.html#keys)
##### tbl.[values](https://stevedonovan.github.io/Penlight/api/libraries/pl.tablex.html#values)
##### tbl.[sub](https://stevedonovan.github.io/Penlight/api/libraries/pl.tablex.html#sub)
##### tbl.[merge](https://stevedonovan.github.io/Penlight/api/libraries/pl.tablex.html#merge)
##### tbl.[difference](https://stevedonovan.github.io/Penlight/api/libraries/pl.tablex.html#difference)
##### tbl.[zip](https://stevedonovan.github.io/Penlight/api/libraries/pl.tablex.html#zip)
