---
name: gRPC-gateway
publisher: Kong Inc.
version: 0.1.x

categories:
  - transformations
type: plugin

desc: Access gRPC services through HTTP REST
description: |
  A Kong plugin to allow access to a gRPC service via HTTP REST requests
  and translate requests and responses in a JSON format. Similar to
  [gRPC-gateway](https://grpc-ecosystem.github.io/grpc-gateway/).

source_url: https://github.com/Kong/kong-plugin-grpc-gateway

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
  name: grpc-gateway
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
        Describes the gRPC types and methods.
        [HTTP configuration](https://github.com/googleapis/googleapis/blob/fc37c47e70b83c1cc5cc1616c9a307c4303fe789/google/api/http.proto)
        must be defined in the file.

---

## Purpose

This plugin translates requests and responses between gRPC and HTTP REST.

![grpc-gateway](https://grpc-ecosystem.github.io/grpc-gateway/assets/images/architecture_introduction_diagram.svg)

Image credit: [grpc-gateway](https://grpc-ecosystem.github.io/grpc-gateway/)

## Usage

This plugin should be enabled on a Kong `Route` that serves the `http(s)` protocol
but proxies to a `Service` with the `grpc(s)` protocol.

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
    - name: grpc-gateway
      config:
        proto: path/to/hello.proto
```

Sample configuration via the Admin API:

```bash
$ # add the gRPC service
$ curl -XPOST localhost:8001/services \
  --data name=grpc \
  --data protocol=grpc \
  --data host=localhost \
  --data port=9000

$ # add an http route
$ curl -XPOST localhost:8001/services/grpc/routes \
  --data protocols=http \
  --data name=web-service \
  --data paths[]=/

$ # add the plugin to the route
$ curl -XPOST localhost:8001/routes/web-service/plugins \
  --data name=grpc-gateway
```

The proto file must contain the
[HTTP REST to gRPC mapping rule](https://github.com/googleapis/googleapis/blob/fc37c47e70b83c1cc5cc1616c9a307c4303fe789/google/api/http.proto).

The example uses the following mapping:

```protobuf
syntax = "proto2";

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
message HelloReply {
  string message = 1;
}
```

Note the `option (google.api.http) = {}` section is required.

You can send the following requests to Kong that translate to the corresponding
gRPC requests:

```bash
curl -XGET localhost:8000/v1/messages/Kong2.0
{"message":"Hello Kong2.0"}

curl -XGET localhost:8000/v1/messages/legacy/Kong2.0
{"message":"Hello Kong2.0"}

curl -XGET localhost:8000/v1/messages/legacy/Kong2.0/more/paths
{"message":"Hello Kong2.0\/more\/paths"}

curl -XPOST localhost:8000/v1/messages/Kong2.0 -d '{"name":"kong2.0"}'
{"message":"Hello kong2.0"}
```

All syntax defined in [Path template syntax](https://github.com/googleapis/googleapis/blob/fc37c47e70b83c1cc5cc1616c9a307c4303fe789/google/api/http.proto#L225) is supported.

Currently only unary requests are supported; streaming requests are not supported.

## See also

[Introduction to Kong gRPC plugins](/enterprise/2.1.x/plugins/grpc)
