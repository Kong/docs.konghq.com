---
title: WebAssembly
book: plugin_dev
chapter: 11
---

# Your First Proxy-Wasm Filter

Filters can be written in almost any language that supports WebAssembly as a
compilation target, but the easiest and most ergonomic way to get started is by
using a language which has an existing [Proxy-Wasm](https://github.com/proxy-wasm/spec)
SDK, such as [Go](https://github.com/tetratelabs/proxy-wasm-go-sdk/)
or [Rust](https://github.com/proxy-wasm/proxy-wasm-rust-sdk/).

## Coding, building and deploying a Proxy-Wasm filter

Kong made available Go and Rust Proxy-Wasm filter templates, which can be used
to start coding your own filters or build as they are and have your first "hello
world"-type filter:

* [Go Proxy-Wasm filter template](https://github.com/Kong/proxy-wasm-go-filter-template/)
* [Rust Proxy-Wasm filter template](https://github.com/Kong/proxy-wasm-rust-filter-template/)

### Deploying the Filter with Kong

After writing and building the filter, it is time to deploy it.

#### Configuration

WebAssembly support must be enabled in {{site.base_gateway}}:

```console
$ export KONG_WASM=on
```

Additionally, the `wasm_filters_path` parameter must be configured in order for
{{site.base_gateway}} to load the filter at runtime. During local development,
when a short feedback loop is desirable, you may want to set this parameter to
your build toolchain's output directory (wherever the compiled
`<filter-name>.wasm` file is produced):

```console
$ export KONG_WASM_FILTERS_PATH=/path/to/my_filter/build
```

#### Link to a Kong Service and Route

Now, the next step is to create a Kong filter chain entity using the
filter created in the previous step and associate it with a Kong route
or service. This will be done by creating a declarative yaml config file
at `kong.yml`:

```yaml
---
_format_version: '3.0'
services:
  - name: my-wasm-service
    url: http://mockbin.org
    routes:
      - name: my-wasm-route
        paths:
          - /
    filter_chains:
      - name: my-wasm-demo
        filters:
          - name: my_filter
            config: >-
              {
                "my_greeting": "Hello from WasmX!"
              }
```

```console
$ export KONG_DATABASE=off
$ export KONG_DECLARATIVE_CONFIG="$PWD/kong.yml"
```

#### Start Kong

Now Kong can be started:

```console
$ export KONG_PREFIX="$PWD/wasm-servroot"
$ kong prepare
$ kong start
```

And the Proxy-Wasm filter is ready to be used:

```console
$ http --headers http://127.0.0.1:8000/

HTTP/1.1 200 OK
Connection: keep-alive
Content-Encoding: gzip
Content-Type: text/html; charset=utf-8
Date: Thu, 03 Aug 2023 19:28:27 GMT
Vary: Accept-Encoding
Via: kong/3.4.0
X-Greeting: Hello from WasmX!
X-Kong-Proxy-Latency: 1
X-Kong-Upstream-Latency: 342
```

## Further Reading

Other useful resources to learn more about Proxy-Wasm:
* [Proxy-Wasm spec](https://github.com/proxy-wasm/spec)
* [ngx_wasm_module](https://github.com/Kong/ngx_wasm_module)
* [ngx_wasm_module Proxy-Wasm documentation](https://github.com/Kong/ngx_wasm_module/blob/main/docs/PROXY_WASM.md)
* [Kong's `filter_chains` entity](/gateway/latest/reference/wasm/#filter-chain)
* [Go SDK](https://github.com/tetratelabs/proxy-wasm-go-sdk/)
* [Rust SDK](https://github.com/proxy-wasm/proxy-wasm-rust-sdk/)
