---
title: Install Kong Gateway on RHEL
---

The {{site.base_gateway}} software is governed by the
[Kong Software License Agreement](https://konghq.com/kongsoftwarelicense).
Kong is licensed under an
[Apache 2.0 license](https://github.com/Kong/kong/blob/master/LICENSE).

## Prerequisites

* A supported system with root or [root-equivalent](/gateway/{{page.release}}/plan-and-deploy/kong-user/) access.
* (Enterprise only) A `license.json` file from Kong

## Download and Install

You can install {{site.base_gateway}} by downloading an installation package or using our yum repository.

{% navtabs %}
{% navtab Package %}

Install {{site.base_gateway}} on RHEL from the command line.

1. Download the Kong package:

{% capture download_package %}
{% navtabs_ee codeblock %}
{% navtab Kong Gateway %}
```bash
curl -Lo kong-enterprise-edition-{{page.versions.ee}}.rpm $(rpm --eval {{ site.links.cloudsmith }}/public/gateway-{{ page.major_minor_version }}/rpm/el/%{rhel}/x86_64/kong-enterprise-edition-{{page.versions.ee}}.el%{rhel}.noarch.rpm)
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

{% include_cached /md/gateway/setup.md release=page.release %}
