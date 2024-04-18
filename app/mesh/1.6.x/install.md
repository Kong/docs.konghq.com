---
title: Install Kong Mesh
disable_image_expand: true
---

## Install {{site.mesh_product_name}}

{{site.mesh_product_name}} is built on top of Kuma and Envoy. To create a
seamless experience, {{site.mesh_product_name}} follows the same installation
and configuration procedures as Kuma, but with {{site.mesh_product_name}}-specific binaries.

On this page, you will find access to the official {{site.mesh_product_name}}
distributions that provide a drop-in replacement to Kuma's native binaries, plus
links to cloud marketplace integrations.

**The latest {{site.mesh_product_name}} version is
{{page.kong_latest.version}}.**

{% navtabs %}
{% navtab Containerized %}

<div class="docs-grid-install">

  <a href="/mesh/{{page.release}}/installation/kubernetes" class="docs-grid-install-block no-description">
    <img class="install-icon" src="/assets/images/icons/third-party/kubernetes-logo.png" alt="Kubernetes" />
    <div class="install-text">Kubernetes</div>
  </a>

  <a href="/mesh/{{page.release}}/installation/helm" class="docs-grid-install-block no-description">
    <img class="install-icon" src="/assets/images/icons/third-party/helm-icon-color.svg" alt="Helm" />
    <div class="install-text">Helm</div>
  </a>

  <a href="/mesh/{{page.release}}/installation/openshift" class="docs-grid-install-block no-description">
    <img class="install-icon" src="/assets/images/icons/third-party/openshift-logo.png" alt="OpenShift" />
    <div class="install-text">OpenShift</div>
  </a>

  <a href="/mesh/{{page.release}}/installation/docker" class="docs-grid-install-block no-description">
    <img class="install-icon" src="/assets/images/icons/third-party/docker.png" alt="Docker" />
    <div class="install-text">Docker</div>
  </a>

  <a href="/mesh/{{page.release}}/installation/ecs" class="docs-grid-install-block no-description">
    <img class="install-icon" src="/assets/images/icons/third-party/logo-ecs.jpg" alt="Amazon ECS" />
    <div class="install-text">Amazon ECS</div>
  </a>
</div>

{% endnavtab %}
{% navtab Operating Systems %}

<div class="docs-grid-install">

  <a href="/mesh/{{page.release}}/installation/centos" class="docs-grid-install-block no-description">
    <img class="install-icon" src="/assets/images/icons/third-party/centos.gif" alt="CentOS" />
    <div class="install-text">CentOS</div>
  </a>

  <a href="/mesh/{{page.release}}/installation/redhat" class="docs-grid-install-block no-description">
    <img class="install-icon" src="/assets/images/icons/third-party/rhel.jpg" alt="Red Hat" />
    <div class="install-text">Red Hat</div>
  </a>

  <a href="/mesh/{{page.release}}/installation/amazonlinux" class="docs-grid-install-block no-description">
    <img class="install-icon" src="/assets/images/icons/third-party/amazon-linux.png" alt="AWS" />
    <div class="install-text">Amazon Linux</div>
  </a>

  <a href="/mesh/{{page.release}}/installation/debian" class="docs-grid-install-block no-description">
    <img class="install-icon" src="/assets/images/icons/third-party/debian-logo.jpg" alt="Debian" />
    <div class="install-text">Debian</div>
  </a>

  <a href="/mesh/{{page.release}}/installation/ubuntu" class="docs-grid-install-block no-description">
    <img class="install-icon" src="/assets/images/icons/third-party/ubuntu.png" alt="Ubuntu" />
    <div class="install-text">Ubuntu</div>
  </a>

  <a href="/mesh/{{page.release}}/installation/macos" class="docs-grid-install-block no-description">
    <img class="install-icon" src="/assets/images/icons/third-party/macos-logo.png" alt="MacOS" />
    <div class="install-text">MacOS</div>
  </a>

  <a href="/mesh/{{page.release}}/installation/windows" class="docs-grid-install-block no-description">
    <img class="install-icon" src="/assets/images/icons/third-party/windows-logo.svg" alt="Windows" />
    <div class="install-text">Windows</div>
  </a>

</div>

{% endnavtab %}
{% endnavtabs %}

## Licensing

Your {{site.mesh_product_name}} license includes an expiration date and the number of data plane proxies you can deploy. If you deploy more proxies than your license allows, you receive a warning.

You have a 30-day grace period after the license expires. Make sure to renew your license before the grace period ends.

## Check version

To confirm that you have installed the right version of
{{site.mesh_product_name}}, run the following commands and
make sure the version output starts with the `{{site.mesh_product_name}}`
prefix:

```sh
$ kumactl version
{{site.mesh_product_name}} [VERSION NUMBER]

$ kuma-cp version
{{site.mesh_product_name}} [VERSION NUMBER]

$ kuma-dp version
{{site.mesh_product_name}} [VERSION NUMBER]
```
