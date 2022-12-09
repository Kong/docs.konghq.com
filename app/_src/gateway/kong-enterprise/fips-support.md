---
title: FIPS 140-2
badge: enterprise
content_type: reference
---

The Federal Information Processing Standard (FIPS) 140-2 is a federal standard defined by the National Institute of Standards and Technology. It specifies the security requirements that must be satisfied by a cryptographic module. The FIPS {{site.base_gateway}} package is FIPS 140-2 compliant. Compliance means that the software has met all of the rules of FIPS 140-2, but has not been submitted to a NIST testing lab for validation.


{{site.ee_product_name}} provides a FIPS 140-2 compliant package for **Ubuntu 20.04** {% if_version gte:3.1.x %}, **Ubuntu 22.04**, and **Red Hat Enterprise 8** {% endif_version %}. This package provides compliance for the core {{site.base_gateway}} product {% if_version gte:3.1.x %} and all out of the box plugins {% endif_version %}.

The package replaces the primary library in {{site.base_gateway}}, OpenSSL, with [BoringSSL](https://boringssl.googlesource.com/boringssl/), which at its core uses the FIPS 140-2 validated BoringCrypto for cryptographic operations.

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
