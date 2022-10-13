---
title: Kong Mesh with Amazon Linux
---

<div class="alert alert-ee blue">
If you want to use {{site.mesh_product_name}} on Amazon EKS, follow the
<a href="/mesh/{{page.kong_version}}/installation/kubernetes">Kubernetes instructions</a>
instead.
</div>

To install and run {{site.mesh_product_name}} on Amazon Linux (**x86_64**):

1. [Download {{site.mesh_product_name}}](#1-download-kong-mesh)
2. [Run {{site.mesh_product_name}}](#2-run-kong-mesh)
3. [Verify the Installation](#3-verify-the-installation)

Finally, you can follow the [Quickstart](#4-quickstart) to take it from here and continue your {{site.mesh_product_name}} journey.

## Prerequisites

You have a license for {{site.mesh_product_name}}.

## 1. Download {{site.mesh_product_name}}

{% navtabs %}
{% navtab Script %}

Run the following script to automatically detect the operating system and
download the latest version of {{site.mesh_product_name}}:

```sh
yum install -y tar gzip
curl -L https://docs.konghq.com/mesh/installer.sh | VERSION={{page.version}} sh -
```

{% endnavtab %}
{% navtab Manually %}

You can also [download]({{site.links.download}}/mesh-alpine/kong-mesh-{{page.version}}-centos-amd64.tar.gz)
the distribution manually.

Then, extract the archive with:

```sh
tar xvzf kong-mesh-{{page.version}}*.tar.gz
```
{% endnavtab %}
{% endnavtabs %}

{% include_cached /md/mesh/install-universal-run.md version=page.version %}

{% include /md/mesh/install-universal-verify.md %}

{% include /md/mesh/install-universal-quickstart.md %}
