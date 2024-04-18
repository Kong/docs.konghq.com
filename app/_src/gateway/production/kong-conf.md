---
title: Kong Configuration File
content-type: how-to
---

{{site.base_gateway}} comes with a default configuration file `kong.conf`. If you installed {{site.base_gateway}} using an official package, this file can be found at `/etc/kong/kong.conf.default`. 

The {{site.base_gateway}} configuration file is a YAML file that can be used to configure individual properties of your Kong instance. This guide explains how to configure {{site.base_gateway}} using the `kong.conf` file.

For all available parameters in `kong.conf`, see the [Configuration Parameter reference](/gateway/{{page.release}}/reference/configuration/). 

## Configure {{site.base_gateway}}

To configure {{site.base_gateway}}, make a copy of the default configuration file: 

```bash
cp /etc/kong/kong.conf.default /etc/kong/kong.conf
```

The file contains configuration properties and documentation: 

```bash
#upstream_keepalive_pool_size = 60  # Sets the default size of the upstream
                                    # keepalive connection pools.
                                    # Upstream keepalive connection pools
                                    # are segmented by the `dst ip/dst
                                    # port/SNI` attributes of a connection.
                                    # A value of `0` will disable upstream
                                    # keepalive connections by default, forcing
                                    # each upstream request to open a new
                                    # connection.
```

To configure a property, uncomment it and modify the value:

```bash
upstream_keepalive_pool_size = 40
```

Boolean values can be specified as `on`/`off` or `true`/`false`:

```bash
#dns_no_sync = off               # If enabled, then upon a cache-miss every
                                 # request will trigger its own dns query.
                                 # When disabled multiple requests for the
                                 # same name/type will be synchronised to a
                                 # single query.
```

{:.note}
> {{site.base_gateway}} will use the default settings for any value in `kong.conf` that is commented out.

## Verify configuration
To verify that your configuration is usable, use the `check` command. The `check` command will evaluate the [environment variables](/gateway/{{page.release}}/production/environment-variables/) you have
currently set, and will output an error if your settings are invalid. 

```bash
kong check /etc/kong/kong.conf
```
If your configuration is valid the shell will output:

```bash
configuration at /etc/kong/kong.conf is valid
```

## Set custom path

By default, {{site.base_gateway}} looks for `kong.conf` in two
default locations:

```
/etc/kong/kong.conf
/etc/kong.conf
```

You can override this behavior by specifying a custom path for your
configuration file using the `-c / --conf` argument in the CLI:

```bash
kong start --conf /path/to/kong.conf
```

### Debug mode

You can use the [{{site.base_gateway}} CLI](/gateway/{{page.release}}/reference/cli/) in debug-mode to output configuration properties in the shell:

```bash
kong start -c /etc/kong.conf --vv

2016/08/11 14:53:36 [verbose] no config file found at /etc/kong.conf
2016/08/11 14:53:36 [verbose] no config file found at /etc/kong/kong.conf
2016/08/11 14:53:36 [debug] admin_listen = "0.0.0.0:8001"
2016/08/11 14:53:36 [debug] database = "postgres"
2016/08/11 14:53:36 [debug] log_level = "notice"
[...]
```


## More Information

* [Embedding Kong in OpenResty](/gateway/{{page.release}}/production/kong-openresty/)
* [Setting environment variables](/gateway/{{page.release}}/production/environment-variables/)
* [How to serve an API and a website with Kong](/gateway/{{page.release}}/production/website-api-serving/)
* [Configuration parameter reference](/gateway/{{page.release}}/reference/configuration/)
