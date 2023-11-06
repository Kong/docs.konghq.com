---
title: WebAssembly
content_type: reference
badge: free
---

## WebAssembly in Kong

In addition to Lua plugins, {{site.base_gateway}} supports WebAssembly as a
means of extending proxy functionality and performing custom business logic.
This is made possible by Kong's [open source implementation](https://github.com/Kong/ngx_wasm_module) of
the [Proxy-Wasm specification](https://github.com/proxy-wasm/spec).

## Concepts

### Filter

In the context of Proxy-Wasm, a "filter" refers to a specific component or
module that is executed at some stage of request/response handling. Filters can
perform actions like:

* read or write request or response headers
* read or write the request or response body
* terminate the request early and send a self-generated response

If you are familiar with Kong's Lua plugin support, you can think of filters
as semi-analogous to plugins.

Filters differ from Lua plugins in their file format at runtime. A Lua plugin
typically spans several different Lua source code files, all packaged and
deployed in text format. Filters must be compiled from source code
into a single binary file with the `.wasm` extension.

In order to be usable in {{site.base_gateway}}, all filter files must be present
on disk in a single directory, denoted by the `wasm_filters_path` configuration
directive.

### Filter Chain

A Filter Chain is the database entity representing one or more filters executed
for each request to a particular service or route, each one with its
configuration.

Example:

```yaml
---
filter_chains:
  name: my-filter-chain
  # Filter Chains can be toggled on/off for testing
  enabled: true
  filters:
    # this maps to $wasm_filters_path/my_filter.wasm
    - name: my_filter
      # at runtime, configuration is passed to the filter as a byte array
      #
      # filter configuration is inherently untyped--schema and
      # encoding/serialization are left up to the filter code itself
      config: "foo=bar baz=bat"

    - name: my_other_filter
      # individual filters within a chain can be toggled on/off for testing
      enabled: false
      config: >-
          {
            "some_settings": {
              "a": "b",
              "c": "d"
            },
            "foo": "bar"
          }

    # the same filter may occur more than once in a single chain, and all   entries will be
    # executed
    - name: my_filter
      config: "foo=123 baz=456"
```


#### Relationships

Filter Chains **must** be linked to a service or route, and as of {{site.base_gateway}} version 3.4,
the relationship is one-to-one:

* A service or route may only be linked to a single Filter Chain.
* A Filter Chain may only be linked to a single service or route.

## Filter execution behavior

The list of filters that will be executed for a given request is determined
during the `access` phase, after Lua plugins execution. If the service entity
for the request is linked to a Filter Chain, the filters are executed. If the
route entity that was matched to the request is linked to a Filter Chain, its
filters are also executed, _after_ service-related filters (if any) have been
executed. You can inspect the full filter execution plan for a given route via
the Admin API, through the endpoint `/routes/{route_name_or_id}/filters/enabled`.

Filters are always executed in the order in which they are defined in the filter
chain. The same filter may appear in the execution plan multiple times, either
coming from the service and route chains, or even within the same Filter Chain.
Each entry will execute with its own configuration.

### Can Lua plugins and Proxy-Wasm filters be used at the same time?

Yes. Keep in mind though that for each request phase, Lua plugins are executed
_before_ Wasm filters.

There is one side effect of this ordering that is crucial to be aware of: if a
Lua plugin terminates the request during or prior to the `access` phase (by
throwing an exception or explicitly sending a response with
`kong.response.exit()` or other PDK function), **no Wasm filters will be executed
for the request,** including other phases (e.g. `header_filter`).

## Limitations and known issues

### Kong PDK

At the time of this writing, filters do not have access to any of Kong's
Lua-land PDK utilities and are restricted to the functionality defined by
Proxy-Wasm.

### Filter configuration schema

Filter configuration is untyped. That means that Kong
cannot validate a filter configuration ahead of time, e.g. when you create a
Filter Chain instance using the Admin API. This is not so much a limitation of
Kong's implementation as it is a limitation of the Proxy-Wasm
specification itself.

### Proxy-Wasm functionality

The Proxy-Wasm specification is relatively new and still evolving. Some
behaviors of the specification may not yet be fully-implemented. Additionally,
there may be some behavioral discrepancies between {{site.base_gateway}} and
other Proxy-Wasm implementations.

Please refer to the [ngx_wasm_module Proxy-Wasm documentation](https://github.com/Kong/ngx_wasm_module/blob/main/docs/PROXY_WASM.md#current-limitations) for more details.

## Further Reading

* [Create a Proxy-Wasm filter](/gateway/latest/plugin-development/wasm/filter-development-guide)
* [WebAssembly for Proxies (Proxy-Wasm) specification](https://github.com/proxy-wasm/spec)
* [`ngx_wasm_module`](https://github.com/Kong/ngx_wasm_module)
* [`ngx_wasm_module` Proxy-Wasm documentation](https://github.com/Kong/ngx_wasm_module/blob/main/docs/PROXY_WASM.md)
* [Go SDK](https://github.com/tetratelabs/proxy-wasm-go-sdk/)
* [Rust SDK](https://github.com/proxy-wasm/proxy-wasm-rust-sdk/)
