---
title: Install Kong Gateway on Ubuntu
---

<!-- Banner with links to latest downloads -->
<!-- The install-link and install-listing-link classes are used for tracking, do not remove -->

{:.install-banner}
> Download the latest {{site.ee_product_name}} {{page.kong_version}} package for Ubuntu:
> * **Kong Gateway**:
> [**Xenial**]({{ site.links.download }}/gateway-2.x-ubuntu-xenial/pool/all/k/kong-enterprise-edition/kong-enterprise-edition_{{page.kong_versions[page.version-index].ee-version}}_all.deb){:.install-link},
> [**Focal**]({{ site.links.download }}/gateway-2.x-ubuntu-focal/pool/all/k/kong-enterprise-edition/kong-enterprise-edition_{{page.kong_versions[page.version-index].ee-version}}_all.deb){:.install-link}, or
> [**Bionic**]({{ site.links.download }}/gateway-2.x-ubuntu-bionic/pool/all/k/kong-enterprise-edition/kong-enterprise-edition_{{page.kong_versions[page.version-index].ee-version}}_all.deb){:.install-link}
> (latest version: {{page.kong_versions[page.version-index].ee-version}})
> * **Kong Gateway (OSS)**:
> [**Xenial**]({{ site.links.download }}/gateway-2.x-ubuntu-xenial/pool/all/k/kong/kong_{{page.kong_versions[page.version-index].ce-version}}_amd64.deb){:.install-link},
> [**Focal**]({{ site.links.download }}/gateway-2.x-ubuntu-focal/pool/all/k/kong/kong_{{page.kong_versions[page.version-index].ce-version}}_amd64.deb){:.install-link}, or
> [**Bionic**]({{ site.links.download }}/gateway-2.x-ubuntu-bionic/pool/all/k/kong/kong_{{page.kong_versions[page.version-index].ce-version}}_amd64.deb){:.install-link}
>(latest version: {{page.kong_versions[page.version-index].ee-version}})
>
> <br>
> <span class="install-subtitle">View the list of all 2.x packages for
> [**Xenial**]({{ site.links.download }}/gateway-2.x-ubuntu-xenial/pool/all/k/kong-enterprise-edition/){:.install-listing-link},
> [**Focal**]({{ site.links.download }}/gateway-2.x-ubuntu-focal/pool/all/k/kong-enterprise-edition/){:.install-listing-link}, or
> [**Bionic**]({{ site.links.download }}/gateway-2.x-ubuntu-bionic/pool/all/k/kong-enterprise-edition/){:.install-listing-link}
>  </span>


The {{site.base_gateway}} software is governed by the
[Kong Software License Agreement](https://konghq.com/kongsoftwarelicense/).
{{site.ce_product_name}} is licensed under an
[Apache 2.0 license](https://github.com/Kong/kong/blob/master/LICENSE).

## Prerequisites

* A supported system with root or [root-equivalent](/gateway/{{page.kong_version}}/plan-and-deploy/kong-user) access.
* (Enterprise only) A `license.json` file from Kong

## Download and install

You can install {{site.base_gateway}} by downloading an installation package or using our APT repository.

{% navtabs %}
{% navtab Package %}

Install {{site.base_gateway}} on Ubuntu from the command line.

1. Download the {{site.ce_product_name}} package:
    ```bash
    curl -Lo kong.{{page.kong_versions[page.version-index].ce-version}}.amd64.deb "{{ site.links.download }}/gateway-2.x-ubuntu-$(lsb_release -cs)/pool/all/k/kong/kong_{{page.kong_versions[page.version-index].ce-version}}_amd64.deb"
     ```

2. Install the package:
    ```bash
    sudo dpkg -i kong.{{site.data.kong_latest.version}}.amd64.deb
    ```

{% endnavtab %}
{% navtab APT repository %}

Install the APT repository from the command line.

1. Download the {{site.ce_product_name}} APT repository:
    ```bash
    echo "deb [trusted=yes] {{ site.links.download }}/gateway-2.x-ubuntu-$(lsb_release -sc)/
    default all" | sudo tee /etc/apt/sources.list.d/kong.list
    ```
2. Update the repository:
    ```bash
    sudo apt-get update
    ```
3. Install {{site.ce_product_name}}:
    ```bash
    apt install -y kong
    ```

{% endnavtab %}
{% endnavtabs %}

{% include_cached /md/gateway/setup.md kong_version=page.kong_version %}
