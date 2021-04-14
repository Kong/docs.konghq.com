---
title: Go language support
---

## Introduction

Since version 2.0, Kong can be extended with the Go programming language. This
Guide introduces Go plugins and provides instructions on how to write and use
them.

### New Concepts

#### Go Plugin Server

In order for Kong to run Go plugins, it employs a sidecar process: the
[go-pluginserver][go-pluginserver]. The role of this process is to dynamically
load a Go plugin and execute its code on demand, based on communication
with Kong (performed through a Unix domain socket). Kong is responsible for
managing the life cycle of the go-pluginserver, and, as you will see below, it
only needs to know where to find the go-pluginserver's executable to do so.

#### The go-pdk

The [go-pdk][go-pdk] allows your Go plugins to access functionality provided
by the [Kong PDK][kong-pdk]. In order to use it, you need to import add
`"github.com/Kong/go-pdk"` to the list of packages imported by your plugin.
The `kong` parameter received on the phase handler methods is the entry point
for the Go PDK functions. Most of these functions work the same as the corresponding
functions in the Lua PDK.

Check out the [go-pdk](https://pkg.go.dev/github.com/Kong/go-pdk) GoDoc page for
the reference documentation of the Go PDK.

### Prerequisites

In order to use Go plugins, you need the following:

1. A Go compiler, which can be obtained from your Operating System's package
manager, or directly at the [Go Downloads page](https://golang.org/dl/);

2. The `go-pluginserver` executable, built as instructed in the following section.
By default, Kong will expect it in `/usr/local/bin`; however, this location can
be customized with the `go_pluginserver_exe` property in the Kong configuration
file - or via environment variables, like any other Kong configuration property;

3. Set the `go_plugins_dir` variable in the Kong configuration file to a valid directory
where your Go plugins will be installed; the default value `off` value disables
Go support;

4. Add your compiled Go plugins to the directory specified in the previous step
(`go_plugins_dir`);

5. As with custom Lua plugins, make sure to add your Go plugin name to the `plugins`
property, which effectively means Kong will load your plugin;

6. Enable the plugin in the usual way, either via Admin API or a declarative
configuration file.

### Building the Go Plugin Server and your Go Plugins

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
in this example, the latest go-pluginserver version available was `v0.5.0` and
it also pinned the go-pdk version it uses.

3. Build the Go Plugin Server with the following command, which will result in
a `go-pluginserver` executable being placed in the current directory:
```
$ go build github.com/Kong/go-pluginserver
```
**Note**: The following step builds a Go plugin. For the purpose of this tutorial,
we will assume its name is `go-hello`. You can find example Go plugins [here][go-plugins].

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

#### Environment Consistency Constraints

Golang development is well known for its low entry barrier and ease of
deployment. Even complex programs written in Go can be distributed as a single
executable that you can copy anywhere and run directly.

To make this possible, the compiler generates statically-linked executables by
default. A significant drawback of this choice is that it makes extending a
"finished" Go program very difficult. There are several ways around this
limitation, but most of them involve some form of interprocess communication.
Since this is well supported by the language and basic libraries, it's usually
a very good solution, but this isn't always the case.

The extension strategy chosen for Kong is common in other languages: a plugin
is a dynamically loaded module. To allow this, instead of producing fully
static programs, the executable and plugins depend on the system libraries.

This is a relatively recent feature in Golang (introduced in Go 1.8, as the
"plugin" build mode), and has some rough edges in  tooling and deployability.
In particular, it's essential that the loading executable (`go-pluginserver` in
our case) and the plugins have exactly the same linking behaviour. This involves:
* The same version of any common libraries, including:
    * `Kong/go-pdk`
    * All standard Go libraries (like `fmt`, `rpc`, `reflect`, etc)
    * OS libraries, like `libpthread`, `libc`, `ld-xxxx`, etc.
* The exact same version of the Go compiler
* The same Go environment variables like `$GOROOT` and `$GOPATH`

Typically, environment inconsistency issues manifest with error messages like
the following:
```
failed to open plugin kong: plugin.Open("/path/go-plugins/go-hello"): plugin was built with a different version of package github.com/Kong/go-pdk/bridge
```

By following the build steps in the section above, building the go-pluginserver
and plugins in the same environment, consistency is guaranteed.

## Developing Go Plugins

This section shows you how to write a custom Go plugin. It will be useful to
cross-reference a real Go plugin; see an example [here][go-hello].

### Development

To write a Kong plugin in Go, you need to:

1. Define a structure type to hold configuration;
2. Write a `New()` function to create instances of your structure;
3. Add methods on that structure to handle phases;
4. Compile your Go plugin (check out the previous section to learn how to build
your plugins);
5. Put the resulting library (the `.so` file) into the `go_plugins_dir` directory,
as explained in the Prerequisites section.

**Note**: check out [this repository](https://github.com/Kong/go-plugins)
for example Go plugins.

#### 1. Configuration Structure

Plugins written in Lua define a schema to specify how to read and validate
configuration data coming from the datastore or the Admin API.  Since Go is a
statically type language, all that specification is handled by defining a
configuration structure.

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

---

[go-pluginserver]: https://github.com/Kong/go-pluginserver
[go-pluginserver-makefile]: https://github.com/Kong/go-pluginserver/blob/master/Makefile
[go-plugins]: https://github.com/Kong/go-plugins
[go-pdk]: https://github.com/Kong/go-pdk
[kong-pdk]: https://docs.konghq.com/latest/plugin-development/
[go-hello]: https://github.com/Kong/go-plugins/blob/master/go-hello.go
