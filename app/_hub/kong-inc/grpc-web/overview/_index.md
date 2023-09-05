---
nav_title: Overview
---

The gRPC-Web plugins allows access to a gRPC service via the [gRPC-Web protocol](https://github.com/grpc/grpc/blob/master/doc/PROTOCOL-WEB.md#protocol-differences-vs-grpc-over-http2).
Primarily, this means JavaScript browser applications using the [gRPC-Web](https://github.com/grpc/grpc-web) library.

A service that presents a gRPC API can be used by clients written in many languages,
but the network specifications are oriented primarily to connections within a
data center. gRPC-Web lets you expose the gRPC API to the Internet so
that it can be consumed by browser-based JavaScript applications.

This plugin translates requests and responses between gRPC-Web and
[gRPC](https://github.com/grpc/grpc). The plugin supports both HTTP/1.1
and HTTP/2, over plaintext (HTTP) and TLS (HTTPS) connections.

## Why gRPC?

Unlike JSON, [gRPC](https://en.wikipedia.org/wiki/GRPC)
is a binary protocol, using [Protobuf](https://en.wikipedia.org/wiki/Protocol_Buffers)
definitions to instruct how the data is marshalled and unmarshalled. Because
binary data is used instead of text, it's a more efficient way to transmit data
over a network. However, this also makes gRPC harder to work with, because inspecting
what went wrong is more challenging. Additionally, few clients natively handle gRPC.

To help alleviate the challenges of working with gRPC, Kong has two plugins:
- [gRPC-Gateway](/hub/kong-inc/grpc-gateway/)
- gRPC-Web

For flexibility and compatibility with RESTful expectations, the gRPC-Gateway
plugin offers more configurability, whereas the gRPC-Web plugin adheres more
directly to the Protobuf specification.

## Get started with the gRPC-Web plugin

* [Configuration reference](/hub/kong-inc/grpc-web/configuration/)
* [Basic configuration example](/hub/kong-inc/grpc-web/how-to/basic-example/)
* [Learn how to use the plugin](/hub/kong-inc/grpc-web/how-to/)
