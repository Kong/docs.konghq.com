---
title: Getting Started With Kong Mesh
no_search: true
---

## Getting Started

{{site.mesh_product_name}} - built on top of Kuma and Envoy - tries to be as close as possible to the usage of Kuma itself, while providing drop-in binary replacements for both the control plane and data plane executables.

As such - while the {{site.mesh_product_name}} binaries can be downloaded from the [official installation page](/mesh/{{page.kong_version}}/install) - we can follow [Kuma's official documentation](https://kuma.io/docs) after downloading {{site.mesh_product_name}} to start using the product.

For {{site.mesh_product_name}}'s enterprise features instead, we can take a look at the [enterprise documentation](/mesh/{{page.kong_version}}/features).

<div class="alert alert-ee blue">
   Kuma, a donated CNCF project, was originally created by Kong which is currently maintaining both the project and the documentation.
</div>

## 1. Installing {{site.mesh_product_name}}

The first step to start using {{site.mesh_product_name}} is to download the product from the [official installation page](/mesh/{{page.kong_version}}/install).

To make sure that {{site.mesh_product_name}} has been downloaded properly, we can check the versions of the executables and make sure that they start with the `{{site.mesh_product_name}}` prefix:

```sh
$ kumactl version
Kong Mesh [VERSION NUMBER]

$ kuma-cp version
Kong Mesh [VERSION NUMBER]

$ kuma-dp version
Kong Mesh [VERSION NUMBER]
```

## 2. Getting Started

Once downloaded, follow the getting started guide to get up and running:

* [Getting started with Kubernetes](https://kuma.io/docs/latest/quickstart/kubernetes/)
* [Getting started with Universal](https://kuma.io/docs/latest/quickstart/universal/)

## 3. Reading the documentation

Finally, we can learn more about the product by reading the official Kuma documentation, and the enterprise features documentation that are exclusive to {{site.mesh_product_name}}:

* [Official Kuma documentation](https://kuma.io/docs/)
* [Enterprise features documentation](/mesh/{{page.kong_version}}/features)

Of course, if you are a {{site.mesh_product_name}} customer you can also open a support ticket with any question or feedback you may have.
