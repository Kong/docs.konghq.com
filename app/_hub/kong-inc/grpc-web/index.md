---
name: gRPC-Web
publisher: Kong Inc.
version: 0.3.x

categories:
  - transformations

type: plugin

desc: Allow browser clients to call gRPC services
description: |
  A Kong plugin to allow access to a gRPC service via the [gRPC-Web protocol](https://github.com/grpc/grpc/blob/master/doc/PROTOCOL-WEB.md#protocol-differences-vs-grpc-over-http2).
  Primarily, this means JavaScript browser applications using the [gRPC-Web](https://github.com/grpc/grpc-web) library.

source_url: https://github.com/Kong/kong-plugin-grpc-web

license_type: MIT

kong_version_compatibility:
  community_edition:
    compatible:
      - 2.4.x
      - 2.3.x
      - 2.2.x
      - 2.1.x

  enterprise_edition:
    compatible:
      - 2.4.x
      - 2.3.x
      - 2.2.x
      - 2.1.x


params:
  name: grpc-web
  route_id: true
  protocols: ["http", "https"]
  dbless_compatible: true

  config:
    - name: proto
      required: false
      default:
      value_in_examples: path/to/hello.proto
      datatype: string
      description: |
        If present, describes the gRPC types and methods.
        Required to support payload transcoding. When absent, the
        web client must use application/grpw-web+proto content.
    - name: pass_stripped_path
      required: false
      default:
      value_in_examples:
      datatype: boolean
      description:
        If set to `true` causes the plugin to pass the stripped request path to
        the upstream gRPC service (see the `strip_path` Route attribute).
    - name: allow_origin_header
      required: false
      datatype: string
      default: "*"
      value_in_examples:
      description: |
        The value of the `Access-Control-Allow-Origin` header in the response to
        the gRPC-Web client.  The default of `*` is appropriate for requests without
        credentials.  In other cases, specify the allowed origins of the client code.
        For more information, see [MDN Web Docs - Access-Control-Allow-Origin](https://developer.mozilla.org/docs/Web/HTTP/Headers/Access-Control-Allow-Origin).

---

## Purpose

A service that presents a gRPC API can be used by clients written in many languages,
but the network specifications are oriented primarily to connections within a
datacenter. [gRPC-Web] lets you expose the gRPC API to the Internet so
that it can be consumed by browser-based JavaScript applications.

This plugin translates requests and responses between [gRPC-Web] and
[gRPC](https://github.com/grpc/grpc). The plugin supports both HTTP/1.1
and HTTP/2, over plaintext (HTTP) and TLS (HTTPS) connections.

## Usage

Enable this plugin on a Kong Route that serves the `http(s)` protocol
but proxies to a Service with the `grpc(s)` protocol.

Sample configuration via declarative (YAML):

```yaml
_format_version: "1.1"
services:
- protocol: grpc
  host: localhost
  port: 9000
  routes:
  - protocols:
    - http
    paths:
    - /
    plugins:
    - name: grpc-web
```

Same thing via the Admin API:

```bash
$ # add the gRPC service
$ curl -X POST localhost:8001/services \
  --data name=grpc \
  --data protocol=grpc \
  --data host=localhost \
  --data port=9000

$ # add an http route
$ curl -X POST localhost:8001/services/grpc/routes \
  --data protocols=http \
  --data name=web-service \
  --data paths=/

$ # add the plugin to the route
$ curl -X POST localhost:8001/routes/web-service/plugins \
  --data name=grpc-web
```

In these examples, we don't set any plugin configurations.
This minimal setup works for the default varieties of the [gRPC-Web protocol](https://github.com/grpc/grpc/blob/master/doc/PROTOCOL-WEB.md#protocol-differences-vs-grpc-over-http2),
which use ProtocolBuffer messages either directly in binary or with base64-encoding.
The related `Content-Type` headers are `application/grpc-web` or `application/grpc-web+proto`
for binary, and `application/grpc-web-text` or `application/grpc-web-text+proto` for text.

If you want to use JSON encoding, you have to provide the gRPC specification in
a `.proto` file, which needs to be installed in the Kong node running the plugin.
A path starting with a `/` is considered absolute; otherwise, it interprets 
relative to the Kong node's prefix (`/usr/local/kong/` by default). For example:

```protobuf
syntax = "proto2";

package hello;

service HelloService {
  rpc SayHello(HelloRequest) returns (HelloResponse);
  rpc LotsOfReplies(HelloRequest) returns (stream HelloResponse);
  rpc LotsOfGreetings(stream HelloRequest) returns (HelloResponse);
  rpc BidiHello(stream HelloRequest) returns (stream HelloResponse);
}

message HelloRequest {
  optional string greeting = 1;
}

message HelloResponse {
  required string reply = 1;
}
```

The declarative configuration becomes:

```yaml
_format_version: "1.1"
services:
- protocol: grpc
  host: localhost
  port: 9000
  routes:
  - protocols:
    - http
    paths:
    - /
    plugins:
    - name: grpc-web
      proto: path/to/hello.proto
```

or via the Admin API:

```bash
$ # add the plugin to the route
$ curl -X POST localhost:8001/routes/web-service/plugins \
  --data name=grpc-web \
  --data proto=path/to/hello.proto
```

With this setup, there's support for gRPC-Web/JSON clients using `Content-Type` headers
like `application/grpc-web+json` or `application/grpc-web-text+json`.

> **Note**: When using JSON encoding, the [gRPC-Web protocol](https://github.com/grpc/grpc/blob/master/doc/PROTOCOL-WEB.md#protocol-differences-vs-grpc-over-http2) specifies that
both request and response data consist of a series of frames, in a similar way
to the full [gRPC protocol](https://github.com/grpc/grpc). The [gRPC-Web](https://github.com/grpc/grpc-web) library performs this framing as expected.

As an extension, this plugin also allows naked JSON requests with the POST method and
`Content-Type: application/json` header. These requests are encoded to ProtocolBuffer,
framed, and forwarded to the gRPC service. Likewise, the responses are transformed
on the way back, allowing any HTTP client to use a gRPC service without special
libraries. This feature is limited to unary (non-streaming) requests. Streaming
responses are encoded into multiple JSON objects; it's up to the client to split into
separate records if it has to support multiple response messages.

## Related information
- [Kong](https://konghq.com)
- [gRPC protocol](https://github.com/grpc/grpc)
- [gRPC-Web](https://github.com/grpc/grpc-web)
- [gRPC-Web protocol](https://github.com/grpc/grpc/blob/master/doc/PROTOCOL-WEB.md#protocol-differences-vs-grpc-over-http2)
- [lua-protobuf](https://github.com/starwing/lua-protobuf)
- [lua-cjson](https://github.com/openresty/lua-cjson)
- [lua-pack](https://github.com/Kong/lua-pack)

## See also

[Introduction to Kong gRPC plugins](/gateway/latest/configure/grpc)
