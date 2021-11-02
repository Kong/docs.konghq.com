---
title: Install Kong Gateway on RHEL
---

<!-- Banner with links to latest downloads -->
<!-- The install-link and install-listing-link classes are used for tracking, do not remove -->

{:.install-banner}
> Download the latest {{page.kong_version}} package for RHEL:
> * **Kong Gateway**:
> [**RHEL 7**]({{ site.links.download }}/gateway-2.x-rhel-7/Packages/k/kong-enterprise-edition-{{page.kong_versions[page.version-index].ee-version}}.rhel7.noarch.rpm){:.install-link} or
> [**RHEL 8**]({{ site.links.download }}/gateway-2.x-rhel-8/Packages/k/kong-enterprise-edition-{{page.kong_versions[page.version-index].ee-version}}.rhel8.noarch.rpm){:.install-link}
> (latest version: {{page.kong_versions[page.version-index].ee-version}})
> * **Kong Gateway (OSS)**:
> [**RHEL 7**]({{ site.links.download }}/gateway-2.x-rhel-7/Packages/k/kong-{{page.kong_versions[page.version-index].ce-version}}.rhel7.amd64.rpm){:.install-link} or
> [**RHEL 8**]({{ site.links.download }}/gateway-2.x-rhel-8/Packages/k/kong-{{page.kong_versions[page.version-index].ce-version}}.rhel8.amd64.rpm){:.install-link}
> (latest version: {{page.kong_versions[page.version-index].ce-version}})
>
> <br>
> <span class="install-subtitle">View the list of all 2.x packages for
> [**RHEL 7**]({{ site.links.download }}/gateway-2.x-rhel-7/Packages/k/){:.install-listing-link} or
> [**RHEL 8**]({{ site.links.download }}/gateway-2.x-rhel-8/Packages/k/){:.install-listing-link}<span>

## Prerequisites

You have a supported system with root or [root-equivalent](/gateway/{{page.kong_version}}/plan-and-deploy/kong-user) access.


## Download

Choose between RHEL versions 7 and 8.

You can download an RPM file with the specific version, or pull the whole catalog of versions as a Yum repo.

If you already downloaded the packages manually, move on to [Install](#install).

### RHEL 7

{% navtabs %}
{% navtab RPM file %}

To download the RPM file for RHEL 7, use the following command:

```bash
## Kong Gateway
curl -Lo kong-enterprise-edition-{{page.kong_versions[page.version-index].ee-version}}.rhel7.noarch.rpm $( rpm --eval "{{ site.links.download }}/gateway-2.x-rhel-7/Packages/k/kong-enterprise-edition-{{page.kong_versions[page.version-index].ee-version}}.rhel7.noarch.rpm")
```

```bash
## Kong Gateway (OSS)
curl -Lo kong-{{page.kong_versions[page.version-index].ce-version}}.rhel7.amd64.rpm $(rpm --eval "{{ site.links.download }}/gateway-2.x-rhel-7/Packages/k/kong-{{page.kong_versions[page.version-index].ce-version}}.rhel7.amd64.rpm")
```

{% endnavtab %}
{% navtab Yum repo %}

To download the Yum repo file for RHEL 7, use the following command:

```bash
## Kong Gateway
curl $(rpm --eval "{{site.links.download}}/gateway-2.x-rhel-7/config.repo") | sudo tee /etc/yum.repos.d/kong-enterprise-edition.repo
```

```bash
## Kong Gateway (OSS)
curl $( "{{site.links.download}}/gateway-2.x-rhel-7/config.repo") | sudo tee /etc/yum.repos.d/kong.repo
```

{% endnavtab %}
{% endnavtabs %}

### RHEL 8

{% navtabs %}
{% navtab RPM file %}

To download the RPM file for RHEL 8, use the following command:

```bash
## Kong Gateway
curl -Lo kong-enterprise-edition-{{page.kong_versions[page.version-index].ee-version}}.rhel8.noarch.rpm $( rpm --eval "{{ site.links.download }}/gateway-2.x-rhel-8/Packages/k/kong-enterprise-edition-{{page.kong_versions[page.version-index].ee-version}}.rhel8.noarch.rpm")
```

```bash
## Kong Gateway (OSS)
curl -Lo kong-{{page.kong_versions[page.version-index].ce-version}}.rhel8.amd64.rpm $(rpm --eval "{{ site.links.download }}/gateway-2.x-rhel-8/Packages/k/kong-{{page.kong_versions[page.version-index].ce-version}}.rhel8.amd64.rpm")
```

{% endnavtab %}
{% navtab Yum repo %}

To download the Yum repo file for RHEL 8 from the command line, use the following command:

```bash
## Kong Gateway
curl $(rpm --eval "{{site.links.download}}/gateway-2.x-rhel-8/config.repo") | sudo tee /etc/yum.repos.d/kong-enterprise-edition.repo
```

```bash
## Kong Gateway (OSS)
curl $( "{{site.links.download}}/gateway-2.x-rhel-8/config.repo") | sudo tee /etc/yum.repos.d/kong.repo
```

{% endnavtab %}
{% endnavtabs %}

## Install

Choose between RHEL versions 7 and 8.

### RHEL 7

{% navtabs %}
{% navtab RPM file %}

To install the RPM file for RHEL 7, use the following command:

```bash
## Kong Gateway
sudo yum install -y kong-enterprise-edition-{{page.kong_versions[page.version-index].ee-version}}.rhel7.noarch.rpm
```

```bash
## Kong Gateway (OSS)
sudo yum --nogpgcheck install -y kong-{{page.kong_versions[page.version-index].ce-version}}.rhel7.amd64.rpm
```

{% endnavtab %}
{% navtab Yum repo %}

To install the Yum repo file for RHEL from the command line, use the following command:

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

### RHEL 8

{% navtabs %}
{% navtab RPM file %}

To install the RPM file for RHEL 8 from the command line, use the following command:

```bash
## Kong Gateway
sudo yum install -y kong-enterprise-edition-{{page.kong_versions[page.version-index].ee-version}}.rhel8.noarch.rpm
```

```bash
## Kong Gateway (OSS)
sudo yum --nogpgcheck install -y kong-{{page.kong_versions[page.version-index].ce-version}}.rhel8.amd64.rpm
```

{% endnavtab %}
{% navtab Yum repo %}

To install the Yum repo file for RHEL, use the following command:

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
