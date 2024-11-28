---
title: Install Kong Mesh
disable_image_expand: true
# This page is to be removed as soon as we remove docs lower than 2.2.x
---

## Install {{site.mesh_product_name}}

{{site.mesh_product_name}} is built on top of Kuma and Envoy. To create a
seamless experience, {{site.mesh_product_name}} follows the same installation
and configuration procedures as Kuma, but with {{site.mesh_product_name}}-specific binaries.

The official distributions of {{site.mesh_product_name}} provide a drop-in replacement to Kuma's native binaries, plus
links to cloud marketplace integrations.

**The latest {{site.mesh_product_name}} version is
{{page.kong_latest.version}}.**


## Licensing

Your {{site.mesh_product_name}} license includes an expiration date and the number of data plane proxies you can deploy. If you deploy more proxies than your license allows, you receive a warning.

You have a 30-day grace period after the license expires. Make sure to renew your license before the grace period ends.

## Check version

To confirm that you have installed the right version of
{{site.mesh_product_name}}, run the following commands and
make sure the version output starts with the `{{site.mesh_product_name}}`
prefix:

```sh
$ kumactl version
{{site.mesh_product_name}} [VERSION NUMBER]

$ kuma-cp version
{{site.mesh_product_name}} [VERSION NUMBER]

$ kuma-dp version
{{site.mesh_product_name}} [VERSION NUMBER]
```
