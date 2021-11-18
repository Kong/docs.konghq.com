---
title: Install Kong Gateway on RHEL
---

<!-- Banner with links to latest downloads -->
<!-- The install-link and install-listing-link classes are used for tracking, do not remove -->

{:.install-banner}
> Download the latest {{page.kong_version}} package for RHEL:
> * **Kong Gateway**:
> [**RHEL 7**]({{ site.links.download }}/gateway-2.x-rhel-7/Packages/k/kong-enterprise-edition-{{page.kong_versions[page.version-index].ee-version}}.rhel7.noarch.rpm){:.install-link} or
> [**RHEL 8**]({{ site.links.download }}/gateway-2.x-rhel-8/Packages/k/kong-enterprise-edition-{{page.kong_versions[page.version-index].ee-version}}.rhel8.noarch.rpm){:.install-link}
> (latest version: {{page.kong_versions[page.version-index].ee-version}})
> * **Kong Gateway (OSS)**:
> [**RHEL 7**]({{ site.links.download }}/gateway-2.x-rhel-7/Packages/k/kong-{{page.kong_versions[page.version-index].ce-version}}.rhel7.amd64.rpm){:.install-link} or
> [**RHEL 8**]({{ site.links.download }}/gateway-2.x-rhel-8/Packages/k/kong-{{page.kong_versions[page.version-index].ce-version}}.rhel8.amd64.rpm){:.install-link}
> (latest version: {{page.kong_versions[page.version-index].ce-version}})
>
> <br>
> <span class="install-subtitle">View the list of all 2.x packages for
> [**RHEL 7**]({{ site.links.download }}/gateway-2.x-rhel-7/Packages/k/){:.install-listing-link} or
> [**RHEL 8**]({{ site.links.download }}/gateway-2.x-rhel-8/Packages/k/){:.install-listing-link}<span>


The {{site.base_gateway}} software is governed by the
[Kong Software License Agreement](https://konghq.com/kongsoftwarelicense/).
{{site.ce_product_name}} is licensed under an
[Apache 2.0 license](https://github.com/Kong/kong/blob/master/LICENSE).

## Prerequisites

* A supported system with root or [root-equivalent](/gateway/{{page.kong_version}}/plan-and-deploy/kong-user) access.
* (Enterprise only) A `license.json` file from Kong

## Download and Install

You can install {{site.base_gateway}} by downloading an installation package or using our yum repository.

{% navtabs %}
{% navtab Package %}

Install {{site.base_gateway}} on Debian from the command line.

1. Download the {{site.ce_product_name}} package:
    ```bash
    curl -Lo kong-{{site.data.kong_latest.version}}.amd64.rpm $( rpm --eval "{{ site.links.download }}/gateway-2.x-rhel-%{rhel_ver}/Packages/k/kong-{{site.data.kong_latest.version}}.el%{rhel_ver}.amd64.rpm")
     ```

2. Install the package:
    ```bash
    sudo yum install kong-{{site.data.kong_latest.version}}.amd64.rpm
    ```

{% endnavtab %}
{% navtab YUM repository %}

Install the YUM repository from the command line.

1. Download the {{site.ce_product_name}} APT repository:
    ```bash
    curl $(rpm --eval "{{ site.links.download }}/gateway-2.x-rhel-%{rhel_ver}/config.repo") | sudo tee /etc/yum.repos.d/kong.repo
    ```
2. Update the repository:
    ```bash
    sudo yum clean
    ```
3. Install {{site.ce_product_name}}:
    ```bash
    sudo yum install -y kong
    ```

{% endnavtab %}
{% endnavtabs %}

{% include_cached /md/gateway/setup.md kong_version=page.kong_version %}
