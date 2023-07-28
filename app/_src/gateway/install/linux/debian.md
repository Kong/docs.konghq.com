---
title: Install Kong Gateway on Debian
---

The {{site.base_gateway}} software is governed by the
[Kong Software License Agreement](https://konghq.com/kongsoftwarelicense).
{{site.ce_product_name}} is licensed under an
[Apache 2.0 license](https://github.com/Kong/kong/blob/master/LICENSE).

## Prerequisites

* A [supported system](/gateway/{{page.kong_version}}/support-policy/#supported-versions) with root or [root-equivalent](/gateway/{{page.kong_version}}/production/running-kong/kong-user/) access.
* The following tools are installed:
  * [`curl`](https://curl.se/)
  * [`lsb-release`](https://packages.debian.org/lsb-release)
  * [`apt-transport-https`](https://packages.debian.org/apt-transport-https) (Only if installing the APT repository)
* (Enterprise only) A `license.json` file from Kong.

## Download and install

You can install {{site.base_gateway}} by downloading an installation package or using our APT repository.

{% navtabs %}
{% navtab Package %}

Install {{site.base_gateway}} on Debian from the command line.

1. Download the Kong package:

{% capture download_package %}
{% navtabs_ee codeblock %}
{% navtab Kong Gateway %}
```bash
curl -Lo kong-enterprise-edition-{{page.versions.ee}}.amd64.deb "{{ site.links.cloudsmith }}/public/gateway-{{ page.major_minor_version }}/deb/debian/pool/bullseye/main/k/ko/kong-enterprise-edition_{{page.versions.ee}}/kong-enterprise-edition_{{page.versions.ee}}_amd64.deb"
```
{% endnavtab %}
{% navtab Kong Gateway (OSS) %}
```bash
curl -Lo kong-{{page.versions.ce}}.amd64.deb "{{ site.links.cloudsmith }}/public/gateway-{{ page.major_minor_version }}/deb/ubuntu/pool/bionic/main/k/ko/kong_{{page.versions.ce}}/kong_{{page.versions.ce}}_amd64.deb"

```
{% endnavtab %}
{% endnavtabs_ee %}
{% endcapture %}

{{ download_package | indent | replace: " </code>", "</code>" }}

2. Install the package:

{% capture install_package %}
{% navtabs_ee codeblock %}
{% navtab Kong Gateway %}
```bash
sudo apt install -y ./kong-enterprise-edition-{{page.versions.ee}}.amd64.deb
```
{% endnavtab %}
{% navtab Kong Gateway (OSS) %}
```bash
sudo apt install -y ./kong-{{page.versions.ce}}.amd64.deb
```
{% endnavtab %}
{% endnavtabs_ee %}
{% endcapture %}

{{ install_package | indent | replace: " </code>", "</code>" }}


{% endnavtab %}
{% navtab APT repository %}

Install the APT repository from the command line.
 
{% assign gpg_key = site.data.installation.gateway[page.major_minor_version].gpg_key  %}
{% unless gpg_key %}
{% assign gpg_key = site.data.installation.gateway.legacy.gpg_key  %}
{% endunless %}

1. Download the Kong APT repository:
    ```bash
    curl -1sLf "{{ site.links.cloudsmith }}/public/gateway-{{ page.major_minor_version }}/gpg.{{ gpg_key }}.key" |  gpg --dearmor | sudo tee /usr/share/keyrings/kong-gateway-{{ page.major_minor_version }}-archive-keyring.gpg > /dev/null
    curl -1sLf "{{ site.links.cloudsmith }}/public/gateway-{{ page.major_minor_version }}/config.deb.txt?distro=debian&codename=$(lsb_release -sc)" | sudo tee /etc/apt/sources.list.d/kong-gateway-{{ page.major_minor_version }}.list > /dev/null
    ```
2. Update the repository:
    ```bash
    sudo apt-get update
    ```
3. Install Kong:

{% capture install_from_repo %}
{% navtabs_ee codeblock %}
{% navtab Kong Gateway %}
```bash
sudo apt install -y kong-enterprise-edition={{page.versions.ee}}
```
{% endnavtab %}
{% navtab Kong Gateway (OSS) %}
```bash
sudo apt install -y kong={{page.versions.ce}}
```
{% endnavtab %}
{% endnavtabs_ee %}
{% endcapture %}

{{ install_from_repo | indent | replace: " </code>", "</code>" }}

{% endnavtab %}
{% endnavtabs %}

{% include_cached /md/gateway/setup.md kong_version=page.kong_version %}
