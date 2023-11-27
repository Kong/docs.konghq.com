---
title: Install Kong Gateway
disable_image_expand: true
---

<div class="docs-grid-install">

  <a href="/gateway/{{page.kong_version}}/install-and-run/docker" class="docs-grid-install-block no-description">
    <img class="install-icon" src="/assets/images/icons/third-party/docker.png" alt="" />
    <div class="install-text">Docker</div>
  </a>

  <a href="/gateway/{{page.kong_version}}/install-and-run/kubernetes" class="docs-grid-install-block no-description">
    <img class="install-icon" src="/assets/images/icons/third-party/kubernetes-logo.png" alt="" />
    <div class="install-text">Kubernetes</div>
  </a>

  <a href="/gateway/{{page.kong_version}}/install-and-run/helm" class="docs-grid-install-block no-description">
    <img class="install-icon" src="/assets/images/icons/third-party/helm-icon-color.svg" alt="" />
    <div class="install-text">Helm</div>
  </a>

  <a href="/gateway/{{page.kong_version}}/install-and-run/openshift" class="docs-grid-install-block no-description">
    <img class="install-icon" src="/assets/images/icons/third-party/openshift-logo.png" alt="" />
    <div class="install-text">OpenShift</div>
  </a>

  <a href="/gateway/{{page.kong_version}}/install-and-run/centos" class="docs-grid-install-block no-description">
    <img class="install-icon" src="/assets/images/icons/third-party/centos.gif" alt="" />
    <div class="install-text">CentOS</div>
  </a>

  <a href="/gateway/{{page.kong_version}}/install-and-run/ubuntu" class="docs-grid-install-block no-description">
    <img class="install-icon" src="/assets/images/icons/third-party/ubuntu.png" alt="" />
    <div class="install-text">Ubuntu</div>
  </a>

  <a href="/gateway/{{page.kong_version}}/install-and-run/amazon-linux" class="docs-grid-install-block no-description">
    <img class="install-icon" src="/assets/images/icons/third-party/amazon-linux.png" alt="" />
    <div class="install-text">Amazon Linux 2</div>
  </a>

  <a href="/gateway/{{page.kong_version}}/install-and-run/rhel" class="docs-grid-install-block no-description">
    <img class="install-icon" src="/assets/images/icons/third-party/rhel.jpg" alt="" />
    <div class="install-text">RHEL</div>
  </a>

  <a href="/gateway/{{page.kong_version}}/install-and-run/debian" class="docs-grid-install-block no-description">
    <img class="install-icon" src="/assets/images/icons/third-party/debian-logo.jpg" alt="" />
    <div class="install-text">Debian
    </div>
  </a>
</div>

## Deployment options

{% include_cached /md/gateway/deployment-options.md kong_version=page.kong_version %}

## Installation paths

Some installation topics provide multiple package types and installation options.
Choose your preferred mode when following installation steps:

* **Open-source**: Follow installation instructions and skip any Free or Enterprise steps.
* **Free Mode**: Install {{site.base_gateway}} without a license, gaining access to Kong Manager.
* **Enterprise**: Install {{site.base_gateway}} and add a license.

If you install the {{site.ee_product_name}} in Free mode, you can add a license
at any time to gain access to Enterprise features.

{:.note}
> **Note**: For deployments on Kubernetes (including Helm and OpenShift),
you need to apply the license during installation.

See [{{site.base_gateway}} Licensing](/gateway/latest/plan-and-deploy/licenses/) for a feature comparison
between Free Mode and the Enterprise subscription, and more information about licenses.
