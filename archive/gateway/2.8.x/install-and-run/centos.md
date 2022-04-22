---
title: Install Kong Gateway on CentOS
---

{:.important}
> **Deprecation notice**: Support for running open-source Kong Gateway on
CentOS is now deprecated, as [CentOS has reached End of Life (EOL)](https://www.centos.org/centos-linux-eol/).
Starting with Kong Gateway 2.8.0.0, Kong is not building new open-source CentOS images.
> If you need to install Kong Gateway (OSS) on CentOS, see the documentation for
[previous versions](/gateway/2.7.x/install-and-run/centos/).
> <br><br>
> Kong Gateway Enterprise subscriptions can still use CentOS in 2.8, but support
for CentOS is planned to be removed in 3.0.

<!-- Banner with links to latest downloads -->
<!-- The install-link and install-listing-link classes are used for tracking, do not remove -->

{:.install-banner}
> Download the latest **Kong Gateway {{page.kong_version}}** package for Centos:
> * [**CentOS 7**]({{ site.links.download }}/gateway-2.x-centos-7/Packages/k/kong-enterprise-edition-{{page.kong_versions[page.version-index].ee-version}}.el7.noarch.rpm){:.install-link}
> * [**CentOS 8**]({{ site.links.download }}/gateway-2.x-centos-8/Packages/k/kong-enterprise-edition-{{page.kong_versions[page.version-index].ee-version}}.el8.noarch.rpm){:.install-link}
>
> (latest version: {{page.kong_versions[page.version-index].ee-version}})
> <br><br>
> <span class="install-subtitle">View the list of all 2.x packages for
> [**CentOS 7**]({{ site.links.download }}/gateway-2.x-centos-7/Packages/k/){:.install-listing-link} or
> [**CentOS 8**]({{ site.links.download }}/gateway-2.x-centos-8/Packages/k/){:.install-listing-link} </span>


The {{site.base_gateway}} software is governed by the
[Kong Software License Agreement](https://konghq.com/kongsoftwarelicense/).
Kong is licensed under an
[Apache 2.0 license](https://github.com/Kong/kong/blob/master/LICENSE).

## Prerequisites

* A supported system with root or [root-equivalent](/gateway/{{page.kong_version}}/plan-and-deploy/kong-user) access.
* (Enterprise only) A `license.json` file from Kong.

## Download and Install

You can install {{site.base_gateway}} by downloading an installation package or
using our YUM repository.

{% navtabs %}
{% navtab Package %}

Install {{site.base_gateway}} on CentOS from the command line.

1. Download the Kong package:

    ```bash
    curl -Lo kong-enterprise-edition-{{page.kong_versions[page.version-index].ee-version}}.rpm $(rpm --eval "{{ site.links.download }}/gateway-2.x-centos-%{centos_ver}/Packages/k/kong-enterprise-edition-{{page.kong_versions[page.version-index].ee-version}}.el%{centos_ver}.noarch.rpm")
    ```

2. Install the package:

    ```bash
    sudo yum install kong-enterprise-edition-{{page.kong_versions[page.version-index].ee-version}}.rpm
    ```

{% endnavtab %}
{% navtab YUM repository %}

Install the YUM repository from the command line.

1. Download the Kong APT repository:
    ```bash
    curl $(rpm --eval "{{ site.links.download }}/gateway-2.x-centos-%{centos_ver}/config.repo") | sudo tee /etc/yum.repos.d/kong.repo
    ```

2. Install Kong:

    ```bash
    sudo yum install kong-enterprise-edition-{{page.kong_versions[page.version-index].ee-version}}
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
