{% capture lua_version %}{{site.data.kong_latest.dependencies.lua}}{% endcapture %}
{% capture luarocks_version %}{{site.data.kong_latest.dependencies.luarocks}}{% endcapture %}
{% capture dnsmasq_version %}{{site.data.kong_latest.dependencies.dnsmasq}}{% endcapture %}
{% capture cassandra_version %}{{site.data.kong_latest.dependencies.cassandra}}{% endcapture %}
{% capture openresty_version %}{{site.data.kong_latest.dependencies.openresty}}{% endcapture %}


### Other

1. **Install dependencies:**

    Install [Lua v{{lua_version}}](http://www.lua.org/versions.html#5.1)

    Install [Luarocks v{{luarocks_version}}](https://github.com/keplerproject/luarocks/wiki/Download)

    Install [Dnsmasq](http://www.thekelleys.org.uk/dnsmasq/)

    Install [OpenResty v{{openresty_version}}](http://openresty.com/#Installation) (OpenResty has some dependencies of its own), with the following `configure` options:

    ```bash
    $ ./configure --with-pcre-jit --with-ipv6 --with-http_realip_module --with-http_ssl_module --with-http_stub_status_module
    ```

    Install [OpenSSL](https://www.openssl.org/)

    Install [PCRE](http://www.pcre.org/)

    Some of the dependencies may be available in your favorite package manager.

2. **Install Kong:**

    ```bash
    $ luarocks install kong {{site.data.kong_latest.luarocks_version}}
    ```

3. **Configure Cassandra**

    Before starting Kong, make sure you have [installed](http://www.apache.org/dyn/closer.cgi?path=/cassandra/{{cassandra_version}}/apache-cassandra-{{cassandra_version}}-bin.tar.gz) or [provisioned](http://kongdb.org) Cassandra v{{cassandra_version}} and updated [`/etc/kong/kong.yml`](/docs/{{site.data.kong_latest.version}}/configuration/#databases_available.*).

4. **Start Kong:**

    ```bash
    $ kong start

    # Kong is running
    $ curl 127.0.0.1:8001
    ```

4. **Use Kong:**

    Quickly learn how to use Kong with the [5-minute Quickstart](/docs/{{site.data.kong_latest.version}}/getting-started/quickstart).
