---
title: Go language support
---

## Introduction

Kong 2.0 introduces support for plugins written in Go.

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
* A Go development environment.
* A `go-pluginserver` executable built with the same compiler and libraries.  The most direct way is to get it from source with `go get github.com/Kong/go-pluginserver`
* Copy the new executable to `/usr/local/bin`, with `cp $(go env GOPATH)/bin/go-pluginserver /usr/local/bin`. Alternatively, you can specify the `go_pluginserver_exe` property with the path to the `go-pluginserver` binary
* The Go-PDK package: `import "github.com/Kong/go-pdk"`.

## Development

To write a Kong plugin in Go, you need to:

* Define a structure type to hold configuration.
* Write a `New()` function to create instances of your structure.
* Add methods on that structure to handle events.
* Compile like: `go build -buildmode=plugin`.
* Put the resulting library (the `.so` file) into the `go_plugins_dir` directory.


**Note**: check out [this repository](https://github.com/Kong/go-plugins)
for example Go plugins.

### Configuration Structure

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

See the [go-pdk](https://godoc.org/github.com/Kong/go-pdk) godoc page for the
reference documentation of the Go PDK.
