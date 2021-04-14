---
title: Go Plugin Development Kit
---

## Introduction

Until {{site.ee_product_name}} 2.1, Lua was the only language supported for
writing Kong plugins, and continues to be the most common language for developing
and extending Kong. The Kong Go PDK directly parallels the existing Kong PDK for
Lua plugins, and the addition of Go plugin support allows Kong users to tap into
the Go ecosystem.

You may want to use the Go PDK if you are more familiar with the language, for
accessing certain databases, or for any other functionality that Go might
provide over Lua. For example, there are databases like MS SQL Server that don't
have good client libraries for Lua, but are well supported in Go. A Go plugin
could directly access such a server without having to pass through Kong's Lua
code.

<div class="alert alert-info">
 The reference documentation for <code>Kong/go-pdk</code> package is located on
 its <a href="https://pkg.go.dev/github.com/Kong/go-pdk?tab=doc">GoDoc page</a>.
 The following sections provide background and workflow context, as well as steps
 with examples for using the Go PDK.
</div>

## Go Concepts

### Go Plugin Server

Kong employs a sidecar process to run Go plugins: the [go-pluginserver][go-pluginserver].
The role of this process is to dynamically
load a Go plugin and execute its code on demand, based on communication
with Kong (performed through a Unix domain socket). Kong is responsible for
managing the lifecycle of the `go-pluginserver`, and, as you will see below, it
only needs to know where to find the `go-pluginserver`'s executable to do so.

### The go-pdk

The [go-pdk][go-pdk] allows your Go plugins to access functionality provided
by the [Kong PDK][kong-pdk]. To use it, you need to add
`"github.com/Kong/go-pdk"` to the list of packages imported by your plugin.
The `kong` parameter received on the phase handler methods is the entry point
for the Go PDK functions. Most of these functions work the same as the
corresponding functions in the Lua PDK.

See the [go-pdk](https://pkg.go.dev/github.com/Kong/go-pdk) GoDoc page for reference documentation.

## Limitations of the Go PDK
When compared to the Kong Lua PDK, the Go PDK has the following limitations:

* Kong plugins written using the Go PDK are slower than plugins written with Lua.
* There are no [`header_filter`](https://docs.konghq.com/2.0.x/plugin-development/custom-logic/#available-contexts) or [`body_filter`](https://docs.konghq.com/2.0.x/plugin-development/custom-logic/#available-contexts) phases.
* There are certain [environment consistency constraints](#environment-consistency-constraints)
requiring matching versions of libraries and packages, and matching environment
variables.

## Prerequisites

To use Go plugins, you need the following:

1. A Go compiler, which can be obtained from your Operating System's package
manager, or directly from the [Go Downloads page](https://golang.org/dl/).

2. The `go-pluginserver` executable, built as instructed in the following section.
By default, Kong will expect it in `/usr/local/bin`, however, this location
can be customized with the `go_pluginserver_exe` property in the Kong
configuration file, or with environment variables, like any other Kong
configuration property.

3. Set the `go_plugins_dir` variable in the Kong configuration file to a valid directory where your Go plugins will be installed. The default value is `off`,
which disables Go support.

4. Add your compiled Go plugins to the directory specified in the previous step
(`go_plugins_dir`).

5. As with custom Lua plugins, make sure to add your Go plugin name to the
`plugins` property, which effectively means Kong will load your plugin.

6. Enable the plugin either with either the Admin API or a declarative configuration file.

## Building the Go Plugin Server and your Go Plugins

The Go Plugin Server is a typical Go application. Leveraging Go Modules, it
can be built in the following way:

1. Initialize a `go.mod` file for your Kong Go Plugin project:
```
$ go mod init kong-go-plugin
go: creating new go.mod: module kong-go-plugin
```

2. Import the Go Plugin Server as a dependency:
```
$ go get -d -v github.com/Kong/go-pluginserver
go: github.com/Kong/go-pluginserver upgrade => v0.5.0
go: downloading github.com/Kong/go-pluginserver v0.5.0
go: downloading github.com/Kong/go-pdk v0.5.0
go: downloading github.com/ugorji/go v1.1.7
go: downloading github.com/ugorji/go/codec v1.1.7
```
This will, by default, select the latest version available, registering it
into the `go.mod` file and adding all its dependencies into `go.sum`. Note that,
in this example, the latest `go-pluginserver` version available was `v0.5.0`, and
it also pinned the `go-pdk `version it uses.

3. Build the Go Plugin Server with the following command, which will result in
a `go-pluginserver` executable being placed in the current directory:
```
$ go build github.com/Kong/go-pluginserver
```
> **Note**: The following step builds a Go plugin. For the purpose of this tutorial, we will assume its name is `go-hello`. You can find example Go plugins [here][go-plugins].

4. Build your Go plugin with the following command, which will result in a
`.so` file being placed in the current directory:
```
go build -buildmode plugin go-hello.go
```

Note: When installing the `go-pluginserver` binary globally, you  need to
enable `go.mod` support:

```
GO111MODULE=on go get -d -v github.com/Kong/go-pluginserver
```

### Environment Consistency Constraints

Golang development is well known for its low entry barrier and ease of
deployment. Even complex programs written in Go can be distributed as a single
executable that you can copy anywhere and run directly.

To make this possible, the compiler generates statically-linked executables by
default. A significant drawback of this choice is that it makes extending a
completed Go program very difficult. There are several ways around this
limitation, but most of them involve some form of interprocess communication.
Since this is well supported by the language and basic libraries, it's usually
a very good solution, but this isn't always the case.

The extension strategy chosen for Kong is common in other languages: a plugin
is a dynamically loaded module. To allow this, instead of producing fully
static programs, the executable and plugins depend on the system libraries.

This is a relatively recent feature in Golang (introduced in Go 1.8, as the
`plugin` build mode), and has some rough edges in tooling and deployability.
In particular, it's essential that the loading executable (`go-pluginserver` in
our case) and the plugins have exactly the same linking behaviour. This involves:
* The same version of any common libraries, including:
    * `Kong/go-pdk`
    * All standard Go libraries (like `fmt`, `rpc`, `reflect`, etc.)
    * OS libraries, like `libpthread`, `libc`, `ld-xxxx`, etc.
* The exact same version of the Go compiler
* The same Go environment variables like `$GOROOT` and `$GOPATH`

Typically, environment inconsistency issues manifest with error messages like
the following:
```
failed to open plugin kong: plugin.Open("/path/go-plugins/go-hello"): plugin was built with a different version of package github.com/Kong/go-pdk/bridge
```

By following the build steps in the section above, building the `go-pluginserver`
and plugins in the same environment, consistency is guaranteed.

## Developing Go Plugins

This section shows you how to write a custom Go plugin. You may find it useful
to reference a real Go plugin; see an example [here][go-hello].

### Development

To write a Kong plugin in Go, you need to:

1. Define a structure type to hold configuration.
2. Write a `New()` function to create instances of your structure.
3. Add methods on that structure to handle phases.
4. Compile your Go plugin (check out the previous section to learn how to build
your plugins).
5. Put the resulting library (the `.so` file) into the `go_plugins_dir` directory, as explained in the [Prerequisites](#prerequisites) section.

> **Note**: See the [Kong/go-plugins repository](https://github.com/Kong/go-plugins)
for example Go plugins.

#### 1. Configuration Structure

Plugins written in Lua define a schema to specify how to read and validate
configuration data coming from the datastore or the Admin API. Since Go is a
statically typed language, all of that specification is handled by defining a
configuration structure:

```
type MyConfig struct {
    Path   string
    Reopen bool
}
```

Public fields (that is, those starting with a capital letter) will be filled
with configuration data. If you want them to have a different name in the
datastore, add field tags as defined in the `encoding/json` package:

```
type MyConfig struct {
    Path   string `json:my_file_path`
    Reopen bool   `json:reopen`
}
```

#### 2. New() Constructor

Your plugin must define a function called `New` that creates an instance of this type and returns as an `interface{}`. In most cases, it's as simple as:

```
func New() interface{} {
    return &MyConfig{}
}
```

You can add more fields to the structure and they’ll be passed around, but
there are no guarantees about the lifetime or quantity of configuration
instances.

#### 3. Phase Handlers

Similarly to Kong Lua plugins, you can implement custom logic to execute at
various points (phases) of the request processing lifecycle. For example, to
execute custom Go code in the access phase, define a function named `Access`:
```
func (conf *MyConfig) Access (kong *pdk.PDK) {
  ...
}
```

You can implement custom logic for the following phases:
- `Certificate`
- `Rewrite`
- `Access`
- `Preread`
- `Log`

The expected function signature is the same for all of them.


[go-pluginserver]: https://github.com/Kong/go-pluginserver
[go-pluginserver-makefile]: https://github.com/Kong/go-pluginserver/blob/master/Makefile
[go-plugins]: https://github.com/Kong/go-plugins
[go-pdk]: https://github.com/Kong/go-pdk
[kong-pdk]: https://docs.konghq.com/latest/plugin-development/
[go-hello]: https://github.com/Kong/go-plugins/blob/master/go-hello.go
