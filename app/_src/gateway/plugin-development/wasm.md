---
title: WebAssembly
book: plugin_dev
chapter: 11
---

# Hello World: Your First Proxy-Wasm Filter

Filters can be written in almost any language that supports WebAssembly as a
compilation target, but the easiest  and most ergonomic way to get started is by
using a language which has an existing [Proxy-Wasm](https://github.com/proxy-wasm/spec)
SDK, such as [Go](https://github.com/tetratelabs/proxy-wasm-go-sdk/),
[C++](https://github.com/proxy-wasm/proxy-wasm-cpp-sdk/), or [Rust](https://github.com/proxy-wasm/proxy-wasm-rust-sdk/).

This section describes how to create and use a basic Proxy-Wasm filter to
terminate the request after sending a custom response.

## The Code

The Hello World filter will be written in Rust, using the
[Proxy-Wasm SDK for Rust](https://github.com/proxy-wasm/proxy-wasm-rust-sdk/).

Here is a look at the filesystem tree:

```console
$ tree
.
├── Cargo.toml
└── src
    └── filter.rs

2 directories, 2 files
```


The `Cargo.toml` file holds the metadata necessary for building the filter:

```toml
[package]
name = "hello_world"
version = "0.1.0"
edition = "2021"

[lib]
path = "src/filter.rs"
crate-type = ["cdylib"]

[dependencies]
proxy-wasm = "0.2"
```

And `src/filter.rs` holds the actual filter code:

```rust
use proxy_wasm::traits::{Context, HttpContext};
use proxy_wasm::types::Action;

struct HelloWorld;

impl Context for HelloWorld {}

impl HttpContext for HelloWorld {
    fn on_http_request_headers(&mut self, _num_headers: usize, _end_of_stream: bool) -> Action {
        static RESPONSE: &str = "Hello from Proxy-Wasm!";

        self.send_http_response(200, vec![], Some(RESPONSE.as_bytes()));

        Action::Continue
    }
}

proxy_wasm::main! {{
   proxy_wasm::set_http_context(|_, _| -> Box<dyn HttpContext> {
       Box::new(HelloWorld)
   });
}}
```

### Building the Filter Module

Use `cargo` to build the filter module, specifying `wasm32-wasi` as the build
target:

```console
$ cargo build --target wasm32-wasi
```

This will produce a binary file at `target/wasm32-wasi/debug/hello_world.wasm`.

### Deploying the Filter with Kong

After writing and building the filter, it is time to deploy it.

#### Configuration

At first, WebAssembly support must be enabled in {{site.base_gateway}}:

```console
$ echo "wasm = on" > kong.conf
```

The path where the filters files are stored also must be set. It can be the full
`cargo` target output path, or the individual file can be copied or moved into a
common directory instead:

```console
$ mkdir -p ./filters
$ cp target/wasm32-wasi/debug/hello_world.wasm ./filters/
$ echo "wasm_filters_path = $PWD/filters" >> kong.conf
```

#### Link to a Kong Service and Route

Now, the next step is to create a Kong filter chain entity using the Hello World
filter and associate it with a Kong route or service. This will be done by
creating a declarative yaml config file at `kong.yml`:

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
          - name: hello_world
```

```console
$ echo "database = off" >> kong.conf
$ echo "declarative_config = $PWD/kong.yml" >> kong.conf
```

#### Start Kong

Now Kong can be started:

```console
$ echo "prefix = $PWD/wasm-servroot" >> kong.conf
$ kong prepare -c kong.conf
$ kong start -c kong.conf
```

And the Hello World filter is ready to be used:

```console
$ curl http://127.0.0.1:8000/
Hello from Proxy-Wasm!
```

## Further Reading

Other useful resources to learn more about Proxy-Wasm:
* [Proxy-Wasm spec](https://github.com/proxy-wasm/spec)
* [ngx_wasm_module](https://github.com/Kong/ngx_wasm_module)
* [ngx_wasm_module Proxy-Wasm documentation](https://github.com/Kong/ngx_wasm_module/blob/main/docs/PROXY_WASM.md)
* [Kong's `filter_chains` entity](/gateway/latest/reference/wasm/#filter-chain)
* [Go SDK](https://github.com/tetratelabs/proxy-wasm-go-sdk/)
* [Rust SDK](https://github.com/proxy-wasm/proxy-wasm-rust-sdk/)
* [C++ SDK](https://github.com/proxy-wasm/proxy-wasm-cpp-sdk/)
