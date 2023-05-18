---
title: Install Kong Gateway on Ubuntu
---

The {{site.base_gateway}} software is governed by the
[Kong Software License Agreement](https://konghq.com/kongsoftwarelicense).
Kong is licensed under an
[Apache 2.0 license](https://github.com/Kong/kong/blob/master/LICENSE).

{:.note}
> This page will install {{ site.base_gateway }} in traditional mode, where it acts as both the control plane and data plane. Running in this mode may have a small performance impact.
> &nbsp;
> 
> &nbsp;
> 
> We recommend using [{{site.konnect_short_name}}](https://konghq.com/products/kong-konnect/register?utm_medium=referral&utm_source=docs&utm_campaign=install-ubuntu) as your control plane to allow your data plane to run at maximum performance and decrease your deployment complexity

## Prerequisites

* A [supported system](/gateway/{{page.kong_version}}/support-policy/#supported-versions) with root or [root-equivalent](/gateway/{{page.kong_version}}/production/running-kong/kong-user/) access.
* (Enterprise only) A `license.json` file from Kong

## Installation

The quickest way to get started with {{ site.base_gateway }} is using our install script:

{% navtabs_ee codeblock %}
{% navtab Kong Gateway %}
```bash
bash <(curl -sS https://get.konghq.com/install) -v {{page.versions.ee}}
```
{% endnavtab %}
{% navtab Kong Gateway (OSS) %}
```bash
bash <(curl -sS https://get.konghq.com/install) -p kong -v {{page.versions.ce}}
```
{% endnavtab %}
{% endnavtabs_ee %}

This script detects your operating system and automatically installs the correct package. It will also install a Postgres database and bootstrap {{ site.base_gateway }} for you.

If you'd prefer to install just the package, please see the [Package Install](#package-install) section.

### Verify install

Once the script completes, run the following in the same terminal window:

```bash
curl -i http://localhost:8001
```

You should receive a `200` status code.

### Next steps

Once {{ site.base_gateway }} is running, you may want to do the following:

* Optional: [Add your Enterprise license](/gateway/{{ page.kong_version }}/licenses/deploy).
* [Enable Kong Manager](/gateway/{{ page.kong_version }}/kong-manager/enable/)
* [Enable Dev Portal](/gateway/{{ page.kong_version }}/kong-enterprise/dev-portal/enable/)
* [Create services and routes](/gateway/{{ page.kong_version }}/get-started/services-and-routes/).

## Advanced Installation

### Package Install

You can install {{site.base_gateway}} by downloading an installation package or using our APT repository.

{:.note .no-icon}
> We currently package {{ site.base_gateway }} for Ubuntu Bionic and Focal.
> If you are using a different release, replace `$(lsb_release -sc)` with `focal` in the commands below.
> <br /><br />
> To check your release name run `lsb_release -sc`.

{% navtabs %}
{% navtab Package %}

Install {{site.base_gateway}} on Ubuntu from the command line.

1. Download the Kong package:

{% capture download_package %}
{% navtabs_ee codeblock %}
{% navtab Kong Gateway %}
```bash
curl -Lo kong-enterprise-edition-{{page.versions.ee}}.amd64.deb "{{ site.links.download }}/gateway-3.x-ubuntu-$(lsb_release -sc)/pool/all/k/kong-enterprise-edition/kong-enterprise-edition_{{page.versions.ee}}_amd64.deb"
```
{% endnavtab %}
{% navtab Kong Gateway (OSS) %}
```bash
curl -Lo kong-{{page.versions.ce}}.amd64.deb "{{ site.links.download }}/gateway-3.x-ubuntu-$(lsb_release -sc)/pool/all/k/kong/kong_{{page.versions.ce}}_amd64.deb"
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
sudo apt install -y ./kong-enterprise-edition-{{page.versions.ee}}.amd64.deb
```
{% endnavtab %}
{% navtab Kong Gateway (OSS) %}
```bash
sudo apt install -y ./kong-{{page.versions.ce}}.amd64.deb
```
{% endnavtab %}
{% endnavtabs_ee %}
{% endcapture %}

{{ install_package | indent | replace: " </code>", "</code>" }}

{% navtabs_ee %}
{% navtab Kong Gateway %}
{:.note .no-icon}
> To uninstall the package, run: `sudo apt remove kong-enterprise-edition`.
{% endnavtab %}
{% navtab Kong Gateway (OSS) %}
{:.note .no-icon}
> To uninstall the package, run: `sudo apt remove kong`.
{% endnavtab %}
{% endnavtabs_ee %}

{% endnavtab %}
{% navtab APT repository %}

Install the APT repository from the command line.

1. Setup the Kong APT repository:
    ```bash
    echo "deb [trusted=yes] {{ site.links.download }}/gateway-3.x-ubuntu-$(lsb_release -sc)/ \
    default all" | sudo tee /etc/apt/sources.list.d/kong.list
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
apt install -y kong={{page.versions.ce}}
```
{% endnavtab %}
{% endnavtabs_ee %}
{% endcapture %}

{{ install_from_repo | indent | replace: " </code>", "</code>" }}

4. Optional: Prevent accidental upgrades by marking the package as `hold`:
{% capture optional %}
{% navtabs_ee %}
{% navtab Kong Gateway %}
```bash
sudo apt-mark hold kong-enterprise-edition
```
{% endnavtab %}
{% navtab Kong Gateway (OSS) %}
```bash
sudo apt-mark hold kong
```
{% endnavtab %}
{% endnavtabs_ee %}
{% endcapture %}
{{ optional | indent | replace: " </code>", "</code>" }}

{% endnavtab %}
{% endnavtabs %}