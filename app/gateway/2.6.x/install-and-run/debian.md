---
title: Install Kong Gateway on Debian
badge: oss
---
{:.install-banner}
> Download the latest {{site.ce_product_name}} {{page.kong_version}} package for Debian:
> * [8 Jessie]({{ site.links.download }}/gateway-2.x-debian-jessie/pool/all/k/kong/kong_{{page.kong_versions[page.version-index].ce-version}}_amd64.deb){:.install-link}
> * [9 Stretch]({{ site.links.download }}/gateway-2.x-debian-stretch/pool/all/k/kong/kong_{{page.kong_versions[page.version-index].ce-version}}_amd64.deb){:.install-link}
> * [10 Buster]({{ site.links.download }}/gateway-2.x-debian-buster/pool/all/k/kong/kong_{{page.kong_versions[page.version-index].ce-version}}_amd64.deb){:.install-link}
> * [11 Bullseye]({{ site.links.download }}/gateway-2.x-debian-bullseye/pool/all/k/kong/kong_{{page.kong_versions[page.version-index].ce-version}}_amd64.deb){:.install-link}
>
> (latest version: {{page.kong_versions[page.version-index].ce-version}})
>
> <br>
> <span class="install-subtitle">View the list of all 2.x packages for
> [8 Jessie]({{ site.links.download }}/gateway-2.x-debian-jessie/pool/all/k/){:.install-listing-link},
> [9 Stretch]({{ site.links.download }}/gateway-2.x-debian-stretch/pool/all/k/){:.install-listing-link},
> [10 Buster]({{ site.links.download }}/gateway-2.x-debian-buster/pool/all/k/){:.install-listing-link}, or
> [11 Bullseye]({{ site.links.download }}/gateway-2.x-debian-bullseye/pool/all/k/){:.install-listing-link}
>  </span>

## Prerequisites

You have a supported system with root or [root-equivalent](/gateway/{{page.kong_version}}/plan-and-deploy/kong-user) access.

## Download and install

You can install {{site.base_gateway}} by downloading an installation package or using our APT repository.

{% navtabs %}
{% navtab Package %}

Install {{site.base_gateway}} on Debian from the command line.

1. Download the {{site.ce_product_name}} package:
    ```bash
    curl -Lo kong.{{page.kong_versions[page.version-index].ce-version}}.amd64.deb "{{ site.links.download }}/gateway-2.x-debian-$(lsb_release -cs)/pool/all/k/kong/kong_{{page.kong_versions[page.version-index].ce-version}}_amd64.deb"
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
    echo "deb [trusted=yes] {{ site.links.download }}/gateway-2.x-debian-$(lsb_release -sc)/
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

{% include /md/installation.md %}
