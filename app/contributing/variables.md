---
title: Using variables
---

Use variable in content text, links, and in code blocks.

Do not use in:
* Page front matter: This is an important note for plugins in particular, as
much of the page content is generated out of a plugin’s front matter.
* Auto-generated docs (for example, Admin API).
* Page titles or headings.

## Product names

For specific product name definitions and when to use what, see [word choice and naming](/contributing/word-choice/).

<!-- vale off-->

Variable | Output | Definition
---------|--------|-----------
{% raw %}`{{site.base_gateway}}`{% endraw %} | {{site.base_gateway}} | The Kong API Gateway. Use this in most situations, especially when talking about a feature that is available in both open-source and Enterprise packages.
{% raw %}`{{site.ee_product_name}}`{% endraw %} | {{site.ee_product_name}} | The whole self-managed Enterprise Gateway package, including modules and peripherals, e.g. Kong Manager, Enterprise plugins, etc. Use when you specifically need to refer to Enterprise functionality.
{% raw %}`{{site.ce_product_name}}`{% endraw %} | {{site.ce_product_name}} | Kong's open-source API gateway. Use when referring to something that's _only_ available in open-source.
{% raw %}`{{site.konnect_product_name}}`{% endraw %}| {{site.konnect_product_name}} | The full name of Kong Konnect.
{% raw %}`{{site.konnect_short_name}}`{% endraw %} | {{site.konnect_short_name}} | The short name of the SaaS Konnect control plane.
{% raw %}`{{site.company_name}}`{% endraw %} | {{site.company_name}} | The name of the company. <br><br> Sometimes "Kong" is used to refer to Kong Gateway. For branding reasons, we should avoid using this term to refer to Kong Gateway going forward, however, user communities will continue to use this term as shorthand.

## Links

Variable | Output | Definition
---------|--------|-----------
{% raw %}`{{site.links.learn}}`{% endraw %} | https://education.konghq.com | Link to the current location of Kong Academy or a similar education site.
{% raw %}`{{site.links.download}}`{% endraw %} | https://download.konghq.com | Kong's product download site.
{% raw %}`{{site.links.web}}`{% endraw %} | https://docs.konghq.com | Kong Docs website.

<!-- vale on -->

## Update or add variables

The product name variables are defined in the site config file, `jekyll.yml`.

If you need to update the variable text, add, or remove a variable, edit
`jekyll.yml` and `jekyll-dev.yml` in the root of the site repository.

For a new variable, use the following syntax: `<variable>:<output>`

<!-- vale off -->
<!--
## Versions

> WORK IN PROGRESS

kong_version

Depends on the page

The release-level version of the page that you’re on - eg 1.5.x, 1.3-x.

{{page.kong_version}}

Use this variable in links, eg:

/enterprise/{{page.kong_version}}/introduction

page.kong_latest.version

Depends on current release

The latest real version of the product on the page (eg 2.1.0.2)

{{page.kong_latest.version}}

page.kong_latest.release

Depends on current release

The URL and folder name of the latest version (eg 2.1.x) for the product on the page.

{{page.kong_latest.release}}

page.kong_versions[x].version

Outputs the specified version in the array

Turns the list of versions into an array and pulls the specified version.

E.g., if you want to pull the first version of the doc, you would use {{page.kong_versions[0].version}}, if you want to use the third published version, you would use {{page.kong_versions[2].version}}, etc

{{page.kong_versions[0].version}}

{{page.kong_versions[1].version}} -->

<!-- vale on -->
