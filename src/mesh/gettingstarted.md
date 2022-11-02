---
title: Getting Started with Kong Mesh
---

## Getting Started

{{site.mesh_product_name}} &mdash; built on top of CNCF's [Kuma](https://kuma.io) and Envoy &mdash;
 tries to be as close as possible to the usage of Kuma itself, while providing
 drop-in binary replacements for both the control plane and data plane
 executables.

You can download the {{site.mesh_product_name}} binaries from the
[official installation page](/mesh/{{page.kong_version}}/install).

<div class="alert alert-ee blue">
   Kuma, a donated CNCF project, was originally created by Kong, which is
   currently maintaining both the project and the documentation.
</div>

## 1. Installing {{site.mesh_product_name}}

Download and install {{site.mesh_product_name}} from the
[official installation page](/mesh/{{page.kong_version}}/install).

## 2. Getting Started

After you install, follow the getting started guides to get
{{site.mesh_product_name}} up and running:

* [Getting started with Kubernetes](/mesh/{{page.kong_version}}/quickstart/kubernetes/){:target="_blank"}
* [Getting started with Universal](/mesh/{{page.kong_version}}/quickstart/universal/){:target="_blank"}

## 3. Learn more

Learn about enterprise features:
  * [Support for HashiCorp Vault CA](/mesh/{{page.kong_version}}/features/vault)
  * [Support for Amazon Certificate Manager Private CA](/mesh/{{page.kong_version}}/features/acmpca)
  * [Support for Kubernetes cert-manager CA](/mesh/{{page.kong_version}}/features/cert-manager)
  * [Support for Open Policy Agent](/mesh/{{page.kong_version}}/features/opa)
  * [Multi-zone authentication](/mesh/{{page.kong_version}}/features/kds-auth)
  * [Support for FIPS](/mesh/{{page.kong_version}}/features/fips-support)
  * [Certificate Authority rotation](/mesh/{{page.kong_version}}/features/ca-rotation)
  * [Role-Based Access Control](/mesh/{{page.kong_version}}/features/rbac)
  * [Red Hat Universal Base Images](/mesh/{{page.kong_version}}/features/ubi-images)
  * [Windows Support](/mesh/{{page.kong_version}}/features/windows)

If you are a {{site.mesh_product_name}} customer, you can also open a support
ticket with any questions or feedback you may have.
