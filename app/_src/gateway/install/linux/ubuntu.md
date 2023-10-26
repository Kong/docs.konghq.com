---
title: Install Kong Gateway on Ubuntu
---

The {{site.base_gateway}} software is governed by the
[Kong Software License Agreement](https://konghq.com/kongsoftwarelicense).
Kong is licensed under an
[Apache 2.0 license](https://github.com/Kong/kong/blob/master/LICENSE).

{:.note}
> This page will install {{ site.base_gateway }} in traditional mode, where it acts as both the control plane and data plane. Running in this mode may have a small performance impact.
> &nbsp;
> 
> &nbsp;
> 
> We recommend using [{{site.konnect_short_name}}](https://konghq.com/products/kong-konnect/register?utm_medium=referral&utm_source=docs&utm_campaign=install-ubuntu) as your control plane to allow your data plane to run at maximum performance and decrease your deployment complexity.

## Prerequisites

* A [supported system](/gateway/{{page.kong_version}}/support-policy/#supported-versions) with root or [root-equivalent](/gateway/{{page.kong_version}}/production/running-kong/kong-user/) access.
* (Enterprise only) A `license.json` file from Kong

## Installation

{:.note}
> **Notes:**
* {{site.base_gateway}} supports running on [AWS Graviton processors](https://aws.amazon.com/ec2/graviton/). It can run in all AWS Regions where AWS Graviton is supported.
* In July of 2023 Kong announced that package hosting was shifting from {{ site.links.download }} to [{{ site.links.cloudsmith }}]({{ site.links.cloudsmith }}). Read more about it in this [blog post](https://konghq.com/blog/product-releases/changes-to-kong-package-hosting)!

{% include /md/gateway/install-linux-os.md kong_version=page.kong_version versions_ce=page.versions.ce versions_ee=page.versions.ee %}

## Advanced installation

### Package install

You can install {{site.base_gateway}} by downloading an installation package or using the APT repository.

{% if_version gte:3.4.x %}
We currently package {{ site.base_gateway }} for Ubuntu Focal and Jammy. If you are using a different release, replace `jammy` with `$(lsb_release -sc)` or the release name in the commands below. To check your release name, run `lsb_release -sc`.
{% endif_version %}
{% if_version lte:3.3.x %}
We currently package {{ site.base_gateway }} for Ubuntu Bionic, Focal, and Jammy. If you are using a different release, replace `jammy` with `$(lsb_release -sc)` or the release name in the commands below. To check your release name, run `lsb_release -sc`.
{% endif_version %}

{:.note .no-icon}
> {{site.base_gateway}} supports running on [AWS Graviton processors](https://aws.amazon.com/ec2/graviton/). It can run in all AWS Regions where AWS Graviton is supported.

{% navtabs %}
{% navtab Package %}

Install {{site.base_gateway}} on Ubuntu from the command line.

1. Download the Kong package:

{% assign ubuntu_flavor = "jammy" %}
{% if page.release == "3.0.x" %}
{% assign ubuntu_flavor = "bionic" %}
{% endif %}

{% capture download_package %}
{% navtabs_ee codeblock %}
{% navtab Kong Gateway %}
```bash
curl -Lo kong-enterprise-edition-{{page.versions.ee}}.amd64.deb "{{ site.links.cloudsmith }}/public/gateway-{{ page.major_minor_version }}/deb/ubuntu/pool/{{ ubuntu_flavor }}/main/k/ko/kong-enterprise-edition_{{page.versions.ee}}/kong-enterprise-edition_{{page.versions.ee}}_amd64.deb"
```
{% endnavtab %}
{% navtab Kong Gateway (OSS) %}
```bash
curl -Lo kong-{{page.versions.ce}}.amd64.deb "{{ site.links.cloudsmith }}/public/gateway-{{ page.major_minor_version }}/deb/ubuntu/pool/{{ ubuntu_flavor }}/main/k/ko/kong_{{page.versions.ce}}/kong_{{page.versions.ce}}_amd64.deb"
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

{% navtabs_ee %}
{% navtab Kong Gateway %}
{:.note .no-icon}
> To uninstall the package, run: `sudo apt remove kong-enterprise-edition`.
{% endnavtab %}
{% navtab Kong Gateway (OSS) %}
{:.note .no-icon}
> To uninstall the package, run: `sudo apt remove kong`.
{% endnavtab %}
{% endnavtabs_ee %}

{% endnavtab %}
{% navtab APT repository %}

Install the APT repository from the command line.

{% assign gpg_key = site.data.installation.gateway[page.major_minor_version].gpg_key  %}
{% unless gpg_key %}
{% assign gpg_key = site.data.installation.gateway.legacy.gpg_key  %}
{% endunless %}

1. Setup the Kong APT repository:
    ```bash
    curl -1sLf "{{ site.links.cloudsmith }}/public/gateway-{{ page.major_minor_version }}/gpg.{{ gpg_key }}.key" |  gpg --dearmor | sudo tee /usr/share/keyrings/kong-gateway-{{ page.major_minor_version }}-archive-keyring.gpg > /dev/null
    curl -1sLf "{{ site.links.cloudsmith }}/public/gateway-{{ page.major_minor_version }}/config.deb.txt?distro=ubuntu&codename=focal" | sudo tee /etc/apt/sources.list.d/kong-gateway-{{ page.major_minor_version }}.list > /dev/null
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
sudo apt-get install -y kong-enterprise-edition={{page.versions.ee}}
```
{% endnavtab %}
{% navtab Kong Gateway (OSS) %}
```bash
sudo apt-get install -y kong={{page.versions.ce}}
```
{% endnavtab %}
{% endnavtabs_ee %}
{% endcapture %}

{{ install_from_repo | indent | replace: " </code>", "</code>" }}

4. Optional: Prevent accidental upgrades by marking the package as `hold`:
{% capture optional %}
{% navtabs_ee %}
{% navtab Kong Gateway %}
```bash
sudo apt-mark hold kong-enterprise-edition
```
{% endnavtab %}
{% navtab Kong Gateway (OSS) %}
```bash
sudo apt-mark hold kong
```
{% endnavtab %}
{% endnavtabs_ee %}
{% endcapture %}
{{ optional | indent | replace: " </code>", "</code>" }}

{% endnavtab %}
{% endnavtabs %}

### Next steps

Before starting {{site.base_gateway}}, [set up a data store](/gateway/{{page.kong_version}}/install/post-install/set-up-data-store/) 
and update the `kong.conf.default` configuration property file with a reference to your data store.

Depending on your desired environment, also see the following guides:
* Optional: [Add your Enterprise license](/gateway/{{ include.kong_version }}/licenses/deploy)
* Enable Kong Manager:
  * [Kong Manager Enterprise](/gateway/{{ include.kong_version }}/kong-manager/enable/)
  * [Kong Manager OSS](/gateway/{{ include.kong_version }}/kong-manager-oss/)
* [Enable Dev Portal](/gateway/{{ include.kong_version }}/kong-enterprise/dev-portal/enable/)

You can also check out {{site.base_gateway}}'s series of
[Getting Started](/gateway/{{include.kong_version}}/get-started/) guides to learn how 
get the most out of {{site.base_gateway}}.
