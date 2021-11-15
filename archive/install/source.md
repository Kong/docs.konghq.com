---
id: page-install-method
title: Install - Compile From Source
header_title: Compile Source
header_icon: /assets/images/icons/icn-installation.svg
breadcrumbs:
  Installation: /install
---

{% capture luajit_version %}{{site.data.kong_latest.dependencies.luajit}}{% endcapture %}
{% capture luarocks_version %}{{site.data.kong_latest.dependencies.luarocks}}{% endcapture %}
{% capture openresty_version %}{{site.data.kong_latest.dependencies.openresty}}{% endcapture %}
{% capture openssl_version %}{{site.data.kong_latest.dependencies.openssl}}{% endcapture %}
{% capture libyaml_version %}{{site.data.kong_latest.dependencies.libyaml}}{% endcapture %}
{% capture pcre_version %}{{site.data.kong_latest.dependencies.pcre}}{% endcapture %}

Kong can run either with or without a database.

When using a database, you will use the `kong.conf` configuration file for setting Kong's
configuration properties at start-up, and the database as storage of all configured entities,
such as the Routes and Services to which Kong proxies.

When not using a database, you will use environment variables, and a `kong.yml`
file for specifying the entities as a declarative configuration.

## With a Database

**About the dependencies**

Kong depends on several components (the versions mentioned are the preferred ones):
1. [OpenResty {{openresty_version}}](https://openresty.org/en/installation.html)
2. [Nginx Patches](https://github.com/Kong/kong-build-tools/tree/master/openresty-build-tools/patches)
3. [OpenResty Patches](https://github.com/Kong/kong-build-tools/tree/master/openresty-patches/patches/{{openresty_version}})
4. [Kong Nginx Module](https://github.com/Kong/lua-kong-nginx-module/)
5. [OpenSSL {{openssl_version}}](https://www.openssl.org/)
6. [PCRE {{pcre_version}}](http://www.pcre.org/)
7. [LuaRocks {{luarocks_version}}](https://github.com/luarocks/luarocks/wiki/Download)
8. [LibYAML {{libyaml_version}}](https://pyyaml.org/wiki/LibYAML)

It is not trivial to get everything built correctly, thus we provide
[kong-build-tools](https://github.com/Kong/kong-build-tools/).

1. **Build the dependencies**

   At first, you need to clone `kong-build-tools`:

   ```bash
   $ mkdir kong-sources
   $ cd kong-sources
   $ git clone git@github.com:Kong/kong-build-tools.git
   ```

   Then you need to build the dependencies:

   ```bash
   $ ./kong-build-tools/openresty-build-tools/kong-ngx-build \
       --prefix deps \
       --work work \
       --openresty {{openresty_version}} \
       --openssl {{openssl_version}} \
       --kong-nginx-module master \
       --luarocks {{luarocks_version}} \
       --pcre {{pcre_version}} \
       --jobs 6 \
       --force
   ```

   Now, you should have the dependencies built, but before we continue,
   let's export some environment variables:

   ```bash
   $ export OPENSSL_DIR=$(pwd)/deps/openssl
   $ export PATH=$(pwd)/deps/openresty/bin:$PATH
   $ export PATH=$(pwd)/deps/openresty/nginx/sbin:$PATH
   $ export PATH=$(pwd)/deps/openssl/bin:$PATH
   $ export PATH=$(pwd)/deps/luarocks/bin:$PATH
   ```

   Check everything is working:

   ```bash
   $ nginx -V
   $ resty -v
   $ openresty -V
   $ openssl version -a
   $ luarocks --version
   ```

   You will also need [`LibYAML {{libyaml_version}}`](https://pyyaml.org/wiki/LibYAML)
   that you can install either manually or by using your operating system packages:
   1. Ubuntu: `apt install libyaml-dev`
   2. Fedora: `dnf install libyaml-devel`
   3. macOS: `brew install libyaml`

   At this point you may continue to the next step, but if you are interested in
   running Go plugins, please follow the [Go guide][go].

2. **Install Kong**

    ```bash
    $ git clone git@github.com:Kong/kong.git
    $ cd kong
    $ git checkout {{site.data.kong_latest.version}}
    $ make install
    $ cd ..
    ```

    Finally, place the `bin/kong` script in your `$PATH`:

    ```bash
    $ export PATH=$(pwd)/kong/bin:$PATH
    ```

    Check everything is working:

    ```bash
    $ kong version --vv
    ```

    You can also install Kong with `LuaRocks`. but you will need to install
    the [`kong`](https://github.com/Kong/kong/blob/master/bin/kong) script
    manually:

    ```bash
    $ luarocks install kong {{site.data.kong_latest.luarocks_version}}
    ```

3. **Add `kong.conf`**

    **Note**: This step is **required** if you are using Cassandra; it is **optional** for Postgres users.

    By default, Kong is configured to communicate with a local Postgres instance.
    If you are using Cassandra, or need to modify any settings, copy the default
    configuration file and [adjust][configuration] it as necessary.

    ```bash
    $ cp kong/kong.conf.default kong.conf
    $ <vim|nano|…> kong.conf
    ```

    You may also place the configuration file to `/etc/kong` where Kong can automatically detect it
    on start:   

    ```bash
    $ [sudo] mkdir --parents /etc/kong
    $ [sudo] cp kong.conf /etc/kong
    ```

4. **Prepare your database**

    [Configure][configuration] Kong so it can connect to your database. Kong
    supports both [PostgreSQL {{site.data.kong_latest.dependencies.postgres}}](http://www.postgresql.org/)
    and [Cassandra {{site.data.kong_latest.dependencies.cassandra}}](http://cassandra.apache.org/)
    as its datastore.

    If you are using Postgres, provision a database and a user before starting Kong:

    ```sql
    CREATE USER kong;
    CREATE DATABASE kong OWNER kong;
    ```

    Next, run the Kong migrations:

    ```bash
    $ kong migrations bootstrap [-conf kong.conf]
    ```

5. **Start Kong**

    ```bash
    $ kong start --prefix node [--conf kong.conf]
    ```

    `prefix` is also optional or can be specified in `kong.conf`, but in the above
    example we decided to specify it for illustrative purposes.

6. **Use Kong**

    Verify that Kong is running:

    ```bash
    $ curl --include http://localhost:8001/
    ```

    Quickly learn how to use Kong with the [5-minute Quickstart](/gateway-oss/latest/getting-started/quickstart).

## Without a database

1. Follow steps 1 and 2 (Build the dependencies, Install Kong) from the list above.

2. **Write a declarative configuration file**

    The following command will generate a `kong.yml` file in your current folder.
    It contains instructions about how to fill it up. Follow the
    [Declarative Configuration Format]: /gateway-oss/latest/db-less-and-declarative-config/#the-declarative-configuration-format
    instructions while doing so.

    ``` bash
    $ kong config init
    ```

3. **Start Kong**

    On database configuration steps above, we used `kong.conf` file for the configuration.
    Alternatively, you can use environment variables to configure Kong:

    ```bash
    $ KONG_DATABASE=off \
      KONG_DECLARATIVE_CONFIG=kong.yml \
      kong start --prefix node
    ```

4. **Use Kong**

    Verify that Kong is running, and it has the entities detailed in the declarative config file:

    ```bash
    $ curl --include http://localhost:8001/
    ```

[configuration]: /gateway-oss/latest/configuration#database
[go]: /gateway-oss/latest/external-plugins
