---
title: Kong Mesh With Amazon Linux
no_search: true
---

## Amazon Linux

<div class="alert alert-ee blue">
If you wish to use Kuma on Amazon EKS please follow the <a href="/mesh/{{page.kong_version}}/installation/kubernetes">Kubernetes instructions</a> instead.
</div>

To install and run {{site.mesh_product_name}} on Amazon Linux (**x86_64**) execute the following steps:

* [1. Download {{site.mesh_product_name}}](#_1-download-kong-mesh)
* [2. Follow Kuma instructions](#_2-follow-kuma-instructions)

### 1. Download {{site.mesh_product_name}}

Run the following script to automatically detect the operating system and download {{site.mesh_product_name}}:

```sh
$ yum install -y tar gzip
$ curl -L https://docs.konghq.com/mesh/installer.sh | sh -
```

or you can [download](https://kong.bintray.com/kong-mesh/kong-mesh-{{page.kong_latest.version}}-centos-amd64.tar.gz) the distribution manually.

Then extract the archive with:

```sh
$ tar xvzf kong-mesh-{{page.kong_latest.version}}*.tar.gz
```

### 2. Follow Kuma instructions

Afer downloading the {{site.mesh_product_name}} binaries, the installation instructions are compatible with Kuma, except they will be running the {{site.mesh_product_name}} binaries instead of the vanilla Kuma ones.

To continue the installation follow the second installation step on [the official Kuma installation guide](https://kuma.io/docs/0.7.1/installation/amazonlinux/#_2-run-kuma).
