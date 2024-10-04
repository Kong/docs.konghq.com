<!-- DO NOT UPDATE THIS FILE, IT'S FOR ARCHIVED CONTENT ONLY -->

## Installation

Kong can be installed by downloading an installation package or from our yum repository

{% navtabs %}
{% navtab Packages %}

    {% if include.distribution == "aws" %}

- [Amazon Linux 2]({{ site.links.download }}/gateway-2.x-amazonlinux-2/Packages/k/kong-{{site.data.kong_latest.version}}.aws.amd64.rpm)

To install from the command line

```bash
$ curl -Lo kong-{{site.data.kong_latest.version}}.aws.amd64.rpm "{{ site.links.download }}/gateway-2.x-amazonlinux-2/Packages/k/kong-{{site.data.kong_latest.version}}.aws.amd64.rpm"
$ sudo yum install kong-{{site.data.kong_latest.version}}.aws.amd64.rpm
```

    {% endif %}

    {% if include.distribution == "centos" %}

- [CentOS 7]({{ site.links.download }}/gateway-2.x-centos-7/Packages/k/kong-{{site.data.kong_latest.version}}.el7.amd64.rpm)
- [CentOS 8]({{ site.links.download }}/gateway-2.x-centos-8/Packages/k/kong-{{site.data.kong_latest.version}}.el8.amd64.rpm)

To install from the command line

```bash
$ curl -Lo kong-{{site.data.kong_latest.version}}.amd64.rpm $( rpm --eval "{{ site.links.download }}/gateway-2.x-centos-%{centos_ver}/Packages/k/kong-{{site.data.kong_latest.version}}.el%{centos_ver}.amd64.rpm")
$ sudo yum install kong-{{site.data.kong_latest.version}}.amd64.rpm
```

    {% endif %}

    {% if include.distribution == "rhel" %}

- [Red Hat 7]({{ site.links.download }}/gateway-2.x-rhel-7/Packages/k/kong-{{site.data.kong_latest.version}}.rhel7.amd64.rpm)
- [Red Hat 8]({{ site.links.download }}/gateway-2.x-rhel-8/Packages/k/kong-{{site.data.kong_latest.version}}.rhel8.amd64.rpm)

To install from the command line using `yum`

```bash
$ curl -Lo kong-{{site.data.kong_latest.version}}.amd64.rpm $( rpm --eval "{{ site.links.download }}/gateway-2.x-rhel-7/Packages/k/kong-{{site.data.kong_latest.version}}.rhel%{rhel}.amd64.rpm")
$ sudo yum kong-{{site.data.kong_latest.version}}.amd64.rpm
```

To install from the command line using `rpm` directly (you will need Kong's dependencies installed separately)

```bash
$ curl -Lo kong.rpm $( rpm --eval "{{ site.links.download }}/gateway-2.x-rhel-7/Packages/k/kong-{{site.data.kong_latest.version}}.rhel%{rhel}.amd64.rpm")
rpm -iv kong.rpm
```

Installing directly using `rpm` is suitable for Red Hat's [Universal Base Image](https://developers.redhat.com/blog/2020/03/24/red-hat-universal-base-images-for-docker-users) "minimal" variant. You will need to install Kong's dependencies separately via `microdnf`

    {% endif %}

{% endnavtab %}
{% navtab Repository %}

**YUM Repositories**

    {% if include.distribution == "aws" %}

- [Amazon Linux 2]({{ site.links.download }}/gateway-2.x-amazonlinux-2/)

To install from the command line

```bash
$ curl {{ site.links.download }}/gateway-2.x-amazonlinux-2/config.repo | sudo tee /etc/yum.repos.d/kong.repo
$ sudo yum install -y kong
```

    {% endif %}

    {% if include.distribution == "centos" %}

- [CentOS 7]({{ site.links.download }}/gateway-2.x-centos-7/)
- [CentOS 8]({{ site.links.download }}/gateway-2.x-centos-8/)

To install from the command line

```bash
$ curl $(rpm --eval "{{ site.links.download }}/gateway-2.x-centos-%{centos_ver}/config.repo") | sudo tee /etc/yum.repos.d/kong.repo
$ sudo yum install -y kong
```

    {% endif %}

    {% if include.distribution == "rhel" %}

- [Red Hat 7]({{ site.links.download }}/gateway-2.x-rhel-7/)
- [Red Hat 8]({{ site.links.download }}/gateway-2.x-rhel-8/)

```bash
$ curl $(rpm --eval "{{ site.links.download }}/gateway-2.x-centos-%{rhel}/config.repo") | sudo tee /etc/yum.repos.d/kong.repo
$ sudo yum install -y kong
```

    {% endif %}

{% endnavtab %}
{% endnavtabs %}

{% include_cached /md/installation.md release=page.release %}
