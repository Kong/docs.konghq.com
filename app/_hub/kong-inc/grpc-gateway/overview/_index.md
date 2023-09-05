---
nav_title: Overview
---

The gRPC-Gateway plugin allows you to send JSON requests to a gRPC service. A
specially configured `.proto` file handles the conversion of the JSON request
into one that the gRPC service can handle. This allows you to expose RESTful-style
interfaces that talk to a gRPC service.

This plugin's implementation is similar to [gRPC-gateway](https://grpc-ecosystem.github.io/grpc-gateway/).

![grpc-gateway](https://grpc-ecosystem.github.io/grpc-gateway/assets/images/architecture_introduction_diagram.svg)

Image credit: [grpc-gateway](https://grpc-ecosystem.github.io/grpc-gateway/)

## Why gRPC?

Unlike JSON, [gRPC](https://en.wikipedia.org/wiki/GRPC)
is a binary protocol, using [Protobuf](https://en.wikipedia.org/wiki/Protocol_Buffers)
definitions to instruct how the data is marshalled and unmarshalled. Because
binary data is used instead of text, it's a more efficient way to transmit data
over a network. However, this also makes gRPC harder to work with, because inspecting
what went wrong is more challenging. Additionally, few clients natively handle gRPC.

To help alleviate the challenges of working with gRPC, Kong has two plugins:
- gRPC-Gateway
- [gRPC-Web](/hub/kong-inc/grpc-web/)

For flexibility and compatibility with RESTful expectations, the gRPC-Gateway
plugin offers more configurability, whereas the gRPC-Web plugin adheres more
directly to the Protobuf specification.

## Get started with the gRPC-Gateway plugin

* [Configuration reference](/hub/kong-inc/grpc-gateway/configuration/)
* [Basic configuration example](/hub/kong-inc/grpc-gateway/how-to/basic-example/)
* [Learn how to use the plugin](/hub/kong-inc/grpc-gateway/how-to/)
