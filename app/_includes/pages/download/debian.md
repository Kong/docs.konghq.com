{% capture cassandra_version %}{{site.data.kong_latest.dependencies.cassandra}}{% endcapture %}

### Debian 6/7/8

1. **Installation:**

    For Debian 6 Squeeze download this package: [kong-0.2.0-2.squeeze_all.deb](https://github.com/Mashape/kong/releases/download/0.2.0-2/kong-0.2.0-2.squeeze_all.deb)

    For Debian 7 Wheezy download this package: [kong-0.2.0-2.wheezy_all.deb](https://github.com/Mashape/kong/releases/download/0.2.0-2/kong-0.2.0-2.wheezy_all.deb)

    For Debian 8 Jessie download this package: [kong-0.2.0-2.jessie_all.deb](https://github.com/Mashape/kong/releases/download/0.2.0-2/kong-0.2.0-2.jessie_all.deb)

    Then execute:

    ```bash
    $ sudo apt-get update
    $ sudo dpkg -i kong-0.2.0-2.*.deb
    $ sudo apt-get install -f
    ```

2. **Configure Cassandra**

    Before starting Kong, make sure you have [installed](http://www.apache.org/dyn/closer.cgi?path=/cassandra/{{cassandra_version}}/apache-cassandra-{{cassandra_version}}-bin.tar.gz) or [provisioned](http://kongdb.org) Cassandra v{{cassandra_version}} and updated [`/etc/kong/kong.yml`](/docs/{{site.data.kong_latest.version}}/configuration/#databases_available.*).

3. **Start Kong:**

    ```bash
    $ kong start

    # Kong is running
    $ curl 127.0.0.1:8001
    ```

4. **Use Kong:**

    Quickly learn how to use Kong with the [5-minute Quickstart](/docs/{{site.data.kong_latest.version}}/getting-started/quickstart).
