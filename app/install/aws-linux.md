---
id: page-install-method aws-marketplace
title: Install - Amazon Linux
header_title: Amazon Linux
header_icon: /assets/images/icons/icn-installation.svg
breadcrumbs:
  Installation: /install
---

{% capture cassandra_version %}{{site.data.kong_latest.dependencies.cassandra}}{% endcapture %}

### Packages:

Start by downloading the following package specifically built for the Amazon Linux AMI:

- [Download]({{ site.links.download }}/aws.rpm)

----

### Installation:

1. **Install the Package:**

    After downloading the [package](#packages), execute:

    ```bash
    $ sudo yum install epel-release
    $ sudo yum install kong-{{site.data.kong_latest.version}}.aws.rpm --nogpgcheck
    ```

2. **Configure Cassandra**

    Before starting Kong, make sure you have [installed](http://www.apache.org/dyn/closer.cgi?path=/cassandra/{{cassandra_version}}/apache-cassandra-{{cassandra_version}}-bin.tar.gz) or [provisioned](http://kongdb.org) Cassandra v{{cassandra_version}} and updated [`/etc/kong/kong.yml`](/docs/latest/configuration/#databases_available).

3. **Start Kong:**

    ```bash
    $ kong start

    # Kong is running
    $ curl 127.0.0.1:8001
    ```

4. **Use Kong:**

    Quickly learn how to use Kong with the [5-minute Quickstart](/docs/latest/getting-started/quickstart).
