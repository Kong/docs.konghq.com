---
nav_title: Overview
---

This plugin consumes messages from [Confluent Cloud](https://confluent.io/cloud) Kafka topics and makes them available through HTTP endpoints.
For more information, see [Confluent Cloud documentation](https://docs.confluent.io/).

Kong also provides plugins for publishing messages to Confluent Cloud:
* See [Confluent](/hub/kong-inc/confluent/)

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
> **Important**: When running multiple data plane nodes, there is no thread-safe behavior between nodes. In high-load scenarios, you may observe the same message being delivered multiple times across different data plane nodes

To minimize duplicate message delivery in a multi-node setup, consider:
* Using a single data plane node for consuming messages from specific topics
* Implementing idempotency handling in your consuming application
* Monitoring consumer group offsets across your data plane nodes

## Prerequisites

Before using this plugin:
1. [Create a Kafka cluster in Confluent Cloud](https://docs.confluent.io/cloud/current/get-started/index.html#step-1-create-a-ak-cluster-in-ccloud)
2. [Create a Kafka topic in the cluster](https://docs.confluent.io/cloud/current/get-started/index.html#step-2-create-a-ak-topic)

## HTTP GET Quickstart

The following steps assume that {{site.base_gateway}} is installed and the Confluent Consume plugin is enabled.

1. Create a Route and add the `confluent-consume` plugin to it:

    ```bash
    curl -X POST http://localhost:8001/routes \
        --data "name=confluent-consumer" \
        --data "hosts[]=confluent-consumer.test"
    ```

    ```bash
    curl -X POST http://localhost:8001/routes/confluent-consumer/plugins \
        --data "name=confluent-consume" \
        --data "config.bootstrap_servers[1].host=<YOUR_BOOTSTRAP_SERVER>" \
        --data "config.bootstrap_servers[1].port=9092" \
        --data "config.topics[1].name=my-topic" \
        --data "config.authentication.strategy=sasl" \
        --data "config.authentication.mechanism=PLAIN" \
        --data "config.authentication.user=<YOUR_API_KEY>" \
        --data "config.authentication.password=<YOUR_API_SECRET>"
    ```

2. Consume messages using HTTP GET:

    ```bash
    curl http://localhost:8000/messages \
        --header 'Host: confluent-consumer.test'
    ```

## Server-Sent Events Quickstart

1. Create a Route and add the `confluent-consume` plugin with SSE mode:

    ```bash
    curl -X POST http://localhost:8001/routes \
        --data "name=confluent-sse-consumer" \
        --data "hosts[]=confluent-sse.test"
    ```

    ```bash
    curl -X POST http://localhost:8001/routes/confluent-sse-consumer/plugins \
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

2. Stream messages using Server-Sent Events:

    ```bash
    curl http://localhost:8000/stream \
        --header 'Host: confluent-sse.test' \
        --header 'Accept: text/event-stream'
    ```

## Configuration

### Enable on a Route

```bash
curl -X POST http://localhost:8001/routes/{route}/plugins \
    --data "name=confluent-consume" \
    --data "config.bootstrap_servers[1].host=<YOUR_BOOTSTRAP_SERVER>" \
    --data "config.bootstrap_servers[1].port=9092" \
    --data "config.topics[1].name=my-topic" \
    --data "config.mode=http-get" \
    --data "config.message_deserializer=json" \
    --data "config.auto_offset_reset=latest" \
    --data "config.authentication.strategy=sasl" \
    --data "config.authentication.mechanism=PLAIN" \
    --data "config.authentication.user=<YOUR_API_KEY>" \
    --data "config.authentication.password=<YOUR_API_SECRET>"
```

### Parameters

Here's a list of all the parameters which can be used in this plugin's configuration:

| FORM PARAMETER | DEFAULT | DESCRIPTION |
|---------------|---------|-------------|
| `bootstrap_servers` <br>*required* | | Set of bootstrap brokers in a `{host: host, port: port}` list format. |
| `topics` <br>*required* | | The Kafka topics and their configuration you want to consume from. |
| `mode` | `http-get` | The mode of operation for the plugin. One of: `http-get`, `server-sent-events` |
| `message_deserializer` | `noop` | The deserializer to use for the consumed messages. One of: `json`, `noop` |
| `auto_offset_reset` | `latest` | The offset to start from when there is no initial offset in the consumer group. One of: `earliest`, `latest` |
| `authentication.strategy` | | The authentication strategy for the plugin. Currently supports: `sasl` |
| `authentication.mechanism` | | The SASL authentication mechanism. Supports: `PLAIN`, `SCRAM-SHA-256`, `SCRAM-SHA-512` |
| `authentication.user` | | Username for SASL authentication (API Key for Confluent Cloud) |
| `authentication.password` | | Password for SASL authentication (API Secret for Confluent Cloud) |
| `cluster_name` | | The name of your Confluent Cloud cluster |
