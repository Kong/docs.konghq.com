---
title: WebAssembly
content_type: reference
badge: free
---

# WebAssembly in Kong

In addition to Lua plugins, {{site.base_gateway}} supports WebAssembly as a
means of extending proxy functionality and performing custom business logic.
This is made possible by Kong's [open source implementation][ngx_wasm_module] of
the [proxy-wasm specification][proxy-wasm].

## Concepts

### filter

In the context of proxy-wasm, a "filter" refers to a specific component or
module that is executed at some stage of request/response handling. Filters can
do things like...

* read or write request or response headers
* read or write the request or response body
* terminate the request early and send a self-generated response

If you are familiar with Kong's Lua plugin support, you can think of filters
as semi-analogous to plugins.

Filters differ from Lua plugins in their file format at runtime. A Lua
plugin typically spans several different Lua source code files (all packaged and
deployed in text format), whereas a filter must be compiled from source code
into a single binary file with the `.wasm` extension.

In order to be usable in {{site.base_gateway}}, all filter files must be present
on disk in a single directory, denoted by the `wasm_filters_path` configuration
directive.

### filter chain

A filter chain is the database entity that represents one or more filters which
are executed for each request to a particular service or route.

Example:

```yaml
---
name: my-filter-chain
# filter chains can be toggled on/off for testing
enabled: true
filters:
    # this maps to $wasm_filters_path/my_filter_chain.wasm
  - name: my_filter
    # at runtime, configuration is passed to the filter as a byte array
    #
    # filter configuration is inherently un-typed--schema and
    # encoding/serialization are left up to the filter code itself
    config: foo=bar baz=bat

    # filters may occur more than once in a single chain, and both will be
    # executed
  - name: my_filter
    config: foo=123 baz=456

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
```


#### Relationships

Filter chains _must_ be linked to a service or route, and as of this writing,
the relationship is one-to-one:

* a service or route may only be linked to a single filter chain
* a filter chain may only be linked to a single service or route

## Filter Execution Behavior

The filter execution plan for a given request is determined during the `access`
phase, after Lua plugin execution. If the target service entity for the request
is linked to a filter chain, its filters are executed. If the route entity that
was matched to the request is linked to a filter chain, its filters are _also_
executed.

Filters are always executed in the order in which they are defined in the filter
chain.

#### Can I use Lua plugins and Wasm filters at the same time?

Yes! Keep in mind though that Lua plugins are executed earlier in the request
lifecycle, _before_ filter chain linkage is assessed. So if a Lua plugin
terminates the request early in the `access` phase, no Wasm filters will be
executed.

## Limitations/Known Issues

### Kong PDK

At the time of this writing, filters do not have access to any of Kong's
Lua-land PDK utilities and are restricted to the functionality defined by
proxy-wasm.

### Filter Configuration Schema

As mentioned above, filter configuration is un-typed. That means that Kong
cannot validate your filter configuration ahead of time (i.e. when you create a
filter chain instance via the admin API). This is not so much a limitation of
Kong's implementation as it is simply a limitation of the proxy-wasm spec
itself.

### Buffered Responses in `on_http_response_body`

[Code samples][rust-body-buffer-example] in the official proxy-wasm SDK
repositories demonstrate the ability to buffer the entire response stream by
returning the `pause` signal from `on_http_response_body()`. This behavior is
part of the Envoy proxy-wasm implementation but not explicitly called out within
the specification.

Currently, this functionality does not work in Kong, though we plan on
implementing it in a future release for increase compatibility with other
proxy-wasm implementations.


## Further Reading

* [ngx_wasm_module proxy-wasm documentation](https://github.com/Kong/ngx_wasm_module/blob/main/docs/PROXY_WASM.md)
* [proxy-wasm spec](https://github.com/proxy-wasm/spec)


[proxy-wasm](https://github.com/proxy-wasm/spec)
[proxy-wasm-doc]: https://github.com/Kong/ngx_wasm_module/blob/main/docs/PROXY_WASM.md#what-is-proxy-wasm
[filter-chain]: link "TODO:link to filter-chain entity"
[sdk]: https://github.com/proxy-wasm/spec#sdks
[go-sdk]: https://github.com/tetratelabs/proxy-wasm-go-sdk/
[rust-sdk]: https://github.com/proxy-wasm/proxy-wasm-rust-sdk/
[cpp-sdk]: https://github.com/proxy-wasm/proxy-wasm-cpp-sdk/
[rust-body-buffer-example]: https://github.com/proxy-wasm/proxy-wasm-rust-sdk/blob/6b47aec926bc29971c727471d6f4c972ec407c7f/examples/http_body/src/lib.rs#L52-L56
[ngx_wasm_module]: https://github.com/Kong/ngx_wasm_module
