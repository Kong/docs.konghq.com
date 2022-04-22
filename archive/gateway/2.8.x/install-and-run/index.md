---
title: Install Kong Gateway
disable_image_expand: true
---

<div class="docs-grid-install">

  <a href="/gateway/{{page.kong_version}}/install-and-run/docker" class="docs-grid-install-block no-description">
    <img class="install-icon" src="https://doc-assets.konghq.com/install-logos/docker.png" alt="" />
    <div class="install-text">Docker</div>
  </a>

  <a href="/gateway/{{page.kong_version}}/install-and-run/kubernetes" class="docs-grid-install-block no-description">
    <img class="install-icon" src="/assets/images/icons/documentation/kubernetes-logo.png" alt="" />
    <div class="install-text">Kubernetes</div>
  </a>

  <a href="/gateway/{{page.kong_version}}/install-and-run/helm" class="docs-grid-install-block no-description">
    <img class="install-icon" src="/assets/images/icons/documentation/helm-icon-color.svg" alt="" />
    <div class="install-text">Helm</div>
  </a>

  <a href="/gateway/{{page.kong_version}}/install-and-run/openshift" class="docs-grid-install-block no-description">
    <img class="install-icon" src="/assets/images/icons/documentation/openshift-logo.png" alt="" />
    <div class="install-text">OpenShift</div>
  </a>

  <a href="/gateway/{{page.kong_version}}/install-and-run/centos" class="docs-grid-install-block no-description">
    <img class="install-icon" src="https://doc-assets.konghq.com/install-logos/centos.gif" alt="" />
    <div class="install-text">CentOS</div>
  </a>

  <a href="/gateway/{{page.kong_version}}/install-and-run/ubuntu" class="docs-grid-install-block no-description">
    <img class="install-icon" src="https://doc-assets.konghq.com/install-logos/ubuntu.png" alt="" />
    <div class="install-text">Ubuntu</div>
  </a>

  <a href="/gateway/{{page.kong_version}}/install-and-run/amazon-linux" class="docs-grid-install-block no-description">
    <img class="install-icon" src="https://doc-assets.konghq.com/install-logos/amazon-linux.png" alt="" />
    <div class="install-text">Amazon Linux 2</div>
  </a>

  <a href="/gateway/{{page.kong_version}}/install-and-run/rhel" class="docs-grid-install-block no-description">
    <img class="install-icon" src="https://www.redhat.com/cms/managed-files/styles/wysiwyg_full_width/s3/Logo-RedHat-Hat-Color-CMYK%20%281%29.jpg?itok=Mf0Ff9jq" alt="" />
    <div class="install-text">RHEL</div>
  </a>

  <a href="/gateway/{{page.kong_version}}/install-and-run/debian" class="docs-grid-install-block no-description">
    <img class="install-icon" src="/assets/images/icons/documentation/debian-logo.jpg" alt="" />
    <div class="install-text">Debian
    </div>
  </a>

  <a href="/gateway/{{page.kong_version}}/install-and-run/macos" class="docs-grid-install-block no-description">
    <img class="install-icon" src="/assets/images/icons/documentation/macos-logo.png" alt="" />
    <div class="install-text">MacOS
    <br> <span class="badge oss" aria-label="open-source only"></span>
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

If you install the {{site.base_gateway}} (not open-source), you can add a license
at any time to gain access to Enterprise features.

{:.note}
> **Note**: For deployments on Kubernetes (including Helm and OpenShift),
you need to apply the license during installation.

See [Kong Gateway Licensing](/gateway/latest/plan-and-deploy/licenses/) for a feature comparison
between Free Mode and the Enterprise subscription, and more information about licenses.
