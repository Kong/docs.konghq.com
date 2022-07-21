---
title: Kong Mesh
subtitle: A modern control plane built on top of Envoy and focused on simplicity, security, and scalability
---

<div class="alert alert-ee blue">
   <b>Demo</b>: To see {{site.mesh_product_name}} in action, you can
   <a href="https://konghq.com/request-demo-kong-mesh/">request a demo</a> and
   we will get in touch with you.
</div>

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
[{{site.ee_product_name}}](https://konghq.com/products/kong-enterprise) for a
full-stack connectivity platform for all of your services and APIs, across
every cloud and environment.

<div class="alert alert-ee blue">
   Kuma itself was originally created by Kong and donated to CNCF to
   provide the first neutral Envoy-based service mesh to the industry. Kong
   still maintains and develops Kuma, which is the foundation for
   {{site.mesh_product_name}}.
</div>
<br>
<center>
  <i>{{site.mesh_product_name}} extends CNCF's Kuma and Envoy to provide an
  enterprise-grade service mesh with unique features in the service mesh
  landscape, while still relying on a neutral foundation.</i>

<table class="mesh-features features-table">
<thead>
<tr>
<th></th>
<th class="product-name">
<span class="mobile-label">Kuma</span>
<img src="/assets/images/logos/kuma.png" alt="Kuma"/>
<a class="feature-cta" href="https://kuma.io/" target="_blank">Start Free</a>
</th>
<th class="product-name">
<span class="mobile-label">Kong Mesh</span>
<img src="/assets/images/logos/kong-mesh.png" alt="Kong Mesh"/>
<a class="feature-cta" href="http://konghq.com/contact-sales" target="_blank">Contact Sales</a>
</th>
</tr>
</thead>
<tbody>

<tr>
<td class="header-row"><span>Core Service Mesh Capabilities</span></td>
<td class="no-mobile"></td>
<td class="no-mobile"></td>
</tr>
<tr>
<td>All Kuma Policies</td>
<td><i class="fa fa-check"></i></td>
<td><i class="fa fa-check"></i></td>
</tr>
<tr>
<td>All Traffic Management Policies</td>
<td><i class="fa fa-check"></i></td>
<td><i class="fa fa-check"></i></td>
</tr>
<tr>
<td>All Observability Policies</td>
<td><i class="fa fa-check"></i></td>
<td><i class="fa fa-check"></i></td>
</tr>
<tr>
<td>Multi-Zone & Multi-Cluster</td>
<td><i class="fa fa-check"></i></td>
<td><i class="fa fa-check"></i></td>
</tr>
<tr>
<td>Multi-Zone Security

{% info_tooltip %}
This enterprise capability allows the user to secure multi-zone deployments with a JWT-based authentication that makes sure that only approved zones can join the cluster.
{% endinfo_tooltip %}
</td>
<td><i class="fa fa-times"></i></td>
<td><i class="fa fa-check"></i></td>
</tr>
<tr>
<td>Multi-Mesh Support</td>
<td><i class="fa fa-check"></i></td>
<td><i class="fa fa-check"></i></td>
</tr>

<tr>
<td class="header-row"><span>Zero-Trust and mTLS</span></td>
<td class="no-mobile"></td>
<td class="no-mobile"></td>
</tr>
<tr>
<td>Built-in CA</td>
<td><i class="fa fa-check"></i></td>
<td><i class="fa fa-check"></i></td>
</tr>
<tr>
<td>Provided CA</td>
<td><i class="fa fa-check"></i></td>
<td><i class="fa fa-check"></i></td>
</tr>
<tr>
<td>
HashiCorp Vault CA

{% info_tooltip %}
This enterprise capability allows us to enable HashiCorp Vault as an additional 3rd-party backend for out mTLS CAs that are being used to setup zero-trust security, without storing the CAs in Kong Mesh proper.
{% endinfo_tooltip %}
</td>
<td><i class="fa fa-times"></i></td>
<td><i class="fa fa-check"></i></td>
</tr>
<tr>
<td>
AWS Certificate Manager CA
{% info_tooltip %}
This enterprise capability allows us to enable AWS Certificate Manager as an additional 3rd-party backend for out mTLS CAs that are being used to setup zero-trust security, without storing the CAs in Kong Mesh proper.
{% endinfo_tooltip %}
</td>
<td><i class="fa fa-times"></i></td>
<td><i class="fa fa-check"></i></td>
</tr>
<tr>
<td>
Kubernetes cert-manager CA
{% info_tooltip %}
This enterprise capability allows us to enable Kubernetes cert-manager as an additional 3rd-party backend for out mTLS CAs that are being used to setup zero-trust security, without storing the CAs in Kong Mesh proper.
{% endinfo_tooltip %}
</td>
<td><i class="fa fa-times"></i></td>
<td><i class="fa fa-check"></i></td>
</tr>
<tr>
<td>
GUI Dashboard for TLS and CA
{% info_tooltip %}
This enterprise capability provides us with addional visual reports that visualize the status of the rotation of our data plane proxy certificates, and the rotation of the CAs themselves, in a zero-trust service mesh.
{% endinfo_tooltip %}
</td>
<td><i class="fa fa-times"></i></td>
<td><i class="fa fa-check"></i></td>
</tr>
<tr>
<td>Data Plane Certificate Rotation</td>
<td><i class="fa fa-check"></i></td>
<td><i class="fa fa-check"></i></td>
</tr>
<tr>
<td>
CA Automatic Rotation
{% info_tooltip %}
This enterprise capability provides automatic rotation across different CAs with no downtime, in addition to providing automatic rotation and certificate lifecycle management to the data plane proxy mTLS certificates. This feature combined with the GUI Dashboard for TLS and CA provides a complete solution for managing the entire lifecycle of zero-trust service meshes.
{% endinfo_tooltip %}
</td>
<td><i class="fa fa-times"></i></td>
<td><i class="fa fa-check"></i></td>
</tr>

<tr>
<td class="header-row"><span>Enterprise Application Security</span></td>
<td class="no-mobile"></td>
<td class="no-mobile"></td>
</tr>
<tr>
<td>
FIPS-140 Encryption

{% info_tooltip %}
Kong Mesh ships with FIPS-140 compliant encryption automatically enabled by default on the Envoy-based data plane proxies, requiring no additional steps from the user other than just running Kong Mesh itself.
{% endinfo_tooltip %}
</td>
<td><i class="fa fa-times"></i></td>
<td><i class="fa fa-check"></i></td>
</tr>
<tr>
<td>
Embedded OPA Agent
{% info_tooltip %}
Kong Mesh ships with an embedded OPA agent in the data plane proxy sidecars, without requiring the user to run an additional dedicated sidecar for the OPA agenet, therefore simplifying the rollout of OPA across the entire organization with lower operational costs.
{% endinfo_tooltip %}
</td>
<td><i class="fa fa-times"></i></td>
<td><i class="fa fa-check"></i></td>
</tr>
<tr>
<td>
Native OPA Policy
{% info_tooltip %}
This enterprise capability exposes a native OPA policy resource that can be used to store and automatically propagate OPA policies across a multi-zone deployment natively with Kong Mesh. We also support the ability to connect to a 3rd-party OPA store like Styra.
{% endinfo_tooltip %}
</td>
<td><i class="fa fa-times"></i></td>
<td><i class="fa fa-check"></i></td>
</tr>

<tr>
<td class="header-row"><span>Enterprise Security and Governance</span></td>
<td class="no-mobile"></td>
<td class="no-mobile"></td>
</tr>
<tr>
<td>
Roles and permissions (RBAC)
{% info_tooltip %}
This enterprise capability allows us to manage complex RBAC rules to allow - or deny - access to Kong Mesh policies and functions in a sophisticated and fine grained way. Works across multi-zone and multi-mesh natively.
{% endinfo_tooltip %}
</td>
<td><i class="fa fa-times"></i></td>
<td><i class="fa fa-check"></i></td>
</tr>
<tr>
<td>
Audit Logs
{% info_tooltip %}
This enterprise capability allows us to store and fetch auditing logs for operations that have been performed on the cluster and - when used with RBAC - allows us to have full visibility into how the system is being governed and configured by the users.
{% endinfo_tooltip %}
</td>
<td><i class="fa fa-times"></i></td>
<td><i class="fa fa-check"></i></td>
</tr>

<tr>
<td class="header-row"><span>Universal Platform Distributions</span></td>
<td class="no-mobile"></td>
<td class="no-mobile"></td>
</tr>
<tr>
<td>Containers, Kubernetes & OpenShift</td>
<td><i class="fa fa-check"></i></td>
<td><i class="fa fa-check"></i></td>
</tr>
<tr>
<td>
Kubernetes Operator
{% info_tooltip %}
This enterprise capability allows us to enormously simplify the operational cost of running Kong Mesh on Kubernetes by providing a native Kubernetes operator to fully manage the deployment, upgrades and rollouts of a cluster on Kubernetes.
{% endinfo_tooltip %}
</td>
<td><i class="fa fa-times"></i></td>
<td><i class="fa fa-check"></i></td>
</tr>
<tr>
<td>Virtual Machine Support</td>
<td><i class="fa fa-check"></i></td>
<td><i class="fa fa-check"></i></td>
</tr>
<tr>
<td>Virtual Machine Transparent Proxying</td>
<td><i class="fa fa-check"></i></td>
<td><i class="fa fa-check"></i></td>
</tr>
<tr>
<td>
Native AWS ECS Controller
{% info_tooltip %}
This enterprise capability allows us to natively support AWS ECS workloads with a built-in controller that automatically integrates ECS workloads within one or more service meshes powered by Kong Mesh, simplifying the expansion of service mesh in the cloud.
{% endinfo_tooltip %}
</td>
<td><i class="fa fa-times"></i></td>
<td><i class="fa fa-check"></i></td>
</tr>
<tr>
<td>
Windows Distributions
{% info_tooltip %}
This enterprise capability allows us to natively support Microsoft Windows workloads into our service meshes, allowing to us further expand the reach of Kong Mesh across every workload in the organization.
{% endinfo_tooltip %}
</td>
<td><i class="fa fa-times"></i></td>
<td><i class="fa fa-check"></i></td>
</tr>
<tr>
<td>
UBI Federal Distributions
{% info_tooltip %}
This enterprise capability provides officially supported distributions based on the Red Hat Universal Base Images (UBI).
{% endinfo_tooltip %}
</td>
<td><i class="fa fa-times"></i></td>
<td><i class="fa fa-check"></i></td>
</tr>


<tr>
<td class="header-row"><span>Support and Customer Success</span></td>
<td class="no-mobile"></td>
<td class="no-mobile"></td>
</tr>
<tr>
<td>
Enterprise Support and SLA
{% info_tooltip %}
With Kong Mesh we provide 24/7/265 enterprise support with different SLAs, powered by Kong's global customer success and technical support team across all world regions, and access to a vast network of partners for local language support as well. A must to have for enterprise mission-critical deployments.
{% endinfo_tooltip %}
</td>
<td><i class="fa fa-times"></i></td>
<td><i class="fa fa-check"></i></td>
</tr>
<tr>
<td>
Customer Success Packages
{% info_tooltip %}
With Kong Mesh we provide access to our implementation and training programs to accelerate the rollout of a service mesh across every team, and to properly train and educate the organization on how to effectively drive business outcomes with the product.
{% endinfo_tooltip %}
</td>
<td><i class="fa fa-times"></i></td>
<td><i class="fa fa-check"></i></td>
</tr>
<tr>
<td>
Envoy Support
{% info_tooltip %}
With Kong Mesh we provide access to the Envoy contributors at Kong to further expand the capabilities of the underlying data plane proxy technology (Envoy) with features that are not currently available in upstream Envoy, in order to remove road blocks and cater to unique enterprise requirements and use-cases.
{% endinfo_tooltip %}
</td>
<td><i class="fa fa-times"></i></td>
<td><i class="fa fa-check"></i></td>
</tr>
</tbody>
</table>

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
[Learn more](https://kuma.io/docs/latest/introduction/deployments/) about the
standalone and multi-zone deployment modes in the Kuma documentation.
