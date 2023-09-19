---
title: Kong Gateway Operator
subtitle: Deploy and manage Kong on Kubernetes using Kubernetes resources
---

## Quick Links

<div class="docs-grid-install max-4">

  <a href="/gateway-operator/{{page.release}}/get-started/konnect/install/" class="docs-grid-install-block no-description">
    <img class="install-icon no-image-expand" src="/assets/images/icons/icn-cloud-blue.svg" alt="">
    <div class="install-text">Quick Start (Konnect)</div>
  </a>

  <a href="/gateway/{{page.release}}/get-started/kic/install/" class="docs-grid-install-block no-description">
    <img class="install-icon no-image-expand" src="/assets/images/icons/documentation/icn-learning.svg" alt="">
    <div class="install-text">Quick Start (KIC)</div>
  </a>

  <a href="/gateway-operator/{{page.release}}/install/" class="docs-grid-install-block no-description">
    <img class="install-icon no-image-expand" src="/assets/images/icons/documentation/icn-deployment-color.svg" alt="">
    <div class="install-text">Install</div>
  </a>

  <a href="/gateway-operator/{{page.release}}/reference/custom-resources/" class="docs-grid-install-block no-description">
    <img class="install-icon no-image-expand" src="/assets/images/icons/documentation/icn-admin-api-color.svg" alt="">
    <div class="install-text">CRDs</div>
  </a>

</div>

## Introducing {{ site.kgo_product_name }}

{{site.kgo_product_name}} is a [Kubernetes Operator](https://kubernetes.io/docs/concepts/extend-kubernetes/operator/) that can manage your {{ site.kic_product_name }}, {{ site.base_gateway }} Data Planes, or both together when running on Kubernetes.

With {{site.kgo_product_name}}, users can:

* Deploy and configure {{ site.base_gateway }} services
* Customise deployments using `PodTemplateSpec` to deploy sidecards, set node affinity and more.
* Upgrade Data Planes using a rolling restart or blue/green deployments