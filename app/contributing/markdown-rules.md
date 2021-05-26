---
title: Markdown rules and formatting
no_version: true
---

## Markdown Front Matter

Markdown files on the doc site (excluding `docs.konghq.com/hub/`) must have a
YAML front matter section with at least one parameter (`title`). You can also
specify additional parameters to change how the doc renders in the
output.

**Required:**

`title: <page title>`
: The title of the topic you're adding.

**Optional:**

`no_search: true`
: Disables search for the page.

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

## Variables
Use variables for product names and release versions.

- `{{page.kong_version}}` - Outputs the version of the current page
- `{{site.ee_product_name}}` - Kong Enterprise
- `{{site.ce_product_name}}` - Kong Gateway


## Links
In markdown(`.md`) files, use relative links with a version variable.
- For Community: `/{{page.kong_version}}/file`
- For Enterprise: `/enterprise/{{page.kong_version}}/file`

If you're adding a new topic, you also need to add it to the nav file for its
version. These are located under `app/_data`. In these files, the path is
relative to the versioned folder.

For example, if the project path is `app/enterprise/2.1.x/overview`, the path in
the nav file would be `/overview`.


## Info blocks

When you need to call out important information in some way, you can use an alert
info block. In our docs, we do this with Markdown blockquotes:

```
> Here's a note.
```

### Note

A generic note element that calls out useful information that the reader should
pay attention to, but won't break anything if it's not followed.

If you don't use any class at all, the blockquote element defaults to this style.

Markdown:

{% raw %}
```
{:.note}
> Here's some info.
```
{% endraw %}

Result:

{:.note}
> Here's some info.

### Tip

Information that might help the reader improve their results or their experience.

Markdown:

{% raw %}
```
{:.tip}
> Hey, there's an advanced version of this plugin, you should check it out if
you want these extra features.
```
{% endraw %}

Result:

{:.tip}
> Hey, there's an advanced version of this plugin, you should check it out if
you want these extra features.

### Important

Something important that the reader really needs to pay attention to, otherwise
the thing won't work.

Markdown:

{% raw %}
```
{:.important}
> Be cautious about this thing.
```
{% endraw %}

Result:

{:.important}
> Be cautious about this thing.


### Warning

Any big breaking changes or anything irreversible.

Markdown:

{% raw %}
```
{:.warning}
> Everything will break forever if you do this.
```
{% endraw %}

Result:

{:.warning}
> Everything will break forever if you do this.



## Badges

Use badges when you need to label a heading, a page, or some other element as
a specific Konnect tier.

Badge | HTML tag | Markdown tag
------|----------|-------------
<span class="badge free"></span> | `<span class="badge free"></span>` | `{:.badge free}`
<span class="badge plus"></span> | `<span class="badge plus"></span>` | `{:.badge plus}`
<span class="badge enterprise"></span> | `<span class="badge enterprise"></span>` | `{:.badge enterprise}`

For example, you can use the Markdown tag on headers:

```markdown
### Set up the Dev Portal
{:.badge enterprise}
```

The HTML span tag is useful for including a badge inline:

```html
The Dev Portal <span class="badge plus"></span> is a thing.
```


## Table of contents generator

Almost all pages have an automatic Table of Contents (ToC) added to the right of
the page.

To disable it for pages that don't have any headers, add `toc: false` to the
page front matter.

The ToC generator depends on headings being correctly nested in Markdown,
and will only pick up H2 and H3 level headings.

If a page has an incorrectly-formatted ToC, be sure to check that the headers
are nested correctly.

Do:
```markdown
## Sub-heading Level 2
### Sub-sub-heading Level 3
## Sub-heading Level 2
```
Here, the headings are nested correctly, with the smaller heading H3 contained
within H2.

Don't do:
```markdown
### Sub-sub-heading Level 3
## Sub-heading Level 2
### Sub-sub-heading Level 3
```
With this order, the first H3 gets skipped.


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
their preferred format. See [navtabs for codeblocks](#navtabs-for-codeblocks).

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

> **Important:** You can’t use navtabs in lists, or nest navtabs within navtabs.

### Navtabs for codeblocks

A specialized use of navtabs is the `codeblock` style. This will create copyable
tabbed codeblocks for easy code comparison and better use of space.

> **Important:** Codeblock navtabs must contain codeblocks and **nothing else**.
Additionally, tabbed codeblocks can't be used in lists or steps.

To create a tabbed codeblock, specify the `codeblock` class in the first element
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
