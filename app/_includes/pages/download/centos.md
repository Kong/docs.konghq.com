{% capture cassandra_version %}{{site.data.kong_latest.dependencies.cassandra}}{% endcapture %}

### CentOS 5/6/7

1. **Installation:**

    For CentOS 5/RHEL5 download this package: [kong-0.2.0_2.el5.noarch.rpm](https://github.com/Mashape/kong/releases/download/0.2.0-2/kong-0.2.0_2.el5.noarch.rpm)

    For CentOS 6/RHEL6 download this package: [kong-0.2.0_2.el6.noarch.rpm](https://github.com/Mashape/kong/releases/download/0.2.0-2/kong-0.2.0_2.el6.noarch.rpm)

    For CentOS 7/RHEL7 download this package: [kong-0.2.0_2.el7.noarch.rpm](https://github.com/Mashape/kong/releases/download/0.2.0-2/kong-0.2.0_2.el7.noarch.rpm)

    Then execute:

    ```bash
    sudo yum install kong-0.2.0_2.*.noarch.rpm --nogpgcheck
    ```

2. **Start Kong:**

    Before starting Kong, make sure [Cassandra v{{cassandra_version}}](http://cassandra.apache.org/) is running and [`/etc/kong/kong.yml`](/docs/{{site.data.kong_latest.version}}/configuration) points to the right Cassandra server. Then execute:


    ```bash
    kong start
    ```

3. **Kong is running:**

    ```bash
    curl http://127.0.0.1:8001
    ```

4. **Start using Kong:**

    Quickly learn how to use Kong with the [5-minute Quickstart](/docs/{{site.data.kong_latest.version}}/getting-started/quickstart).