---
title: Reusable content
no_version: true
---

In Jekyll, reusable content is managed using [`include`](https://jekyllrb.com/docs/includes/)
snippets, which are located in the [`/app/_includes`](https://github.com/Kong/docs.konghq.com/tree/main/app/_includes)
folder. Use `includes` to reuse snippets of the same content across multiple
pages.

The examples in this topic reference a [short `include` file with a snippet about installation](https://github.com/Kong/docs.konghq.com/blob/main/app/_includes/md/enterprise/install.md).

Snippets from that `include` file are called with an `include` tag in a few
target files, such as the
[Docker installation guide](https://github.com/Kong/docs.konghq.com/blob/main/app/enterprise/2.5.x/deployment/installation/docker.md).

## Create an include

### File formats and directories

Add a Markdown (`.md`) or HTML (`.html`) file to the [`/app/_includes`](https://github.com/Kong/docs.konghq.com/tree/main/app/_includes) directory at the root of the `Kong/docs.konghq.com` repository.

* Markdown `includes` contain snippets of documentation content, for example, common installation steps.
* HTML `includes` contain pieces of website layout and functionality, for
example, the footer and navbars.

If your Markdown `include` does not need to belong to a particular product version, place it in a product directory. For example:

- `app/_includes/mesh`
- `app/_includes/plugins-hub`

If the `include` will be used across products, place it directly in of the
`app/_includes/md/` directory.

{:.note}
> If you have different versions of the `include` content:
- Content for current version continues to live at the root of the product directory
- Versioned content (for non-current versions only!) lives in a sub-directory named {VERSION_NUMBER}

### Markdown comments

At the top of an `include` file, add a Markdown comment to note the instances
where this `include` is being used. For example:

```md
<!-- Shared between all Community Linux installation topics: Amazon Linux,
 CentOS, Debian, RedHat, and Ubuntu -->
```

### Page variables
If using page variables inside an `include`, replace `page` in the variable with
`include`. For example, `page.kong_version` becomes `include.kong_version`.

```
This is an include that uses {% raw %}{{ include.kong_version }}{% endraw %}.
```

This is necessary because we use the `jekyll_include_cache` plugin on the docs
site, and the plugin needs to know that the variable should not be cached.

## Use an include

To add an `include`, use the `include` tag with the following basic syntax:

```
{% raw %}{% include_cached /md/install.md %}{% endraw %}
```

* Declare the tag with `include_cached`
* Add a path relative to the `_includes` directory

Depending on the content of the snippet, you can pass various parameters to the `include` tag. If the `include` content has a variable anywhere in the text, map it to the [page variable](#page-variables):

```
{% raw %}{% include_cached /md/install.md kong_version=page.kong_version %}{% endraw %}
```

This maps `page.kong_version` to the `include.kong_version` from the source include file.


### Conditional content

You can add `if` statements to an `include` to create
variations of the content for use in different contexts. For example, in an
file named `install.md`, you might have a snippet where the instructions are
specific to Docker:

```liquid
{% raw %}{% if include.install == "docker" %}{% endraw %}
your docker content goes here
{% raw %}{% endif %}{% endraw %}
```

In the target file (the file where you want the content to display), call the
Docker section of the `include`:

```
{% raw %}{% include_cached /md/install.md install='docker' %}{% endraw %}
```

{:.important}
> The syntax for the if statement and the `include` is not the same.
* When creating an if statement condition based on a string, the string must be
enclosed in double quotes (`" "`) and use two equals signs: `if include.install == "docker"`
* When calling the section in an `include_cached` tag, use single quotes (`' '`) and one equals sign: `install='docker'`


## include-check script

The Kong docs site runs an `include` check script on every change pushed to the repository. If you run into issues with an `include`, the check will flag them. See more info about the `include` check in our repository [README](https://github.com/Kong/docs.konghq.com/#include-check).
