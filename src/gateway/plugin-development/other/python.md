---
title: Write plugins in Python
content-type: explanation
---

## The Python PDK

{{site.base_gateway}} support for Python plugin development is provided by the [kong-python-pdk](https://github.com/Kong/kong-python-pdk) library.
The library provides a plugin server and Kong-specific
functions to interface with {{site.base_gateway}}.

## Install

To install the plugin server and PDK globally, use `pip`:

```
pip3 install kong-pdk
```

## Development

A {{site.base_gateway}} Python plugin implementation has following attributes:

```python
Schema = (
    { "message": { "type": "string" } },
)
version = '0.1.0'
priority = 0
class Plugin(object):
  pass
```

* A class named `Plugin` defines the class that implements this plugin. 
* A dictionary called `Schema` that defines expected values and data types of the plugin. 
* The variables `version` and `priority` that define the version number and priority of execution respectively.

{:.note}
>**Note**: [This repository](https://github.com/Kong/kong-python-pdk/tree/master/examples) contains example Python plugins and an [API reference](https://kong.github.io/kong-python-pdk/py-modindex.html).

## Phase handlers

You can implement custom logic to be executed at
various points of the request processing lifecycle. To execute
custom code during the access phase, define a function named `access`:

```python
class Plugin(object):
    def __init__(self, config):
        self.config = config
    def access(self, kong):
      pass
```

You can implement custom logic during the following phases using the same function signature:

- `certificate`
- `rewrite`
- `access`
- `response`
- `preread`
- `log`

The presence of the `response` handler automatically enables the buffered proxy mode.

### Type hints

Support for [type hints](https://www.python.org/dev/peps/pep-0484/) is available. To use type hints
and autocomplete in an IDE, add the the `kong` parameter to the phase handler function:

```python
import kong_pdk.pdk.kong as kong
class Plugin(object):
    def __init__(self, config):
        self.config = config
    def access(self, kong: kong.kong):
        host, err = kong.request.get_header("host")
```

## Embedded server

To use the embedded server, use the following code:

```python
if __name__ == "__main__":
    from kong_pdk.cli import start_dedicated_server
    start_dedicated_server("py-hello", Plugin, version, priority)
```

The first argument to `start_dedicated_server` defines the plugin name and must
be unique.

## Example configuration

To load plugins using the `kong.conf` [configuration file](/gateway/latest/kong-production/kong-conf), you have to map existing {{site.base_gateway}} properties to aspects of your plugin.
Below are two examples of loading plugins within `kong.conf`.

```
pluginserver_names = my-plugin,other-one
pluginserver_my_plugin_socket = /usr/local/kong/my-plugin.socket
pluginserver_my_plugin_start_cmd = /path/to/my-plugin.py
pluginserver_my_plugin_query_cmd = /path/to/my-plugin.py --dump
pluginserver_other_one_socket = /usr/local/kong/other-one.socket
pluginserver_other_one_start_cmd = /path/to/other-one.py
pluginserver_other_one_query_cmd = /path/to/other-one.py -dump
```

The socket and start command settings coincide with
their defaults and can be omitted:

```
pluginserver_names = my-plugin,other-one
pluginserver_my_plugin_query_cmd = /path/to/my-plugin --dump
pluginserver_other_one_query_cmd = /path/to/other-one --dump
```

## Concurrency model

The Python plugin server and the embedded server support concurrency. By default,
the server starts in multi-threading mode.

If your workload is IO intensive, you can use the [Gevent](http://www.gevent.org/) model by passing the `-g` flag to
`start_cmd` in `kong.conf`.
If your workload is CPU intensive, consider the multi-processing model by by passing the `-m` flag to
`start_cmd` in `kong.conf`.


## More Information
* [PDK Reference](/gateway/latest/plugin-development/pdk/)
* [Plugins with Containers](/gateway/latest/plugin-development/other/plugins-kubernetes)
* [Develop plugins with Go](/gateway/latest/plugin-development/other/go)
* [Develop plugins with JavaScript](/gateway/latest/plugin-development/other/javascript)