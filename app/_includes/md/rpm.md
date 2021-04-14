
## Installation

Kong can be installed by downloading an installation package or from our yum repository

{% navtabs %}
{% navtab Packages %}

- [CentOS 6]({{ site.links.download }}/gateway-community/centos/6/Packages/k/kong-{{site.data.kong_latest.version}}.el6.amd64.rpm)
- [CentOS 7]({{ site.links.download }}/gateway-community/centos/7/Packages/k/kong-{{site.data.kong_latest.version}}.el7.amd64.rpm)
- [CentOS 8]({{ site.links.download }}/gateway-community/centos/8/Packages/k/kong-{{site.data.kong_latest.version}}.el8.amd64.rpm)

To install from the command line

```bash
$ sudo yum install $(rpm --eval "{{ site.links.download }}/gateway-community/centos/%{centos_ver}/Packages/k/kong-{{site.data.kong_latest.version}}.el%{centos_ver}.amd64.rpm")
```

{% endnavtab %}
{% navtab Repository %}

**YUM Repositories**

- [CentOS 6]({{ site.links.download }}/gateway-community/centos/6/)
- [CentOS 7]({{ site.links.download }}/gateway-community/centos/7/)
- [CentOS 8]({{ site.links.download }}/gateway-community/centos/8/)

To install from the command line

```bash
$ curl $(rpm --eval "{{ site.links.download }}/gateway-community/centos/%{centos_ver}/config.repo") | sudo tee /etc/yum.repos.d/kong.repo
$ sudo yum info kong
$ sudo yum install -y kong-{{site.data.kong_latest.version}}
```

{% endnavtab %}
{% endnavtabs %}

{% include /md/installation.md %}
