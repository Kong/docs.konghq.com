---
title: Getting Started with Kong Mesh
---

{{site.mesh_product_name}} &mdash; built on top of CNCF's [Kuma](https://kuma.io) and Envoy &mdash;
 tries to be as close as possible to the usage of Kuma itself, while providing
 drop-in binary replacements for both the control plane and data plane
 executables.

{% if_version gte:2.0.x %}
You can download the {{site.mesh_product_name}} binaries from the
[official installation page](/mesh/{{page.release}}/install).
{% endif_version %}

{% if_version lte:1.9.x %}
You can download the {{site.mesh_product_name}} binaries from the
[official installation page](/mesh/{{page.release}}/install), then follow
[Kuma's official documentation](https://kuma.io/docs) to start using the product.
{% endif_version %}

{:.note}
> Kuma, a donated CNCF project, was originally created by Kong, which is
currently maintaining both the project and the documentation.

## 1. Installing {{site.mesh_product_name}}

Download and install {{site.mesh_product_name}} from the
[official installation page](/mesh/{{page.release}}/install).

## 2. Getting started

After you install, follow the getting started guides to get
{{site.mesh_product_name}} up and running.

{% if_version lte:1.9.x %}
The Kuma quickstart documentation
is fully compatible with {{site.mesh_product_name}}, except that you are
running {{site.mesh_product_name}} containers instead of Kuma containers:
{% endif_version %}

* [Getting started with Kubernetes][get-started-k8s]
{% if_version lte:2.5.x -%}
* [Getting started with Universal][get-started-universal]
{% endif_version %}

## 3. Learn more

Learn about enterprise features:
  * [Support for HashiCorp Vault CA](/mesh/{{page.release}}/features/vault/)
  * [Support for Amazon Certificate Manager Private CA](/mesh/{{page.release}}/features/acmpca/)
  {% if_version gte:1.8.x -%}
  * [Support for Kubernetes cert-manager CA](/mesh/{{page.release}}/features/cert-manager/)
  {% endif_version -%}
  * [Support for Open Policy Agent](/mesh/{{page.release}}/features/opa/)
  * [Multi-zone authentication](/mesh/{{page.release}}/features/kds-auth/)
  * [Support for FIPS](/mesh/{{page.release}}/features/fips-support/)
  * [Certificate Authority rotation](/mesh/{{page.release}}/features/ca-rotation/)
  * [Role-Based Access Control](/mesh/{{page.release}}/features/rbac/)
  * [Red Hat Universal Base Images](/mesh/{{page.release}}/features/ubi-images/)
  {% if_version lte:2.3.x -%}
  * [Windows Support](/mesh/{{page.release}}/features/windows/)
  {% endif_version %}

If you are a {{site.mesh_product_name}} customer, you can also open a support
ticket with any questions or feedback you may have.

<!-- links -->
{% if_version gte:2.6.x %}
[get-started-k8s]: /mesh/{{page.release}}/quickstart/kubernetes-demo/
{% endif_version %}

{% if_version lte:2.5.x gte:2.0.x %}
[get-started-k8s]: /mesh/{{page.release}}/quickstart/kubernetes/
[get-started-universal]: /mesh/{{page.release}}/quickstart/universal/
{% endif_version %}

{% if_version lte:1.9.x %}
[get-started-k8s]: https://kuma.io/docs/1.8.x/quickstart/kubernetes/
[get-started-universal]: https://kuma.io/docs/1.8.x/quickstart/universal/
{% endif_version %}
