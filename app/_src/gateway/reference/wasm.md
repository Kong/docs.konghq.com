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
perform actions such as:

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

### Filter chain

A filter chain is the database entity representing one or more filters executed
for each request to a particular service or route, each one with its
configuration.

Example:

```yaml
---
filter-chains:
  name: my-filter-chain
  # filter chains can be toggled on/off for testing
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

Filter chains **must** be linked to a service or route, and as of this writing,
the relationship is one-to-one:

* a service or route may only be linked to a single filter chain
* a filter chain may only be linked to a single service or route

## Filter execution behavior

The filter execution plan for a given request is determined during the `access`
phase, after Lua plugins execution. If the Service entity for the request
is linked to a filter chain, the filters are executed. If the route entity that
was matched to the request is linked to a filter chain, its filters are _also_
executed.

Filters are always executed in the order in which they are defined in the filter
chain.

### Can Lua plugins and Proxy-Wasm filters be used at the same time?

Yes -- Keep in mind though that Lua plugins are executed earlier in the request
lifecycle, **before** filter chain linkage is assessed. So, if a Lua plugin
terminates the request early during the `access` phase, no Proxy-Wasm filters will
be executed.

## Limitations and known issues

### Kong PDK

At the time of this writing, filters do not have access to any of Kong's
Lua-land PDK utilities and are restricted to the functionality defined by
Proxy-Wasm.

### Filter configuration schema

Filter configuration is untyped. That means that Kong
cannot validate a filter configuration ahead of time, e.g. when you create a
filter chain instance using the Admin API. This is not so much a limitation of
Kong's implementation as it is a limitation of the Proxy-Wasm
specification itself.

### Buffered responses in `on_http_response_body`

[Code samples](https://github.com/proxy-wasm/proxy-wasm-rust-sdk/blob/v0.2.1/examples/http_body/src/lib.rs#L52-L56) in the official Proxy-Wasm SDK
repositories demonstrate the ability to buffer the entire response stream by
returning the `pause` signal from `on_http_response_body()`. This behavior is
part of the Envoy Proxy-Wasm implementation but not explicitly called out within
the specification.

Currently, this functionality does not work with Kong, though there are plans on
implementing it in a future release for increase compatibility with other
Proxy-Wasm implementations.

## Further Reading

* [Create a Proxy-Wasm filter](/gateway/latest/plugin-development/wasm)
* [WebAssembly for Proxies (Proxy-Wasm) specification](https://github.com/proxy-wasm/spec)
* [`ngx_wasm_module`](https://github.com/Kong/ngx_wasm_module)
* [`ngx_wasm_module` Proxy-Wasm documentation](https://github.com/Kong/ngx_wasm_module/blob/main/docs/PROXY_WASM.md)
* [Go SDK](https://github.com/tetratelabs/proxy-wasm-go-sdk/)
* [Rust SDK](https://github.com/proxy-wasm/proxy-wasm-rust-sdk/)
