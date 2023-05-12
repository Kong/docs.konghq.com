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

You can install {{site.base_gateway}} by downloading an installation package or using our yum repository.

{% navtabs %}
{% navtab Package (AL2023) %}
Install {{site.base_gateway}} on Amazon Linux 2023 from the command line.

1. Download the Kong package:

{% capture download_package %}
{% navtabs_ee codeblock %}
{% navtab Kong Gateway %}
```bash
curl -Lo kong-enterprise-edition-{{page.versions.ee}}.aws.amd64.rpm "{{ site.links.download }}/gateway-3.x-amazonlinux-2023/Packages/k/kong-enterprise-edition-{{page.versions.ee}}.aws.amd64.rpm"
```
{% endnavtab %}
{% navtab Kong Gateway (OSS) %}
```bash
curl -Lo kong-{{page.versions.ce}}.aws.amd64.rpm "{{ site.links.download }}/gateway-3.x-amazonlinux-2023/Packages/k/kong-{{page.versions.ce}}.aws.amd64.rpm"
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
sudo yum install kong-enterprise-edition-{{page.versions.ee}}.aws.amd64.rpm
```
{% endnavtab %}
{% navtab Kong Gateway (OSS) %}
```bash
sudo yum install kong-{{page.versions.ce}}.aws.amd64.rpm
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
curl -Lo kong-enterprise-edition-{{page.versions.ee}}.aws.amd64.rpm "{{ site.links.download }}/gateway-3.x-amazonlinux-2/Packages/k/kong-enterprise-edition-{{page.versions.ee}}.aws.amd64.rpm"
```
{% endnavtab %}
{% navtab Kong Gateway (OSS) %}
```bash
curl -Lo kong-{{page.versions.ce}}.aws.amd64.rpm "{{ site.links.download }}/gateway-3.x-amazonlinux-2/Packages/k/kong-{{page.versions.ce}}.aws.amd64.rpm"
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
sudo yum install kong-enterprise-edition-{{page.versions.ee}}.aws.amd64.rpm
```
{% endnavtab %}
{% navtab Kong Gateway (OSS) %}
```bash
sudo yum install kong-{{page.versions.ce}}.aws.amd64.rpm
```
{% endnavtab %}
{% endnavtabs_ee %}
{% endcapture %}

{{ install_package | indent | replace: " </code>", "</code>" }}

{% endnavtab %}
{% navtab YUM repository (AL2023) %}

Install the YUM repository from the command line.

1. Download the Kong APT repository:
    ```bash
    curl https://download.konghq.com/gateway-3.x-amazonlinux-2023/config.repo | sudo tee /etc/yum.repos.d/kong.repo
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

1. Download the Kong APT repository:
    ```bash
    curl https://download.konghq.com/gateway-3.x-amazonlinux-2/config.repo | sudo tee /etc/yum.repos.d/kong.repo
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
{% endnavtabs %}

{% include_cached /md/gateway/setup.md kong_version=page.kong_version %}
