---
nav_title: Overview
---

This plugin consumes messages from [Apache Kafka](https://kafka.apache.org/) topics and makes them available through HTTP endpoints.
For more information, see [Kafka topics](https://kafka.apache.org/documentation/#intro_concepts_and_terms).

{:.note}
> **Note**: This plugin has the following known limitations:
> * Message compression is not supported.
> * The message format is not customizable.
> * {{site.base_gateway}} does not support Kafka 4.0.

Kong also provides Kafka plugins for publishing messages:
* See [Kafka Log](/hub/kong-inc/kafka-log/)
* See [Kafka Upstream](/hub/kong-inc/kafka-upstream/)

## Implementation details

The plugin supports two modes of operation:
* `http-get`: Consume messages via HTTP GET requests (default)
* `server-sent-events`: Stream messages using [Server-Sent Events](https://developer.mozilla.org/en-US/docs/Web/API/Server-sent_events)

## Message delivery guarantees

When running multiple data plane nodes, there is no thread-safe behavior between nodes. In high-load scenarios, you may observe the same message being delivered multiple times across different data plane nodes.

To minimize duplicate message delivery in a multi-node setup, consider:
* Using a single data plane node for consuming messages from specific topics
* Implementing idempotency handling in your consuming application
* Monitoring consumer group offsets across your data plane nodes

## HTTP GET quickstart

The following steps assume that {{site.base_gateway}} is installed.

1. Create a Kafka topic in your cluster:

   ```bash
   ${KAFKA_HOME}/bin/kafka-topics.sh --create \
      --bootstrap-server localhost:9092 \
      --replication-factor 1 \
      --partitions 10 \
      --topic kong-test
   ```

2. Create a Route:

   ```bash
   curl -X POST http://localhost:8001/routes \
      --data "name=kafka-consume" \
      --data "hosts[]=kafka-consume.test"
   ```

3. Add the `kafka-consume` plugin to the Route:

   ```bash
   curl -X POST http://localhost:8001/routes/kafka-consume/plugins \
      --data "name=kafka-consume" \
      --data "config.bootstrap_servers[1].host=localhost" \
      --data "config.bootstrap_servers[1].port=9092" \
      --data "config.topics[1].name=kong-test"
   ```

4. Consume messages using HTTP GET:

   ```bash
   curl http://localhost:8000/messages \
      --header 'Host: kafka-consume.test'
   ```

## Server-Sent Events quickstart

1. Create a Route:

   ```bash
   curl -X POST http://localhost:8001/routes \
      --data "name=kafka-sse-consume" \
      --data "hosts[]=kafka-sse.test"
   ```

2. Add the `kafka-consume` plugin in SSE mode:
   ```bash
   curl -X POST http://localhost:8001/routes/kafka-sse-consume/plugins \
      --data "name=kafka-consume" \
      --data "config.bootstrap_servers[1].host=localhost" \
      --data "config.bootstrap_servers[1].port=9092" \
      --data "config.topics[1].name=kong-test" \
      --data "config.mode=server-sent-events"
   ```

3. Stream messages using Server-Sent Events:

   ```bash
   curl http://localhost:8000/stream \
      --header 'Host: kafka-sse.test' \
      --header 'Accept: text/event-stream'
   ```

## Learn more about the Kafka Consume plugin

* [Configuration reference](/hub/kong-inc/kafka-consume/configuration/)
* [Basic configuration example](/hub/kong-inc/kafka-consume/how-to/basic-example/)
