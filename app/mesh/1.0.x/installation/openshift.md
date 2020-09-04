---
title: Kong Mesh with OpenShift
no_search: true
---

## OpenShift

To install and run {{site.mesh_product_name}} on OpenShift, execute the
following steps:

* [1. Download {{site.mesh_product_name}}](#_1-download-kong-mesh)
* [2. Follow Kuma instructions](#_2-follow-kuma-instructions)

### 1. Download {{site.mesh_product_name}}

To run {{site.mesh_product_name}} on OpenShift, you need to download a
compatible version of {{site.mesh_product_name}} for the machine from which
you will be executing the commands.

{% navtabs %}
{% navtab Script %}

You can run the following script to automatically detect the operating system
and download {{site.mesh_product_name}}:

```sh
$ curl -L https://docs.konghq.com/mesh/installer.sh | sh -
```

{% endnavtab %}
{% navtab Manually %}

You can also download the distribution manually. Download a distribution for
the **client host** from where you will be executing the commands to access
Kubernetes:

* [CentOS](https://kong.bintray.com/kong-mesh/kong-mesh-{{page.kong_latest.version}}-centos-amd64.tar.gz)
* [RedHat](https://kong.bintray.com/kong-mesh/kong-mesh-{{page.kong_latest.version}}-rhel-amd64.tar.gz)
* [Debian](https://kong.bintray.com/kong-mesh/kong-mesh-{{page.kong_latest.version}}-debian-amd64.tar.gz)
* [Ubuntu](https://kong.bintray.com/kong-mesh/kong-mesh-{{page.kong_latest.version}}-ubuntu-amd64.tar.gz)
* [macOS](https://kong.bintray.com/kong-mesh/kong-mesh-{{page.kong_latest.version}}-darwin-amd64.tar.gz)

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
[the official Kuma installation guide](https://kuma.io/docs/0.7.1/installation/openshift/#_2-run-kuma).
