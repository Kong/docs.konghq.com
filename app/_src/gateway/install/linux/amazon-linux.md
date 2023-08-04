---
title: Install Kong Gateway on Amazon Linux
---

The {{site.base_gateway}} software is governed by the
[Kong Software License Agreement](https://konghq.com/kongsoftwarelicense).
Kong is licensed under an
[Apache 2.0 license](https://github.com/Kong/kong/blob/master/LICENSE).

## Prerequisites

* A [supported system](/gateway/{{page.kong_version}}/support-policy/#supported-versions) with root or [root-equivalent](/gateway/{{page.kong_version}}/production/running-kong/kong-user/) access.
* (Enterprise only) A `license.json` file from Kong.

## Download and Install

You can install {{site.base_gateway}} by downloading an installation package or using the yum repository.

{:.note}
> **Note:** {{site.base_gateway}} supports running on [AWS Graviton processors](https://aws.amazon.com/ec2/graviton/). It can run in all AWS Regions where AWS Graviton is supported.

{% navtabs %}
{% navtab Package (AL2023) %}
Install {{site.base_gateway}} on Amazon Linux 2023 from the command line.

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
sudo yum install kong-enterprise-edition-{{page.versions.ee}}.rpm
```
{% endnavtab %}
{% navtab Kong Gateway (OSS) %}
```bash
sudo yum install kong-{{page.versions.ce}}.rpm
```
{% endnavtab %}
{% endnavtabs_ee %}
{% endcapture %}

{{ install_package | indent | replace: " </code>", "</code>" }}

{% endnavtab %}
{% navtab Package (Amazon Linux 2) %}

Install {{site.base_gateway}} on Amazon Linux 2 from the command line.

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
{% navtab YUM repository (AL2023) %}

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
sudo yum install kong-enterprise-edition-{{page.versions.ee}}
```
{% endnavtab %}
{% navtab Kong Gateway (OSS) %}
```bash
sudo yum install kong-{{page.versions.ce}}
```
{% endnavtab %}
{% endnavtabs_ee %}
{% endcapture %}

{{ install_from_repo | indent | replace: " </code>", "</code>" }}

{% endnavtab %}
{% navtab YUM repository (Amazon Linux 2) %}

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

{% include_cached /md/gateway/setup.md kong_version=page.kong_version %}
