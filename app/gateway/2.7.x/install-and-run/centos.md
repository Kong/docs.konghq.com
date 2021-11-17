---
title: Install Kong Gateway on CentOS
---

<!-- Banner with links to latest downloads -->
<!-- The install-link and install-listing-link classes are used for tracking, do not remove -->

{:.install-banner}
> Download the latest {{page.kong_version}} package for Centos:
> * **Kong Gateway**:
> [**CentOS 7**]({{ site.links.download }}/gateway-2.x-centos-7/Packages/k/kong-enterprise-edition-{{page.kong_versions[page.version-index].ee-version}}.el7.noarch.rpm){:.install-link} or
> [**CentOS 8**]({{ site.links.download }}/gateway-2.x-centos-8/Packages/k/kong-enterprise-edition-{{page.kong_versions[page.version-index].ee-version}}.el8.noarch.rpm){:.install-link}
> (latest version: {{page.kong_versions[page.version-index].ee-version}})
> * **Kong Gateway (OSS)**:
> [**CentOS 7**]({{ site.links.download }}/gateway-2.x-centos-7/Packages/k/kong-{{page.kong_versions[page.version-index].ce-version}}.el7.amd64.rpm){:.install-link} or
> [**CentOS 8**]({{ site.links.download }}/gateway-2.x-centos-8/Packages/k/kong-{{page.kong_versions[page.version-index].ce-version}}.el8.amd64.rpm){:.install-link}
> (latest version: {{page.kong_versions[page.version-index].ce-version}})
>
> <br>
> <span class="install-subtitle">View the list of all 2.x packages for
> [**CentOS 7**]({{ site.links.download }}/gateway-2.x-centos-7/Packages/k/){:.install-listing-link} or
> [**CentOS 8**]({{ site.links.download }}/gateway-2.x-centos-8/Packages/k/){:.install-listing-link} </span>


The {{site.base_gateway}} software is governed by the
[Kong Software License Agreement](https://konghq.com/kongsoftwarelicense/).
{{site.ce_product_name}} is licensed under an
[Apache 2.0 license](https://github.com/Kong/kong/blob/master/LICENSE).

## Prerequisites

* A supported system with root or [root-equivalent](/gateway/{{page.kong_version}}/plan-and-deploy/kong-user) access.
* (Enterprise only) A `license.json` file from Kong.

## Download

Choose between CentOS versions 7 and 8.

You can download an RPM file with the specific version, or pull the whole catalog of versions as a Yum repo.

If you already downloaded the packages manually, move on to [Install](#install).

### CentOS 7

{% navtabs %}
{% navtab RPM file %}

Download the RPM file for CentOS 7:

```bash
## Kong Gateway
curl -Lo kong-enterprise-edition-{{page.kong_versions[page.version-index].ee-version}}.el7.noarch.rpm $( rpm --eval "{{ site.links.download }}/gateway-2.x-centos-7/Packages/k/kong-enterprise-edition-{{page.kong_versions[page.version-index].ee-version}}.el7.noarch.rpm")
```

```bash
## Kong Gateway (OSS)
curl -Lo kong-{{page.kong_versions[page.version-index].ce-version}}.el7.amd64.rpm $(rpm --eval "{{ site.links.download }}/gateway-2.x-centos-7/Packages/k/kong-{{page.kong_versions[page.version-index].ce-version}}.el7.amd64.rpm")
```

{% endnavtab %}
{% navtab Yum repo %}

Download the Yum repo file for CentOS 7:

```bash
## Kong Gateway
curl $(rpm --eval "{{site.links.download}}/gateway-2.x-centos-7/config.repo") | sudo tee /etc/yum.repos.d/kong-enterprise-edition.repo
```

```bash
## Kong Gateway (OSS)
curl $( "{{site.links.download}}/gateway-2.x-centos-7/config.repo") | sudo tee /etc/yum.repos.d/kong.repo
```

{% endnavtab %}
{% endnavtabs %}

### CentOS 8

{% navtabs %}
{% navtab RPM file %}

Download the RPM file for CentOS 8:

```bash
## Kong Gateway
curl -Lo kong-enterprise-edition-{{page.kong_versions[page.version-index].ee-version}}.el8.noarch.rpm $( rpm --eval "{{ site.links.download }}/gateway-2.x-centos-8/Packages/k/kong-enterprise-edition-{{page.kong_versions[page.version-index].ee-version}}.el8.noarch.rpm")
```

```bash
## Kong Gateway (OSS)
curl -Lo kong-{{page.kong_versions[page.version-index].ce-version}}.el8.amd64.rpm $(rpm --eval "{{ site.links.download }}/gateway-2.x-centos-8/Packages/k/kong-{{page.kong_versions[page.version-index].ce-version}}.el8.amd64.rpm")
```

{% endnavtab %}
{% navtab Yum repo %}

Download the Yum repo file for CentOS 8:

```bash
## Kong Gateway
curl $(rpm --eval "{{site.links.download}}/gateway-2.x-centos-8/config.repo") | sudo tee /etc/yum.repos.d/kong-enterprise-edition.repo
```

```bash
## Kong Gateway (OSS)
curl $( "{{site.links.download}}/gateway-2.x-centos-8/config.repo") | sudo tee /etc/yum.repos.d/kong.repo
```

{% endnavtab %}
{% endnavtabs %}

## Install

Choose between CentOS versions 7 and 8.

### CentOS 7

{% navtabs %}
{% navtab RPM file %}

Install the RPM file for CentOS 7:

```bash
## Kong Gateway
sudo yum install -y kong-enterprise-edition-{{page.kong_versions[page.version-index].ee-version}}.el7.noarch.rpm
```

```bash
## Kong Gateway (OSS)
sudo yum --nogpgcheck install -y kong-{{page.kong_versions[page.version-index].ce-version}}.el7.amd64.rpm
```

{% endnavtab %}
{% navtab Yum repo %}

Install the Yum repo file for CentOS 7:

```bash
## Kong Gateway
sudo yum install -y kong-enterprise-edition
```

```bash
## Kong Gateway (OSS)
sudo yum --nogpgcheck install -y kong
```

{% endnavtab %}
{% endnavtabs %}

### CentOS 8

{% navtabs %}
{% navtab RPM file %}

Install the RPM file for CentOS 8:

```bash
## Kong Gateway
sudo yum install -y kong-enterprise-edition-{{page.kong_versions[page.version-index].ee-version}}.el8.noarch.rpm
```

```bash
## Kong Gateway (OSS)
sudo yum --nogpgcheck install -y kong-{{page.kong_versions[page.version-index].ce-version}}.el8.amd64.rpm
```

{% endnavtab %}
{% navtab Yum repo %}

Install the Yum repo file for CentOS using the following command:

```bash
## Kong Gateway
sudo yum install -y kong-enterprise-edition
```

```bash
## Kong Gateway (OSS)
sudo yum --nogpgcheck install -y kong
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
