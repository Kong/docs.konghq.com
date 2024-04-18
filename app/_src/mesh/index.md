---
title: Kong Mesh
subtitle: A modern control plane built on top of Envoy and focused on simplicity, security, and scalability
---

{:.note}
> **Demo**: To see {{site.mesh_product_name}} in action, you can
[request a demo](https://konghq.com/request-demo-kong-mesh/) and
we will get in touch with you.

Welcome to the official documentation for {{site.mesh_product_name}}!

{{site.mesh_product_name}} is an enterprise-grade service mesh that runs on
both Kubernetes and VMs on any cloud. Built on top of CNCF's
[Kuma](https://kuma.io) and Envoy and focused on simplicity,
{{site.mesh_product_name}} enables the microservices transformation with:
* Out-of-the-box service connectivity and discovery
* Zero-trust security
* Traffic reliability
* Global observability across all traffic, including cross-cluster deployments

{{site.mesh_product_name}} extends Kuma and Envoy with enterprise features and
support, while providing native integration with
[{{site.ee_product_name}}](https://konghq.com/products/api-gateway-platform) for a
full-stack connectivity platform for all of your services and APIs, across
every cloud and environment.

{:.note}
> Kuma itself was originally created by Kong and donated to CNCF to
provide the first neutral Envoy-based service mesh to the industry. Kong
still maintains and develops Kuma, which is the foundation for
{{site.mesh_product_name}}.

<center>
  <i>{{site.mesh_product_name}} extends CNCF's Kuma and Envoy to provide an
  enterprise-grade service mesh with unique features in the service mesh
  landscape, while still relying on a neutral foundation.</i>

{% include_cached feature-table.html config=site.data.tables.features.mesh %}

</center>
<br>
{{site.mesh_product_name}} provides a unique combination of strengths and
features in the service mesh ecosystem, specifically designed for the enterprise
architect, including:

* **Universal** support for both Kubernetes and VM-based services.
* **Single and Multi Zone** deployments to support multi-cloud and multi-cluster
 environments with global/remote control plane modes, automatic Ingress
 connectivity, and service discovery.
* **Multi-Mesh** to create as many service meshes as we need, using one cluster
 with low operational costs.
* **Easy to install and use** and turnkey, by abstracting away all the
complexity of running a service mesh with easy-to-use policies for managing
services and traffic.
* **Full-Stack Connectivity** by natively integrating with Kong and
{{site.ee_product_name}} for end-to-end connectivity that goes from the API
gateway to the service mesh.
* **Powered by Kuma and Envoy** to provide a modern and reliable CNCF
open source foundation for an enterprise service mesh.

When used in combination with {{site.ee_product_name}}, {{site.mesh_product_name}}
provides a full stack connectivity platform for all of our L4-L7 connectivity,
for both edge and internal API traffic.

<center>
  <img src="/assets/images/docs/mesh/gw_mesh.png" width="600px"/>
  <br>
  <i>Two different applications - "Banking" and "Trading" - run in their
  own meshes "A" and "B" across different data centers. In this example,
  {{site.base_gateway}} is being used both for edge communication and for internal
  communication between meshes.</i>
</center>

## Why {{site.mesh_product_name}}? {#why-kong-mesh}

Organizations are transitioning to distributed software architectures to
support and accelerate innovation, gain digital revenue, and reduce costs.
A successful transition to microservices requires many pieces to fall into
place: that services are connected reliably with minimal latency,
that they are protected with end-to-end security, that they are discoverable
and fully observable. However, this presents challenges due to the need to
write custom code for security and identity, a lack of granular telemetry,
and insufficient traffic management capabilities, especially as the number of
services grows.

Leading organizations are looking to service meshes to address these challenges
in a scalable and standardized way. With a service mesh, you can:

* **Ensure service connectivity, discovery, and traffic reliability**: Apply
out-of-box traffic management to intelligently route traffic across any
platform and any cloud to meet expectations and SLAs.
* **Achieve Zero-Trust Security**: Restrict access by default, encrypt all
traffic, and only complete transactions when identity is verified.
* **Gain Global Traffic Observability**: Gain a detailed understanding of your
service behavior to increase application reliability and the efficiency of
your teams.

{{site.mesh_product_name}} is the universal service mesh for enterprise
organizations focused on simplicity and scalability with Kuma and Envoy.
Kong’s service mesh is unique in that it allows you to:

* **Start, secure, and scale with ease**:
  * Deploy a turnkey service mesh with a single command.
  * Group services by attributes to efficiently apply policies.
  * Manage multiple service meshes as tenants of a single control plane to
  provide scale and reduce operational costs.
* **Run anywhere**:
  * Deploy the service mesh across any environment, including multi-cluster,
  multi-cloud, and multi-platform.
  * Manage service meshes natively in Kubernetes using CRDs, or start with a
  service mesh in a VM environment and migrate to Kubernetes at your own pace.
* **Connect services end-to-end**:
  * Integrate into the {{site.ee_product_name}} platform for full stack connectivity,
  including Ingress and Egress traffic for your service mesh.
  * Expose mesh services for internal or external consumption and manage the
  full lifecycle of APIs.

Thanks to the underlying Kuma runtime, with {{site.mesh_product_name}}, you
can easily support multiple clusters, clouds, and architectures using the
multi-zone capability that ships out of the box. This &mdash; combined with
multi-mesh support &mdash; lets you create a service mesh powered by an Envoy proxy
for the entire organization in just a few steps. You can do this for both
simple and distributed deployments, including multi-cloud, multi-cluster, and
hybrid Kubernetes/VMs:

<center>
  <img src="/assets/images/docs/mesh/multi-zone.jpg" width="600px"/>
  <br>
  <i>{{site.mesh_product_name}} can support multiple zones (like a Kubernetes
    cluster, VPC, data center, etc.) together in the same distributed deployment.
     Then, you can create multiple isolated virtual meshes with the same
     control plane in order to support every team and application in the
     organization.</i>
</center>
<br>
Learn more about the [standalone and multi-zone deployment modes][deployments].

Example of a multi-zone deployment for multiple Kubernetes clusters, or a
hybrid Kubernetes/VM cluster:

<center>
  <img src="/assets/images/diagrams/gslides/kuma_multizone.svg" alt="Kuma service mesh multi zone deployment" style="padding-top: 20px; padding-bottom: 10px;">
</center>

## Support policy
Kong primarily follows a [semantic versioning](https://semver.org/) (SemVer)
model for its products.

For the latest version support information for
{{site.mesh_product_name}}, see our [version support policy](/mesh/latest/support-policy/).

## Contribute

You can contribute to the development of {{site.mesh_product_name}} by contributing to [Kuma](https://kuma.io/).
For more information, see the [contribution guide](https://kuma.io/community).

<!-- links -->
{% if_version gte:2.0.x %}
{% if_version lte:2.1.x %}
[deployments]: /mesh/{{page.release}}/introduction/deployments/
{% endif_version %}
{% if_version gte:2.2.x %}
[deployments]: /mesh/{{page.release}}/production/deployment/
{% endif_version %}
{% endif_version %}

{% if_version lte:1.9.x %}
[deployments]: https://kuma.io/docs/1.8.x/introduction/deployments/
{% endif_version %}
