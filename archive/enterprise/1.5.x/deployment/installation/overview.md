---
title: Install Kong Enterprise
toc: false
disable_image_expand: true
---
{% navtabs %}
{% navtab Containerized %}
<div class="docs-grid-install">

  <a href="/enterprise/{{page.kong_version}}/deployment/installation/docker" class="docs-grid-install-block">
    <img class="install-icon" src="https://doc-assets.konghq.com/install-logos/docker.png" alt="docker" />
    <div class="install-text">Docker</div>
    <div class="install-description">Install Kong Enterprise on Docker</div>
  </a>

  <a href="/enterprise/{{page.kong_version}}/kong-for-kubernetes/install" class="docs-grid-install-block">
    <img class="install-icon" src="/assets/images/icons/documentation/k8s-and-openshift.png" alt="kubernetes" />
    <div class="install-text">K4K8s Enterprise
    <br/>(Kong Ingress Controller)</div>
    <div class="install-description">(kubectl or OpenShift oc)
    <br/><br/>Install the Kong Ingress Controller with the Kong Gateway (Enterprise), without any Enterprise plugins or add-ons</div>
  </a>

  <a href="/enterprise/{{page.kong_version}}/kong-for-kubernetes/install-on-kubernetes" class="docs-grid-install-block">
    <img class="install-icon" src="/assets/images/icons/documentation/k8s-and-openshift.png" alt="kubernetes" />
    <div class="install-text">Full Kong Enterprise on Kubernetes</div>
    <div class="install-description">(kubectl or OpenShift oc)
    <br/><br/>Install Kong Enterprise on Kubernetes with Enterprise plugins and add-ons, optionally with the Kong Ingress Controller</div>
  </a>

</div>

{% endnavtab %}
{% navtab Operating Systems %}
<div class="docs-grid-install">
  <a href="/enterprise/{{page.kong_version}}/deployment/installation/centos" class="docs-grid-install-block no-description">
    <img class="install-icon" src="https://doc-assets.konghq.com/install-logos/centos.gif" alt="centos" />
    <div class="install-text">CentOS</div>
  </a>

  <a href="/enterprise/{{page.kong_version}}/deployment/installation/amazon-linux" class="docs-grid-install-block no-description">
    <img class="install-icon" src="https://doc-assets.konghq.com/install-logos/amazon-linux.png" alt="aws" />
    <div class="install-text">Amazon Linux 1</div>
  </a>

  <a href="/enterprise/{{page.kong_version}}/deployment/installation/amazon-linux-2" class="docs-grid-install-block no-description">
    <img class="install-icon" src="https://doc-assets.konghq.com/install-logos/amazon-linux.png" alt="aws" />
    <div class="install-text">Amazon Linux 2</div>
  </a>

  <a href="/enterprise/{{page.kong_version}}/deployment/installation/ubuntu" class="docs-grid-install-block no-description">
    <img class="install-icon" src="https://doc-assets.konghq.com/install-logos/ubuntu.png" alt="aws" />
    <div class="install-text">Ubuntu</div>
  </a>

  <a href="/enterprise/{{page.kong_version}}/deployment/installation/rhel" class="docs-grid-install-block no-description">
    <img class="install-icon" src="https://www.redhat.com/cms/managed-files/styles/wysiwyg_full_width/s3/Logo-RedHat-Hat-Color-CMYK%20%281%29.jpg?itok=Mf0Ff9jq" alt="redhat" />
    <div class="install-text">RHEL</div>
  </a>

</div>

{% endnavtab %}
{% endnavtabs %}
