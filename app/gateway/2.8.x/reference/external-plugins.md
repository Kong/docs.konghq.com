---
title: Plugins in Other Languages

---

## Introduction

External plugins are those that run on a process separate from {{site.base_gateway}} itself,
enabling the use of any programming language for which an appropriate
plugin server is available.

Each plugin server hosts one or more plugins and communicates with the
main {{site.base_gateway}} process through Unix sockets. If so configured, {{site.base_gateway}} can manage
those processes, starting, restarting and stopping as necessary.

{{site.base_gateway}} currently maintains support for the following languages with
their respective Kong PDKs:
- Go language: [go-pdk]
- JavaScript language: [kong-js-pdk]
- Python language: [kong-python-pdk]

## Kong Gateway plugin server configuration

The `pluginserver_names` property is a comma-separated list of names, one
for each plugin server process. These names are used to group each process'
properties and to annotate log entries.

For each name, other properties can be defined:

Property | Description | Default
---------|-------------|--------
`pluginserver_<NAME>_socket` | Unix socket path | `/usr/local/kong/<NAME>.socket`
`pluginserver_<NAME>_start_cmd` | Command to start the plugin server process | `/usr/local/bin/<NAME>`
`pluginserver_<NAME>_query_cmd` | Command to dump available plugins' info | `/usr/local/bin/query_<NAME>`


For example, you could set Go and Python plugins like this (assuming
an hypothetical Python plugin server called `pypluginserver.py`):

```
pluginserver_names = go,python

pluginserver_go_socket = /usr/local/kong/go_pluginserver.sock
pluginserver_go_start_cmd = /usr/local/bin/go-plugin -kong-prefix /usr/local/kong
pluginserver_go_query_cmd = /usr/local/bin/go-plugin -dump -kong-prefix /usr/local/kong

pluginserver_python_socket = /usr/local/kong/python_pluginserver.sock
pluginserver_python_start_cmd = /usr/local/bin/kong-python-pluginserver
pluginserver_python_query_cmd = /usr/local/bin/kong-python-pluginserver --dump-all-plugins
```

To enable those plugins, add the each plugin name to the `plugins` config. Assume we have those hello plugins
in each language:

```
plugins = bundled, go-hello, js-hello, py-hello
```

{:.note}
> **Note:** The `pluginserver_XXX_start_cmd` and `pluginserver_XXX_query_cmd` commands use
 a limited default `PATH` variable. In most cases, you have to specify the full executable
 path instead.

### Legacy configuration

{{site.base_gateway}} versions 2.0.x to 2.2.x supported only Go external plugins and a single
plugin server using a different configuration style. Starting with {{site.base_gateway}} version 2.3,
the old style is recognized and internally transformed to the new style.

{:.important}
> The legacy configuration is deprecated in {{site.base_gateway}} version 2.8.0 and
> planned to be removed in {{site.base_gateway}} version 3.0.0.

If property `pluginserver_names` isn't defined, the legacy properties
`go_plugins_dir` and `go_pluginserver_exe` are transparently mapped to the new style:

Property | Description | Default
---------|-------------|--------
`go_plugins_dir` | Directory with Go plugins | `off`, meaning to disable Go plugins
`go_pluginserver_exe` | Path to the go-pluginserver executable | `/usr/local/bin/go-pluginserver`

Notes:

- Using the legacy style is discouraged; it is deprecated as of {{site.base_gateway}} version 2.8.0,
and planned to be removed in {{site.base_gateway}} version 3.0.0.
- The legacy configuration doesn't allow multiple plugin servers.
- Version 0.5.0 of [go-pluginserver] requires the old style configuration.
- The new configuration style requires v0.6.0 of [go-pluginserver].

#### Updating from legacy to embedded server style

In embedded server mode, the plugin itself acts as the plugin server,
so the external `go-pluginserver` is no longer required.

Update legacy configuration to embedded plugin server style configuration with
the following steps:

1. Add a `main()` function that calls `server.StartServer(New, Version, Priority)`.
2. Ensure that properties `go_plugins_dir` and `go_pluginserver_exe` are not set
in your Kong configuration file or environment variable.
3. Set configuration according to [Kong Gateway plugin server configuration](#kong-gateway-plugin-server-configuration).

Check out the [go-plugins](https://github.com/Kong/go-plugins/tree/v0.5.0) repository for an example of the required updates. Plugins with the `-lm` suffix correspond to the legacy method, while those without the suffix
correspond to the embedded plugin server approach.

## Developing Go plugins

{{site.base_gateway}} supports the Go language with the [go-pdk], a library that provides Go functions to access {{site.base_gateway}} features of the [PDK][kong-pdk].

Notes:

The {{site.base_gateway}} version 2.3 allows multiple plugin servers; in particular
it's now possible to write single-plugin servers, in effect plugins as
microservices. To help with this, version v0.6.0 of the [go-pdk] package
includes an optional plugin server. See [Embedded Server](#embedded-server)
for more information.

### Development

To write a {{site.base_gateway}} plugin in Go, you need to:

1. Define a structure type to hold configuration.
2. Write a `New()` function to create instances of your structure.
3. Add methods on that structure to handle phases.
4. Include the `go-pdk/server` sub-library.
5. Add a `main()` function that calls `server.StartServer(New, Version, Priority)`.
6. Compile as an executable with `go build`.

**Note**: Check out [this repository](https://github.com/Kong/go-plugins)
for example Go plugins.

#### 1. Configuration Structure

Plugins written in Lua define a schema to specify how to read and validate
configuration data coming from the datastore or the Admin API. Since Go is a
statically-typed language, all that specification is handled by defining a
configuration structure:

```go
type MyConfig struct {
    Path   string
    Reopen bool
}
```

Public fields (that is, those starting with a capital letter) will be filled
with configuration data. If you want them to have a different name in the
datastore, add field tags as defined in the `encoding/json` package:

```go
type MyConfig struct {
    Path   string `json:"my_file_path"`
    Reopen bool   `json:"reopen"`
}
```

#### 2. New() Constructor

Your plugin must define a function called `New` that creates an instance of this type
and returns as an `interface{}`. In most cases, it’s just this:

```go
func New() interface{} {
    return &MyConfig{}
}
```

You can add more fields to the structure and they’ll be passed around, but
there are no guarantees about the lifetime or quantity of configuration
instances.

#### 3. main() Function

Each plugin is compiled as a standalone executable. Include `github.com/Kong/go-pdk/server` in
the imports list, and add a `main()` function:

```go
func main () {
  server.StartServer(New, Version, Priority)
}
```

The `main()` function must have a `package main` line at the
top of the file.

Then, a standard Go build creates an executable. There is no extra `go-pluginserver`,
no plugin loading, and no compiler, library, or environment compatibility issues.

The resulting executable can be placed somewhere in your path (for example,
`/usr/local/bin`). The common `-h` flag shows a usage help message:

```
$ my-plugin -h

Usage of my-plugin:
  -dump
        Dump info about plugins
  -help
        Show usage info
  -kong-prefix string
        Kong prefix path (specified by the -p argument commonly used in the Kong CLI) (default "/usr/local/kong")
```

When run without arguments, it creates a socket file within the
`kong-prefix` and the executable name, appending `.socket`. For example,
if the executable is `my-plugin`, it would be
`/usr/local/kong/my-plugin.socket` by default.


#### 4. Phase Handlers

Similarly to {{site.base_gateway}} Lua plugins, you can implement custom logic to be executed at
various points of the request processing lifecycle. For example, to execute
custom Go code in the access phase, define a function named `Access`:
```go
func (conf *MyConfig) Access (kong *pdk.PDK) {
  ...
}
```

The phases you can implement custom logic for are as follows, and the expected function
signature is the same for all of them:

- `Certificate`
- `Rewrite`
- `Access`
- `Response`
- `Preread`
- `Log`

Similar to Lua plugins, the presence of the `Response` handler automatically enables the buffered proxy mode.

#### 4. Version and Priority

Similarly to {{site.base_gateway}} Lua plugins, you can define the version number and priority of execution
by having following lines in plugin code:

```go
const Version = "1.0.0"
const Priority = 1
```

{{site.base_gateway}} executes plugins from highest priority to lowest ones.

#### Example configuration

Two standalone plugins, called `my-plugin` and `other-one`:

```
pluginserver_names = my-plugin,other-one

pluginserver_my_plugin_socket = /usr/local/kong/my-plugin.socket
pluginserver_my_plugin_start_cmd = /usr/local/bin/my-plugin
pluginserver_my_plugin_query_cmd = /usr/local/bin/my-plugin -dump

pluginserver_other_one_socket = /usr/local/kong/other-one.socket
pluginserver_other_one_start_cmd = /usr/local/bin/other-one
pluginserver_other_one_query_cmd = /usr/local/bin/other-one -dump

```

Note that the socket and start command settings coincide with
their defaults, so they can be omitted:

```
pluginserver_names = my-plugin,other-one
pluginserver_my_plugin_query_cmd = /usr/local/bin/my-plugin -dump
pluginserver_other_one_query_cmd = /usr/local/bin/other-one -dump
```

## Developing JavaScript plugins

{{site.base_gateway}} support for the JavaScript language is provided by [kong-js-pdk].
The library provides a plugin server to provide runtime for JavaScript plugins, and
functions to access {{site.base_gateway}} features of the [PDK][kong-pdk].

TypeScript is also supported in the following ways:

- [kong-js-pdk] includes type definitions for PDK functions that allow type checking
when developing plugins in TypeScript.
- Plugin written in TypeScript can be loaded directly and transpiled on the fly.

### Example configuration

[kong-js-pdk] can be installed using `npm`. To install the plugin server binary globally:

```
npm install kong-pdk -g
```

Assume the plugins are stored in `/usr/local/kong/js-plugins`:

```
pluginserver_names = js
pluginserver_js_socket = /usr/local/kong/js_pluginserver.sock
pluginserver_js_start_cmd = /usr/local/bin/kong-js-pluginserver --plugins-directory /usr/local/kong/js-plugins
pluginserver_js_query_cmd = /usr/local/bin/kong-js-pluginserver --plugins-directory /usr/local/kong/js-plugins --dump-all-plugins
```

### Development

Install [kong-js-pdk] in your local development directory:

```
npm install kong-pdk --save
```

A valid JavaScript plugin implementation should export the following object:

```javascript
module.exports = {
  Plugin: KongPlugin,
  Schema: [
    { message: { type: "string" } },
  ],
  Version: '0.1.0',
  Priority: 0,
}
```

`Plugin` attribute defines the class that implements this plugin. `Schema` defines the config
schema of plugin, it shares the same syntax as it's a Lua plugin. `Version` and `Priority`
defines the version number and priority of execution respectively.

**Note**: Check out [this repository](https://github.com/Kong/kong-js-pdk/tree/master/examples)
for example JavaScript and TypeScript plugins.

#### 1. Phase Handlers

Similarly to {{site.base_gateway}} Lua plugins, you can implement custom logic to be executed at
various points of the request processing lifecycle. For example, to execute
custom JavaScript code in the access phase, define a function named `access`:

```javascript
class KongPlugin {
  constructor(config) {
    this.config = config
  }
  async access(kong) {
    // ...
  }
}
```

The phases you can implement custom logic for are as follows, and the expected function
signature is the same for all of them:

- `certificate`
- `rewrite`
- `access`
- `response`
- `preread`
- `log`

Similar to Lua plugins, the presence of the `response` handler automatically enables the buffered proxy mode.

#### 2. PDK functions

[kong-js-pdk] invokes PDK functions in Kong through network-based IPC (inter-process communication).
So each function returns a Promise
instance; it's convenient to use `async`/`await` keywords in phase handlers for better readability.

```javascript
class KongPlugin {
  constructor(config) {
    this.config = config
  }
  async access(kong) {
    let host = await kong.request.getHeader("host")
    // do something to host
  }
}
```

Or consume Promise in a traditional way:

```javascript
class KongPlugin {
  constructor(config) {
    this.config = config
  }
  async access(kong) {
    kong.request.getHeader("host")
      .then((host) => {
        // do something to host
      })
  }
}
```

#### 3. Plugin dependencies

When using the plugin server, plugins are allowed to have extra dependencies, as long as the
directory that holds plugin source code also includes a `node_modules` directory.

Assuming plugins are stored under `/usr/local/kong/js-plugins`, the extra dependencies are
then defined in `/usr/local/kong/js-plugins/package.json`. Developers also need to
run `npm install` under `/usr/local/kong/js-plugins` to install those dependencies locally
into `/usr/local/kong/js-plugins/node_modules`.

Note in this case, the node version and architecture that runs the plugin server and
the one that runs `npm install` under plugins directory must match. For example, it may break
when you run `npm install` under macOS and mount the working directory into a Linux container.

### Testing

[kong-js-pdk] provides a mock framework to test plugin code correctness through `jest`.

Install `jest` as a development dependency, and add  the `test` script in `package.json`:

```
npm install jest --save-dev
```

The `package.json` has content similar to the following:

    {
      "scripts": {
        "test": "jest"
      },
      "devDependencies": {
        "jest": "^26.6.3",
        "kong-pdk": "^0.3.2"
      }
    }

Run the test through npm with:

```
npm test
```

**Note**: Check out [this repository](https://github.com/Kong/kong-js-pdk/tree/master/examples)
for examples on how to write test using `jest`.

## Developing Python plugins

{{site.base_gateway}} support for the Python language is provided by [kong-python-pdk].
The library provides a plugin server to provide runtime for Python plugins, and
functions to access {{site.base_gateway}} features of the [PDK][kong-pdk].

### Example configuration

[kong-python-pdk] can be installed using `pip`. To install the plugin server binary and PDK globally, use:

```
pip3 install kong-pdk
```

Assume the plugins are stored in `/usr/local/kong/python-plugins`:

```
pluginserver_names = python
pluginserver_python_socket = /usr/local/kong/python_pluginserver.sock
pluginserver_python_start_cmd = /usr/local/bin/kong-python-pluginserver --plugins-directory /usr/local/kong/python-plugins
pluginserver_python_query_cmd = /usr/local/bin/kong-python-pluginserver --plugins-directory /usr/local/kong/python-plugins --dump-all-plugins
```

### Development

A valid Python plugin implementation has following attributes:

```python
Schema = (
    { "message": { "type": "string" } },
)
version = '0.1.0'
priority = 0
class Plugin(object):
  pass
```

A class named `Plugin` defines the class that implements this plugin. `Schema` defines the config
schema of plugin, it shares the same syntax as it's a Lua plugin. `version` and `priority`
defines the version number and priority of execution respectively.

**Note**: Check out [this repository](https://github.com/Kong/kong-python-pdk/tree/master/examples)
for example Python plugins and [API reference](https://kong.github.io/kong-python-pdk/py-modindex.html).

#### 1. Phase Handlers

Similarly to {{site.base_gateway}} Lua plugins, you can implement custom logic to be executed at
various points of the request processing lifecycle. For example, to execute
custom Go code in the access phase, define a function named `access`:

```python
class Plugin(object):
    def __init__(self, config):
        self.config = config
    def access(self, kong):
      pass
```

The phases you can implement custom logic for are as follows, and the expected function
signature is the same for all of them:

- `certificate`
- `rewrite`
- `access`
- `response`
- `preread`
- `log`

Similar to Lua plugins, the presence of the `response` handler automatically enables the buffered proxy mode.

#### 2. Type hints

[kong-python-pdk] supports [type hint](https://www.python.org/dev/peps/pep-0484/) in Python 3.x. To use type lint
and autocomplete in IDE, user can annotate the `kong` parameter in phase handler:

```python
import kong_pdk.pdk.kong as kong
class Plugin(object):
    def __init__(self, config):
        self.config = config
    def access(self, kong: kong.kong):
        host, err = kong.request.get_header("host")
```

### Embedded server

Each plugin can be a microservice. To use the embedded server, use the following code:

```python
if __name__ == "__main__":
    from kong_pdk.cli import start_dedicated_server
    start_dedicated_server("py-hello", Plugin, version, priority)
```

Note the first argument to `start_dedicated_server` defines the plugin name and must
be unique across all languages.

#### Example configuration

Two standalone plugins, called `my-plugin` and `other-one`:

```
pluginserver_names = my-plugin,other-one
pluginserver_my_plugin_socket = /usr/local/kong/my-plugin.socket
pluginserver_my_plugin_start_cmd = /path/to/my-plugin.py
pluginserver_my_plugin_query_cmd = /path/to/my-plugin.py --dump
pluginserver_other_one_socket = /usr/local/kong/other-one.socket
pluginserver_other_one_start_cmd = /path/to/other-one.py
pluginserver_other_one_query_cmd = /path/to/other-one.py -dump
```

Note that the socket and start command settings coincide with
their defaults, so they can be omitted:

```
pluginserver_names = my-plugin,other-one
pluginserver_my_plugin_query_cmd = /path/to/my-plugin --dump
pluginserver_other_one_query_cmd = /path/to/other-one --dump
```

### Concurrency model

Python plugin server and embedded server supports multiple concurrency model. By default,
the server starts in multi-threading mode.

If your workload is IO intensive, consider the gevent model by adding `-g` to pluginserver's
start_cmd.
If your workload is CPU intensive, consider the multi-processing model by adding `-m` to pluginserver's
start_cmd.


## Performance for external plugins

Depending on implementation details, Go plugins are able to use multiple CPU cores
and so perform best on a multi-core system. JavaScript plugins are currently
single-core only and there's no dedicated plugin server support.
Python plugins can use a dedicated plugin server to span workload to
multiple CPU cores as well.

Unlike Lua plugins where invoking PDK functions are handled in local processes,
calling PDK functions in external plugins implies inter-process communications and so is a
relatively expensive operation. Because of the expense of calling PDK functions in external plugins, the performance of Kong using external plugins is
highly related to the number of IPC (inter-process communication) calls in each request.

The following graph demonstrates the correlation between performance and count of IPC
calls per request. Numbers of RPS and latency are removed as they are dependent on
hardware and to avoid confusion.

<center><img title="RPS" src="/assets/images/docs/external-plugins/rps.png"/></center>

<center><img title="Latency" src="/assets/images/docs/external-plugins/latency.png"/></center>

## Use external plugins in container and Kubernetes

To use plugins requiring external plugin servers, both the plugin servers and the plugins themselves need to be installed inside the {{ site.base_gateway }} container.

For plugins written in Golang, build external plugins in embedded server mode in a builder container
and copy or mount the binary artifacts into the {{ site.base_gateway }} container.
For plugins written in JavaScript, first install Node and `npm`, then use `npm` to install `kong-pdk`, and finally
copy or mount the plugins source code into the {{ site.base_gateway }} container.
For plugins written in Python, install Python and `pip`. Then use `pip` to install `kong-pdk`. Finally,
copy or mount the plugin's source code into the {{ site.base_gateway }} container.

Refer to previous sections on how to configure {{ site.base_gateway }} after you build the image
or create the container.

{:.note}
> **Note:** Official {{ site.base_gateway }} images are configured to run as the `nobody` user. When building a custom image, to copy files into
the {{ site.base_gateway }} image, you must temporarily set the user to `root`.

```dockerfile
FROM kong
USER root
# Example for GO:
COPY your-go-plugin /usr/local/bin/your-go-plugin
# Example for JavaScript:
RUN apk update && apk add nodejs npm && npm install -g kong-pdk
COPY you-js-plugin /path/to/your/js-plugins/you-js-plugin
# Example for Python
# PYTHONWARNINGS=ignore is needed to build gevent on Python 3.9
RUN apk update && \
    apk add python3 py3-pip python3-dev musl-dev libffi-dev gcc g++ file make && \
    PYTHONWARNINGS=ignore pip3 install kong-pdk
COPY you-py-plugin /path/to/your/py-plugins/you-py-plugin
# reset back the defaults
USER kong
ENTRYPOINT ["/docker-entrypoint.sh"]
EXPOSE 8000 8443 8001 8444
STOPSIGNAL SIGQUIT
HEALTHCHECK --interval=10s --timeout=10s --retries=10 CMD kong health
CMD ["kong", "docker-start"]
```
---

[go-pluginserver]: https://github.com/Kong/go-pluginserver
[go-plugins]: https://github.com/Kong/go-plugins
[go-pdk]: https://github.com/Kong/go-pdk
[kong-pdk]: https://docs.konghq.com/latest/plugin-development/
[go-hello]: https://github.com/Kong/go-plugins/blob/master/go-hello.go
[kong-js-pdk]: https://github.com/Kong/kong-js-pdk
[kong-python-pdk]: https://github.com/Kong/kong-python-pdk
