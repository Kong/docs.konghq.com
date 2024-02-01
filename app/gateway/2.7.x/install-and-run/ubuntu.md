---
title: Install Kong Gateway on Ubuntu
---

The {{site.base_gateway}} software is governed by the
[Kong Software License Agreement](https://konghq.com/kongsoftwarelicense).
Kong is licensed under an
[Apache 2.0 license](https://github.com/Kong/kong/blob/master/LICENSE).

## Prerequisites

* A supported system with root or [root-equivalent](/gateway/{{page.release}}/plan-and-deploy/kong-user/) access.
* (Enterprise only) A `license.json` file from Kong

## Download and install

You can install {{site.base_gateway}} by downloading an installation package or using our APT repository.

{% navtabs %}
{% navtab Package %}

Install {{site.base_gateway}} on Ubuntu from the command line.

1. Download the Kong package:

{% capture download_package %}
{% navtabs_ee codeblock %}
{% navtab Kong Gateway %}
```bash
curl -Lo kong-enterprise-edition-{{page.versions.ee}}.all.deb "{{ site.links.cloudsmith }}/public/gateway-legacy/deb/ubuntu/pool/xenial/main/k/ko/kong-enterprise-edition_{{page.versions.ee}}/kong-enterprise-edition_{{page.versions.ee}}_all.deb"
```
{% endnavtab %}
{% navtab Kong Gateway (OSS) %}
```bash
curl -Lo kong-{{page.versions.ce}}.all.deb "{{ site.links.cloudsmith }}/public/gateway-legacy/deb/ubuntu/pool/xenial/main/k/ko/kong_{{page.versions.ce}}/kong_{{page.versions.ce}}_amd64.deb"
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
sudo apt install -y ./kong-enterprise-edition-{{page.versions.ee}}.all.deb
```
{% endnavtab %}
{% navtab Kong Gateway (OSS) %}
```bash
sudo apt install -y ./kong-{{page.versions.ce}}.all.deb
```
{% endnavtab %}
{% endnavtabs_ee %}
{% endcapture %}

{{ install_package | indent | replace: " </code>", "</code>" }}

{% endnavtab %}
{% navtab APT repository %}

Install the APT repository from the command line.

{% assign gpg_key = site.data.installation.gateway.legacy.gpg_key  %}

1. Setup the Kong APT repository:
    ```bash
    curl -1sLf "{{ site.links.cloudsmith }}/public/gateway-legacy/gpg.{{ gpg_key }}.key" |  gpg --dearmor | sudo tee -a /usr/share/keyrings/kong-gateway-legacy-archive-keyring.gpg > /dev/null
    curl -1sLf "{{ site.links.cloudsmith }}/public/gateway-legacy/config.deb.txt?distro=ubuntu&codename=xenial" | sudo tee /etc/apt/sources.list.d/kong-gateway-legacy.list > /dev/null
    ```

2. Update the repository:
    ```bash
    sudo apt-get update
    ```

3. Install Kong:

{% capture install_from_repo %}
{% navtabs_ee codeblock %}
{% navtab Kong Gateway %}
```bash
sudo apt install -y kong-enterprise-edition={{page.versions.ee}}
```

{% endnavtab %}
{% navtab Kong Gateway (OSS) %}
```bash
sudo apt install -y kong={{page.versions.ce}}
```


{% endnavtab %}
{% endnavtabs_ee %}
{% endcapture %}

{{ install_from_repo | indent | replace: " </code>", "</code>" }}

{% navtabs_ee %}
{% navtab Kong Gateway %}
{:.note .no-icon}
> Once {{ site.base_gateway }} is installed, you may want to run `sudo apt-mark hold kong-enterprise-edition`. This will prevent an accidental upgrade to a new version.
{% endnavtab %}
{% navtab Kong Gateway (OSS) %}
{:.note .no-icon}
> Once {{ site.base_gateway }} is installed, you may want to run `sudo apt-mark hold kong`. This will prevent an accidental upgrade to a new version.
{% endnavtab %}
{% endnavtabs_ee %}

{% endnavtab %}
{% endnavtabs %}

{% include_cached /md/gateway/setup.md release=page.release %}
