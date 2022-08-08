---
title: Write plugins in Go
content-type: explanation
---

## Developing Go plugins

{{site.base_gateway}} supports the Go language with the [Go PDK](https://pkg.go.dev/github.com/Kong/go-pdk), a library that provides Go bindings for {{site.base_gateway}}.

## Overview

To write a {{site.base_gateway}} plugin in Go, you need to:

1. Define a `structure` type to hold configuration.
2. Write a `New()` function to create instances of your structure.
3. Add methods to that structure to handle phases.
4. Include the `go-pdk/server` sub-library.
5. Add a `main()` function that calls `server.StartServer(New, Version, Priority)`.
6. Compile as an executable with `go build`.

{:.note}
> **Note**: [The Kong Go plugins repository](https://github.com/Kong/go-plugins) contains example Go plugins. 

## Configuration

### `Struct`
The plugin you write needs a way to handle incoming configuration data from the data store or the Admin API. 
You can use a `struct` to create a schema of the incoming data.

```go
type MyConfig struct {
    Path   string
    Reopen bool
}
```
Because this plugin will be processing configuration data, you are going to want to control encoding using the `encoding/json` package.
Go fields that start with a capital letter can be exported, making them accessible outside of the current package, including by the `encoding/json` package.
If you want the fields to have a different name in the data store, add tags to the fields in your `struct`.

```go
type MyConfig struct {
    Path   string `json:"my_file_path"`
    Reopen bool   `json:"reopen"`
}
```

### The `New()` constructor

The plugin must define a function called `New`.
This function should instantiate the `MyConfig` struct and return it as an `interface`.

```go
func New() interface{} {
    return &MyConfig{}
}
```

### The `main()` function

Each plugin is compiled as a standalone executable. Include `github.com/Kong/go-pdk` in
the imports list, and add a `main()` function:

```go
func main () {
  server.StartServer(New, Version, Priority)
}
```

Executables can be placed somewhere in your path (for example,
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

When you run the plugin without arguments, it creates a socket file within the
`kong-prefix` and the executable name, appending `.socket`. 
For example, if the executable is `my-plugin`, the socket file would be
`/usr/local/kong/my-plugin.socket`.


### Phase handlers

In {{site.base_gateway}} Lua plugins, you can implement custom logic to be executed at
various points of the request processing lifecycle. For example, to execute
custom Go code during the access phase, create a function named `Access` with the following function signature:

```go
func (conf *MyConfig) Access (kong *pdk.PDK) {
  ...
}
```

You can implement custom logic during the following phases using the same function signature:

- `Certificate`
- `Rewrite`
- `Access`
- `Response`
- `Preread`
- `Log`

The presence of the `Response` handler automatically enables the buffered proxy mode.

### Version and priority

You can define the version number and priority of execution
by declaring the following constants within the plugin code:

```go
const Version = "1.0.0"
const Priority = 1
```

{{site.base_gateway}} executes plugins from highest priority to lowest.

## Example configuration

To load plugins using the `kong.conf` [configuration file](/gateway/latest/kong-production/kong-conf), you have to map existing {{site.base_gateway}} properties to aspects of your plugin.
Here are two examples of loading plugins within `kong.conf`:

```
pluginserver_names = my-plugin,other-one

pluginserver_my_plugin_socket = /usr/local/kong/my-plugin.socket
pluginserver_my_plugin_start_cmd = /usr/local/bin/my-plugin
pluginserver_my_plugin_query_cmd = /usr/local/bin/my-plugin -dump

pluginserver_other_one_socket = /usr/local/kong/other-one.socket
pluginserver_other_one_start_cmd = /usr/local/bin/other-one
pluginserver_other_one_query_cmd = /usr/local/bin/other-one -dump

```

The socket and start command settings coincide with
their defaults and can be omitted:

```
pluginserver_names = my-plugin,other-one
pluginserver_my_plugin_query_cmd = /usr/local/bin/my-plugin -dump
pluginserver_other_one_query_cmd = /usr/local/bin/other-one -dump
```

## More information

* [PDK Reference](/gateway/latest/plugin-development/pdk/)
* [Plugins with Containers](/gateway/latest/plugin-development/other/plugins-kubernetes)
* [Develop plugins with Python](/gateway/latest/plugin-development/other/python)
* [Develop plugins with JavaScript](/gateway/latest/plugin-development/other/javascript)