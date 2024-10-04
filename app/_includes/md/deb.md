## Installation

You can install Kong by downloading an installation package or using our apt repository

{% navtabs %}
{% navtab Packages %}

    {% if include.distribution == "ubuntu" %}

    {% if_version lte:2.8.x -%}
- [Xenial]({{ site.links.download }}/gateway-2.x-ubuntu-xenial/pool/all/k/kong/kong_{{site.data.kong_latest.version}}_amd64.deb)
    {% endif_version -%}
- [Bionic]({{ site.links.download }}/gateway-2.x-ubuntu-bionic/pool/all/k/kong/kong_{{site.data.kong_latest.version}}_amd64.deb)
- [Focal]({{ site.links.download }}/gateway-2.x-ubuntu-focal/pool/all/k/kong/kong_{{site.data.kong_latest.version}}_amd64.deb)

    {% endif %}

    {% if include.distribution == "debian" %}

    {% if_version lte:2.8.x -%}
- [8 Jessie]({{ site.links.download }}/gateway-2.x-debian-jessie/pool/all/k/kong/kong_{{site.data.kong_latest.version}}_amd64.deb)
    {% endif_version -%}
- [9 Stretch]({{ site.links.download }}/gateway-2.x-debian-stretch/pool/all/k/kong/kong_{{site.data.kong_latest.version}}_amd64.deb)
- [10 Buster]({{ site.links.download }}/gateway-2.x-debian-buster/pool/all/k/kong/kong_{{site.data.kong_latest.version}}_amd64.deb)
- [11 Bullseye]({{ site.links.download }}/gateway-2.x-debian-bullseye/pool/all/k/kong/kong_{{site.data.kong_latest.version}}_amd64.deb)

    {% endif %}

To install from the command line

```bash
$ curl -Lo kong.{{site.data.kong_latest.version}}.amd64.deb "{{ site.links.download }}/gateway-2.x-{{ include.distribution }}-$(lsb_release -cs)/pool/all/k/kong/kong_{{site.data.kong_latest.version}}_amd64.deb"
$ sudo dpkg -i kong.{{site.data.kong_latest.version}}.amd64.deb
```

{% endnavtab %}
{% navtab Repository %}

**APT Repositories**

To install from the command line

```bash
$ echo "deb [trusted=yes] {{ site.links.download }}/gateway-2.x-{{ include.distribution }}-$(lsb_release -sc)/ default all" | sudo tee /etc/apt/sources.list.d/kong.list
$ sudo apt-get update
$ sudo apt install -y kong
```

{% endnavtab %}
{% endnavtabs %}

{% include_cached /md/installation.md release=page.release %}
