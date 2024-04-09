---
title: Kong Mesh with Red Hat
---

To install and run {{site.mesh_product_name}} on Red Hat (**x86_64**):

1. [Download {{site.mesh_product_name}}](#1-download-kong-mesh)
1. [Run {{site.mesh_product_name}}](#2-run-kong-mesh)
1. [Verify the Installation](#3-verify-the-installation)

Finally, you can follow the [Quickstart](#4-quickstart) to take it from here and continue your {{site.mesh_product_name}} journey.

## Prerequisites

You have a license for {{site.mesh_product_name}}.

## 1. Download {{site.mesh_product_name}}

{% navtabs %}
{% navtab Script %}

Run the following script to automatically detect the operating system
and download {{site.mesh_product_name}}:

```sh
$ curl -L https://docs.konghq.com/mesh/installer.sh | VERSION={{page.version}} sh -
```
{% endnavtab %}
{% navtab Manually %}
You can also [download]({{site.links.direct}}/kong-mesh-legacy/raw/names/kong-mesh-rhel-amd64/versions/{{page.version}}/kong-mesh-{{page.version}}-rhel-amd64.tar.gz) the distribution manually.

Then, extract the archive with:

```sh
$ tar xvzf kong-mesh-{{page.version}}*.tar.gz
```
{% endnavtab %}
{% endnavtabs %}

{% include /md/mesh/install-universal-run.md kong_latest=page.kong_latest %}

{% include /md/mesh/install-universal-verify.md %}

{% include /md/mesh/install-universal-quickstart.md %}
