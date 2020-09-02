---
title: Install Kong Mesh
no_search: true
---

## Install {{site.mesh_product_name}}

{{site.mesh_product_name}} is built on top of Kuma and Envoy and in order to create a seamless experience it follows the same exact installation and configuration procedures as Kuma, but with its own binaries instead.

On this page you will find access to the official {{site.mesh_product_name}} distributions that provide a drop-in replacemement to Kuma's native binaries.

<b>The latest {{site.mesh_product_name}} is {{page.kong_latest.version}}:</b>

* [Kubernetes](/mesh/{{page.kong_version}}/installation/kubernetes)
* [Helm](/mesh/{{page.kong_version}}/installation/helm)
* [OpenShift](/mesh/{{page.kong_version}}/installation/openshift)
* [Docker](/mesh/{{page.kong_version}}/installation/docker)
* [CentOS](/mesh/{{page.kong_version}}/installation/centos)
* [RedHat](/mesh/{{page.kong_version}}/installation/redhat)
* [Amazon Linux](/mesh/{{page.kong_version}}/installation/amazonlinux)
* [Debian](/mesh/{{page.kong_version}}/installation/debian)
* [Ubuntu](/mesh/{{page.kong_version}}/installation/ubuntu)
* [macOS](/mesh/{{page.kong_version}}/installation/macos)

## Verify installation

To make sure that we have installed the right version of {{site.mesh_product_name}}, you can always run the following commands and make sure that the version output is being prefixed with `{{site.mesh_product_name}}`:

```sh
$ kumactl version
Kong Mesh [VERSION NUMBER]

$ kuma-cp version
Kong Mesh [VERSION NUMBER]

$ kuma-dp version
Kong Mesh [VERSION NUMBER]
```
