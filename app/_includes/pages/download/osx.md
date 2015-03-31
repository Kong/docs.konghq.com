### OS X

1. Install dependencies:

    Install [Lua v5.1.5](http://www.lua.org/versions.html#5.1)

    ```
    brew install lua51
    ln /usr/local/bin/lua5.1 /usr/local/bin/lua # alias lua5.1 to lua (required for kong scripts)
    ```

    Install [Luarocks v2.2.1](http://luarocks.org)

   ```
    brew tap naartjie/luajit
    brew install naartjie/luajit/luarocks-luajit --with-lua51
   ```

    Install [OpenResty v1.7.10.1](http://openresty.com/)

    ```
    brew tap killercup/openresty
    brew install ngx_openresty
    ln /usr/local/bin/openresty /usr/local/bin/nginx # alias openresty to nginx (required for kong scripts)
    ```

2. Install Kong:

    ```bash
    luarocks install kong {{site.latest}}
    ```

3. Start Kong:

    Before starting Kong, make sure [Cassandra v2.1.3](http://cassandra.apache.org/) is running and [`kong.yml`](/docs/getting-started/configuration/) points to the right Cassandra server. Then execute:

    ```bash
    kong start
    ```

    You can install Cassandra with:

    ```
    brew install cassandra
    # to start cassandra, just run `cassandra`
    ```

4. Kong is running:

    ```bash
    curl http://127.0.0.1:8001
    ```