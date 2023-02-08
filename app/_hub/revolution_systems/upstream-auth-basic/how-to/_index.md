### Installation

1. The [LuaRocks](http://luarocks.org){:target="_blank"}{:rel="noopener noreferrer"} package manager must be [Installed](https://github.com/luarocks/luarocks/wiki/Download){:target="_blank"}{:rel="noopener noreferrer"}.
2. [Kong](https://konghq.com) must be [Installed](https://konghq.com/install) and you must be familiar with using and configuring Kong.
3. Install the module kong-plugin-upstream-auth-basic.
```
luarocks install kong-plugin-upstream-auth-basic
```
4. Add the custom plugin to the `kong.conf` file (e.g. `/etc/kong/kong.conf`)
```
custom_plugins = ...,upstream-auth-basic
```
5. Restart kong
