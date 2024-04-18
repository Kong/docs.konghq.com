---
title: Install Kong Gateway on Amazon Linux
---

The {{site.base_gateway}} software is governed by the
[Kong Software License Agreement](https://konghq.com/kongsoftwarelicense).
Kong is licensed under an
[Apache 2.0 license](https://github.com/Kong/kong/blob/master/LICENSE).

{% include_cached /md/gateway/install-traditional-mode.md %}

## Prerequisites

* A [supported system](/gateway/{{page.release}}/support-policy/#supported-versions) with root or [root-equivalent](/gateway/{{page.release}}/production/running-kong/kong-user/) access.
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
curl -Lo kong-enterprise-edition-{{page.versions.ee}}.rpm $(rpm --eval {{ site.links.direct }}/gateway-{{ page.major_minor_version }}/rpm/amzn/%{amzn}/%{_arch}/kong-enterprise-edition-{{page.versions.ee}}.aws.%{_arch}.rpm)
```
{% endnavtab %}
{% navtab Kong Gateway (OSS) %}
```bash
curl -Lo kong-{{page.versions.ce}}.rpm $(rpm --eval {{ site.links.direct }}/gateway-{{ page.major_minor_version }}/rpm/amzn/%{amzn}/%{_arch}/kong-{{page.versions.ce}}.aws.%{_arch}.rpm)
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
    curl -1sLf "{{ site.links.direct }}/gateway-{{ page.major_minor_version }}/config.rpm.txt?distro=amzn&codename=$(rpm --eval '%{amzn}')" | sudo tee /etc/yum.repos.d/kong-gateway-{{ page.major_minor_version }}.repo > /dev/null
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
