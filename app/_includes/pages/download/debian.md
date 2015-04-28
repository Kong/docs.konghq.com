{% capture cassandra_version %}{{site.data.kong_latest.dependencies.cassandra}}{% endcapture %}

### Debian 6/7

1. **Installation:**

    For Debian 6 Squeeze download this package: [kong-0.2.0-2.squeeze_all.deb](https://github.com/Mashape/kong/releases/download/0.2.0-2/kong-0.2.0-2.squeeze_all.deb)

    For Debian 7 Wheezy download this package: [kong-0.2.0-2.wheezy_all.deb](https://github.com/Mashape/kong/releases/download/0.2.0-2/kong-0.2.0-2.wheezy_all.deb)

    Then execute:

    ```bash
    sudo apt-get update
    sudo apt-get install kong-0.2.0_2.*.deb
    sudo apt-get install -f
    ```

2. **Start Kong:**

    Before starting Kong, make sure [Cassandra v{{cassandra_version}}](http://cassandra.apache.org/) is running and [`kong.yml`](/docs/{{site.data.kong_latest.version}}/configuration) points to the right Cassandra server. Then execute:

    ```bash
    kong start
    ```

3. **Kong is running:**

    ```bash
    curl http://127.0.0.1:8001
    ```

4. **Start using Kong:**

    Quickly learn how to use Kong with the [5-minute Quickstart](/docs/{{site.data.kong_latest.version}}/getting-started/quickstart).