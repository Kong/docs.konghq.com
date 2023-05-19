## Purpose

This plugin translates requests and responses between gRPC and HTTP REST.

![grpc-gateway](https://grpc-ecosystem.github.io/grpc-gateway/assets/images/architecture_introduction_diagram.svg)

Image credit: [grpc-gateway](https://grpc-ecosystem.github.io/grpc-gateway/)

## Usage

This plugin should be enabled on a Kong `Route` that serves the `http(s)` protocol
but proxies to a `Service` with the `grpc(s)` protocol.

Sample configuration via declarative (YAML):

```yaml
_format_version: "3.0"
services:
- protocol: grpc
  host: localhost
  port: 9000
  routes:
  - protocols:
    - name: http
    paths:
    - /
    plugins:
    - name: grpc-gateway
      config:
        proto: path/to/hello.proto
```

Sample configuration via the Admin API:

1. Add the gRPC service:
  ```sh
  curl -X POST localhost:8001/services \
    --data name=grpc \
    --data protocol=grpc \
    --data host=localhost \
    --data port=9000
  ```

2. Add an `http` route:
  ```sh
  curl -X POST localhost:8001/services/grpc/routes \
    --data protocols=http \
    --data name=web-service \
    --data paths[]=/
  ```

3. Add the plugin to the route:
  ```sh
  curl -X POST localhost:8001/routes/web-service/plugins \
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
message HelloResponse {
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

{% if_plugin_version gte:2.6.x %}
Object fields not mentioned in the endpoint paths as in `/messages/{name}` can be passed as URL arguments, for example `/v1/messages?name=Kong`.  Structured arguments are supported.

 For example, a request like the following:

`/v1/messages?dest.name=Freddy&dest.address=1428+Elm+Street&message=One+Two...`

is interpreted like the following JSON object:

```json
{
  "dest": {
    "name": "Freddy",
    "address": "1428 Elm Street"
  },
  "message": "One Two..."
}
```

Similarly, fields of the type `google.protobuf.Timestamp` are converted to and from strings in ISO8601 format.

{% endif_plugin_version %}

Currently only unary requests are supported; streaming requests are not supported.

## See also

[Introduction to Kong gRPC plugins](/gateway/latest/configure/grpc)
