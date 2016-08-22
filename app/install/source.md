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
{% capture serf_version %}{{site.data.kong_latest.dependencies.serf}}{% endcapture %}

1. **Install the dependencies:**

    (Optional) [Dnsmasq](http://www.thekelleys.org.uk/dnsmasq/) if you wish to enable it for Kong's runtime DNS resolutions.

    [OpenResty {{openresty_version}}](https://openresty.org/en/installation.html). Kong being an OpenResty application, you must follow the OpenResty [installation instructions](https://openresty.org/en/installation.html). You will need [OpenSSL](https://www.openssl.org/) and [PCRE](http://www.pcre.org/) to compile OpenResty, and to at least use the following compilation options:

    ```bash
    $ ./configure \
      --with-pcre-jit \
      --with-ipv6 \
      --with-http_realip_module \
      --with-http_ssl_module \
      --with-http_stub_status_module
    ```

    You might have to specify `--with-openssl` and you can add any other option you'd like, such as additional Nginx modules or a custom `--prefix` directory.

    OpenResty conveniently bundles [LuaJIT](http://luajit.org/) and [resty-cli](https://github.com/openresty/resty-cli) which are essential to Kong. Add the `nginx` and `resty` executables to your $PATH:

    ```bash
    $ export PATH="$PATH:/usr/local/openresty/bin"
    ```

    [Luarocks {{luarocks_version}}](https://github.com/keplerproject/luarocks/wiki/Download), compiled with the LuaJIT version bundled with OpenResty (See the `--with-lua` and `--with-lua-include` configure options). Example:

    ```bash
    ./configure \
      --lua-suffix=jit \
      --with-lua=/usr/local/openresty/luajit \
      --with-lua-include=/usr/loca/openresty/luajit/include/luajit-2.1
    ```

    Finally, the [Serf v{{serf_version}}](https://www.serf.io/) executable should be available in one of `/usr/local/bin` or `/usr/bin`. You can use it from a custom location assuming you configure the Kong's `serf_path` property accordingly.

    Consulting the [setup_env.sh](https://github.com/Mashape/kong/blob/next/.ci/setup_env.sh) CI script is a good resource for a concrete example of those instructions. Notice how Serf is used from a custom location which is specified using an environment variable in [run_tests.sh](https://github.com/Mashape/kong/blob/next/.ci/run_tests.sh).

2. **Install Kong:**

    Now that OpenResty and other third-party dependencies are installed, we can use Luarocks to install Kong's Lua sources:

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

[configuration]: /docs/{{site.data.kong_latest.release}}/configuration#database
