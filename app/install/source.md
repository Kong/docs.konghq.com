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

1. **Install the dependencies**

    [OpenResty {{openresty_version}}](https://openresty.org/en/installation.html).
    Kong being an OpenResty application, you must follow the OpenResty
    [installation instructions](https://openresty.org/en/installation.html).
    You will need [OpenSSL](https://www.openssl.org/) and
    [PCRE](http://www.pcre.org/) to compile OpenResty, and to at least use the
    following compilation options:

    ```bash
    $ ./configure \
      --with-pcre-jit \
      --with-http_ssl_module \
      --with-http_realip_module \
      --with-http_stub_status_module \
      --with-http_v2_module
    ```

    You might have to specify `--with-openssl` and you can add any other option
    you'd like, such as additional Nginx modules or a custom `--prefix` directory.

    OpenResty conveniently bundles [LuaJIT](http://luajit.org/) and
    [resty-cli](https://github.com/openresty/resty-cli) which are essential to
    Kong. Add the `nginx` and `resty` executables to your $PATH:

    ```bash
    $ export PATH="$PATH:/usr/local/openresty/bin"
    ```

    [Luarocks {{luarocks_version}}](https://github.com/keplerproject/luarocks/wiki/Download),
    compiled with the LuaJIT version bundled with OpenResty (See the
    `--with-lua` and `--with-lua-include` configure options). Example:

    ```bash
    ./configure \
      --lua-suffix=jit \
      --with-lua=/usr/local/openresty/luajit \
      --with-lua-include=/usr/local/openresty/luajit/include/luajit-2.1
    ```

1. **Install Kong**

    Now that OpenResty is installed, we can use Luarocks to install Kong's Lua sources:

    ```bash
    $ luarocks install kong {{site.data.kong_latest.luarocks_version}}
    ```

    **Or**:

    ```bash
    $ git clone git@github.com:Kong/kong.git
    $ cd kong
    $ [sudo] make install # this simply runs the `luarocks make kong-*.rockspec` command
    ```

    Finally, place the `bin/kong` script in your `$PATH`.

1. **Add `kong.conf`**

    **Note**: This step is **required** if you are using Cassandra; it is **optional** for Postgres users.

    By default, Kong is configured to communicate with a local Postgres instance.
    If you are using Cassandra, or need to modify any settings, download the [`kong.conf.default`](https://raw.githubusercontent.com/Kong/kong/master/kong.conf.default) file and [adjust][configuration] it as necessary.
    Then, as root, add it to `/etc`:

    ```bash
    $ sudo mkdir -p /etc/kong
    $ sudo cp kong.conf.default /etc/kong/kong.conf
    ```

1. **Prepare your database**

    [Configure][configuration] Kong so it can connect to your database. Kong
    supports both [PostgreSQL {{site.data.kong_latest.dependencies.postgres}}](http://www.postgresql.org/)
    and [Cassandra {{site.data.kong_latest.dependencies.cassandra}}](http://cassandra.apache.org/)
    as its datastore.

    If you are using Postgres, provision a database and a user before starting Kong:

    ```sql
    CREATE USER kong; CREATE DATABASE kong OWNER kong;
    ```

    Next, run the Kong migrations:

    ```bash
    $ kong migrations up [-c /path/to/kong.conf]
    ```

    **Note**: Migrations should never be run concurrently; only
    one Kong node should be performing migrations at a time.

1. **Start Kong**

    ```bash
    $ kong start [-c /path/to/kong.conf]
    ```

1. **Use Kong**

    Verify that Kong is running:

    ```bash
    $ curl -i http://localhost:8001/
    ```

    Quickly learn how to use Kong with the [5-minute Quickstart](/latest/getting-started/quickstart).

[configuration]: /{{site.data.kong_latest.release}}/configuration#database
