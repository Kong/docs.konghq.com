---
title: Markdown rules and formatting
no_version: true
---

## Markdown front matter

Every Markdown file on the doc site (excluding `docs.konghq.com/hub/`) starts with
some YAML front matter. This section must have at least one parameter (`title`),
and you can also set additional parameters to change how the doc renders in the
output.

Plugin Hub docs have specialized front matter elements. See the
[plugin contribution docs](/contributing/plugin-docs) for details.

**Required:**

`title: <page title>`
: The title of the topic you're adding.

**Optional:**

`no_version: true`
: Disables the version selector dropdown. Set this on pages that belong to
unversioned doc sets like `/konnect/`.

`toc: false`
: Disables the right-hand nav for the page; useful if the page is short and has
one or no headers.

`beta: true` or `alpha: true`
: Labels the page as beta or alpha; adds a banner to the top of the page.

`disable_image_expand: true`
: Stops images from expanding in a modal on click. Sets it for the entire page.

`class: no-copy-code`
: Disables the copy code button ( <i class="fa fa-copy"></i> ) for all
codeblocks on the page.

### Examples

A versionless Konnect page for a beta feature:

```yaml
---
title: My Page
no_version: true
beta: true
---
```

A Kong Gateway doc (with versions) that you don't want people to copy code from
and has no headings, so you also want to disable the page nav:

```yaml
---
title: My Gateway API Doc
class: no-copy-code
toc: false
---
```


## Variables
Use variables for product names and release versions. See
[Variables](/contributing/variables) for syntax and when to use each one.


## Links

### Content in markdown files

* **Use relative links:** In markdown (`.md`) files, use links relative to the root
domain (`docs.konghq.com`).

    For example, if the final link for a page will be `docs.konghq.com/konnect/servicehub`,
    you would write `/konnect/servicehub`.

* **Use version variables when possible:** For versioned doc sets such as Kong
Gateway and Kong Mesh, use the page version variable.

    For example: {% raw %}`/enterprise/{{page.kong_version}}/file`{% endraw %}

* **Use `latest` in unversioned docs:** If you're linking to a versioned topic
from an unversioned topic, use `/latest/` instead of a version name or variable.

### Adding new entries to the ToC

If you're adding a new topic (or editing the name or location of an existing
one), you also need to add it to the `yml` nav file for its version. These are
located under `app/_data`. In these files, the path is relative to the versioned
folder.

For example, if the project path is `app/enterprise/2.1.x/overview`, the path in
the nav file would be `/overview`, and you would add it to the file
`app/_data/docs_nav_ee_2.1.x.yml`.


## Codeblocks

Codeblocks are containers for your code examples. In Markdown, you can create
them using three backticks, aka fenced codeblocks:

````
```bash
some code here
```
````

Include a language whenever possible (in the example above, that language is
`bash`). This will format your codeblocks using language-specific syntax.

You can also create tabbed codeblocks, so that users can easily switch to
their preferred format. See [tabs for codeblocks](#tabs-for-codeblocks).

### Line numbers
By default, every codeblock is generated with line numbers, which is useful for
calling out specific sections of code. If you need to disable the line numbers,
use the `highlight` tag with an optional language class instead of
backticks. For example:

{% raw %}
```
{% highlight bash %}
some code here
{% endhighlight %}
```
{% endraw %}

## Tabs

If your topic provides instructions for two or more methods of completing a
task, you can nest them inside `navtabs`. For example,
[this topic](https://docs.konghq.com/getting-started-guide/latest/expose-services/#add-a-service)
tabs between the Admin API and Kong Manager methods for adding a Service.

{:.important}
> **Important:** You can’t use tabs in lists, or nest tabs within tabs.

Here's how you use them:

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

And here's the output:

{% navtabs %}
{% navtab Example title %}

Here's some content.

{% endnavtab %}
{% navtab Another example title %}

Here's some more content.

{% endnavtab %}
{% endnavtabs %}

### Tabs for codeblocks

A specialized use of navtabs is the `codeblock` style. This creates copyable
tabbed codeblocks for easy code comparison and better use of space.

{:.important}
> **Important:** Codeblock tabs must contain codeblocks and **nothing else** --
not even extra blank lines.

To create a tabbed codeblock, set the `codeblock` class in the first element
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


## Admonitions

When you need to highlight important information in some way, you can use an
admonition. In our docs, we do this with Markdown blockquotes (`>`) and a class:

```
{:.note}
> **Note**: Here's a note.
```

When using admonitions, think about whether the thing you're trying to note is
_actually_ a note (or warning, or caution), or simply another piece of
information that fits the flow of the task or content on the page. Avoid
nesting too many elements inside admonitions, and try to keep them short.

You can set the admonition label to anything you want. For example, you might
want an `important` note to start with **Protect your password!**.

Set a class on the admonition to display a specific style:

* **Note:** {% raw %}`{:.note}`{% endraw %}

    This is a generic note callout that points out useful information that the
    reader should pay attention to, but won't break anything if it's not followed.
    If you don't use any class at all, the blockquote element defaults to this style.

    {:.note}
    > **Note:** Here's some info.

* **Important:** {% raw %}`{:.important}`{% endraw %}

    Use the `important` callout for something that the reader really
    needs to pay attention to, otherwise the thing they're trying to do won't work.

    {:.important}
    > **Important:** Be cautious about this thing.

* **Warning:** {% raw %}`{:.warning}`{% endraw %}

    Use the `warning` callout for any big breaking changes, or for anything
    irreversible.

    {:.warning}
    > **Warning:** Everything will break forever if you do this.


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

**Don't do:**
```markdown
### Sub-sub-heading Level 3
## Sub-heading Level 2
### Sub-sub-heading Level 3
```
With this order, the first H3 gets skipped.

## Badges

Use badges when you need to label a heading, a page, or some other element as
a specific Konnect tier or DB-less compatible.

Badge | HTML tag | Markdown tag
------|----------|-------------
<span class="badge free"></span> | `<span class="badge free"></span>` | `{:.badge .free}`
<span class="badge plus"></span> | `<span class="badge plus"></span>` | `{:.badge .plus}`
<span class="badge enterprise"></span> | `<span class="badge enterprise"></span>` | `{:.badge .enterprise}`
<span class="badge dbless"></span> | `<span class="badge dbless"></span>` | `{:.badge .dbless}`

For example, you can use the Markdown tag on headers:

```markdown
### Set up the Dev Portal
{:.badge .enterprise}
```

The HTML span tag is useful for including a badge inline:

```html
The Dev Portal <span class="badge plus"></span> is a thing.
```
