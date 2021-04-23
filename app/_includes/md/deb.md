## Installation

Kong can be installed by downloading an installation package or from our apt repository

{% navtabs %}
{% navtab Packages %}

    {% if include.distribution == "ubuntu" %}

- [Xenial]({{ site.links.download }}/gateway-community/ubuntu/xenial/pool/all/k/kong/kong_{{site.data.kong_latest.version}}_amd64.deb)
- [Bionic]({{ site.links.download }}/gateway-community/ubuntu/bionic/pool/all/k/kong/kong_{{site.data.kong_latest.version}}_amd64.deb)
- [Focal]({{ site.links.download }}/gateway-community/ubuntu/focal/pool/all/k/kong/kong_{{site.data.kong_latest.version}}_amd64.deb)

    {% endif %}

    {% if include.distribution == "debian" %}

- [8 Jessie]({{ site.links.download }}/gateway-community/debian/jessie/pool/all/k/kong/kong_{{site.data.kong_latest.version}}_amd64.deb)
- [9 Stretch]({{ site.links.download }}/gateway-community/debian/stretch/pool/all/k/kong/kong_{{site.data.kong_latest.version}}_amd64.deb)
- [10 Buster]({{ site.links.download }}/gateway-community/debian/buster/pool/all/k/kong/kong_{{site.data.kong_latest.version}}_amd64.deb)
- [11 Bullseye]({{ site.links.download }}/gateway-community/debian/bullseye/pool/all/k/kong/kong_{{site.data.kong_latest.version}}_amd64.deb)

    {% endif %}

To install from the command line

```bash
$ curl -Lo kong.{{site.data.kong_latest.version}}.amd64.deb "{{ site.links.download }}/gateway-2.x-{{ include.distribution }}-$(lsb_release -cs)/pool/all/k/kong/kong_{{site.data.kong_latest.version}}_amd64.deb"
$ sudo dpkg -i kong.{{site.data.kong_latest.version}}.amd64.deb
```

{% endnavtab %}
{% navtab Repository %}

**APT Repositories**

```bash
$ echo "deb [trusted=yes] {{ site.links.download }}/gateway-2.x-{{ include.distribution }}-$(lsb_release -sc)/ default all" | sudo tee /etc/apt/sources.list.d/kong.list 
$ sudo apt-get update
$ sudo apt-cache search kong
$ sudo apt install -y kong={{site.data.kong_latest.version}}
```

{% endnavtab %}
{% endnavtabs %}

{% include /md/installation.md %}
