---
title: Configuring a gRPC Service
---

Note: this guide assumes familiarity with gRPC; for learning how to set up
Kong with an upstream REST API, check out the [Configuring a Service guide][conf-service].

Starting with version 1.3, gRPC proxying is natively supported in Kong. In this
section, you'll learn how to configure Kong to manage your gRPC services. For the
purpose of this guide, we'll use [grpcurl][grpcurl] and [grpcbin][grpcbin] - they
provide a gRPC client and gRPC services, respectively.

We will describe two setups: Single gRPC Service and Route and single gRPC Service
with multiple Routes. In the former, a single catch-all Route is configured, which
proxies all matching gRPC traffic to an upstream gRPC service; the latter demonstrates
how to use a Route per gRPC method.

In Kong 1.3, gRPC support assumes gRPC over HTTP/2 framing. As such, make sure
you have at least one HTTP/2 proxy listener (check out the [Configuration Reference][configuration-reference]
for how to). In this guide, we will assume Kong is listening for HTTP/2 proxy
requests on port 9080.

## Before you start

You have installed and started {{site.base_gateway}}, either through the [Docker quickstart](/gateway/{{page.kong_version}}/get-started/quickstart) or a more [comprehensive installation](/gateway/{{page.kong_version}}/install-and-run).

## 1. Single gRPC Service and Route

Issue the following request to create a gRPC Service (assuming your gRPC
server is listening in localhost, port 15002):

```bash
curl -XPOST localhost:8001/services \
  --data name=grpc \
  --data protocol=grpc \
  --data host=localhost \
  --data port=15002
```

Issue the following request to create a gRPC route:

```bash
curl -XPOST localhost:8001/services/grpc/routes \
  --data protocols=grpc \
  --data name=catch-all \
  --data paths=/
```

Using the [grpcurl][grpcurl] command line client, issue the following gRPC
request:

```bash
grpcurl -v -d '{"greeting": "Kong 1.3!"}' \
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
  "reply": "hello Kong 1.3!"
}

Response trailers received:
(empty)
Sent 1 request and received 1 response
```

Notice that Kong response headers, such as `via` and `x-kong-proxy-latency`, were
inserted in the response.

## 2. Single gRPC Service with Multiple Routes

Building on top of the previous example, let's create a few more routes, for
individual gRPC methods.

The gRPC "HelloService" service being used in this example exposes a few different
methods, as can be seen in [its protobuf file][protobuf]. We will create individual
routes for its "SayHello" and LotsOfReplies methods.

Create a Route for "SayHello":

```bash
curl -X POST localhost:8001/services/grpc/routes \
  --data protocols=grpc \
  --data paths=/hello.HelloService/SayHello \
  --data name=say-hello
```

Create a Route for "LotsOfReplies":

```bash
curl -X POST localhost:8001/services/grpc/routes \
  --data protocols=grpc \
  --data paths=/hello.HelloService/LotsOfReplies \
  --data name=lots-of-replies
```

With this setup, gRPC requests to the "SayHello" method will match the first
Route, while requests to "LotsOfReplies" will be routed to the latter.

Issue a gRPC request to the "SayHello" method:

```bash
grpcurl -v -d '{"greeting": "Kong 1.3!"}' \
  -H 'kong-debug: 1' -plaintext \
  localhost:9080 hello.HelloService.SayHello
```

(Notice we are sending a header `kong-debug`, which causes Kong to insert
debugging information in response headers.)

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
  "reply": "hello Kong 1.3!"
}

Response trailers received:
(empty)
Sent 1 request and received 1 response
```

Notice the Route ID should refer to the first route we created.

Similarly, let's issue a request to the "LotsOfReplies" gRPC method:

```bash
grpcurl -v -d '{"greeting": "Kong 1.3!"}' \
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
  "reply": "hello Kong 1.3!"
}

Response contents:
{
  "reply": "hello Kong 1.3!"
}

Response contents:
{
  "reply": "hello Kong 1.3!"
}

Response contents:
{
  "reply": "hello Kong 1.3!"
}

Response contents:
{
  "reply": "hello Kong 1.3!"
}

Response contents:
{
  "reply": "hello Kong 1.3!"
}

Response contents:
{
  "reply": "hello Kong 1.3!"
}

Response contents:
{
  "reply": "hello Kong 1.3!"
}

Response contents:
{
  "reply": "hello Kong 1.3!"
}

Response contents:
{
  "reply": "hello Kong 1.3!"
}

Response trailers received:
(empty)
Sent 1 request and received 10 responses
```

Notice that the `kong-route-id` response header now carries a different value
and refers to the second Route created in this page.

**Note:**
Some gRPC clients (typically CLI clients) issue ["gRPC Reflection Requests"][grpc-reflection]
as a means of determining what methods a server exports and how those methods are called.
Said requests have a particular path; for example, `/grpc.reflection.v1alpha.ServerReflection/ServerReflectionInfo`
is a valid reflection path. As with any proxy request, Kong needs to know how to
route these; in the current example, they would be routed to the catch-all route
(whose path is `/`, matching any path). If no route matches the gRPC reflection
request, Kong will respond, as expected, with a `404 Not Found` response.

## 3. Enabling Plugins

Kong 1.3 gRPC support is compatible with Logging and Observability plugins; for
example, let's try out the [File Log][file-log] plugin with gRPC.

Issue the following request to enable File Log on the "SayHello" route:

```bash
curl -X POST localhost:8001/routes/say-hello/plugins \
  --data name=file-log \
  --data config.path=grpc-say-hello.log
```

Follow the output of the log as gRPC requests are made to "SayHello":

```
tail -f grpc-say-hello.log
{"latencies":{"request":8,"kong":5,"proxy":3},"service":{"host":"localhost","created_at":1564527408,"connect_timeout":60000,"id":"74a95d95-fbe4-4ddb-a448-b8faf07ece4c","protocol":"grpc","name":"grpc","read_timeout":60000,"port":15002,"updated_at":1564527408,"write_timeout":60000,"retries":5},"request":{"querystring":{},"size":"46","uri":"\/hello.HelloService\/SayHello","url":"http:\/\/localhost:9080\/hello.HelloService\/SayHello","headers":{"host":"localhost:9080","content-type":"application\/grpc","kong-debug":"1","user-agent":"grpc-go\/1.20.0-dev","te":"trailers"},"method":"POST"},"client_ip":"127.0.0.1","tries":[{"balancer_latency":0,"port":15002,"balancer_start":1564527732522,"ip":"127.0.0.1"}],"response":{"headers":{"kong-route-id":"e49f2df9-3e8e-4bdb-8ce6-2c505eac4ab6","content-type":"application\/grpc","connection":"close","kong-service-name":"grpc","kong-service-id":"74a95d95-fbe4-4ddb-a448-b8faf07ece4c","kong-route-name":"say-hello","via":"kong\/1.2.1","x-kong-proxy-latency":"5","x-kong-upstream-latency":"3"},"status":200,"size":"298"},"route":{"id":"e49f2df9-3e8e-4bdb-8ce6-2c505eac4ab6","updated_at":1564527431,"protocols":["grpc"],"created_at":1564527431,"service":{"id":"74a95d95-fbe4-4ddb-a448-b8faf07ece4c"},"name":"say-hello","preserve_host":false,"regex_priority":0,"strip_path":false,"paths":["\/hello.HelloService\/SayHello"],"https_redirect_status_code":426},"started_at":1564527732516}
{"latencies":{"request":3,"kong":1,"proxy":1},"service":{"host":"localhost","created_at":1564527408,"connect_timeout":60000,"id":"74a95d95-fbe4-4ddb-a448-b8faf07ece4c","protocol":"grpc","name":"grpc","read_timeout":60000,"port":15002,"updated_at":1564527408,"write_timeout":60000,"retries":5},"request":{"querystring":{},"size":"46","uri":"\/hello.HelloService\/SayHello","url":"http:\/\/localhost:9080\/hello.HelloService\/SayHello","headers":{"host":"localhost:9080","content-type":"application\/grpc","kong-debug":"1","user-agent":"grpc-go\/1.20.0-dev","te":"trailers"},"method":"POST"},"client_ip":"127.0.0.1","tries":[{"balancer_latency":0,"port":15002,"balancer_start":1564527733555,"ip":"127.0.0.1"}],"response":{"headers":{"kong-route-id":"e49f2df9-3e8e-4bdb-8ce6-2c505eac4ab6","content-type":"application\/grpc","connection":"close","kong-service-name":"grpc","kong-service-id":"74a95d95-fbe4-4ddb-a448-b8faf07ece4c","kong-route-name":"say-hello","via":"kong\/1.2.1","x-kong-proxy-latency":"1","x-kong-upstream-latency":"1"},"status":200,"size":"298"},"route":{"id":"e49f2df9-3e8e-4bdb-8ce6-2c505eac4ab6","updated_at":1564527431,"protocols":["grpc"],"created_at":1564527431,"service":{"id":"74a95d95-fbe4-4ddb-a448-b8faf07ece4c"},"name":"say-hello","preserve_host":false,"regex_priority":0,"strip_path":false,"paths":["\/hello.HelloService\/SayHello"],"https_redirect_status_code":426},"started_at":1564527733554}
```

[enabling-plugins]: /gateway/{{page.kong_version}}/get-started/quickstart/enabling-plugins
[conf-service]: /gateway/{{page.kong_version}}/get-started/quickstart/configuring-a-service
[configuration-reference]: /gateway/{{page.kong_version}}/reference/configuration/
[grpc-reflection]: https://github.com/grpc/grpc/blob/master/doc/server_reflection_tutorial.md
[grpcbin]: https://github.com/moul/grpcbin
[grpcurl]: https://github.com/fullstorydev/grpcurl
[protobuf]: https://raw.githubusercontent.com/moul/pb/master/hello/hello.proto
[file-log]: /hub/kong-inc/file-log
[zipkin]: /hub/kong-inc/zipkin
