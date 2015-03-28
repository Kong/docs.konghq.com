### Other

1. Install dependencies:

    Install [OpenResty v1.7.10.1](http://openresty.com/)

    Install [Lua v5.1.5](http://www.lua.org/versions.html#5.1)

    Install [Luarocks v2.2.1](http://luarocks.org)

    Some of the dependencies may be available in your favorite package manager.

2. Install Kong:

    ```bash
    luarocks install kong {{site.latest}}
    ```

3. Start Kong:

    Before starting Kong, make sure [Cassandra v2.1.3](http://cassandra.apache.org/) is running and [`kong.yml`](/docs/getting-started/configuration/) points to the right Cassandra server. Then execute:

    ```bash
    kong start
    ```

4. Kong is running:

    ```bash
    curl http://127.0.0.1:8001
    ```
