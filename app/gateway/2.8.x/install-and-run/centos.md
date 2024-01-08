---
title: Install Kong Gateway on CentOS
---

{:.important}
> **Deprecation notice**: Support for running open-source {{site.base_gateway}} on
CentOS is now deprecated, as [CentOS has reached End of Life (EOL)](https://www.centos.org/centos-linux-eol/).
Starting with {{site.base_gateway}} 2.8.0.0, Kong is not building new open-source CentOS images.
> If you need to install {{site.base_gateway}} (OSS) on CentOS, see the documentation for
[previous versions](/gateway/2.7.x/install-and-run/centos/).
> <br><br>
> {{site.ee_product_name}} subscriptions can still use CentOS in 2.8, but support
for CentOS is planned to be removed in 3.0.

The {{site.base_gateway}} software is governed by the
[Kong Software License Agreement](https://konghq.com/kongsoftwarelicense).
Kong is licensed under an
[Apache 2.0 license](https://github.com/Kong/kong/blob/master/LICENSE).

## Prerequisites

* A supported system with root or [root-equivalent](/gateway/{{page.kong_version}}/plan-and-deploy/kong-user/) access.
* (Enterprise only) A `license.json` file from Kong.

## Download and Install

You can install {{site.base_gateway}} by downloading an installation package or
using our YUM repository.

{% navtabs %}
{% navtab Package %}

Install {{site.base_gateway}} on CentOS from the command line.

1. Download the Kong package:

    ```bash
    curl -Lo kong-enterprise-edition-{{page.versions.ee}}.rpm $(rpm --eval {{ site.links.cloudsmith }}/public/gateway-{{ page.major_minor_version }}/rpm/el/%{centos_ver}/x86_64/kong-enterprise-edition-{{page.versions.ee}}.el%{centos_ver}.noarch.rpm)
    ```

2. Install the package:

    ```bash
    sudo yum install -y kong-enterprise-edition-{{page.versions.ee}}.rpm
    ```

{% endnavtab %}
{% navtab YUM repository %}

Install the YUM repository from the command line.

1. Download the Kong yum repository:
    ```bash
    curl -1sLf "{{ site.links.cloudsmith }}/public/gateway-{{ page.major_minor_version }}/config.rpm.txt?distro=el&codename=$(rpm --eval '%{rhel}')" | sudo tee /etc/yum.repos.d/kong-gateway-{{ page.major_minor_version }}.repo
    sudo yum -q makecache -y --disablerepo='*' --enablerepo='kong-gateway-{{ page.major_minor_version }}'
    ```

2. Install Kong:

    ```bash
    sudo yum install -y kong-enterprise-edition-{{page.versions.ee}}
    ```

{% endnavtab %}
{% endnavtabs %}

<!-- Setup content shared between all Linux installation topics: Amazon Linux, CentOS, Ubuntu, and RHEL.
Includes the following sections: Setup configs, Using a database, Using a yaml declarative config file,
Using a yaml declarative config file, Verify install, Enable and configure Kong Manager, Enable Dev Portal,
Support, and Next Steps.
Located in the app/_includes/md/gateway folder.
See https://docs.konghq.com/contributing/includes/ for more information about using includes in this project.
-->

{% include_cached /md/gateway/setup.md kong_version=page.kong_version %}
