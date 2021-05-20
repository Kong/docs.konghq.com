---
title: Markdown rules and formatting
---
> **TO DO: Lena will deal with this file**

#### Markdown Front Matter

Markdown files on the doc site (excluding `docs.konghq.com/hub/`) must have a
yaml front matter section with at least one parameter (`title`). You can also
specify additional parameters to change how the doc source renders in the
output.

**Required:**

``` yaml
title: Page Title
```

**Optional:**

``` yaml
no_search: true
# Disables search for the page.

toc: false
# Disables the right-hand nav for the page; useful if the page is short and has
# one or no headers.

beta: true
alpha: true
# Labels the page as beta or alpha; adds a banner to the top of the page.

disable_image_expand: true
# Stops images from expanding in a modal on click. Sets it for the entire page.

class: no-copy-code
# Disables the copy code button in any code blocks on the page.
```



#### Variables
Use variables for product names and release versions.

- `{{page.kong_version}}` - Outputs the version of the current page
- `{{site.ee_product_name}}` - Kong Enterprise
- `{{site.ce_product_name}}` - Kong Gateway



#### Links
In markdown(`.md`) files, use relative links with a version variable.
- For Community: `/{{page.kong_version}}/file`
- For Enterprise: `/enterprise/{{page.kong_version}}/file`

If you're adding a new topic, you also need to add it to the nav file for its
version. These are located under `app/_data`. In these files, the path is
relative to the versioned folder.

For example, if the project path is `app/enterprise/2.1.x/overview`, the path in
the nav file would be `/overview`.



#### Info Blocks

Info blocks are HTML divs that follow this basic format:
```
<div class="alert alert-type">
   Some text.
</div>
```

For a basic info block, use:
```
<div class="alert alert-ee blue">
Some text.
</div>
```

For a warning, use:
```
<div class="alert alert-warning">
   Some text.
</div>
```

For a breaking issue or notice of alpha/beta, use:
```
<div class="alert alert-ee red">
   Some text.
</div>
```



#### Table of Contents generator

Almost all pages have an automatic Table of Contents (ToC) added to the right of
the page.

To inhibit the automatic addition of ToC (such as on API reference pages),
add the following to the front-matter: `toc: false`.

This ToC generator depends on headings being correctly coded in the markdown
portion of the doc site files, and will only pick up H2 and H3 level headings.
If a page has an incorrectly-formatted ToC, be sure to check the following:

- Heading levels must be correctly nested. Thus, heading levels like this:

```
### Sub-sub-heading Level 3
## Sub-heading Level 2
### Sub-sub-heading Level 3
```

will cause the first H3 to be skipped, and should be corrected to:

```
## Sub-heading Level 2
## Sub-heading Level 2
### Sub-sub-heading Level 3
```



#### Codeblocks

Codeblocks are containers for your code examples. In Markdown, you can create
them using three backticks, aka fenced codeblocks:

<code>
```bash</br>
some code here</br>
```
</code>

Include a language whenever possible (in the example above, that language is
`bash`). This will format your codeblocks using language-specific syntax.

You can also create tabbed codeblocks, so that users can easily switch to
their preferred format. See [navtabs for codeblocks](#navtabs-for-codeblocks).

##### Line numbers
By default, every codeblock is generated with line numbers, which is useful for
calling out specific sections of code. If you need to disable the line numbers,
use the `{% highlight %}` tag with an optional language class instead of
 backticks. For example:

```
{% highlight bash %}
some code here
{% endhighlight %}
```



#### Using navtabs within topics

If your topic provides instructions for two or more methods of completing a
task, you can nest them inside `navtabs`. For example, this topic
[here](https://docs.konghq.com/getting-started-guide/latest/expose-services/#add-a-service)
tabs between the Admin API and Kong Manager methods for adding a Service.

Here's how you use them:

```
{% navtabs %}
{% navtab <your title here> %}

Here's some content.

{% endnavtab %}
{% navtab <some other title> %}

Here's some more content.

{% endnavtab %}
{% endnavtabs %}
```

On initial page load, the first tab (`"<your title here>"` in the example above)
will be the one displayed.

> **Note:** You can’t nest navtabs within navtabs.

##### Navtabs for codeblocks

A specialized use of navtabs is the `codeblock` style. This will create copyable
tabbed codeblocks for easy code comparison and better use of space. See
[here](https://docs.konghq.com/enterprise/2.1.x/deployment/installation/kong-for-kubernetes/)
for an example of this style in use.

> **Important!** Codeblock navtabs must contain codeblocks and **nothing else**.
Additionally, tabbed codeblocks can't be used in lists or steps.

To create a tabbed codeblock, specify the `codeblock` class in the first element
when creating a `navtabs` group:

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
