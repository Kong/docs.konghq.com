---
title: Install Kong Gateway on Debian
---

The {{site.base_gateway}} software is governed by the
[Kong Software License Agreement](https://konghq.com/kongsoftwarelicense).
{{site.ce_product_name}} is licensed under an
[Apache 2.0 license](https://github.com/Kong/kong/blob/master/LICENSE).

{% include_cached /md/gateway/install-traditional-mode.md %}

## Prerequisites

* A [supported system](/gateway/{{page.release}}/support-policy/#supported-versions) with root or [root-equivalent](/gateway/{{page.release}}/production/running-kong/kong-user/) access.
* The following tools are installed:
  * [`curl`](https://curl.se/)
  * [`lsb-release`](https://packages.debian.org/lsb-release)
  * [`apt-transport-https`](https://packages.debian.org/apt-transport-https) (Only if installing the APT repository)
* (Enterprise only) A `license.json` file from Kong.

{% if_version gte:3.2.x %}
{:.note}
> **Notes:**
* {{site.base_gateway}} supports running on [AWS Graviton processors](https://aws.amazon.com/ec2/graviton/). It can run in all AWS Regions where AWS Graviton is supported.
* In July of 2023, Kong announced that package hosting was shifting from download.konghq.com to [{{ site.links.download }}]({{ site.links.download }}). Read more about it in this [blog post](https://konghq.com/blog/product-releases/changes-to-kong-package-hosting)!
{% endif_version %}

{% if_version lte:3.2.x %}
{:.note}
> **Note:** In July of 2023, Kong announced that package hosting was shifting from download.konghq.com to [{{ site.links.download }}]({{ site.links.download }}). Read more about it in this [blog post](https://konghq.com/blog/product-releases/changes-to-kong-package-hosting)!
{% endif_version %}

## Package install

You can install {{site.base_gateway}} by downloading an installation package or using the APT repository.

The following steps install the package **only**, without a data store. 
You will need to set one up after installation.

{% navtabs %}
{% navtab Package %}

Install {{site.base_gateway}} on Debian from the command line.

1. Download the Kong package:

{% capture download_package %}
{% navtabs_ee codeblock %}
{% navtab Kong Gateway %}
```bash
curl -Lo kong-enterprise-edition-{{page.versions.ee}}.deb "{{ site.links.direct }}/gateway-{{ page.major_minor_version }}/deb/debian/pool/bullseye/main/k/ko/kong-enterprise-edition_{{page.versions.ee}}/kong-enterprise-edition_{{page.versions.ee}}_$(dpkg --print-architecture).deb"
```
{% endnavtab %}
{% navtab Kong Gateway (OSS) %}
```bash
curl -Lo kong-{{page.versions.ce}}.deb "{{ site.links.direct }}/gateway-{{ page.major_minor_version }}/deb/debian/pool/bullseye/main/k/ko/kong_{{page.versions.ce}}/kong_{{page.versions.ce}}_$(dpkg --print-architecture).deb"
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
sudo apt install -y ./kong-enterprise-edition-{{page.versions.ee}}.deb
```
{% endnavtab %}
{% navtab Kong Gateway (OSS) %}
```bash
sudo apt install -y ./kong-{{page.versions.ce}}.deb
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
    curl -1sLf "{{ site.links.direct }}/gateway-{{ page.major_minor_version }}/gpg.{{ gpg_key }}.key" |  gpg --dearmor | sudo tee /usr/share/keyrings/kong-gateway-{{ page.major_minor_version }}-archive-keyring.gpg > /dev/null
    curl -1sLf "{{ site.links.direct }}/gateway-{{ page.major_minor_version }}/config.deb.txt?distro=debian&codename=$(lsb_release -sc)" | sudo tee /etc/apt/sources.list.d/kong-gateway-{{ page.major_minor_version }}.list > /dev/null
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

### Next steps

Before starting {{site.base_gateway}}, [set up a data store](/gateway/{{page.release}}/install/post-install/set-up-data-store/) 
and update the `kong.conf.default` configuration property file with a reference to your data store.

Depending on your desired environment, also see the following guides:
* Optional: [Add your Enterprise license](/gateway/{{ page.release }}/licenses/deploy/)
{% if_version gte:3.4.x -%}
* Enable Kong Manager:
  * [Kong Manager Enterprise](/gateway/{{ page.release }}/kong-manager/enable/)
  * [Kong Manager OSS](/gateway/{{ page.release }}/kong-manager-oss/)
{% endif_version -%}
{% if_version lte:3.3.x -%}
* [Enable Kong Manager](/gateway/{{ page.release }}/kong-manager/enable/)
{% endif_version %}

You can also check out {{site.base_gateway}}'s series of
[Getting Started](/gateway/{{ page.release }}/get-started/) guides to learn how 
get the most out of {{site.base_gateway}}.

## Uninstall package

Stop {{site.base_gateway}}:
```
kong stop
```

{% navtabs_ee %}
{% navtab Kong Gateway %}
To uninstall the package, run: 
```
sudo apt remove kong-enterprise-edition
```
{% endnavtab %}
{% navtab Kong Gateway (OSS) %}
To uninstall the package, run: 
```
sudo apt remove kong
```
{% endnavtab %}
{% endnavtabs_ee %}
