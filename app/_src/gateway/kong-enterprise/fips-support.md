---
title: FIPS 140-2
badge: enterprise
content_type: reference
---
<!--Only update this file for versions 3.1 or earlier. Versions 3.2 and later use the file in /gateway/kong-enterprise/fips-support/index -->
The Federal Information Processing Standard (FIPS) 140-2 is a federal standard defined by the National Institute of Standards and Technology. It specifies the security requirements that must be satisfied by a cryptographic module. The FIPS {{site.base_gateway}} package is FIPS 140-2 compliant. Compliance means that the software has met all of the rules of FIPS 140-2, but has not been submitted to a NIST testing lab for validation.


{{site.ee_product_name}} provides a FIPS 140-2 compliant package for **Ubuntu 20.04** {% if_version gte:3.1.x %}, **Ubuntu 22.04** {% if_version gte:3.4.x %}, **Red Hat Enterprise 9** {% endif_version %}, and **Red Hat Enterprise 8** {% endif_version %}. This package provides compliance for the core {{site.base_gateway}} product {% if_version gte:3.2.x %} and all out of the box plugins {% endif_version %}.

The package uses the OpenSSL FIPS 3.0 module OpenSSL to provide FIPS 140-2 validated cryptographic operations.

{% if_version eq:3.0.x %}
## Installing the {{site.base_gateway}} FIPS compliant Ubuntu package

The FIPS compliant Ubuntu 20.04 and Ubuntu 22.04 packages can be installed using the package distinctively named `kong-enterprise-edition-fips`. To install the package follow these instructions:

1. Set up the Kong APT repository:
    ```bash
    curl -1sLf "{{ site.links.cloudsmith }}/public/gateway-{{ page.major_minor_version }}/gpg.{{ gpg_key }}.key" |  gpg --dearmor >> /usr/share/keyrings/kong-gateway-{{ page.major_minor_version }}-archive-keyring.gpg
    curl -1sLf "{{ site.links.cloudsmith }}/public/gateway-{{ page.major_minor_version }}/config.deb.txt?distro=ubuntu&codename=$(lsb_release -sc)" > /etc/apt/sources.list.d/kong-gateway-{{ page.major_minor_version }}.list
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
    curl -1sLf "{{ site.links.cloudsmith }}/public/gateway-{{ page.major_minor_version }}/gpg.{{ gpg_key }}.key" |  gpg --dearmor >> /usr/share/keyrings/kong-gateway-{{ page.major_minor_version }}-archive-keyring.gpg
    curl -1sLf "{{ site.links.cloudsmith }}/public/gateway-{{ page.major_minor_version }}/config.deb.txt?distro=ubuntu&codename=$(lsb_release -sc)" > /etc/apt/sources.list.d/kong-gateway-{{ page.major_minor_version }}.list
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
    curl -Lo kong-enterprise-edition-fips-{{page.versions.ee}}.rpm $(rpm --eval {{ site.links.cloudsmith }}/public/gateway-{{ page.major_minor_version }}/rpm/el/%{rhel}/x86_64/kong-enterprise-edition-fips-{{page.versions.ee}}.el%{rhel}.x86_64.rpm)
    ```

2. Install the {{site.base_gateway}} FIPS package:

    ```sh
    yum install kong-enterprise-edition-fips-{{page.versions.ee}}
    ```

{% endnavtab %}
{% navtab Yum repo %}
1. Set up the Kong Yum repository:

    ```bash
    curl -1sLf "{{ site.links.cloudsmith }}/public/gateway-{{ page.major_minor_version }}/config.rpm.txt?distro=el&codename=$(rpm --eval '%{rhel}')" | sudo tee /etc/yum.repos.d/kong-gateway-{{ page.major_minor_version }}.repo
    sudo yum -q makecache -y --disablerepo='*' --enablerepo='kong-gateway-{{ page.major_minor_version }}'
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
