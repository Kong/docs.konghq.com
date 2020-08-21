---
title: Kong Mesh With macOS
no_search: true
---

## macOS

To install and run {{site.mesh_product_name}} on macOS execute the following steps:

* [1. Download {{site.mesh_product_name}}](#_1-download-kong-mesh)
* [2. Follow Kuma instructions](#_2-follow-kuma-instructions)

### 1. Download {{site.mesh_product_name}}

To run {{site.mesh_product_name}} on macOS you can choose among different installation methods:

{% navtabs %}
{% navtab Script %}

Run the following script to automatically detect the operating system and download {{site.mesh_product_name}}:

```sh
$ curl -L https://konghq.com/assets/mesh/installer.sh | sh -
```

{% endnavtab %}
{% navtab Manually %}

You can also download the distribution manually:

* [Download {{site.mesh_product_name}}](https://kong.bintray.com/kong-mesh/kong-mesh-{{page.kong_latest.version}}-darwin-amd64.tar.gz)

Then extract the archive with:

```sh
$ tar xvzf kong-mesh-{{page.kong_latest.version}}*.tar.gz
```

{% endnavtab %}
{% navtab Homebrew (kumactl only) %}

If you only need the {{site.mesh_product_name}} CLI `kumactl`, then you can also execute:

```sh
$ brew install kumactl
```

{% endnavtab %}
{% endnavtabs %}

### 2. Follow Kuma instructions

Afer downloading the {{site.mesh_product_name}} binaries, the installation instructions are compatible with Kuma, except they will be running the {{site.mesh_product_name}} binaries instead of the vanilla Kuma ones.

To continue the installation follow the second installation step on [the official Kuma installation guide](https://kuma.io/docs/0.7.1/installation/macos/#_2-run-kuma).
