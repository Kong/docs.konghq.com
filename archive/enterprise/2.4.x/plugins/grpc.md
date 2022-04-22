---
title: Introduction to Kong gRPC Plugins
---

Before going into the specifics of configuring Kong's gRPC plugins, let's
discuss the advantages of the gRPC protocol. Unlike JSON,
[gRPC](https://en.wikipedia.org/wiki/GRPC)
is a binary protocol, using [protobuf](https://en.wikipedia.org/wiki/Protocol_Buffers)
definitions to instruct how the data is marshalled and unmarshalled. Because
binary data is used instead of text, it's a more efficient way to transmit data
over a network. However, this also makes gRPC harder to work with, because inspecting
what went wrong is more challenging. Additionally, few clients natively handle gRPC.

To help alleviate the challenges of working with gRPC, Kong has two plugins:
- [gRPC-Gateway](/hub/kong-inc/grpc-gateway)
- [gRPC-Web](/hub/kong-inc/grpc-web)

The gRPC-Gateway plugin allows you to send JSON requests to a gRPC service. A
specially configured `.proto` file handles the conversion of the JSON request
into one that the gRPC service can handle. This allows you to expose RESTful-style
interfaces that talk to a gRPC service.

The gRPC-Web plugin allows you to interact with a gRPC service from a browser.
Instead of presenting a RESTful-type call, you POST data to the same
gRPC service endpoint that the protobuf defines.

For flexibility and compatibility with RESTful expectations, the gRPC-Gateway
plugin offers more configurability, whereas the gRPC-Web plugin adheres more
directly to the protobuf specification.

Let's walk through setting up each plugin so you can see how they work.

## gRPC-Gateway plugin configuration

Set up a Service:

```
curl -X POST kong-cp-host:8001/services \
--data 'name=grpcbin-service' \
--data 'url=grpc://grpcb.in:9000'
```

Set up the Route to the Service:

```
curl -X POST kong-cp-host:8001/services/grpcbin-service/routes \
--data 'name=grpcbin-get-route' \
--data 'paths=/' \
--data 'methods=GET' \
--data 'headers.x-grpc=true'
```

Set up the gRPC-Web plugin:

```
curl -X POST kong-cp-host:8001/routes/grpcbin-get-route/plugins \
--data 'name=grpc-gateway' \
--data 'config.proto=/usr/local/kong/hello-gateway.proto'
```

Protobuf definition (`hello-gateway.proto`):

```
syntax = "proto3";

package hello;

service HelloService {
  rpc SayHello(HelloRequest) returns (HelloResponse) {
    option (google.api.http) = {
      get: "/v1/messages/{name}"
      additional_bindings {
        get: "/v1/messages/legacy/{name=**}"
      }
      post: "/v1/messages/"
      body: "*"
    }
  }
}


// The request message containing the user's name.
message HelloRequest {
  string name = 1;
}

// The response message containing the greetings
message HelloResponse {
  string message = 1;
}
```

Upload the protobuf definition to your Kong Node:

```
docker cp hello-gateway.proto kong-dp-host:/usr/local/kong/
```

Test your setup:

```
curl -X GET kong-dp-host:8000/v1/messages/kong2.1 \
--header 'x-grpc: true'
```

## gRPC-Web plugin configuration

Set up a Service:

```
curl -X POST kong-cp-host:8001/services \
--data 'name=grpcbin-service' \
--data 'url=grpc://grpcb.in:9000'
```

Set up the Route to the Service:

```
curl -X POST kong-cp-host:8001/services/grpcbin-service/routes \
--data 'name=grpcbin-post-route' \
--data 'paths=/' \
--data 'methods=POST' \
--data 'headers.x-grpc=true'
```

Set up the gRPC-Web plugin:

```
curl -X POST kong-cp-host:8001/routes/grpcbin-post-route/plugins \
--data 'name=grpc-web' \
--data 'config.proto=/usr/local/kong/hello.proto'
```

Protobuf definition (`hello.proto`):

```
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

Upload the protobuf definition to your Kong Node:

```
docker cp hello.proto kong-dp-host:/usr/local/kong/
```

Test your setup:

```
curl -X POST kong-dp-host:8000/hello.HelloService/SayHello \
--header 'x-grpc: true' \
--header 'Content-Type: application/json' \
--data '{"greeting":"kong2.1"}'
```
