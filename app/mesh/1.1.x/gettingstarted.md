---
title: Getting Started with Kong Mesh
---

## Getting Started

{{site.mesh_product_name}} &mdash; built on top of CNCF's Kuma and Envoy &mdash;
 tries to be as close as possible to the usage of Kuma itself, while providing
 drop-in binary replacements for both the control plane and data plane
 executables.

You can download the {{site.mesh_product_name}} binaries from the
[official installation page](/mesh/{{page.kong_version}}/install), then follow
[Kuma's official documentation](https://kuma.io/docs) to start using the product.

For {{site.mesh_product_name}}'s enterprise features, take a look at the
[enterprise documentation](/mesh/{{page.kong_version}}/features).

<div class="alert alert-ee blue">
   Kuma, a donated CNCF project, was originally created by Kong, which is
   currently maintaining both the project and the documentation.
</div>

## 1. Installing {{site.mesh_product_name}}

Download and install {{site.mesh_product_name}} from the
[official installation page](/mesh/{{page.kong_version}}/install).

To confirm that {{site.mesh_product_name}} has been installed properly, you
can check the versions of the executables and make sure that they start with
the `{{site.mesh_product_name}}` prefix:

```sh
$ kumactl version
Kong Mesh [VERSION NUMBER]

$ kuma-cp version
Kong Mesh [VERSION NUMBER]

$ kuma-dp version
Kong Mesh [VERSION NUMBER]
```

## 2. Getting Started

Once installed, follow the getting started guide to get
{{site.mesh_product_name}} up and running:

* [Getting started with Kubernetes](https://kuma.io/docs/latest/quickstart/kubernetes/)
* [Getting started with Universal](https://kuma.io/docs/latest/quickstart/universal/)

## 3. Reading the Documentation

You can learn more about the product by reading the official Kuma documentation,
and the documentation for the enterprise features that are exclusive to
{{site.mesh_product_name}}:

* [Official Kuma documentation](https://kuma.io/docs/)
* [Enterprise features documentation](/mesh/{{page.kong_version}}/features)

If you are a {{site.mesh_product_name}} customer, you can also open a support
ticket with any question or feedback you may have.
