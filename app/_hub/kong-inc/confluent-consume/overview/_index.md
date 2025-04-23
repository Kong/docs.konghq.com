---
nav_title: Overview
---

This plugin consumes messages from [Confluent Cloud](https://confluent.io/cloud) Kafka topics and makes them available through HTTP endpoints.
For more information, see the [Confluent Cloud documentation](https://docs.confluent.io/).

{:.note}
> **Note**: This plugin has the following known limitations:
> * Message compression is not supported.
> * The message format is not customizable.
> * {{site.base_gateway}} does not support Kafka 4.0.

Kong also provides a [plugin for publishing messages to Confluent Cloud](/hub/kong-inc/confluent/).

## Implementation details

The plugin supports two modes of operation:
* `http-get`: Consume messages via HTTP GET requests (default)
* `server-sent-events`: Stream messages using [Server-Sent Events](https://developer.mozilla.org/en-US/docs/Web/API/Server-sent_events)

## Message delivery guarantees

When running multiple data plane nodes, there is no thread-safe behavior between nodes. In high-load scenarios, you may observe the same message being delivered multiple times across different data plane nodes

To minimize duplicate message delivery in a multi-node setup, consider:
* Using a single data plane node for consuming messages from specific topics
* Implementing idempotency handling in your consuming application
* Monitoring consumer group offsets across your data plane nodes

## Prerequisites

Before using this plugin:
1. [Create a Kafka cluster in Confluent Cloud](https://docs.confluent.io/cloud/current/get-started/index.html#step-1-create-a-ak-cluster-in-ccloud)
2. [Create a Kafka topic in the cluster](https://docs.confluent.io/cloud/current/get-started/index.html#step-2-create-a-ak-topic)

## HTTP GET quickstart

The following steps assume that {{site.base_gateway}} is installed.

1. Create a Route:

   ```bash
   curl -X POST http://localhost:8001/routes \
      --data "name=confluent-consume" \
      --data "hosts[]=confluent-consume.test"
   ```
2. Add the `confluent-consume` plugin to the Route:

	 ```bash
   curl -X POST http://localhost:8001/routes/confluent-consume/plugins \
      --data "name=confluent-consume" \
      --data "config.bootstrap_servers[1].host=<YOUR_BOOTSTRAP_SERVER>" \
      --data "config.bootstrap_servers[1].port=9092" \
      --data "config.topics[1].name=my-topic" \
      --data "config.authentication.strategy=sasl" \
      --data "config.authentication.mechanism=PLAIN" \
      --data "config.authentication.user=<YOUR_API_KEY>" \
      --data "config.authentication.password=<YOUR_API_SECRET>"
   ```

3. Consume messages using HTTP GET:

   ```bash
   curl http://localhost:8000/messages \
      --header 'Host: confluent-consume.test'
   ```

## Server-Sent Events quickstart

1. Create a Route:

   ```bash
   curl -X POST http://localhost:8001/routes \
      --data "name=confluent-sse-consume" \
      --data "hosts[]=confluent-sse.test"
   ```
2. Add the `confluent-consume` plugin in SSE mode:

   ```bash
   curl -X POST http://localhost:8001/routes/confluent-sse-consume/plugins \
      --data "name=confluent-consume" \
      --data "config.bootstrap_servers[1].host=<YOUR_BOOTSTRAP_SERVER>" \
      --data "config.bootstrap_servers[1].port=9092" \
      --data "config.topics[1].name=my-topic" \
      --data "config.mode=server-sent-events" \
      --data "config.authentication.strategy=sasl" \
      --data "config.authentication.mechanism=PLAIN" \
      --data "config.authentication.user=<YOUR_API_KEY>" \
      --data "config.authentication.password=<YOUR_API_SECRET>"
   ```

3. Stream messages using Server-Sent Events:

   ```bash
   curl http://localhost:8000/stream \
      --header 'Host: confluent-sse.test' \
      --header 'Accept: text/event-stream'
   ```

## Learn more about the Confluent Consume plugin

* [Configuration reference](/hub/kong-inc/confluent-consume/configuration/)
* [Basic configuration example](/hub/kong-inc/confluent-consume/how-to/basic-example/)
