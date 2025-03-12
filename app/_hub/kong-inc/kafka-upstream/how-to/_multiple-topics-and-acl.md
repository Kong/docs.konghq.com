---
nav_title: Configure Multiple Producer Topics with Whitelist in Kafka Upstream Plugin
title: Configure Multiple Producer Topics with Whitelist in Kafka Upstream Plugin
minimum_version: 3.10.x
---

## Configure Multiple Producer Topics with Whitelist in Kafka Upstream Plugin


Since {{site.base_gateway}} 3.10, the Kafka Upstream Plugin supports sending the message to multiple client-defined Kafka topics, by using a query parameter that contains a list of target topic names. To prevent client request from sending message to arbitrary topics, user can also define an allowed topic whitelist that can be sent to.

By using the new configuration field `topics_query_arg`, user can define a request parameter name that contains a list of the target topics that Kafka Upstream will produce message to. By using the new configuration field `allowed_topics`, user can define the list of allowed topic names to which messages can be sent.

{:.note .no-icon}
> The default topic configured in the `topic` field is always allowed, regardless of its inclusion in `allowed_topics`. When `allowed_topics` is not defined, only the default topic configured in the `topic` field is allowed.

## How-to

Here is an example config that demonstrate how these new config field are being used in the Kafka Upstream plugin:

```
_format_version: "3.0"

services:
  - name: kafka-service
    url: http://mock-upstream
    routes:
      - name: kafka-route
        paths:
          - /kafka
    plugins:
      - name: key-auth
      - name: kafka-upstream
        config:
          bootstrap_servers:
            - host: localhost
              port: 9092
          topic: "my-topic"
          topics_query_arg: "topic-list"
          allowed_topics:
            - "my-topic"
            - "topic1"
            - "topic2"

consumers:
  - username: alice
    keyauth_credentials:
      - key: "example-api-key"

```

A client can use the `topic-list` query argument to send the message to multiple topics

```
> curl 'http://localhost:8000/kafka?topic-list=my-topic,topic1'
{"message":"message sent"}

# Check message in the topics
> kcat -b 127.0.0.1:9092 -G mygroup1 -t my-topic -p 0 -C
.....OLD MESSAGES.....
% Reached end of topic my-topic [0] at offset 22
{"body_args":{},"body_base64":true,"body":""}
% Reached end of topic my-topic [0] at offset 23

> kcat -b 127.0.0.1:9092 -G mygroup -t topic1 -p 0 -C
% Reached end of topic topic1 [0] at offset 0
{"body_args":{},"body_base64":true,"body":""}
% Reached end of topic topic1 [0] at offset 1
```

A client can send the message to whatever topics that is incluede in the `allowed_topic` list as well as the default topic defined in the `topic` field.

A client cannot send the message to a topic that is not allowed in the `allowed_topic` list:q

```
> curl 'http://localhost:8000/kafka?topic-list=my-topic,topic1,topic3'
{"message":"Bad Gateway","error":"one or more target topics are not in the allowed topics list"}

# proxy error log will show
2025/03/12 17:07:28 [error] 56468#0: *6580 [kong] producers.lua:28 [kafka-upstream] sending message to the following topics is not allowed: (topic3), client: 127.0.0.1, server: kong, request: "GET /kafka?topic-list=my-topic,topic1,topic3 HTTP/1.1", host: "localhost:8000",
request_id: "2535dd1cf1bee70828eaef039c1e1070"
```
