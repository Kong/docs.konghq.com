---
title: Markdown rules and formatting
---

## Markdown front matter

Every Markdown file on the doc site (excluding `docs.konghq.com/hub/`) starts with
some YAML front matter. This section must have at least one parameter (`title`),
and you can also set additional parameters to change how the doc renders in the
output.

Plugin Hub docs have specialized front matter elements. See the
[plugin contribution docs](/contributing/plugin-docs) for details.

**Required:**

`title: PAGE_TITLE`
: The title of the topic you're adding.

`content_type: how-to | explanation | reference | tutorial`
: Add a tag to the front matter of each topic that you edit.
Add the tag that most closely resembles the concept, even if it doesn’t perfectly align with a tag.
: 
: See our [contribution templates](/contributing/contribution-templates/) for more information about each content type.

`description: DESCRIPTION`
: A short description of what the page covers. This is used by Google and appears below the page title. Target length 50-160 characters.

**Optional:**

`no_version: true`
: Disables the version selector dropdown. Set this on pages that shouldn't be versioned.
: 
: Do not use if the page is part of `/contributing/` or `/konnect/`, 
as both of those doc sets are not versioned by default.

`beta: true` or `alpha: true`
: Labels the page as beta or alpha; adds a banner to the top of the page. Can use `stability_message` to
add a custom explanation.

`stability_message: <message>`
: Set a custom message about the stability of a release. Must be used with `beta: true` or `alpha: true`.
: 
: Use YAML pipe (`|`) notation if your message extends over one line.

`badge: enterprise | plus | oss | free`
: Sets a tier badge on the page title.

`disable_image_expand: true`
: Stops images from expanding in a modal on click. Sets it for the entire page.

`class: no-copy-code`
: Disables the copy code button ( <i class="fa fa-copy"></i> ) for all
code blocks on the page.

### Examples

A {{site.konnect_short_name}} page without a version for a beta feature:

```yaml
---
title: My Page
beta: true
---
```

A {{site.base_gateway}} doc (with versions) that you don't want people to copy code from,
and where you don't want any of the images to be expandable:

```yaml
---
title: My Gateway API Doc
class: no-copy-code
disable_image_expand: true
---
```

A page with a custom stability banner:

```yaml
---
title: Using multiple backend Services
content_type: tutorial
beta: true
stability_message: |
  Using multiple backend services will be GA once a non-beta version of the 
  <a href="https://gateway-api.sigs.k8s.io/">Kubernetes Gateway API</a> is available.
---
```

## Variables

Use variables for product names and release versions. See
[Variables](/contributing/variables) for syntax and when to use each one.

## Headers

Headers should not contain any code. Use plain text instead.

Use sentence case for all headers, per [Content best practices](/contributing/style-guide/#content-best-practices).

## Links

### Content in markdown files

- **Use relative links:** In markdown (`.md`) files, use links relative to the root
domain (`docs.konghq.com`).

   For example, if the final link for a page will be `https://docs.konghq.com/contributing`,
    you would write `/contributing`.

- **Use version variables when possible:** For versioned doc sets such as
{{site.base_gateway}} and {{site.mesh_product_name}}, use the page version variable.

    For example: {% raw %}`/enterprise/{{page.release}}/file`{% endraw %}

- **Use `latest` in docs without versions:** If you're linking to a versioned topic
from an topic without versions, use `/latest/` instead of a version name or variable.

### Add new entries to the ToC

If you're adding a new topic (or editing the name or location of an existing
one), you also need to add it to the `yml` nav file for its version. These are
located under `app/_data`. In these files, the path is relative to the versioned
folder.

For example, if the project path is `app/enterprise/2.1.x/overview`, the path in
the nav file would be `/overview`, and you would add it to the file
`app/_data/docs_nav_ee_2.1.x.yml`.

### Add redirects

If you're making an organization change like updating page nesting or renaming a top-level
menu item, you'll need to set up a redirect. Redirects prevent `404` pages, and
redirect users automatically to the new content location.

1. Navigate to `app` then `_redirects`.
2. Find the section of the documentation for which the redirect applies. For example, Dev Portal.
3. Add a new line with the link you want to redirect **from**.
4. On the same line, add the link you want to redirect **to**.

```bash
\\ Start the link with what appears after https://docs.konghq.com/.

\\ In the following example, we created a new menu section called Applications
in the Dev Portal section of the docs. And we moved the dev-apps page to our
new menu section.

/konnect/dev-portal/developers/dev-apps                    /konnect/dev-portal/applications/dev-apps
```

{:.important}
> **Important:** When making organizational changes, update all internal links
in the documentation to the new links. **Don't** rely on redirects to change
internal links. Redirects are not great for SEO (search engine optimization),
and they create slower page loading times, especially if there's a redirect chain.

## Code blocks

Code blocks are containers for your code examples. In Markdown, you can create
them using three backticks, or fenced code blocks:

````
```bash
curl -i -X http://some-url \
  --header 'content-type: application/json' \
  --data '{"something":"example"}'
```
````

You can also create tabbed code blocks, so that users can easily switch to
their preferred format. See [tabs for code blocks](#tabs-for-code-blocks).

### Code block best practices 

Use the following best practices for code blocks:

* Wrap lines at 80 characters whenever possible. Use the `\` character to wrap a line.

* Include a language (in the example above, that language is
`bash`). This will format your code blocks using language-specific syntax.

* Preface code examples with an introductory sentence. Use present tense, 
avoid qualifiers, and end the statement with a colon (`:`). 

  For example:

  ✅ **Do:** The results should look like this:

  ✅ **Do:** The output shows all of the connected data plane instances in the cluster:

  ❌ **Don't:** The results should look _something_ like this:

  ❌ **Don't:** The output will show...

## Tabs

If your topic provides instructions for two or more methods of completing a
task, you can nest them inside `navtabs`. For example,
[this topic](/gateway/latest/get-started/comprehensive/expose-services/#add-a-service)
tabs between the Admin API and Kong Manager methods for adding a Service.

{:.important}
> **Important:** You can’t use tabs in lists, or nest tabs within tabs.

Here's how you use them:

<!-- vale off -->
{% raw %}
```
{% navtabs %}
{% navtab Example title %}

Here's some content.

{% endnavtab %}
{% navtab Another example title %}

Here's some more content.

{% endnavtab %}
{% endnavtabs %}
```
{% endraw %}
<!-- vale on -->

And here's the output:

{% navtabs %}
{% navtab Example title %}

Here's some content.

{% endnavtab %}
{% navtab Another example title %}

Here's some more content.

{% endnavtab %}
{% endnavtabs %}

You can automatically select a specific tab (or set of tabs) on a page using the `tab` URL parameter.
For example:
https://docs.konghq.com/gateway/2.7.x/get-started/comprehensive/protect-services/?tab=using-deck-yaml

The value provided to `?tab` is the lowercase title of the tab, with all non-alphanumeric characters removed and spaces replaced with `-`.

Examples:

* `Using Kong Manager` => `using-kong-manager`
* `Using the Admin API` => `using-the-admin-api`
* `Using decK (YAML)` => `using-deck-yaml`

If you're unsure what value to use, view the page source and search for `data-slug` to see the generated slug.

If there are multiple sets of tabs to enable, you can provide multiple tab names, separated by a comma:

```
?tab=using-the-admin-api,using-deck-yaml
```

This will activate the `Using the Admin API` tab, then the `Using decK (YAML)` tabs. The order may be important if you are reusing tab names across contexts.
See this [sample link to the getting started guide with Admin API and decK tabs selected](/gateway/2.7.x/get-started/comprehensive/protect-services/?tab=using-the-admin-api,using-deck-yaml/).

When using `?tab=`, it *must* come before any URL fragments (`#`) in the URL:

* <i class="fa fa-check"></i> Good URL: /gateway/2.7.x/get-started/comprehensive/protect-services/?tab=using-deck-yaml#validate-rate-limiting
* <i class="fa fa-times"></i> Bad URL: /gateway/2.7.x/get-started/comprehensive/protect-services/#validate-rate-limiting/?tab=using-deck-yaml

### Tabs for code blocks

A specialized use of navtabs is the `codeblock` style. This creates copyable
tabbed code blocks for easy code comparison and better use of space.

{:.important}
> **Important:** Code block tabs must contain code blocks and **nothing else** --
not even extra blank lines.

To create a tabbed code block, set the `codeblock` class in the first element
when creating a `navtabs` group:

{% raw %}
````
{% navtabs codeblock %}
{% navtab cURL %}
```sh
$ curl some request
```
{% endnavtab %}
{% navtab HTTPie %}
```sh
$ httpie some request
```
{% endnavtab %}
{% endnavtabs %}
````
{% endraw %}

And here's what that looks like:

{% navtabs codeblock %}
{% navtab cURL %}
```sh
$ curl some request
```
{% endnavtab %}
{% navtab HTTPie %}
```sh
$ httpie some request
```
{% endnavtab %}
{% endnavtabs %}

### Tabs for OSS/Enterprise

{:.important}
> Important: `navtabs_ee` currently only works for Gateway documentation

When using `navtabs` to render content for both Open Source and Enterprise versions
of a product, you should use the `navtabs_ee` block instead of `navtabs`. This hides
the inline tab selection and adds a "Switch to Enterprise/OSS" option on the right hand
side of the page.

`navtabs_ee` expects the tabs to be called `Kong Gateway` and `Kong Gateway (OSS)`, and
that the enterprise tab will always be shown first.

Here's an example of how to use them:

<!-- vale off -->
````
{% raw %}
{% navtabs_ee codeblock %}
{% navtab Kong Gateway %}
```bash
This will be shown when Enterprise is selected
```
{% endnavtab %}
{% navtab Kong Gateway (OSS) %}
```bash
This will be shown when OSS is selected
```
{% endnavtab %}
{% endnavtabs_ee %}
{% endraw %}
````
<!-- vale on -->

The Enterprise tab is shown by default. Add `?install=oss` to your URL if you'd like
to link to the OSS install instructions for on a page.

### Indenting tabs in an ordered list

Sometimes you are writing an ordered list of steps and may need to include multiple
ways to complete the task, like with the Admin API as well as the Kong Manager UI, and
want to include tabs. Tabs do not indent well though and often reset the numbering of
ordered lists.

To indent your tabs so you can maintain your numbering, including code block tabs,
you can use the indent filter on a capture of your tabs.

<!-- vale off -->
{% raw %}
````
{% capture the_code %}
{% navtabs codeblock %}
{% navtab cURL %}
```sh
curl -i -X POST http://localhost:8001/event-hooks \
-d source=crud \
-d event=consumers \
-d handler=webhook \
-d config.url=<WEBHOOK_URL>
```
{% endnavtab %}
{% navtab HTTPie %}
```sh
http -f :8001/event-hooks \
source=crud \
event=consumers \
handler=webhook \
config.url=<WEBHOOK_URL>
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{{ the_code | indent }}
````
{% endraw %}
<!-- vale on -->

And here's what it looks like:

To make a technical writer smile, **always** do the following:

1. Use the Oxford comma. It matters. (With indent filter)

{% capture the_code %}
{% navtabs codeblock %}
{% navtab cURL %}
```sh
curl -i -X POST http://localhost:8001/event-hooks \
-d source=crud \
-d event=consumers \
-d handler=webhook \
-d config.url=<WEBHOOK_URL>
```
{% endnavtab %}
{% navtab HTTPie %}
```sh
http -f :8001/event-hooks \
source=crud \
event=consumers \
handler=webhook \
config.url=<WEBHOOK_URL>
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{{ the_code | indent }}

2. Laugh at all of their awesome puns. Using puns used to be considered a sign of great intelligence, after all. (Without the indent filter)

  {% navtabs codeblock %}
  {% navtab cURL %}
  ```sh
  curl -i -X POST http://localhost:8001/event-hooks \
  -d source=crud \
  -d event=consumers \
  -d handler=webhook \
  -d config.url=<WEBHOOK_URL>
  ```
  {% endnavtab %}
  {% navtab HTTPie %}
  ```sh
  http -f :8001/event-hooks \
  source=crud \
  event=consumers \
  handler=webhook \
  config.url=<WEBHOOK_URL>
  ```
  {% endnavtab %}
  {% endnavtabs %}

3. Bring chocolate. There's nothing wrong with bribery. (Without the indent filter)

  {% navtabs codeblock %}
  {% navtab cURL %}
  ```sh
  curl -i -X POST http://localhost:8001/event-hooks \
  -d source=crud \
  -d event=consumers \
  -d handler=webhook \
  -d config.url=<WEBHOOK_URL>
  ```
  {% endnavtab %}
  {% navtab HTTPie %}
  ```sh
  http -f :8001/event-hooks \
  source=crud \
  event=consumers \
  handler=webhook \
  config.url=<WEBHOOK_URL>
  ```
  {% endnavtab %}
  {% endnavtabs %}

## Page-level navigation

Almost all pages have an automatic table of contents (ToC) added to the right of
the page.

To disable it for pages that don't have any headers, add `toc: false` to the
page front matter.

The ToC generator depends on headings being correctly nested in Markdown,
and will only pick up H2 and H3 level headings.

**Do:**
```markdown
## Sub-heading Level 2
### Sub-sub-heading Level 3
## Sub-heading Level 2
```
Here, the headings are nested correctly, with the smaller heading H3 contained
within H2.

**Don't:**
```markdown
### Sub-sub-heading Level 3
## Sub-heading Level 2
### Sub-sub-heading Level 3
```
With this order, the first H3 gets skipped.

## Badges

Use badges when you need to label a heading, a page, or some other element as
a specific {{site.konnect_short_name}} tier or DB-less compatible.

Badge | HTML tag | Markdown tag | Purpose
------|----------|--------------|---------
<span class="badge free"></span> | `<span class="badge free"></span>` | `{:.badge .free}` | {{site.ee_product_name}} - free mode
<span class="badge enterprise"></span> | `<span class="badge enterprise"></span>` | `{:.badge .enterprise}` | {{site.ee_product_name}} features
<span class="badge paid"></span> | `<span class="badge paid"></span>` | `{:.badge .paid}` | {{site.konnect_short_name}} paid plugins
<span class="badge premium"></span> | `<span class="badge premium"></span>` | `{:.badge .premium}` |  {{site.konnect_short_name}} premium plugins
<span class="badge dbless"></span> | `<span class="badge dbless"></span>` | `{:.badge .dbless}` | Used to label API endpoints as DB-less compatible
<span class="badge beta"></span> | `<span class="badge beta"></span>` | `{:.badge .beta}` | Beta features
<span class="badge alpha"></span> | `<span class="badge alpha"></span>` | `{:.badge .alpha}` | Alpha/tech preview features
<span class="badge oss"></span> | `<span class="badge oss"></span>` | `{:.badge .oss}` | {{site.base_gateway}} - features available in open-source Gateway only
<span class="badge package"></span> | `<span class="badge package"></span>` | `{:.badge .package}` | Used in support tables
<span class="badge docker"></span> | `<span class="badge docker"></span>` | `{:.badge .docker}` | Used in support tables
<span class="badge ami"></span> | `<span class="badge ami"></span>` | `{:.badge .ami}` | Used in support tables

For example, you can use the Markdown tag on headers:

```markdown
### Set up the Dev Portal
{:.badge .enterprise}
```

The HTML span tag is useful for including a badge inline:

```html
The Dev Portal <span class="badge plus"></span> is a thing.
```

## Escape Liquid syntax

Jekyll processes all Liquid filters in code blocks. This means that if you are
using a language that contains double curly braces
(`{% raw %}{{ }}{% endraw %}`), you need to place <code>&#123;% raw %}</code>
and <code>&#123;% endraw %}</code> tags around your code.

For example:

{% navtabs codeblock %}
{% navtab Input %}
<div class="copy-code-snippet"><pre><code>&#123;% raw %}'{% raw %}{{ tag "kuma.io/service" }}{% endraw %}.mesh'&#123;% endraw %}</code></pre></div>
{% endnavtab %}
{% navtab Output %}
```
{% raw %}'{{ tag "kuma.io/service" }}.mesh'{% endraw %}
```
{% endnavtab %}
{% endnavtabs %}

## Icons

You can add the following classes to any Font Awesome or custom icon:

* `inline`: The icon appears inline with text.
* `no-image-expand`: The icon won't open in a modal on click.

If you're using the [`konnect_icon`](#konnect-icon) shortcut, both classes are
already applied to the icons and you don't need to add them manually.

### Unicode icons

We use Unicode icons for common icons such as ✅ &nbsp; and ❌ &nbsp;. To make sure the
spacing is correct, insert `&nbsp;` after the icon:

```md
✅ &nbsp; and ❌ &nbsp;
```

If you don't add it, the icon will look like ❌ this.

### Font Awesome

To use a Font Awesome icon, use an `<i>` HTML tag with the name of the icon
set as its class.

For example, the following code snippet:

```
<i class="fas fa-anchor"></i>
```

Resolves to <i class="fas fa-anchor"></i>.


### Custom icons

Custom icons for the Kong docs site are located in the
[`/assets/images/icons/`](https://github.com/Kong/docs.konghq.com/tree/main/app/assets/images/icons)
directory. To add an icon, ensure it meets the following criteria:
* SVG format
* The same icon doesn't already exist in the folder, in Unicode, or in the
Font Awesome library.

For most custom icons ([except {{site.konnect_short_name}}](#konnect-icons)), access them like
you would any image in markdown. For example:

```
![document icon](/assets/images/icons/icn-doc.svg){:.inline .no-image-expand}
```

This resolves to ![document icon](/assets/images/icons/icn-doc.svg){:.inline .no-image-expand}.

### {{site.konnect_short_name}} icons

{{site.konnect_short_name}} icons can be found in `app/assets/images/icons/konnect`.
When adding an icon to this folder, use the naming convention `icn-<name>`.

You can then access a {{site.konnect_short_name}} icon with a shortcut for easy use in text:

<!-- vale off -->
```
{% raw %}{% konnect_icon runtimes %}{% endraw %}
# Uses the icon located at /app/assets/images/icons/konnect/icn-runtimes.svg

{% raw %}{% konnect_icon dev-portal %}{% endraw %}
# Uses the icon located at /app/assets/images/icons/konnect/icn-dev-portal.svg
```
<!-- vale on -->
