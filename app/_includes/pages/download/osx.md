{% capture cassandra_version %}{{site.data.kong_latest.dependencies.cassandra}}{% endcapture %}

### OS X

1. **Installation**

    *Package*

    You can download a **.pkg** installer at: [kong-0.2.0-2.pkg](https://github.com/Mashape/kong/releases/download/0.2.0-2/kong-0.2.0-2.pkg). After installing the package you can skip to step 2.

    *Homebrew*

    Kong is also available as a **Homebrew formula** (with Cassandra included) on GitHub: [Mashape/homebrew-kong](https://github.com/Mashape/homebrew-kong).

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
