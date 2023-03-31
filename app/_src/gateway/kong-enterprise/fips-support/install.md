---
title: Install and Configure the FIPS Compliant Package
badge: enterprise
content_type: how-to
---

This how-to guide explains how to install and configure the {{site.base_gateway}} FIPS-compliant package. After following the steps in this guide, you will have a FIPS-compliant {{site.base_gateway}} with FIPS mode enabled.

## Installing a {{site.base_gateway}} FIPS compliant package

{% navtabs %}
{% navtab Ubuntu %}

The FIPS-compliant Ubuntu 20.04 package can be installed using the package distinctively named `kong-enterprise-edition-fips`. To install the package follow these instructions:

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

The FIPS-compliant Red Hat 8 package can be installed using the package distinctively named `kong-enterprise-edition-fips`. To install the package follow these instructions:

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

## Configure FIPS

To start in FIPS mode, set the following configuration property to `on` in the `kong.conf` configuration file before starting {{site.base_gateway}}:

```
fips = on # fips mode is enabled, causing incompatible ciphers to be disabled
```

You can also set this configuration using an environment variable:

```bash
export KONG_FIPS=on
```

If you are migrating from {{site.base_gateway}} 3.1 to 3.2 in FIPS mode and are using the key-auth-enc plugin, you should send [PATCH or POST requests](/hub/kong-inc/key-auth-enc/#create-a-key) to all existing key-auth-enc credentials to re-hash them in SHA256.

{:.important .no-icon}
> Migrating from non-FIPS to FIPS mode and backwards is not supported.