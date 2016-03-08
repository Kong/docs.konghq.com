---
id: page-install-method
title: Install - Compile From Source
header_title: Compile Source
header_icon: /assets/images/icons/icn-installation.svg
breadcrumbs:
  Installation: /install
redirect_from: /install/compile/
---

{% capture luajit_version %}{{site.data.kong_latest.dependencies.luajit}}{% endcapture %}
{% capture luarocks_version %}{{site.data.kong_latest.dependencies.luarocks}}{% endcapture %}
{% capture openresty_version %}{{site.data.kong_latest.dependencies.openresty}}{% endcapture %}

1. **Install the dependencies:**

    (Optional) [Dnsmasq](http://www.thekelleys.org.uk/dnsmasq/).

    [LuaJIT {{luajit_version}}](http://luajit.org/download.html), which both Luarocks and OpenResty depend on. Also make sure to add it to your `$PATH` so the Kong CLI can find it.

    [Luarocks {{luarocks_version}}](https://github.com/keplerproject/luarocks/wiki/Download), compiled with the previously installed LuaJIT (See the `--with-lua` and `--with-lua-include` configure options).

    To compile OpenResty: [OpenSSL](https://www.openssl.org/) and [PCRE](http://www.pcre.org/).

    [OpenResty {{openresty_version}}](http://openresty.com/#Installation), compiled with the previously installed LuaJIT (See the `--with-luajit` configure option).

    Make sure to use the following `configure` options:

    ```bash
    $ ./configure \
      --with-pcre-jit \
      --with-ipv6 \
      --with-http_realip_module \
      --with-http_ssl_module \
      --with-http_stub_status_module \
      --with-luajit=/path/to/luajit
    ```

    Some of the dependencies may be available in the package manager of your choice.

2. **Install Kong:**

    ```bash
    $ luarocks install kong {{site.data.kong_latest.luarocks_version}}
    ```

    **Or**:

    ```bash
    $ git clone git@github.com:Mashape/kong.git
    $ [sudo] make install # this simply runs the `luarocks make kong-*.rockspec` command
    ```

2. **Configure your database**

    [Configure][configuration] Kong so it can connect to your database. Kong supports both [PostgreSQL {{site.data.kong_latest.dependencies.postgres}}](http://www.postgresql.org/) and [Cassandra {{site.data.kong_latest.dependencies.cassandra}}](http://cassandra.apache.org/) as its datastore.

4. **Start Kong:**

    ```bash
    $ kong start

    # Kong is running
    $ curl 127.0.0.1:8001
    ```

4. **Use Kong:**

    Quickly learn how to use Kong with the [5-minute Quickstart](/docs/latest/getting-started/quickstart).

[configuration]: /docs/{{page.kong_version}}/configuration#database
