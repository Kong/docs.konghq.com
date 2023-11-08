---
title: Install Kong Gateway on Amazon Linux
---

The {{site.base_gateway}} software is governed by the
[Kong Software License Agreement](https://konghq.com/kongsoftwarelicense).
Kong is licensed under an
[Apache 2.0 license](https://github.com/Kong/kong/blob/master/LICENSE).

{:.note}
> This page guides you through installing {{ site.base_gateway }} in traditional mode, where it acts as both the control plane and data plane. Running in this mode may have a small performance impact.
> <br><br>
> We recommend using [{{site.konnect_short_name}}](https://konghq.com/products/kong-konnect/register?utm_medium=referral&utm_source=docs&utm_campaign=install-ubuntu) as your control plane to allow your data plane to run at maximum performance and decrease your deployment complexity.

## Prerequisites

* A [supported system](/gateway/{{page.kong_version}}/support-policy/#supported-versions) with root or [root-equivalent](/gateway/{{page.kong_version}}/production/running-kong/kong-user/) access.
* (Enterprise only) A `license.json` file from Kong.

Once you have everything you need, choose an installation path: 
  * [Quickstart](#installation): Install script for a {{site.base_gateway}} package and PostgreSQL database
  * [Advanced installation](#advanced-installation): Choose your own pieces to install

{% if_version gte:3.2.x %}
{:.note}
> **Notes:** 
* {{site.base_gateway}} supports running on [AWS Graviton processors](https://aws.amazon.com/ec2/graviton/). It can run in all AWS Regions where AWS Graviton is supported.
* In July of 2023, Kong announced that package hosting was shifting from {{ site.links.download }} to [{{ site.links.cloudsmith }}]({{ site.links.cloudsmith }}). Read more about it in this [blog post](https://konghq.com/blog/product-releases/changes-to-kong-package-hosting)!
{% endif_version %}

{% if_version lte:3.2.x %}
{:.note}
> **Note:** In July of 2023, Kong announced that package hosting was shifting from {{ site.links.download }} to [{{ site.links.cloudsmith }}]({{ site.links.cloudsmith }}). Read more about it in this [blog post](https://konghq.com/blog/product-releases/changes-to-kong-package-hosting)!
{% endif_version %}

## Installation

{% include /md/gateway/install-linux-os.md kong_version=page.kong_version versions_ce=page.versions.ce versions_ee=page.versions.ee %}

## Advanced installation

### Package install

You can install {{site.base_gateway}} by downloading an installation package or using the yum repository.

The following steps install the package **only**, without a data store. 
You will need to set one up after installation.

{% navtabs %}
{% navtab Package %}
Install {{site.base_gateway}} on Amazon Linux from the command line.

1. Download the Kong package:

{% capture download_package %}
{% navtabs_ee codeblock %}
{% navtab Kong Gateway %}
```bash
curl -Lo kong-enterprise-edition-{{page.versions.ee}}.rpm $(rpm --eval {{ site.links.cloudsmith }}/public/gateway-{{ page.major_minor_version }}/rpm/amzn/%{amzn}/x86_64/kong-enterprise-edition-{{page.versions.ee}}.aws.x86_64.rpm)
```
{% endnavtab %}
{% navtab Kong Gateway (OSS) %}
```bash
curl -Lo kong-{{page.versions.ce}}.rpm $(rpm --eval {{ site.links.cloudsmith }}/public/gateway-{{ page.major_minor_version }}/rpm/amzn/%{amzn}/x86_64/kong-{{page.versions.ce}}.aws.x86_64.rpm)
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
sudo yum install -y kong-enterprise-edition-{{page.versions.ee}}.rpm
```
{% endnavtab %}
{% navtab Kong Gateway (OSS) %}
```bash
sudo yum install -y kong-{{page.versions.ce}}.rpm
```
{% endnavtab %}
{% endnavtabs_ee %}
{% endcapture %}

{{ install_package | indent | replace: " </code>", "</code>" }}

{% endnavtab %}
{% navtab YUM repository %}

Install the YUM repository from the command line.

1. Download the Kong YUM repository:

    ```bash
    curl -1sLf "{{ site.links.cloudsmith }}/public/gateway-{{ page.major_minor_version }}/config.rpm.txt?distro=amzn&codename=$(rpm --eval '%{amzn}')" | sudo tee /etc/yum.repos.d/kong-gateway-{{ page.major_minor_version }}.repo > /dev/null
    sudo yum -q makecache -y --disablerepo='*' --enablerepo='kong-gateway-{{ page.major_minor_version }}'
    ```

2. Install Kong:

{% capture install_from_repo %}
{% navtabs_ee codeblock %}
{% navtab Kong Gateway %}
```bash
sudo yum install -y kong-enterprise-edition-{{page.versions.ee}}
```
{% endnavtab %}
{% navtab Kong Gateway (OSS) %}
```bash
sudo yum install -y kong-{{page.versions.ce}}
```
{% endnavtab %}
{% endnavtabs_ee %}
{% endcapture %}

{{ install_from_repo | indent | replace: " </code>", "</code>" }}

{% endnavtab %}
{% endnavtabs %}

### Next steps

Before starting {{site.base_gateway}}, [set up a data store](/gateway/{{page.kong_version}}/install/post-install/set-up-data-store/) 
and update the `kong.conf.default` configuration property file with a reference to your data store.

Depending on your desired environment, also see the following guides:
* Optional: [Add your Enterprise license](/gateway/{{ page.kong_version }}/licenses/deploy/)
{%- if_version gte:3.4.x -%}
* Enable Kong Manager:
  * [Kong Manager Enterprise](/gateway/{{ page.kong_version }}/kong-manager/enable/)
  * [Kong Manager OSS](/gateway/{{ page.kong_version }}/kong-manager-oss/)
{%- endif_version -%}
{%- if_version lte:3.3.x -%}
* [Enable Kong Manager](/gateway/{{ page.kong_version }}/kong-manager/enable/)
{% endif_version %}

You can also check out {{site.base_gateway}}'s series of
[Getting Started](/gateway/{{ page.kong_version }}/get-started/) guides to learn how 
get the most out of {{site.base_gateway}}.

## Uninstall package

{% navtabs_ee %}
{% navtab Kong Gateway %}
To uninstall the package, run: 
```
sudo yum remove kong-enterprise-edition
```
{% endnavtab %}
{% navtab Kong Gateway (OSS) %}
To uninstall the package, run: 
```
sudo yum remove kong
```
{% endnavtab %}
{% endnavtabs_ee %}