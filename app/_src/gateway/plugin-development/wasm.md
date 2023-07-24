---
title: WebAssembly
book: plugin_dev
chapter: 11
---

# Hello World: Your First Wasm Filter

Filters can be written in almost  any language that supports WebAssembly as a
compilation target, but the easiest  and most ergonomic way to get started is by
using a language which has an existing [proxy-wasm SDK][sdk], such as [Go][go-sdk],
[C++][cpp-sdk], or [Rust][rust-sdk].

This section describes how to create and utilize a very basic proxy-wasm filter.

The filter will simply terminate the request after sending a custom response.

### The Code

We'll write our filter in Rust, using the [proxy-wasm SDK for Rust][rust-sdk].

Here is a look at the filesystem tree:

```
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
        static RESPONSE: &str = "Hello from proxy-wasm!";

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

```
cargo build --target wasm32-wasi
```

This will produce a binary file at `target/wasm32-wasi/debug/hello_world.wasm`.

### Deploying the Filter with Kong

We've written and built the filter, and now it's time to deploy.

#### Configuration

We need to tell {{site.base_gateway}} to enable wasm support:

```
echo "wasm = on" > kong.conf
```

And we also need to tell {{site.base_gateway}} which directory the filter module
resides in. We can provide the full `cargo` target output path, or we can just
copy the individual file into a common directory instead:

```
mkdir -p ./filters
cp target/wasm32-wasi/debug/hello_world.wasm ./filters/
echo "wasm_filters_path = $PWD/filters" >> kong.conf
```

#### Link to a Kong Service and Route

Now, what's needed is to create a Kong filter chain entity utilizing our filter
and associate it with a Kong route or service. Let's do that by creating a
declarative yaml config file at `kong.yml`:

```yaml
---
_format_version: '3.0'
services:
  - name: my-wasm-service
    url: http://example.com
    routes:
      - name: my-wasm-route
        paths:
          - /
    filter_chains:
      - name: my-wasm-demo
        filters:
          - name: hello_world
```

```
echo "database = off" >> kong.conf
echo "declarative_config = $PWD/kong.yml" >> kong.conf
```

#### Start Kong

Now we can start Kong:

```
echo "prefix = $PWD/wasm-servroot" >> kong.conf
kong prepare -c kong.conf
kong start -c kong.conf
```

And we can make a request to test it out:

```
$ curl http://127.0.0.1:8000/
Hello from proxy-wasm!
```

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
