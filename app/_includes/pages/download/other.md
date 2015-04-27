{% capture lua_version %}{{site.data.kong_latest.dependencies.lua}}{% endcapture %}
{% capture luarocks_version %}{{site.data.kong_latest.dependencies.luarocks}}{% endcapture %}
{% capture cassandra_version %}{{site.data.kong_latest.dependencies.cassandra}}{% endcapture %}
{% capture openresty_version %}{{site.data.kong_latest.dependencies.openresty}}{% endcapture %}


### Other

1. **Install dependencies:**

    Install [Lua v{{lua_version}}](http://www.lua.org/versions.html#5.1)

    Install [Luarocks v{{luarocks_version}}](http://luarocks.org)

    Install [OpenResty v{{openresty_version}}](http://openresty.com/), with the following `configure` options:

    ```
    ./configure --with-pcre-jit --with-ipv6 --with-http_realip_module --with-http_ssl_module --with-http_stub_status_module
    ```

    Some of the dependencies may be available in your favorite package manager.

2. **Install Kong:**

    ```bash
    luarocks install kong {{site.data.kong_latest.version}}
    ```

3. **Start Kong:**

    Before starting Kong, make sure [Cassandra v{{cassandra_version}}](http://cassandra.apache.org/) is running and [`kong.yml`](/docs/{{site.data.kong_latest.version}}/configuration) points to the right Cassandra server. Then execute:

    ```bash
    kong start
    ```

4. **Kong is running:**

    ```bash
    curl http://127.0.0.1:8001
    ```

4. **Start using Kong:**

    Quickly learn how to use Kong with the [5-minute Quickstart](/docs/{{site.data.kong_latest.version}}/getting-started/quickstart).