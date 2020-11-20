---
title: Install Kong Mesh
---

## Install {{site.mesh_product_name}}

{{site.mesh_product_name}} is built on top of Kuma and Envoy. To create a
seamless experience, {{site.mesh_product_name}} follows the same installation
and configuration procedures as Kuma, but uses its own binaries.

On this page, you will find access to the official {{site.mesh_product_name}}
distributions that provide a drop-in replacement to Kuma's native binaries.

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

## Verify Installation

To confirm that you have installed the right version of
{{site.mesh_product_name}}, you can always run the following commands and
make sure that the version output starts with the `{{site.mesh_product_name}}`
prefix:

```sh
$ kumactl version
Kong Mesh [VERSION NUMBER]

$ kuma-cp version
Kong Mesh [VERSION NUMBER]

$ kuma-dp version
Kong Mesh [VERSION NUMBER]
```
