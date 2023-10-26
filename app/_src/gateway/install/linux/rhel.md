---
title: Install Kong Gateway on RHEL
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
> **Note:** In July of 2023 Kong announced that package hosting was shifting from {{ site.links.download }} to [{{ site.links.cloudsmith }}]({{ site.links.cloudsmith }}). Read more about it in this [blog post](https://konghq.com/blog/product-releases/changes-to-kong-package-hosting)!

{% include /md/gateway/install-linux-os.md kong_version=page.kong_version versions_ce=page.versions.ce versions_ee=page.versions.ee %}

## Advanced installation

### Package install

You can install {{site.base_gateway}} by downloading an installation package or using the yum repository.

{% navtabs %}
{% navtab Package %}

Install {{site.base_gateway}} on RHEL from the command line.

1. Download the Kong package:

{% capture download_package %}
{% navtabs_ee codeblock %}
{% navtab Kong Gateway %}
```bash
curl -Lo kong-enterprise-edition-{{page.versions.ee}}.rpm $(rpm --eval {{ site.links.cloudsmith }}/public/gateway-{{ page.major_minor_version }}/rpm/el/%{rhel}/x86_64/kong-enterprise-edition-{{page.versions.ee}}.el%{rhel}.x86_64.rpm)
```
{% endnavtab %}
{% navtab Kong Gateway (OSS) %}
```bash
curl -Lo kong-{{page.versions.ce}}.rpm $(rpm --eval {{ site.links.cloudsmith }}/public/gateway-{{ page.major_minor_version }}/rpm/el/%{rhel}/x86_64/kong-{{page.versions.ce}}.el%{rhel}.x86_64.rpm)
 ```
{% endnavtab %}
{% endnavtabs_ee %}
{% endcapture %}

{{ download_package | indent | replace: " </code>", "</code>" }}

2. Install the package using `yum` or `rpm`.

    If you use the `rpm` install method, the packages _only_ contain {{site.base_gateway}}. They don't include any dependencies.

{% capture install_package %}
{% navtabs %}
{% navtab yum %}
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
{% endnavtab %}
{% navtab rpm %}

{:.important}
> The `rpm` method is only available for open-source packages. For the `kong-enterprise-edition` package, use `yum`.

```bash
rpm -iv kong-{{page.versions.ce}}.rpm
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}

{{ install_package | indent | replace: " </code>", "</code>" }}

    Installing directly using `rpm` is suitable for Red Hat's [Universal Base Image](https://developers.redhat.com/blog/2020/03/24/red-hat-universal-base-images-for-docker-users) "minimal" variant. You will need to install Kong's dependencies separately via `microdnf`.

{% endnavtab %}
{% navtab YUM repository %}

Install the YUM repository from the command line.

1. Download the Kong YUM repository:
    ```bash
    curl -1sLf "{{ site.links.cloudsmith }}/public/gateway-{{ page.major_minor_version }}/config.rpm.txt?distro=el&codename=$(rpm --eval '%{rhel}')" | sudo tee /etc/yum.repos.d/kong-gateway-{{ page.major_minor_version }}.repo
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
* [Apply Enterprise license](/gateway/{{page.kong_version}}/install/post-install/apply-enterprise-license/) 
* [Enable Kong Manager](/gateway/{{page.kong_version}}/install/post-install/enable-kong-manager/) 

You can also check out {{site.base_gateway}}'s series of
[Getting Started](/gateway/{{include.kong_version}}/get-started/) guides to learn how 
get the most out of {{site.base_gateway}}.
