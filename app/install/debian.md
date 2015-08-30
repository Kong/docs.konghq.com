---
id: page-install-method
title: Downloads - Debian
header_title: Debian Installation
header_icon: /assets/images/icons/icn-installation.svg
breadcrumbs:
  Installation: /install
---

{% capture cassandra_version %}{{ site.data.kong_latest.dependencies.cassandra }}{% endcapture %}

### Packages:

Start by downloading the corresponding package for your configuration:

- [Debian 6 Squeeze ]({{ site.repos.kong }}/releases/download/{{site.data.kong_latest.version}}/kong-{{site.data.kong_latest.version}}.squeeze_all.deb)
- [Debian 7 Wheezy]({{ site.repos.kong }}/releases/download/{{site.data.kong_latest.version}}/kong-{{site.data.kong_latest.version}}.wheezy_all.deb)
- [Debian 8 Jessie]({{ site.repos.kong }}/releases/download/{{site.data.kong_latest.version}}/kong-{{site.data.kong_latest.version}}.jessie_all.deb)

----

### Installation:

1. **Install the Package:**

    After downloading the [package](#packages), execute:

    ```bash
    $ sudo apt-get update
    $ sudo apt-get install netcat lua5.1 openssl libpcre3 dnsmasq
    $ sudo dpkg -i kong-{{site.data.kong_latest.version}}.*.deb
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
