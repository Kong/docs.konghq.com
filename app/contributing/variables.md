---
title: Using Variables
no_version: true
---

The product name variables are defined in the site config file, `jekyll.yml`:

```yaml
# product name vars
ee_product_name: Kong Gateway
ce_product_name: Kong Gateway (OSS)
base_gateway: Kong Gateway
mesh_product_name: Kong Mesh
kic_product_name: Kubernetes Ingress Controller
konnect_product_name: Kong Konnect
konnect_short_name: Konnect
konnect_saas: Konnect SaaS
package_name: Kong Konnect
company_name: Kong Inc.

# Konnect tier vars
free_tier: Kong Gateway
plus_tier: Kong Konnect Plus
enterprise_tier: Kong Konnect Enterprise
```

If you need to update the variable text, add, or remove a variable, edit
`jekyll.yml` and `jekyll-dev.yml` in the root of the site repository.

For a new variable, use the following syntax: `<variable>:<output>`

Do: use in content text, in links, in codeblocks.

Do not use in:
* Page front matter: This is an important note for plugins in particular, as
much of the page content is generated out of a plugin’s front matter.

* Auto-generated docs (eg Admin API).

* Page titles or headings.

## Product names

Variable | Output | Definition | Syntax
---------|--------|------------|-------
base_gateway | {{site.base_gateway}} | The base API gateway. Use this when talking about a feature that is available for both Community and Enterprise. | {% raw %}`{{site.base_gateway}}`{% endraw %}
ee_product_name | {{site.ee_product_name}} | The whole self-hosted Enterprise Gateway package, including modules and peripherals, eg Kong Manager, Dev Portal, Vitals, etc. | {% raw %}`{{site.ee_product_name}}`{% endraw %}
ce_product_name | {{site.ce_product_name}} | Kong's open-source API gateway. | {% raw %}`{{site.ce_product_name}}`{% endraw %}
konnect_product_name | {{site.konnect_product_name}} | The full name of the Kong Konnect platform, cloud and self-hosted. | {% raw %}`{{site.konnect_product_name}}`{% endraw %}
konnect_short_name | {{site.konnect_short_name}} | The short name of the SaaS Konnect control plane. | {% raw %}`{{site.konnect_short_name}}`{% endraw %}
konnect_saas | {{site.konnect_saas}} | The full name of the SaaS Konnect control plane.  | {% raw %}`{{site.konnect_saas}}`{% endraw %}
company_name | {{site.company_name}} | The name of the company. <br> Do not use “Kong” without a modifier to refer to Kong Gateway. Kong refers only to the company. | {% raw %}{{site.company_name}}{% endraw %}

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

{{page.kong_versions[1].version}}
