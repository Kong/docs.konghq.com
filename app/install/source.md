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
{% capture dnsmasq_version %}{{site.data.kong_latest.dependencies.dnsmasq}}{% endcapture %}
{% capture cassandra_version %}{{site.data.kong_latest.dependencies.cassandra}}{% endcapture %}
{% capture openresty_version %}{{site.data.kong_latest.dependencies.openresty}}{% endcapture %}

1. **Install the dependencies:**

    (Optional) [Dnsmasq](http://www.thekelleys.org.uk/dnsmasq/).

    [LuaJIT {{luajit_version}}](http://luajit.org/download.html), which both Luarocks and OpenResty depend on. Also make sure to add it to your `$PATH` so the Kong CLI can find it.

    [Luarocks {{luarocks_version}}](https://github.com/keplerproject/luarocks/wiki/Download), compiled with the previously installed LuaJIT (See the `--with-lua` and `--with-lua-include` configure options).

    To compile OpenResty: [OpenSSL](https://www.openssl.org/) and [PCRE](http://www.pcre.org/).

    [OpenResty {{openresty_version}}](http://openresty.com/#Installation), compiled with the previously installed LuaJIT (See the `--with-luajit` configure option).

    You need to apply a patch to Nginx core in order to enable the `ssl_certificate_by_lua` feature. You can follow the instructions [here](https://github.com/openresty/lua-nginx-module/issues/331#issuecomment-77279170).

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

3. **Configure Cassandra**

    Before starting Kong, make sure you have [installed](http://www.apache.org/dyn/closer.cgi?path=/cassandra/{{cassandra_version}}/apache-cassandra-{{cassandra_version}}-bin.tar.gz) or [provisioned](http://kongdb.org) Cassandra {{cassandra_version}} and updated [`/etc/kong/kong.yml`](/docs/latest/configuration/#databases_available).

4. **Start Kong:**

    ```bash
    $ kong start

    # Kong is running
    $ curl 127.0.0.1:8001
    ```

4. **Use Kong:**

    Quickly learn how to use Kong with the [5-minute Quickstart](/docs/latest/getting-started/quickstart).
