{% capture cassandra_version %}{{site.data.kong_latest.dependencies.cassandra}}{% endcapture %}

### CentOS 6/7

1. **Installation:**

    Add the following in your `/etc/yum.repos.d/` directory in a file named (for example) `kong.repo`

    ```
    [kong]
    name = Kong
    baseurl = http://mashape-kong-yum-repo.s3-website-us-east-1.amazonaws.com/$releasever/$basearch
    enabled = 1
    gpgcheck = 0
    ```

    Then execute:

    ```bash
    yum install kong
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

4. **Getting Started**

    Quickly learn how to use Kong with the [5-minute Quickstart](/docs/{{site.data.kong_latest.version}}/quickstart).