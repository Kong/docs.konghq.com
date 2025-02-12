---
title: Kubernetes Topologies
content_type: explanation
---

Running {{ site.base_gateway }} on Kubernetes is a common deployment pattern. When running on Kubernetes, there are two configuration options available:

* [Hybrid mode](#hybrid-mode), with a CP (either on-prem or via Konnect) and multiple DPs
* [DB-less mode](/gateway/{{ page.release }}/production/deployment-topologies/db-less-and-declarative-config/), configured using CRDs and the {{ site.kic_product_name }}

Running Kong in Hybrid mode is commonly referred to as "Kong _on_ Kubernetes". Running Kong with {{ site.kic_product_name }} is commonly referred to as "Kong _for_ Kubernetes", as it provides a Kubernetes native way of configuring Kong entities using {{ site.kic_product_name }}.

{:.note}
> You can also use {{ site.kic_product_name }} to configure a Hybrid mode deployment. This should only be used in a small set of circumstances. We recommend using Hybrid mode without KIC, or DB-less mode with KIC, unless you've been otherwise advised by a member of the Kong team.

## Hybrid mode

Deploying {{ site.base_gateway }} in [Hybrid mode](/gateway/{{ page.release }}/production/deployment-topologies/hybrid-mode/) uses Kubernetes as a runtime for your data planes. 

Configuring Kong on Kubernetes is identical to deploying Kong running on a virtual machine or bare metal. The Data Planes connect to a Control Plane (Konnect, or an in-cluster control plane) and receive configuration from the CP. Configuration is managed using the UI, the Kong Admin API or via [deck](/deck/latest/).

We provide detailed [installation instructions](/gateway/{{ page.release }}/install/kubernetes/proxy/) for Hybrid mode, including ingress definitions for EKS, GKE and AKS.

## DB-less mode with {{ site.kic_product_name }}

{{ site.kic_product_name }} provides a Kubernetes native way to configure {{ site.base_gateway }} using custom resource definitions (CRDs). In this deployment pattern, {{ site.base_gateway }} is deployed in DB-less mode, where the data plane configuration is held in memory.

Operators configure {{ site.base_gateway }} using standard CRDs such as `Ingress` and `HTTPRoute`, and {{ site.kic_product_name }} translates those resources in to Kong entities before sending a request to update the running data plane configurations.

In this topology, the Kubernetes API server is your source of truth. {{ site.kic_product_name }} reads resources stored on the API server and translates them in to a valid Kong configuration object. You can think of {{ site.kic_product_name }} as the control plane for your DB-less data planes.

For more information about {{ site.base_gateway }} and {{ site.kic_product_name }}, see the {{ site.kic_product_name }} [getting started guide](/kubernetes-ingress-controller/latest/get-started/). This guide walks you through installing {{ site.base_gateway }}, configuring a service and route, then adding a rate limiting and caching plugin to your deployment.

## Deciding which to use

Both topologies are supported by Kong, and deciding between the two options depends on your team's capabilities.

If you're a Kubernetes-native company who are comfortable managing CRDs and have pre-existing workflows around Kubernetes resources, we recommend using {{ site.kic_product_name }} to manage your deployment. {{ site.kic_product_name }} can be attached to Konnect to provide visibility in to the generated configuration and live traffic through analytics.

If your team is not familiar with CRDs, or you're migrating an existing configuration from bare metal machines or VMs to Kubernetes, you should choose Hybrid mode. In this topology, Kubernetes is a place to run your data planes and nothing more. There are no CRDs to learn, no Ingress Controller to maintain and update. All configuration is stored in the control plane and send to data planes using the Hybrid mode protocol.

<div class="docs-grid-install max-2">
  <a href="/gateway/{{ page.release }}/install/kubernetes/proxy/" class="docs-grid-install-block no-description">
    <img class="install-icon no-image-expand small" src="/assets/images/icons/kong-gradient.svg" alt="">
    <div class="install-text">Choose Hybrid Mode</div>
  </a>

  <a href="/kubernetes-ingress-controller/latest/get-started/" class="docs-grid-install-block no-description">
    <img class="install-icon no-image-expand small" src="/assets/images/icons/third-party/kubernetes-logo.png" alt="">
    <div class="install-text">Choose {{ site.kic_product_name }}</div>
  </a>
</div>