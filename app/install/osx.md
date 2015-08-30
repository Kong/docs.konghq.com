---
id: page-install-method
title: Downloads - OS X
header_title: OS X Installation
header_icon: /assets/images/icons/icn-installation.svg
breadcrumbs:
  Installation: /install
---

{% capture cassandra_version %}{{site.data.kong_latest.dependencies.cassandra}}{% endcapture %}

### Packages:

- [.pkg Installer]({{ site.repos.kong }}/releases/download/{{site.data.kong_latest.version}}/kong-{{site.data.kong_latest.version}}.osx.pkg)
- [Homebrew Formula](https://github.com/Mashape/homebrew-kong)

----

### Installation:

1. **Install the Package:**

    **Note**: After downloading the [Installer](#packages), you will have to **right click**, select "Open" and authorize it.

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
