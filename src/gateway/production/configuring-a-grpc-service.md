---
title: Configuring a gRPC Service
content_type: how-to
---

{:.note}
> Note: This guide assumes familiarity with gRPC. For learning how to set up
Kong with an upstream REST API, check out the [Configuring a service guide][conf-service].

gRPC proxying is natively supported in Kong. In this guide, you'll learn how 
to configure Kong to manage your gRPC services. For the
purpose of this guide, we'll use [`grpcurl`][grpcurl] and [`grpcbin`][grpcbin] - they
provide a gRPC client and gRPC services, respectively.

The guide sets up two examples:
*  A single gRPC service and route, with a single catch-all route that proxies all matching 
gRPC traffic to an upstream gRPC service. 
* A single gRPC service with multiple routes, demonstrating how to use a route per gRPC method.

In Kong, gRPC support assumes gRPC over HTTP/2 framing. Make sure
you have at least one [HTTP/2 proxy listener](/gateway/{{page.release}}/reference/configuration/#proxy_listen). 

The following examples assume that Kong is running and listening for HTTP/2 proxy
requests on port 9080.

## Single gRPC service and route

1. Issue the following request to create a gRPC service. 
    For example, if your gRPC server is listening on `localhost`, port `15002`:

    ```bash
    curl -XPOST localhost:8001/services \
      --data name=grpc \
      --data protocol=grpc \
      --data host=localhost \
      --data port=15002
    ```

1. Issue the following request to create a gRPC route:

    ```bash
    curl -XPOST localhost:8001/services/grpc/routes \
      --data protocols=grpc \
      --data name=catch-all \
      --data paths=/
    ```

1. Using the [`grpcurl`][grpcurl] command line client, issue the following gRPC
request:

    ```bash
    grpcurl -v -d '{"greeting": "Kong!"}' \
      -plaintext localhost:9080 hello.HelloService.SayHello
    ```

    The response should resemble the following:

    ```
    Resolved method descriptor:
    rpc SayHello ( .hello.HelloRequest ) returns ( .hello.HelloResponse );

    Request metadata to send:
    (empty)

    Response headers received:
    content-type: application/grpc
    date: Tue, 16 Jul 2019 21:37:36 GMT
    server: openresty/1.15.8.1
    via: kong/1.2.1
    x-kong-proxy-latency: 0
    x-kong-upstream-latency: 0

    Response contents:
    {
      "reply": "hello Kong!"
    }

    Response trailers received:
    (empty)
    Sent 1 request and received 1 response
    ```

Notice that Kong response headers, such as `via` and `x-kong-proxy-latency`, were
inserted in the response.

## Single gRPC service with multiple routes

Building on top of the previous example, let's create a few more routes for
individual gRPC methods.

In this example, the gRPC `HelloService` service exposes a few different
methods, as can be seen in its [protocol buffer file][protobuf]. 

1. Create individual routes for its `SayHello` and `LotsOfReplies` methods.

    1. Create a route for `SayHello`:

        ```bash
        curl -X POST localhost:8001/services/grpc/routes \
          --data protocols=grpc \
          --data paths=/hello.HelloService/SayHello \
          --data name=say-hello
        ```

    1. Create a route for `LotsOfReplies`:

        ```bash
        curl -X POST localhost:8001/services/grpc/routes \
          --data protocols=grpc \
          --data paths=/hello.HelloService/LotsOfReplies \
          --data name=lots-of-replies
        ```

    With this setup, gRPC requests to the `SayHello` method will match the first
    route, while requests to `LotsOfReplies` will be routed to the latter.

{% if_version gte:3.2.x %}
1. In `kong.conf`, set [`allow_debug_header: on`](/gateway/{{page.release}}/reference/configuration/#allow_debug_header).
{% endif_version %}

1. Issue a gRPC request to the `SayHello` method:

    ```bash
    grpcurl -v -d '{"greeting": "Kong!"}' \
      -H 'kong-debug: 1' -plaintext \
      localhost:9080 hello.HelloService.SayHello
    ```

    Notice that the example sends the header `kong-debug`, which causes Kong to insert
    debugging information in response headers. 

    The response should look like:

    ```
    Resolved method descriptor:
    rpc SayHello ( .hello.HelloRequest ) returns ( .hello.HelloResponse );

    Request metadata to send:
    kong-debug: 1

    Response headers received:
    content-type: application/grpc
    date: Tue, 16 Jul 2019 21:57:00 GMT
    kong-route-id: 390ef3d1-d092-4401-99ca-0b4e42453d97
    kong-service-id: d82736b7-a4fd-4530-b575-c68d94c3493a
    kong-service-name: s1
    server: openresty/1.15.8.1
    via: kong/1.2.1
    x-kong-proxy-latency: 0
    x-kong-upstream-latency: 0

    Response contents:
    {
      "reply": "hello Kong!"
    }

    Response trailers received:
    (empty)
    Sent 1 request and received 1 response
    ```

    Notice the route ID should refer to the first route we created.

1. Similarly, let's issue a request to the `LotsOfReplies` gRPC method:

    ```bash
    grpcurl -v -d '{"greeting": "Kong!"}' \
      -H 'kong-debug: 1' -plaintext \
      localhost:9080 hello.HelloService.LotsOfReplies
    ```

    The response should look like the following:

    ```
    Resolved method descriptor:
    rpc LotsOfReplies ( .hello.HelloRequest ) returns ( stream .hello.HelloResponse );

    Request metadata to send:
    kong-debug: 1

    Response headers received:
    content-type: application/grpc
    date: Tue, 30 Jul 2019 22:21:40 GMT
    kong-route-id: 133659bb-7e88-4ac5-b177-bc04b3974c87
    kong-service-id: 31a87674-f984-4f75-8abc-85da478e204f
    kong-service-name: grpc
    server: openresty/1.15.8.1
    via: kong/1.2.1
    x-kong-proxy-latency: 14
    x-kong-upstream-latency: 0

    Response contents:
    {
      "reply": "hello Kong!"
    }

    Response contents:
    {
      "reply": "hello Kong!"
    }

    Response contents:
    {
      "reply": "hello Kong!"
    }

    Response contents:
    {
      "reply": "hello Kong!"
    }

    Response contents:
    {
      "reply": "hello Kong!"
    }

    Response contents:
    {
      "reply": "hello Kong!"
    }

    Response contents:
    {
      "reply": "hello Kong!"
    }

    Response contents:
    {
      "reply": "hello Kong!"
    }

    Response contents:
    {
      "reply": "hello Kong!"
    }

    Response contents:
    {
      "reply": "hello Kong!"
    }

    Response trailers received:
    (empty)
    Sent 1 request and received 10 responses
    ```

    Notice that the `kong-route-id` response header now carries a different value
    and refers to the second Route created in this page.

{:.note}
> **Note:**
> Some gRPC clients (typically CLI clients) issue ["gRPC Reflection Requests"][grpc-reflection]
as a means of determining what methods a server exports and how those methods are called.
> These requests have a particular path. For example, `/grpc.reflection.v1alpha.ServerReflection/ServerReflectionInfo` is a valid reflection path. 
> As with any proxy request, Kong needs to know how to route these requests. 
> In the current example, they would be routed to the catch-all route whose path is `/`, matching any path. 
> If no route matches the gRPC reflection request, Kong will respond, as expected, with a `404 Not Found` response.

## Enabling plugins

Let's try out the [File Log][file-log] plugin with gRPC.

1. Issue the following request to enable the File Log plugin on the `SayHello` route:

    ```bash
    curl -X POST localhost:8001/routes/say-hello/plugins \
      --data name=file-log \
      --data config.path=grpc-say-hello.log
    ```

1. Follow the output of the log as gRPC requests are made to `SayHello`:

    ```
    tail -f grpc-say-hello.log
    {"latencies":{"request":8,"kong":5,"proxy":3},"service":{"host":"localhost","created_at":1564527408,"connect_timeout":60000,"id":"74a95d95-fbe4-4ddb-a448-b8faf07ece4c","protocol":"grpc","name":"grpc","read_timeout":60000,"port":15002,"updated_at":1564527408,"write_timeout":60000,"retries":5},"request":{"querystring":{},"size":"46","uri":"\/hello.HelloService\/SayHello","url":"http:\/\/localhost:9080\/hello.HelloService\/SayHello","headers":{"host":"localhost:9080","content-type":"application\/grpc","kong-debug":"1","user-agent":"grpc-go\/1.20.0-dev","te":"trailers"},"method":"POST"},"client_ip":"127.0.0.1","tries":[{"balancer_latency":0,"port":15002,"balancer_start":1564527732522,"ip":"127.0.0.1"}],"response":{"headers":{"kong-route-id":"e49f2df9-3e8e-4bdb-8ce6-2c505eac4ab6","content-type":"application\/grpc","connection":"close","kong-service-name":"grpc","kong-service-id":"74a95d95-fbe4-4ddb-a448-b8faf07ece4c","kong-route-name":"say-hello","via":"kong\/1.2.1","x-kong-proxy-latency":"5","x-kong-upstream-latency":"3"},"status":200,"size":"298"},"route":{"id":"e49f2df9-3e8e-4bdb-8ce6-2c505eac4ab6","updated_at":1564527431,"protocols":["grpc"],"created_at":1564527431,"service":{"id":"74a95d95-fbe4-4ddb-a448-b8faf07ece4c"},"name":"say-hello","preserve_host":false,"regex_priority":0,"strip_path":false,"paths":["\/hello.HelloService\/SayHello"],"https_redirect_status_code":426},"started_at":1564527732516}
    {"latencies":{"request":3,"kong":1,"proxy":1},"service":{"host":"localhost","created_at":1564527408,"connect_timeout":60000,"id":"74a95d95-fbe4-4ddb-a448-b8faf07ece4c","protocol":"grpc","name":"grpc","read_timeout":60000,"port":15002,"updated_at":1564527408,"write_timeout":60000,"retries":5},"request":{"querystring":{},"size":"46","uri":"\/hello.HelloService\/SayHello","url":"http:\/\/localhost:9080\/hello.HelloService\/SayHello","headers":{"host":"localhost:9080","content-type":"application\/grpc","kong-debug":"1","user-agent":"grpc-go\/1.20.0-dev","te":"trailers"},"method":"POST"},"client_ip":"127.0.0.1","tries":[{"balancer_latency":0,"port":15002,"balancer_start":1564527733555,"ip":"127.0.0.1"}],"response":{"headers":{"kong-route-id":"e49f2df9-3e8e-4bdb-8ce6-2c505eac4ab6","content-type":"application\/grpc","connection":"close","kong-service-name":"grpc","kong-service-id":"74a95d95-fbe4-4ddb-a448-b8faf07ece4c","kong-route-name":"say-hello","via":"kong\/1.2.1","x-kong-proxy-latency":"1","x-kong-upstream-latency":"1"},"status":200,"size":"298"},"route":{"id":"e49f2df9-3e8e-4bdb-8ce6-2c505eac4ab6","updated_at":1564527431,"protocols":["grpc"],"created_at":1564527431,"service":{"id":"74a95d95-fbe4-4ddb-a448-b8faf07ece4c"},"name":"say-hello","preserve_host":false,"regex_priority":0,"strip_path":false,"paths":["\/hello.HelloService\/SayHello"],"https_redirect_status_code":426},"started_at":1564527733554}
    ```

[enabling-plugins]: /gateway/{{page.release}}/get-started/enabling-plugins
[conf-service]: /gateway/{{page.release}}/get-started/services-and-routes
[configuration-reference]: /gateway/{{page.release}}/reference/configuration/
[grpc-reflection]: https://github.com/grpc/grpc/blob/master/doc/server_reflection_tutorial.md
[grpcbin]: https://github.com/moul/grpcbin
[grpcurl]: https://github.com/fullstorydev/grpcurl
[protobuf]: https://raw.githubusercontent.com/moul/pb/master/hello/hello.proto
[file-log]: /hub/kong-inc/file-log
[zipkin]: /hub/kong-inc/zipkin
