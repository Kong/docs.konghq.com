---
title: External plugins support
---

## Introduction

External plugins are those that run on a process separate from Kong itself,
enabling the use of any programming language for which an appropriate
"plugin server" is available.

Each plugin server hosts one or more plugins and communicates with the
main Kong process via unix sockets.  If so configured, Kong can manage
those processes, starting, restarting and stopping as necessary.

Kong currently maintains a Go language pluginserver,
[go-pluginserver] and the corresponding PDK library
package, [go-pdk].

## Kong configuration

The `pluginserver_names` property is a comma-separated list of names, one
for each plugin server process.  These names are used to group each process'
properties and to annotate log entries.

For each name, three other properties can be defined:

property | description | default
---------|-------------|--------
`pluginserver_<NAME>_socket` | unix socket path | `/usr/local/kong/<NAME>.socket`
`pluginserver_<NAME>_start_cmd` | command to start the plugin server process | `/usr/local/bin/<NAME>`
`pluginserver_<NAME>_query_cmd` | command to dump available plugins' info | `/usr/local/bin/query_<NAME>`


For example, you could set Go and Python plugins like this:

```
pluginserver_names = go,python

pluginserver_go_socket = /usr/local/kong/go_pluginserver.socket
pluginserver_go_start_cmd = go-pluginserver -kong-prefix /usr/local/kong/ -plugins-dir /usr/local/kong/go-plugins
pluginserver_go_query_cmd = go-pluginserver -dump-all-plugins -plugins-dir /usr/local/kong/go-plugins

pluginserver_python_socket = /usr/local/kong/pyton_pluginserver.socket
pluginserver_python_start_cmd = pypluginserver.py
pluginserver_python_query_cmd = pypluginserver.py -dump
```

### Legacy configuration

Kong versions 2.0 to 2.2 supported only Go external plugins and a single
pluginserver using a different configuration style.  Starting with Kong 2.3,
the old style is recognized and internally transformed to the new style.

If property `pluginserver_names` isn't defined, the legacy properties
`go_plugins_dir` and `go_pluginserver_exe` are tried:

property | description | default
---------|-------------|--------
`go_plugins_dir` | directory with Go plugins | `off`, meaning to disable Go plugins
`go_pluginserver_exe` | path to the go-pluginserver executable | `/usr/local/bin/go-pluginserver`

Notes:

- The old style doesn't allow multiple plugin servers.
- Version 0.5.0 of [go-pluginserver] requires the old style configuration.
- The new style configuration requires v0.6.0 of [go-pluginserver]

## Developing Go plugins

Kong support for the Go language consist of two parts:

- [go-pdk] as a library, provides Go functions to access Kong features of the [PDK][kong-pdk].
- [go-pluginserver] an executable to dynamically load plugins written in Go.


Notes:

The Kong version 2.3 allows multiple plugin servers; in particular
it's now possible to write "single-plugin servers", in effect plugins as
microservices.  To help on this, version v0.6.0 of the [go-pdk] package
includes an optional plugin server, see [Embedded Server](#embedded-server)
for info on this.

The [go-pluginserver] process is still supported.  Its main advantage is
that it is a single process for any numbe of plugins, but the dynamic
loading of plugins has proven challenging under Go language; unlike
the microservice architecture, which is well supported by the language
and tools.

### Development

To write a Kong plugin in Go, you need to:

1. Define a structure type to hold configuration.
2. Write a `New()` function to create instances of your structure.
3. Add methods on that structure to handle phases.
   
if you want a dynamically-loaded plugin to be used with [go-pluginserver]:

4. Compile your Go plugin with `go build -buildmode plugin`.
5. Put the resulting library (the `.so` file) into the `go_plugins_dir` directory.
   
if you want a standalone plugin microservice:

4. include `go-pdk/server` sub-library.
5. Add a `main()` function that calls `server.StartServer(New, Version, Priority)`
6. Compile as an executable with `go build`

**Note**: check out [this repository](https://github.com/Kong/go-plugins)
for example Go plugins.

#### 1. Configuration Structure

Plugins written in Lua define a schema to specify how to read and validate
configuration data coming from the datastore or the Admin API.  Since Go is a
statically type language, all that specification is handled by defining a
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

Your plugin must define a function called New that creates an instance of this type
and returns as an `interface{}`.  In most cases it’s just this:

```
func New() interface{} {
    return &MyConfig{}
}
```

You can add more fields to the structure and they’ll be passed around, but
there’s no guarantees about the lifetime or quantity of configuration
instances.

#### 3. Phase Handlers

Similarly to Kong Lua plugins, you can implement custom logic to be executed at
various points of the request processing life-cycle. For example, to execute
custom Go code in the "access" phase, define a function named `Access`:
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

Similar to Lua plugins, the presence of the `Response` handler automatically enables the "buffered proxy" mode.


### Embedded server

Each plugin can be a microservice, compiled as a standalone executable.

To use the embedded server, include "github.com/Kong/go-pdk/server" in
the imports list, and add a `main()` function:

```go
func main () {
  server.StartServer(New, Version, Priority)
}
```

Note that the `main()` function must have a `package main` line at the
top of the file.

Then, a standard go build creates an executable. no extra "go-pluginserver",
no plugin loading, no compiler/library/environment compatibility issues.

The resulting executable can be placed somewhere in your path (for example
`/usr/local/bin`).  The common `-h` flag shows a "usage" help message:

```
$ my-plugin -h

Usage of my-plugin:
  -dump
        Dump info about plugins
  -help
        Show usage info
  -kong-prefix string
        Kong prefix path (specified by the -p argument commonly used in the kong cli) (default "/usr/local/kong")
```

When run without arguments, it will create a socket file with the
`kong-prefix` and the executable name, appending `.socket`.  For example,
if the executable is `my-plugin` it would be
`/usr/local/kong/my-plugin.socket` by default.

Example configuration: two standalone plugins, called `my-plugin`
and `other-one`:

```
pluginserver_names = my-plugin,other-one

pluginserver_my_plugin_socket = /usr/local/kong/my-plugin.socket
pluginserver_my_plugin_start_cmd = /usr/local/bin/my-plugin
pluginserver_my_plugin_query_cmd = /usr/local/bin/my-plugin -dump

pluginserver_other_one_socket = /usr/local/kong/ohter-one.socket
pluginserver_other_one_start_cmd = /usr/local/bin/other-one
pluginserver_other_one_query_cmd = /usr/local/bin/other-one -dump

```

Note that the "socket" and "start command" settings coincide with
their defaults, so they can be omitted:

```
pluginserver_names = my-plugin,other-one
pluginserver_my_plugin_query_cmd = /usr/local/bin/my-plugin -dump
pluginserver_other_one_query_cmd = /usr/local/bin/other-one -dump
```


---

[go-pluginserver]: https://github.com/Kong/go-pluginserver
[go-pluginserver-makefile]: https://github.com/Kong/go-pluginserver/blob/master/Makefile
[go-plugins]: https://github.com/Kong/go-plugins
[go-pdk]: https://github.com/Kong/go-pdk
[kong-pdk]: https://docs.konghq.com/latest/plugin-development/
[go-hello]: https://github.com/Kong/go-plugins/blob/master/go-hello.go
