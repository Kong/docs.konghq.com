---
title: Go language support
---

## Introduction

Until Kong 2.0, Lua was the only language supported for writing Kong plugins, and continues to be the main way to develop and extend Kong. The addition of Go plugin support allows Kong users to tap into the Go ecosystem.

You may want to use the Go PDK if you are more familiar with the language, for accessing certain databases, or for any other functionality that Go might provide over Lua. For example, there are databases like MS SQL Server that don't have good client libraries for Lua, but are well supported in Go. A Go plugin could directly access such a server without having to pass through Kong's Lua code.

<div class="alert alert-info">
 The reference documentation for <code>Kong/go-pdk</code> package is located on its <a href="https://pkg.go.dev/github.com/Kong/go-pdk?tab=doc">GoDoc page</a>. The following sections provide background and workflow context, prerequisites, requirements, and examples.
</div>

## Architecture

The Go PDK is based on a separate process written entirely in Go. You can configure Kong to launch the process, called `go-pluginserver`, and open a communications channel to pass events and function calls between them. This means that Go plugins run in a real Go environment and can use Go features such as goroutines, I/O, IPC, etc.

>**Note:** this also means any call to a PDK function has to be transferred to the Kong process and back.

Go plugins are built with the `-buildmode=plugin` flag, which allows the plugin server to dynamically load them. To comply with Go's strict linking compatibility checks, they have to be compiled using the `kong/go-plugin-tool` Docker image, as described below.


## Prerequisites

To use Go plugins:

* You need the `go-pluginserver` executable.  The Kong distribution packages
install it in `/usr/local/bin/`.  If you want it anywhere else, set the
`go_pluginserver_exe` variable in the Kong configuration file to the full path.
* Set the `go_plugins_dir` variable in the Kong configuration file to a valid directory.
The default `"off"` value disables Go support.
* Add compiled Go plugins to the directory specified in the previous step.
* Add the plugin settings the usual way, either via Admin API, database or declarative file.
Refer to the the plugin via its filename (without the `.so` suffix).

To write your own Go plugins:

* A Kong development environment as usual.
* The `kong/go-plugin-tool:<version>` Docker image, where `<version>` is the same version as the Kong package you want to deploy on.

## Development

### Environment consistency constraints

Golang development is well known for its low entry barrier and ease of deployment. Even complex programs written in Go can be distributed as a single executable that you can copy anywhere and run directly.

To make this possible, the compiler generates statically-linked executables by default. A significant drawback of this choice is that it makes extending a "finished" Go program very difficult. There are several ways around this limitation, but most of them involve some form of interprocess communication. Since this is well supported by the language and basic libraries, it's usually a very good solution, but this isn't always the case.

The extension strategy chosen for Kong is common in other languages: a plugin is a dynamically loaded module. To allow this, instead of producing fully static programs, the executable and plugins depend on the system libraries.

This is a relatively recent feature in Golang, and has some rough edges in tooling and deployability.  In particular, it's essential that the loading executable (`go-pluginserver` in our case) and the plugins have exactly the same linking behaviour.  This involves at least:

* The same version of any common libraries, including:
    * `Kong/go-pdk`
    * all standard Go libraries (like `fmt`, `rpc`, `reflect`, etc)
    * OS libraries, like `libpthread`, `libc`, `ld-xxxx`, etc.
* The exact same version of the Go compiler.
* The same Go environment variables like `$GOROOT` and `$GOPATH`

The common libraries version compatibility is partially handled by the `go.mod` dependency management, but that introduces more complex issues on the environment variables requirement.

For example, the environment variable `$GOPATH` is a real problem, not only because one of the recommended patterns is `$HOME/go`, which includes the developer's username in their own system, but also because it's common that production builds (Dockerfiles, build scripts, CI/CD systems) use a very different pattern.

To guarantee consistency, the `kong/go-plugin-tool` is used as a wrapper to the Go compiler.  Kong distribution packages and images use it to compile the included `go-pluginserver`.

### Development process

To write a Kong plugin in Go, you need to:

* Define a structure type to hold configuration.
* Write a `New()` function to create instances of your structure.
* Add methods on that structure to handle events.
* Compile using: `docker run --rm -v $(pwd):/plugins kong/go-plugin-tool:<version> build <source>`.
* Put the resulting library (the `.so` file) into the `go_plugins_dir` directory.


**Note**: check out [this repository](https://github.com/Kong/go-plugins)
for example Go plugins.

### Configuration Structure

Plugins written in Lua define a schema to specify how to read and validate
configuration data coming from the datastore or the Admin API.  Since Go is a
statically-typed language, all that specification is handled by defining a
configuration structure.

```
type MyConfig struct {
    Path   string
    Reopen bool
}
```

Public fields (that is, those starting with a capital letter) will be filled
with configuration data.  If you want them to have a different name in the
datastore, add field tags as defined on the `encoding/json` package:

```
type MyConfig struct {
    Path   string `json:my_file_path`
    Reopen bool   `json:reopen`
}
```

### `New()` Constructor

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

### Handling events

To handle Kong events, define the relevant methods on your configuration
structure.  For example, to handle the “access” event, define a function like
this:

```
func (conf *MyConfig) Access (kong *pdk.PDK) {
    …
}
```

The event methods you can define are `Certificate`, `Rewrite`, `Access`, `Preread` and
`Log`.  The signature is the same for all of them.

## `go-pdk` package

Add `"github.com/Kong/go-pdk"` to your imported packages.  The `kong` pointer
received on the event handler methods is the entry point for the Go PDK
functions. Most of these functions work the same as the corresponding
functions in the Lua PDK.

See the [go-pdk](https://pkg.go.dev/github.com/Kong/go-pdk?tab=doc) GoDoc page for the
reference documentation of the Go PDK.
