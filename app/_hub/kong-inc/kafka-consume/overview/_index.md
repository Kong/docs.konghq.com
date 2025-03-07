---
nav_title: Overview
---

This plugin consumes messages from [Apache Kafka](https://kafka.apache.org/) topics and makes them available through HTTP endpoints.
For more information, see [Kafka topics](https://kafka.apache.org/documentation/#intro_concepts_and_terms).

Kong also provides Kafka plugins for publishing messages:
* See [Kafka Log](/hub/kong-inc/kafka-log/)
* See [Kafka Upstream](/hub/kong-inc/kafka-upstream/)

{:.note}
> **Note**: This plugin has the following known limitations:
> * Message compression is not supported.
> * The message format is not customizable.

## Implementation details

The plugin supports two modes of operation:
* `http-get`: Consume messages via HTTP GET requests (default)
* `server-sent-events`: Stream messages using Server-Sent Events (SSE). For more information, see [Server-Sent Events](https://developer.mozilla.org/en-US/docs/Web/API/Server-sent_events)

## Message Delivery Guarantees

{:.important}
> **Important**: When running multiple data plane nodes, there is no thread-safe behavior between nodes. In high-load scenarios, you may observe the same message being delivered multiple times across different data plane nodes.

To minimize duplicate message delivery in a multi-node setup, consider:
* Using a single data plane node for consuming messages from specific topics
* Implementing idempotency handling in your consuming application
* Monitoring consumer group offsets across your data plane nodes

## HTTP GET Quickstart

The following steps assume that {{site.base_gateway}} is installed and the Kafka Consume plugin is enabled.

1. Create a Kafka topic in your cluster:

    ```bash
    ${KAFKA_HOME}/bin/kafka-topics.sh --create \
        --bootstrap-server localhost:9092 \
        --replication-factor 1 \
        --partitions 10 \
        --topic kong-test
    ```

2. Create a Route and add the `kafka-consume` plugin to it:

    ```bash
    curl -X POST http://localhost:8001/routes \
        --data "name=kafka-consumer" \
        --data "hosts[]=kafka-consumer.test"
    ```

    ```bash
    curl -X POST http://localhost:8001/routes/kafka-consumer/plugins \
        --data "name=kafka-consume" \
        --data "config.bootstrap_servers[1].host=localhost" \
        --data "config.bootstrap_servers[1].port=9092" \
        --data "config.topics[1].name=kong-test"
    ```

3. Consume messages using HTTP GET:

    ```bash
    curl http://localhost:8000/messages \
        --header 'Host: kafka-consumer.test'
    ```

## Server-Sent Events Quickstart

1. Create a Route and add the `kafka-consume` plugin with SSE mode:

    ```bash
    curl -X POST http://localhost:8001/routes \
        --data "name=kafka-sse-consumer" \
        --data "hosts[]=kafka-sse.test"
    ```

    ```bash
    curl -X POST http://localhost:8001/routes/kafka-sse-consumer/plugins \
        --data "name=kafka-consume" \
        --data "config.bootstrap_servers[1].host=localhost" \
        --data "config.bootstrap_servers[1].port=9092" \
        --data "config.topics[1].name=kong-test" \
        --data "config.mode=server-sent-events"
    ```

2. Stream messages using Server-Sent Events:

    ```bash
    curl http://localhost:8000/stream \
        --header 'Host: kafka-sse.test' \
        --header 'Accept: text/event-stream'
    ```

## Learn more about the Kafka Consume plugin

* [Configuration reference](/hub/kong-inc/kafka-consume/configuration/)
* [Basic configuration example](/hub/kong-inc/kafka-consume/how-to/basic-example/)

