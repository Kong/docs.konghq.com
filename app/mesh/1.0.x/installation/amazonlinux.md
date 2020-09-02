---
title: Kong Mesh With Amazon Linux
no_search: true
---

## Amazon Linux

<div class="alert alert-ee blue">
If you want to use Kuma on Amazon EKS, follow the
<a href="/mesh/{{page.kong_version}}/installation/kubernetes">Kubernetes instructions</a>
instead.
</div>

To install and run {{site.mesh_product_name}} on Amazon Linux (**x86_64**),
execute the following steps:

* [1. Download {{site.mesh_product_name}}](#_1-download-kong-mesh)
* [2. Follow Kuma instructions](#_2-follow-kuma-instructions)

### 1. Download {{site.mesh_product_name}}

{% navtabs %}
{% navtab Script %}

Run the following script to automatically detect the operating system and
download the latest version of {{site.mesh_product_name}}:

```sh
$ yum install -y tar gzip
$ curl -L https://docs.konghq.com/mesh/installer.sh | sh -
```

{% endnavtab %}
{% navtab Manually %}

You can also [download](https://kong.bintray.com/kong-mesh/kong-mesh-{{page.kong_latest.version}}-centos-amd64.tar.gz)
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
[the official Kuma installation guide](https://kuma.io/docs/0.7.1/installation/amazonlinux/#_2-run-kuma).
