---
nav_title: Overview
---

!! Put an intro to Confluent here. !!

<!-- I modified this a bit to point to Apacha  Kafka installations -->
Kong also provides a Kafka Log as well as Kafka Upstream plugin for publishing logs and messages to a Apache Kafka topic.

* See [Kafka Log](/hub/kong-inc/kafka-log/)
* See [Kafka Upstream](/hub/kong-inc/kafka-upstream/)

## Enable on a service-less route

```bash
curl -X POST http://localhost:8001/routes/my-route/plugins \
    --data "name=confluent" \
    --data "config.bootstrap_servers[1].host=localhost" \
    --data "config.bootstrap_servers[1].port=9092" \
    --data "config.cluster_api_key=my-api-key" \
    --data "config.cluster_api_secret=my-api-secret" \
    --data "config.topic=my-confluent-topic" \
```

## Known issues and limitations

Known limitations:

1. Message compression is not supported.
2. The message format is not customizable.

## Quickstart

The following steps assume that {{site.base_gateway}} is installed and the Confluent plugin is enabled.

<!-- Add instructions here on how to Setup a Confluent Cluster or point to upstream documentation -->

Make sample requests:

    ``` bash
    curl -X POST http://localhost:8000 --header 'Host: confluent.dev' foo=bar
    ```

    You should receive a `200 { message: "message sent" }` response, and should see the request bodies appear on
    the Confluent (what's the equivalent in Conlfuent Cloud here?) consumer console you started in the previous step.
