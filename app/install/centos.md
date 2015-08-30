---
id: page-install-method
title: Downloads - CentOS
header_title: CentOS Installation
header_icon: /assets/images/icons/icn-installation.svg
breadcrumbs:
  Installation: /install
---

{% capture cassandra_version %}{{site.data.kong_latest.dependencies.cassandra}}{% endcapture %}

### Packages:

Start by downloading the corresponding package for your configuration:

- [CentOS 5/RHEL5]({{ site.repos.kong }}/releases/download/{{ site.data.kong_latest.version }}/kong-{{ site.data.kong_latest.version }}.el5.noarch.rpm)
- [CentOS 6/RHEL6]({{ site.repos.kong }}/releases/download/{{ site.data.kong_latest.version }}/kong-{{ site.data.kong_latest.version }}.el6.noarch.rpm)
- [CentOS 7/RHEL7]({{ site.repos.kong }}/releases/download/{{ site.data.kong_latest.version }}/kong-{{ site.data.kong_latest.version }}.el7.noarch.rpm)

----

### Installation:

1. **Install the Package:**

    After downloading the [package](#packages), execute:

    ```bash
    $ sudo yum install epel-release
    $ sudo yum install kong-{{site.data.kong_latest.version}}.*.noarch.rpm --nogpgcheck
    ```

2. **Configure Cassandra**

    Before starting Kong, make sure you have [installed](http://www.apache.org/dyn/closer.cgi?path=/cassandra/{{cassandra_version}}/apache-cassandra-{{cassandra_version}}-bin.tar.gz) or [provisioned](http://kongdb.org) Cassandra v{{cassandra_version}} and updated [`/etc/kong/kong.yml`](/docs/{{site.data.kong_latest.release}}/configuration/#databases_available.*).

3. **Start Kong:**

    ```bash
    $ kong start

    # Kong is running
    $ curl 127.0.0.1:8001
    ```

4. **Use Kong:**

    Quickly learn how to use Kong with the [5-minute Quickstart](/docs/{{site.data.kong_latest.release}}/getting-started/quickstart).
