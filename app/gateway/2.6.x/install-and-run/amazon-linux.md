---
title: Install Kong Gateway on Amazon Linux
---

<!-- Banner with links to latest downloads -->
<!-- The install-link and install-listing-link classes are used for tracking, do not remove -->

{:.install-banner}
> Download the latest {{page.kong_version}} packages for
> Amazon Linux:
> * **Kong Gateway**: [Amazon Linux 1]({{site.links.download }}/gateway-2.x-amazonlinux-1/Packages/k/kong-enterprise-edition-{{page.kong_versions[page.version-index].ee-version}}.amzn1.noarch.rpm){:.install-link} or [Amazon Linux 2]({{site.links.download }}/gateway-2.x-amazonlinux-2/Packages/k/kong-enterprise-edition-{{page.kong_versions[page.version-index].ee-version}}.amzn2.noarch.rpm){:.install-link} (version {{page.kong_versions[page.version-index].ee-version}})
> * **Kong Gateway (OSS)**: [Amazon Linux 2]({{ site.links.download }}/gateway-2.x-amazonlinux-2/Packages/k/kong-{{page.kong_versions[page.version-index].ce-version}}.aws.amd64.rpm){:.install-link} (version {{page.kong_versions[page.version-index].ce-version}})
> <br><br>
>
> <span class="install-subtitle">View the list of all 2.x packages for
> [Amazon Linux 1]({{ site.links.download }}/gateway-2.x-amazonlinux-1/Packages/k/){:.install-listing-link} and [Amazon Linux 2]({{ site.links.download }}/gateway-2.x-amazonlinux-2/Packages/k/){:.install-listing-link}  </span>

The {{site.base_gateway}} software is governed by the 
[Kong Software License Agreement](https://konghq.com/kongsoftwarelicense/).
{{site.ce_product_name}} is licensed under an
[Apache 2.0 license](https://github.com/Kong/kong/blob/master/LICENSE).

## Prerequisites

* A supported system with root or [root-equivalent](/gateway/{{page.kong_version}}/plan-and-deploy/kong-user) access.
* (Enterprise only) A `license.json` file from Kong.

## Download

You can download an RPM file with the specific version, or pull the whole catalog of versions as a Yum repo.

If you already downloaded the packages manually, move on to [Install](#install).

{% navtabs %}
{% navtab RPM file %}

To download the RPM file, choose your Kong Gateway
package type and use the following command:

```bash
## Kong Gateway
curl -Lo kong-enterprise-edition-{{page.kong_versions[page.version-index].ee-version}}.amzn2.noarch.rpm "{{ site.links.download }}/gateway-2.x-amazonlinux-2/Packages/k/kong-enterprise-edition-{{page.kong_versions[page.version-index].ee-version}}.amzn2.noarch.rpm"
```

```bash
## Kong Gateway (OSS)
curl -Lo kong-{{page.kong_versions[page.version-index].ce-version}}.aws.amd64.rpm "{{ site.links.download }}/gateway-2.x-amazonlinux-2/Packages/k/kong-{{page.kong_versions[page.version-index].ce-version}}.aws.amd64.rpm"
```

{% endnavtab %}
{% navtab Yum repo %}

To download the Yum repo file, choose your Kong Gateway
package type and use the following command:

```bash
## Kong Gateway
curl {{site.links.download}}/gateway-2.x-amazonlinux-2/config.repo | sudo tee /etc/yum.repos.d/kong-enterprise-edition.repo
```

```bash
## Kong Gateway (OSS)
curl {{site.links.download}}/gateway-2.x-amazonlinux-2/config.repo | sudo tee /etc/yum.repos.d/kong.repo
```

{% endnavtab %}
{% endnavtabs %}

## Install

{% navtabs %}
{% navtab RPM file %}

To install the RPM file, choose your Kong Gateway package
type and use the following command:

```bash
## Kong Gateway
sudo yum install -y kong-enterprise-edition-{{page.kong_versions[page.version-index].ee-version}}.amzn2.noarch.rpm
```

```bash
## Kong Gateway (OSS)
sudo yum --nogpgcheck install -y kong-{{page.kong_versions[page.version-index].ce-version}}.aws.amd64.rpm
```

{% endnavtab %}
{% navtab Yum repo %}

To install the Yum repo file, choose your Kong Gateway
package type and use the following command:

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
