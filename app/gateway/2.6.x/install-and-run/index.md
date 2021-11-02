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
    <br> <span class="badge oss" aria-label="open-source only"></span>
    </div>
  </a>

  <a href="/gateway/{{page.kong_version}}/install-and-run/macos" class="docs-grid-install-block no-description">
    <img class="install-icon" src="/assets/images/icons/documentation/macos-logo.png" alt="" />
    <div class="install-text">MacOS
    <br> <span class="badge oss" aria-label="open-source only"></span>
    </div>
  </a>
</div>

### Deployment options

{% include_cached /md/gateway/deployment-options.md kong_version=page.kong_version %}

### Licensing

This software is governed by the
[Kong Software License Agreement](https://konghq.com/kongsoftwarelicense/).

To enable Enterprise features, {{site.base_gateway}} requires a license file.
You will receive this file from Kong when you sign up for a
{{site.konnect_product_name}} Enterprise subscription.

Once a license has been deployed to a {{site.base_gateway}} node, retrieve it
using the [`/licenses` Admin API endpoint](/gateway/{{page.kong_version}}/admin-api/licenses/examples).

If you have purchased a subscription but haven't received a license file,
contact your sales representative.

{:.note}
> **Note:** The free mode does not require a license. See
[Kong Gateway Licensing](/gateway/{{page.kong_version}}/plan-and-deploy/licenses/licensing)
for a feature comparison.
