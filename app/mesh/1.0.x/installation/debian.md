---
title: Kong Mesh with Debian
no_search: true
---

## Debian

To install and run {{site.mesh_product_name}} on Debian (**amd64**),
execute the following steps:

* [1. Download {{site.mesh_product_name}}](#_1-download-kong-mesh)
* [2. Follow Kuma instructions](#_2-follow-kuma-instructions)

### 1. Download {{site.mesh_product_name}}

{% navtabs %}
{% navtab Script %}
Run the following script to automatically detect the operating system and
download {{site.mesh_product_name}}:

```sh
$ curl -L https://docs.konghq.com/mesh/installer.sh | sh -
```
{% endnavtab %}
{% navtab Manually %}
You can also [download](https://kong.bintray.com/kong-mesh/kong-mesh-{{page.kong_latest.version}}-debian-amd64.tar.gz)
the distribution manually.

Then, extract the archive with:

```sh
$ tar xvzf kong-mesh-{{page.kong_latest.version}}*.tar.gz
```
{% endnavtab %}
{% endnavtabs %}

### 2. Follow Kuma Instructions

After downloading the {{site.mesh_product_name}} binaries, the remaining
installation instructions for Kuma are fully compatible with
{{site.mesh_product_name}}, except you will be running the
{{site.mesh_product_name}} binaries instead of the vanilla Kuma ones.

To continue the installation, start from the second installation step in
[the official Kuma installation guide](https://kuma.io/docs/0.7.1/installation/debian/#_2-run-kuma).
