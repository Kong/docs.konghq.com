---
title: Install Kong Gateway on Amazon Linux
---

<!-- Banner with links to latest downloads -->
<!-- The install-link and install-listing-link classes are used for tracking, do not remove -->

{:.install-banner}
> Download the latest {{page.kong_version}} packages for
> Amazon Linux:
> * **Kong Gateway**: [**Amazon Linux 2**]({{site.links.download }}/gateway-2.x-amazonlinux-2/Packages/k/kong-enterprise-edition-{{page.kong_versions[page.version-index].ee-version}}.amzn2.noarch.rpm){:.install-link} (version {{page.kong_versions[page.version-index].ee-version}})
> * **Kong Gateway (OSS)**: [**Amazon Linux 2**]({{ site.links.download }}/gateway-2.x-amazonlinux-2/Packages/k/kong-{{page.kong_versions[page.version-index].ce-version}}.aws.amd64.rpm){:.install-link} (version {{page.kong_versions[page.version-index].ce-version}})
> <br><br>
>
> <span class="install-subtitle">View the list of all 2.x packages for
> [Amazon Linux 2]({{ site.links.download }}/gateway-2.x-amazonlinux-2/Packages/k/){:.install-listing-link}  </span>

The {{site.base_gateway}} software is governed by the
[Kong Software License Agreement](https://konghq.com/kongsoftwarelicense/).
Kong is licensed under an
[Apache 2.0 license](https://github.com/Kong/kong/blob/master/LICENSE).

## Prerequisites

* A supported system with root or [root-equivalent](/gateway/{{page.kong_version}}/plan-and-deploy/kong-user) access.
* (Enterprise only) A `license.json` file from Kong.

## Download and Install

You can install {{site.base_gateway}} by downloading an installation package or using our yum repository.

{% navtabs %}
{% navtab Package %}

Install {{site.base_gateway}} on Debian from the command line.

1. Download the Kong package:

{% capture download_package %}
{% navtabs codeblock %}
{% navtab Kong Gateway %}
```bash
curl -Lo kong-enterprise-edition-{{page.kong_versions[page.version-index].ee-version}}.amzn2.noarch.rpm "{{ site.links.download }}/gateway-2.x-amazonlinux-2/Packages/k/kong-enterprise-edition-{{page.kong_versions[page.version-index].ee-version}}.amzn2.noarch.rpm"
```
{% endnavtab %}
{% navtab Kong Gateway (OSS) %}
```bash
curl -Lo kong-{{page.kong_versions[page.version-index].ce-version}}.aws.amd64.rpm "{{ site.links.download }}/gateway-2.x-amazonlinux-2/Packages/k/kong-{{page.kong_versions[page.version-index].ce-version}}.aws.amd64.rpm"
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
sudo yum install kong-enterprise-edition-{{page.kong_versions[page.version-index].ee-version}}.amzn2.noarch.rpm
```
{% endnavtab %}
{% navtab Kong Gateway (OSS) %}
```bash
sudo yum install kong-{{page.kong_versions[page.version-index].ce-version}}.aws.amd64.rpm
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
    curl https://download.konghq.com/gateway-2.x-amazonlinux-2/config.repo | sudo tee /etc/yum.repos.d/kong.repo
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
