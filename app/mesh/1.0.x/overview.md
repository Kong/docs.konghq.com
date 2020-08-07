---
title: Kong Mesh Overview
no_search: true
---

# Introduction

Welcome to the official documentation for {{site.mesh_product_name}}!

{{site.mesh_product_name}} is an enterprise-grade service mesh that runs on both Kubernetes and VMs on any cloud. Built on top of [Kuma](https://kuma.io) and Envoy and focused on simplicity, it enables the microservices transformation with out of the box service connectivity and discovery, zero-trust security, traffic reliability and global observability across all traffic including cross-cluster deployments among other features.

Kong Mesh extends Kuma and Envoy with enterprise features and support, while providing a native integration with [Kong Enterprise](/products/kong-enterprise) to provide a full-stack connectivity platform for all of your services and APIs, across every cloud or environment.

<div class="alert alert-ee blue">
   To see {{site.mesh_product_name}} in action you can <a href="/request-demo-kong-mesh/">request a demo</a> and we will get in touch with you.
</div>

{{site.mesh_product_name}} provides unique combination of strengths and features in the service mesh ecosystem that have been specifically designed for the enterprise architect, including:

* **Universal** support for both Kubernetes and VM-based services.
* **Single and Multi Zone** deployments to support multi-cloud and multi-cluster environments with global/remote control plane modes, automatic Ingress connectivity and service discovery.
* **Multi-Mesh** to create as many service meshes as we need with one cluster with low operational costs.
* **Easy to install and use** and turnkey by abstracting away all the complexity of running a service mesh with easy to use policies to manage our services and traffic.
* **Full-Stack Connectivity** by natively integrating with Kong and Kong Enterprise for end-to-end connectivity that goes from the API gateway to the service mesh.
* **Powered by Kuma and Envoy** to provide a modern and reliable CNCF open source foundation to an enterprise service mesh.

## Why {{site.mesh_product_name}}?

Organizations are transitioning to distributed software architectures to support and accelerate innovation, gain digital revenues and reduce costs. A successful transition to microservices requires that services are connected reliably with minimal latency, that they are protected with end-to-end security, that they are discoverable and fully observable. However, this presents challenges due to the need to write custom code for security and identity, a lack of granular telemetry, and insufficient traffic management capabilities, especially as the number of services grow. 

Leading organizations are looking to service meshes to address these challenges in a scalable and standardized way to 

* **Ensure service connectivity, discovery and traffic reliability**: Apply out-of-box traffic management to intelligently route traffic across any platform and any cloud to meet expectations and SLAs.
* **Achieve Zero-Trust Security**: Restrict access by default, encrypt all traffic, and only complete transactions when identify is verified.
* **Gain Global Traffic Observability**: Gain a detailed understanding of your service behavior to increase application reliability and the efficiency of your teams.

Kong Mesh is the universal service mesh for enterprise organizations focused on simplicity and scalability with Kuma and Envoy. Kong’s service mesh is unique in that it allows to:

* **Start, secure and scale with ease**: Deploy a turnkey service mesh with a single command. Group services by attributes to efficiently apply policies. Manage multiple service meshes as tenants of a single control plane to provide scale and reduce operational costs.
* **Run anywhere**: Deploy the service mesh across any environment, including multi-cluster, multi-cloud and multi-platform. Manage service meshes natively in Kubernetes using CRDs, or start with a service mesh in VM environments and migrate to Kubernetes at your own pace.
* **Connect services end-to-end**: Integrate into the Kong Enterprise platform for full stack connectivity including Ingress and Egress traffic for your service mesh. Expose mesh services for internal or external consumption and manage the full-lifecycle of APIs.





