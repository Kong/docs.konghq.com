---
title: Install Kong Gateway on RHEL
---

The {{site.base_gateway}} software is governed by the
[Kong Software License Agreement](https://konghq.com/kongsoftwarelicense/).
Kong is licensed under an
[Apache 2.0 license](https://github.com/Kong/kong/blob/master/LICENSE).

## Prerequisites

* A [supported system](/gateway/{{page.kong_version}}/install-and-run/os-support) with root or [root-equivalent](/gateway/{{page.kong_version}}/plan-and-deploy/kong-user) access.
* (Enterprise only) A `license.json` file from Kong

## Download and Install

You can install {{site.base_gateway}} by downloading an installation package or using our yum repository.

{% navtabs %}
{% navtab Package %}

Install {{site.base_gateway}} on Amazon Linux from the command line.

1. Download the Kong package:

{% capture download_package %}
{% navtabs codeblock %}
{% navtab Kong Gateway %}
```bash
curl -Lo kong-enterprise-edition-{{page.kong_versions[page.version-index].ee-version}}.rpm $( rpm --eval "{{ site.links.download }}/gateway-2.x-rhel-%{rhel}/Packages/k/kong-enterprise-edition-{{page.kong_versions[page.version-index].ee-version}}.rhel%{rhel}.noarch.rpm")
```
{% endnavtab %}
{% navtab Kong Gateway (OSS) %}
```bash
curl -Lo kong-{{page.kong_versions[page.version-index].ce-version}}.rpm $(rpm --eval "{{ site.links.download }}/gateway-2.x-rhel-%{rhel}/Packages/k/kong-{{page.kong_versions[page.version-index].ce-version}}.rhel%{rhel}.amd64.rpm")
 ```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}

{{ download_package | indent | replace: " </code>", "</code>" }}

2. Install the package:

{% capture install_package %}
{% navtabs codeblock %}
{% navtab Kong Gateway %}
```bash
sudo yum install kong-enterprise-edition-{{page.kong_versions[page.version-index].ee-version}}.rpm
```
{% endnavtab %}
{% navtab Kong Gateway (OSS) %}
```bash
sudo yum install kong-{{page.kong_versions[page.version-index].ce-version}}.rpm
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}

{{ install_package | indent | replace: " </code>", "</code>" }}

{% endnavtab %}
{% navtab YUM repository %}

Install the YUM repository from the command line.

1. Download the Kong APT repository:
    ```bash
    curl $(rpm --eval "{{ site.links.download }}/gateway-2.x-rhel-%{rhel}/config.repo") | sudo tee /etc/yum.repos.d/kong.repo
    ```

2. Install Kong:
{% capture install_from_repo %}
{% navtabs codeblock %}
{% navtab Kong Gateway %}
```bash
sudo yum install kong-enterprise-edition-{{page.kong_versions[page.version-index].ee-version}}
```
{% endnavtab %}
{% navtab Kong Gateway (OSS) %}
```bash
sudo yum install kong-{{page.kong_versions[page.version-index].ce-version}}
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}

{{ install_from_repo | indent | replace: " </code>", "</code>" }}

{% endnavtab %}
{% endnavtabs %}

{% include_cached /md/gateway/setup.md kong_version=page.kong_version %}
