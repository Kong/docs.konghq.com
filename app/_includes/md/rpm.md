
## Installation

Kong can be installed by downloading an installation package or from our yum repository

{% navtabs %}
{% navtab Packages %}

**Installation packages**

{% if include.distribution == "aws" %}

- [Amazon Linux 2]({{ site.links.download }}/gateway-2.x-amazonlinux-2/Packages/k/kong-{{site.data.kong_latest.version}}.aws.amd64.rpm)

To install from the command line

```bash
$ sudo yum install $(rpm --eval "{{ site.links.download }}/gateway-2.x-amazonlinux-2/Packages/k/kong-{{site.data.kong_latest.version}}.aws.amd64.rpm")
```

{% endif %}

{% if include.distribution == "centos" %}

- [CentOS 6]({{ site.links.download }}/gateway-2.x-centos-6/Packages/k/kong-{{site.data.kong_latest.version}}.el6.amd64.rpm)
- [CentOS 7]({{ site.links.download }}/gateway-2.x-centos-7/Packages/k/kong-{{site.data.kong_latest.version}}.el7.amd64.rpm)
- [CentOS 8]({{ site.links.download }}/gateway-2.x-centos-8/Packages/k/kong-{{site.data.kong_latest.version}}.el8.amd64.rpm)

To install from the command line

```bash
$ sudo yum install $(rpm --eval "{{ site.links.download }}/gateway-2.x-centos-%{centos_ver}/Packages/k/kong-{{site.data.kong_latest.version}}.el%{centos_ver}.amd64.rpm")
```

{% endif %}

{% if include.distribution == "rhel" %}

- [Redhat 7]({{ site.links.download }}/gateway-2.x-rhel-7/Packages/k/kong-{{site.data.kong_latest.version}}.rhel7.noarch.rpm)
- [Redhat 8]({{ site.links.download }}/gateway-2.x-rhel-8/Packages/k/kong-{{site.data.kong_latest.version}}.rhel8.noarch.rpm)

To install from the command line

```bash
$ sudo yum install $(rpm --eval "{{ site.links.download }}/gateway-2.x-rhel-%{rhel}/Packages/k/kong-{{site.data.kong_latest.version}}.rhel%{rhel}.noarch.rpm")
```

{% endif %}

{% endnavtab %}
{% navtab Repository %}

**YUM Repositories**

{% if include.distribution == "aws" %}

- [Amazon Linux 2]({{ site.links.download }}/gateway-community/aws/2/)

To install from the command line

```bash
$ curl $(rpm --eval "{{ site.links.download }}/gateway-community/aws/2/config.repo") | sudo tee /etc/yum.repos.d/kong.repo
$ sudo yum info kong
$ sudo yum install -y kong-{{site.data.kong_latest.version}}
```

{% else %}

- [CentOS 6]({{ site.links.download }}/gateway-2.x-centos-6/)
- [CentOS 7]({{ site.links.download }}/gateway-2.x-centos-7/)
- [CentOS 8]({{ site.links.download }}/gateway-2.x-centos-8/)

To install from the command line

```bash
$ curl $(rpm --eval "{{ site.links.download }}/gateway-community/%{DISTRIBUTION}/%{rhel}/config.repo") | sudo tee /etc/yum.repos.d/kong.repo
$ sudo yum info kong
$ sudo yum install -y kong-{{site.data.kong_latest.version}}
```

{% endif %}

{% endnavtab %}
{% endnavtabs %}

{% include /md/installation.md %}
