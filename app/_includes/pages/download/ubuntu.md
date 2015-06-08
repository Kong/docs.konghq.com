{% capture cassandra_version %}{{site.data.kong_latest.dependencies.cassandra}}{% endcapture %}

### Ubuntu 12.04/14.04/15.04

1. **Installation:**

    For Ubuntu 12.04 Precise download this package: [kong-{{site.data.kong_latest.version}}.precise_all.deb](https://github.com/Mashape/kong/releases/download/{{site.data.kong_latest.version}}/kong-{{site.data.kong_latest.version}}.precise_all.deb)

    For Ubuntu 14.04 Trusty download this package: [kong-{{site.data.kong_latest.version}}.trusty_all.deb](https://github.com/Mashape/kong/releases/download/{{site.data.kong_latest.version}}/kong-{{site.data.kong_latest.version}}.trusty_all.deb)

    For Ubuntu 15.04 Vivid Vervet download this package: [kong-{{site.data.kong_latest.version}}.vivid_all.deb](https://github.com/Mashape/kong/releases/download/{{site.data.kong_latest.version}}/kong-{{site.data.kong_latest.version}}.vivid_all.deb)

    Then execute:

    ```bash
    $ sudo apt-get update
    $ sudo apt-get install netcat lua5.1 openssl libpcre3 dnsmasq
    $ sudo dpkg -i kong-{{site.data.kong_latest.version}}.*.deb
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
