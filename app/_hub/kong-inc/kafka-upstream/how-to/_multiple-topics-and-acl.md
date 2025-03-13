---
nav_title: Configure Multiple Allowed Producer Topics
title: Configure Multiple Allowed Producer Topics with the Kafka Upstream Plugin
minimum_version: 3.10.x
---


Starting in {{site.base_gateway}} 3.10, the Kafka Upstream plugin supports sending messages to multiple client-defined Kafka topics by using a query parameter that contains a list of target topic names. 
To prevent client requests from sending messages to arbitrary topics, you can also define a topic allowlist.

You can use the following fields in combination:
* `config.topics_query_arg`:  Define a request parameter name that contains a list of the target topics that Kafka Upstream will produce messages to. 
* `config.allowed_topics`: Define the list of allowed topic names to which messages can be sent.

{:.note}
> The default topic configured in the `topic` field is always allowed, regardless of its inclusion in `allowed_topics`. When `allowed_topics` is not defined, only the default topic configured in the `topic` field is allowed.

## Using the plugin

Here is an example config that defines an allowlist and a topic list:

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

A client can use the `topic-list` query argument to send the message to multiple topics, including any topics in the  `allowed_topic` list, as well as the default topic defined in the `topic` field:

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


A client can't send the message to a topic that is not allowed in the `allowed_topic` list:

```
> curl 'http://localhost:8000/kafka?topic-list=my-topic,topic1,topic3'
{"message":"Bad Gateway","error":"one or more target topics are not in the allowed topics list"}

# proxy error log will show
2025/03/12 17:07:28 [error] 56468#0: *6580 [kong] producers.lua:28 [kafka-upstream] sending message to the following topics is not allowed: (topic3), client: 127.0.0.1, server: kong, request: "GET /kafka?topic-list=my-topic,topic1,topic3 HTTP/1.1", host: "localhost:8000",
request_id: "2535dd1cf1bee70828eaef039c1e1070"
```
