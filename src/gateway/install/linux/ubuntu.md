---
title: Install Kong Gateway on Ubuntu
---

The {{site.base_gateway}} software is governed by the
[Kong Software License Agreement](https://konghq.com/kongsoftwarelicense).
Kong is licensed under an
[Apache 2.0 license](https://github.com/Kong/kong/blob/master/LICENSE).

## Prerequisites

* A supported system with root or [root-equivalent](/gateway/{{page.kong_version}}/plan-and-deploy/kong-user) access.
* (Enterprise only) A `license.json` file from Kong

## Download and install

You can install {{site.base_gateway}} by downloading an installation package or using our APT repository. We currently package {{ site.base_gateway }} for Ubuntu Bionic, Focal, and Xenial.

{:.note .no-icon}
> We currently package {{ site.base_gateway }} for Ubuntu Bionic, Focal and Xenial.
> If you are using a different release, replace `$(lsb_release -sc)` with `xenial` in the commands below.
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
curl -Lo kong-enterprise-edition-{{page.kong_versions[page.version-index].ee-version}}.all.deb "{{ site.links.download }}/gateway-2.x-ubuntu-$(lsb_release -sc)/pool/all/k/kong-enterprise-edition/kong-enterprise-edition_{{page.kong_versions[page.version-index].ee-version}}_all.deb"
```
{% endnavtab %}
{% navtab Kong Gateway (OSS) %}
```bash
curl -Lo kong-{{page.kong_versions[page.version-index].ce-version}}.amd64.deb "{{ site.links.download }}/gateway-2.x-ubuntu-$(lsb_release -sc)/pool/all/k/kong/kong_{{page.kong_versions[page.version-index].ce-version}}_amd64.deb"
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
sudo dpkg -i kong-enterprise-edition-{{page.kong_versions[page.version-index].ee-version}}.all.deb
```
{% endnavtab %}
{% navtab Kong Gateway (OSS) %}
```bash
sudo dpkg -i kong-{{page.kong_versions[page.version-index].ce-version}}.amd64.deb
```
{% endnavtab %}
{% endnavtabs_ee %}
{% endcapture %}

{{ install_package | indent | replace: " </code>", "</code>" }}

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
{% navtab APT repository %}

Install the APT repository from the command line.

1. Setup the Kong APT repository:
    ```bash
    echo "deb [trusted=yes] {{ site.links.download }}/gateway-2.x-ubuntu-$(lsb_release -sc)/ \
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
sudo apt install -y kong-enterprise-edition={{page.kong_versions[page.version-index].ee-version}}
```
{% endnavtab %}
{% navtab Kong Gateway (OSS) %}
```bash
apt install -y kong={{page.kong_versions[page.version-index].ce-version}}
```
{% endnavtab %}
{% endnavtabs_ee %}
{% endcapture %}

{{ install_from_repo | indent | replace: " </code>", "</code>" }}

{% endnavtab %}
{% endnavtabs %}

{% include_cached /md/gateway/setup.md kong_version=page.kong_version %}
