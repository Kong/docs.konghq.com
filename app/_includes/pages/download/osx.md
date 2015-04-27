{% capture cassandra_version %}{{site.data.kong_latest.dependencies.cassandra}}{% endcapture %}

### Homebrew

Kong is available as a Homebrew recipe on GitHub: [Mashape/homebrew-kong](https://github.com/Mashape/homebrew-kong).

1. **Installation**

    ```bash
    brew tap mashape/kong
    brew install kong
    ```

    **(Optional)** If you want to use a local Cassandra cluster, this tap can also install the homebrew/cassandra formula if you run it with:

    ```bash
    brew tap mashape/kong
    brew update # for the cassandra formula
    brew install kong --with-cassandra
    ```

2. **Start Kong:**

    Before starting Kong, make sure [Cassandra v{{cassandra_version}}](http://cassandra.apache.org/) is running and [`kong.yml`](/docs/{{site.data.kong_latest.version}}/configuration) points to the right Cassandra server. Then execute:

    ```bash
    kong start
    ```

    You can install Cassandra with:

    ```
    brew install cassandra
    # to start cassandra, just run `cassandra`
    ```

3. **Kong is running:**

    ```bash
    curl http://127.0.0.1:8001
    ```

4. **Start using Kong:**

    Quickly learn how to use Kong with the [5-minute Quickstart](/docs/{{site.data.kong_latest.version}}/getting-started/quickstart).