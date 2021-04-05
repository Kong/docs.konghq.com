---
title: Plugins in Other Languages
redirect_from:
    /latest/go
    /2.3.x/go

---

## Introduction

External plugins are those that run on a process separate from {{site.base_gateway}} itself,
enabling the use of any programming language for which an appropriate
plugin server is available.

Each plugin server hosts one or more plugins and communicates with the
main {{site.base_gateway}} process through Unix sockets.  If so configured, {{site.base_gateway}} can manage
those processes, starting, restarting and stopping as necessary.

{{site.base_gateway}} currently maintains a Go language plugin server,
[go-pluginserver] and the corresponding PDK library
package, [go-pdk].

## Kong Gateway plugin server configuration

The `pluginserver_names` property is a comma-separated list of names, one
for each plugin server process.  These names are used to group each process'
properties and to annotate log entries.

For each name, other properties can be defined:

Property | Description | Default
---------|-------------|--------
`pluginserver_<NAME>_socket` | Unix socket path | `/usr/local/kong/<NAME>.socket`
`pluginserver_<NAME>_start_cmd` | Command to start the plugin server process | `/usr/local/bin/<NAME>`
`pluginserver_<NAME>_query_cmd` | Command to dump available plugins' info | `/usr/local/bin/query_<NAME>`


For example, you could set Go and Python plugins like this:

```
pluginserver_names = go,python

pluginserver_go_socket = /usr/local/kong/go_pluginserver.sock
pluginserver_go_start_cmd = go-pluginserver -kong-prefix /usr/local/kong/ -plugins-directory /usr/local/kong/go-plugins
pluginserver_go_query_cmd = go-pluginserver -dump-all-plugins -plugins-directory /usr/local/kong/go-plugins

pluginserver_python_socket = /usr/local/kong/python_pluginserver.sock
pluginserver_python_start_cmd = kong-pluginserver.py -d /usr/local/kong/py-plugins
pluginserver_python_query_cmd = kong-pluginserver.py -d /usr/local/kong/py-plugins --dump-all-plugins
```

### Legacy configuration

{{site.base_gateway}} versions 2.0.x to 2.2.x  supported only Go external plugins and a single
plugin server using a different configuration style.  Starting with {{site.base_gateway}} version 2.3,
the old style is recognized and internally transformed to the new style.

If property `pluginserver_names` isn't defined, the legacy properties
`go_plugins_dir` and `go_pluginserver_exe` are tried:

Property | Description | Default
---------|-------------|--------
`go_plugins_dir` | Directory with Go plugins | `off`, meaning to disable Go plugins
`go_pluginserver_exe` | Path to the go-pluginserver executable | `/usr/local/bin/go-pluginserver`

Notes:

- The old style doesn't allow multiple plugin servers.
- Version 0.5.0 of [go-pluginserver] requires the old style configuration.
- The new style configuration requires v0.6.0 of [go-pluginserver]

## Developing Go plugins

{{site.base_gateway}} support for the Go language consist of two parts:

- [go-pdk] as a library, provides Go functions to access {{site.base_gateway}} features of the [PDK][kong-pdk].
- [go-pluginserver] an executable to dynamically load plugins written in Go.


Notes:

The {{site.base_gateway}} version 2.3 allows multiple plugin servers; in particular
it's now possible to write single-plugin servers, in effect plugins as
microservices. To help with this, version v0.6.0 of the [go-pdk] package
includes an optional plugin server. See [Embedded Server](#embedded-server)
for more information.

The [go-pluginserver] process is still supported. Its main advantage is
that it's a single process for any number of plugins, but the dynamic
loading of plugins has proven challenging under the Go language (unlike
the microservice architecture, which is well supported by the language
and tools).

### Development

To write a {{site.base_gateway}} plugin in Go, you need to:

1. Define a structure type to hold configuration.
2. Write a `New()` function to create instances of your structure.
3. Add methods on that structure to handle phases.

   If you want a dynamically-loaded plugin to be used with [go-pluginserver]:

4. Compile your Go plugin with `go build -buildmode plugin`.
5. Put the resulting library (the `.so` file) into the `go_plugins_dir` directory.

   If you want a standalone plugin microservice:

4. Include the `go-pdk/server` sub-library.
5. Add a `main()` function that calls `server.StartServer(New, Version, Priority)`.
6. Compile as an executable with `go build`.

**Note**: Check out [this repository](https://github.com/Kong/go-plugins)
for example Go plugins.

#### 1. Configuration Structure

Plugins written in Lua define a schema to specify how to read and validate
configuration data coming from the datastore or the Admin API.  Since Go is a
statically-typed language, all that specification is handled by defining a
configuration structure:

```
type MyConfig struct {
    Path   string
    Reopen bool
}
```

Public fields (that is, those starting with a capital letter) will be filled
with configuration data.  If you want them to have a different name in the
datastore, add field tags as defined in the `encoding/json` package:

```
type MyConfig struct {
    Path   string `json:my_file_path`
    Reopen bool   `json:reopen`
}
```

#### 2. New() Constructor

Your plugin must define a function called `New` that creates an instance of this type
and returns as an `interface{}`.  In most cases, it’s just this:

```
func New() interface{} {
    return &MyConfig{}
}
```

You can add more fields to the structure and they’ll be passed around, but
there are no guarantees about the lifetime or quantity of configuration
instances.

#### 3. Phase Handlers

Similarly to {{site.base_gateway}} Lua plugins, you can implement custom logic to be executed at
various points of the request processing lifecycle. For example, to execute
custom Go code in the access phase, define a function named `Access`:
```
func (conf *MyConfig) Access (kong *pdk.PDK) {
  ...
}
```

The phases you can implement custom logic for are, and the expected function
signature is the same for all of them:
- `Certificate`
- `Rewrite`
- `Access`
- `Response`
- `Preread`
- `Log`

Similar to Lua plugins, the presence of the `Response` handler automatically enables the buffered proxy mode.


### Embedded server

Each plugin can be a microservice, compiled as a standalone executable.

To use the embedded server, include `github.com/Kong/go-pdk/server` in
the imports list, and add a `main()` function:

```go
func main () {
  server.StartServer(New, Version, Priority)
}
```

Note that the `main()` function must have a `package main` line at the
top of the file.

Then, a standard Go build creates an executable. There are no extra go-pluginserver,
no plugin loading, and no compiler/library/environment compatibility issues.

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

When run without arguments, it will create a socket file with the
`kong-prefix` and the executable name, appending `.socket`.  For example,
if the executable is `my-plugin`, it would be
`/usr/local/kong/my-plugin.socket` by default.

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

## Developing Python Plugins

{{site.base_gateway}} supports the Python language via the [python-pdk] package.  It contains:

- libraries to be imported from a Python plugin
- kong-pluginserver.py, which can execute several Python plugins under the same process.
- a dedicated server, which allows a Python plugin to be executed on its own.

To write a {{site.base_gateway}} plugin in Python, you need to:

1. Install the kong-pdk package, like:

```bash
pip3 install kong-pdk
```

2. Write a Python module exporting a `Plugin` class, a `Schema` description and `version` and `priority` constants.

2.1 `Plugin` class:  This class implements the plugin behaviour.  The `__init__` method receives a `config` object, the `access`, `rewrite`, `certificate`, `preread` and `log` methods are called by {{site.base_gateway}} on the respective phases, and receive a `kong` parameter to be used as a PDK entry point.

2.2 `Schema` description:  Should be an iterable object (list or tuple) containing the definition of each configuration field in the form `{ <fieldname>: { "type": <fieldtype> } }`, similar to the `schema.lua` file for Lua Plugins.

2.3 `version` and `priority` constants: Module-level constants of string and number types, respectively.

Example:

```python
import os
import time
import kong_pdk.pdk.kong as kong

Schema = (
    { "message": { "type": "string" } },
)

version = '0.1.0'
priority = 0

# This is an example plugin that add a header to the response

class Plugin(object):
    def __init__(self, config):
        self.config = config

    def access(self, kong: kong.kong):
        host, err = kong.request.get_header("host")
        if err:
            kong.log.err(err)
        message = "hello"
        if 'message' in self.config:
            message = self.config['message']
        kong.response.set_header("x-hello-from-python", "Python says %s to %s" % (message, host))
        kong.response.set_header("x-python-pid", str(os.getpid()))


# add below section to allow this plugin optionally be running in a dedicated process
if __name__ == "__main__":
    from kong_pdk.cli import start_dedicated_server
    start_dedicated_server("py-hello", Plugin, version, priority)
```

The last part is the idiomatic Python way to execute a module directly, without a "hosting" program.  This allows the same Python Plugin to be either run standalone, or under a pluginserver process.

3. Install and configure.

There are two different ways to configure:

3.1 As a standalone executable:

- Make sure it's executable by the appropriate system user.  Typically `chmod a+x <pluginfilename>` is OK in most cases.

- Add the configuration settings:

```
pluginserver_py_hello_socket=/usr/local/kong/py_hello.sock
pluginserver_py_hello_start_cmd=/dir/to/kong-python-pdk/examples/py-hello.py
pluginserver_py_hello_query_cmd=/dir/to/kong-python-pdk/examples/py-hello.py -d
```

3.2 Under a pluginserver:

The [python-pdk] package includes the `kong-pluginserver.py` executable script, which loads and executes several Python plugins installed under a configurable directory.

- copy the Plugin to a directory where it can be found as a Python Module.

- Add the configuration settings:

```
pluginserver_names=py
pluginserver_py_socket=/usr/local/kong/python_pluginserver.sock
pluginserver_py_start_cmd=/usr/local/bin/kong-python-pluginserver -d /dir/to/kong-python-pdk/examples
pluginserver_py_query_cmd=/usr/local/bin/kong-python-pluginserver -d /dir/to/kong-python-pdk/examples --dump-all-plugins
```


---

[go-pluginserver]: https://github.com/Kong/go-pluginserver
[go-pluginserver-makefile]: https://github.com/Kong/go-pluginserver/blob/master/Makefile
[go-plugins]: https://github.com/Kong/go-plugins
[go-pdk]: https://github.com/Kong/go-pdk
[kong-pdk]: https://docs.konghq.com/latest/plugin-development/
[go-hello]: https://github.com/Kong/go-plugins/blob/master/go-hello.go
[python-pdk]: https://github.com/Kong/kong-python-pdk
