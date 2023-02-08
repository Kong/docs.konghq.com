---
title: Install and Configure the FIPS Compliant Package
badge: enterprise
content_type: how-to
---

This how-to guide explains how to install and configure the {{site.base_gateway}} FIPS compliant package. After following the steps in this guide, you will have a FIPS compliant {{site.base_gateway}} with FIPS mode enabled.

{% if_version eq:3.0.x %}
## Installing the {{site.base_gateway}} FIPS compliant Ubuntu package

The FIPS compliant Ubuntu 20.04 and Ubuntu 22.04 packages can be installed using the package distinctively named `kong-enterprise-edition-fips`. To install the package follow these instructions:

1. Set up the Kong APT repository:
    ```bash
    echo "deb [trusted=yes] {{ site.links.download }}/gateway-3.x-ubuntu-$(lsb_release -sc)/ \
    default all" | sudo tee /etc/apt/sources.list.d/kong.list
    ```

2. Update the repository:
    ```bash
    sudo apt-get update
    ```

3. Install the {{site.base_gateway}} FIPS package:

    ```sh
    apt install kong-enterprise-edition-fips
    ```

{% endif_version %}

{% if_version gte:3.1.x %}

## Installing the {{site.base_gateway}} FIPS compliant package

{% navtabs %}
{% navtab Ubuntu %}

The FIPS compliant Ubuntu 20.04 package can be installed using the package distinctively named `kong-enterprise-edition-fips`. To install the package follow these instructions:

1. Set up the Kong APT repository:
    ```bash
    echo "deb [trusted=yes] {{ site.links.download }}/gateway-3.x-ubuntu-$(lsb_release -sc)/ \
    default all" | sudo tee /etc/apt/sources.list.d/kong.list
    ```

2. Update the repository:
    ```bash
    sudo apt-get update
    ```

3. Install the {{site.base_gateway}} FIPS package:

    ```sh
    apt install -y kong-enterprise-edition-fips={{page.versions.ee}}
    ```

{% endnavtab %}
{% navtab RHEL %}

The FIPS compliant Red Hat 8 package can be installed using the package distinctively named `kong-enterprise-edition-fips`. To install the package follow these instructions:

{% navtabs %}
{% navtab Package %}

1. Download the FIPS package:

    ```sh
    curl -Lo kong-enterprise-edition-fips-{{page.versions.ee}}.rpm \
    $( rpm --eval "{{ site.links.download }}/gateway-3.x-rhel-%{rhel}/Packages/k/kong-enterprise-edition-fips-{{page.versions.ee}}.rhel%{rhel}.amd64.rpm")
    ```

2. Install the {{site.base_gateway}} FIPS package:

    ```sh
    yum install kong-enterprise-edition-fips-{{page.versions.ee}}
    ```

{% endnavtab %}
{% navtab Yum repo %}
1. Set up the Kong Yum repository:

    ```bash
    curl $(rpm --eval "{{ site.links.download }}/gateway-3.x-rhel-%{rhel}/config.repo") | sudo tee /etc/yum.repos.d/kong.repo
    ```

2. Install the {{site.base_gateway}} FIPS package:

    ```sh
    yum install kong-enterprise-edition-fips-{{page.versions.ee}}
    ```

{% endnavtab %}
{% endnavtabs %}

{% endnavtab %}
{% endnavtabs %}
{% endif_version %}

## Configure FIPS

To start in FIPS mode, set the following variable to `on` in the `kong.conf` configuration file before starting {{site.base_gateway}}.

```
fips = on # fips mode is enabled, causing incompatible ciphers to be disabled
```

You can also use an environment variable:

```bash
export KONG_FIPS=on
```

{:.important .no-icon}
> Migrating from non-FIPS to FIPS mode and backwards is not supported.