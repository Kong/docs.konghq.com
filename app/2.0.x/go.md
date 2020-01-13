---
title: Go language support
---

## Introduction

To write a Kong plugin in Go, you need to:

* Define a structure type to hold configuration.
* Add methods on that structure to handle events
* Use the [go-pdk](https://godoc.org/github.com/Kong/go-pdk).

Compile using the `-buildmode=plugin` flag, and put the resulting binary into
the directory specified with the `go_plugins_dir` configuration parameter.

## Configuration Structure

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

You must define a function called New that creates an instance of this type
and returns as an `interface{}`.  In most cases it’s just this:

```
func New() interface{} {
    return &MyConfig{}
}
```

You can add more fields to the structure and they’ll be passed around, but
there’s no guarantees about the lifetime or quantity of configuration
instances.

## Handling events

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

## go-pdk package

Add `"github.com/Kong/go-pdk"` to your imported packages.  The `kong` pointer
received on the event handler methods is the entry point for the Go PDK
functions. Most of these functions work the same as the corresponding
functions in the Lua PDK.

See the [go-pdk](https://godoc.org/github.com/Kong/go-pdk) godoc page for the
reference documentation of the Go PDK.

