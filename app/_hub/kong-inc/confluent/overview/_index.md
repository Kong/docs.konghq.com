---
nav_title: Overview
---

With Kafka at its core, [Confluent](https://confluent.io) offers complete, fully managed, cloud-native data streaming that's available everywhere your data and applications reside.

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

Follow the links to Confluent's documentation site to:
1. [Create a Kafka cluster in Confluent Cloud](https://docs.confluent.io/cloud/current/get-started/index.html#step-1-create-a-ak-cluster-in-ccloud)
2. [Create a Kafka topic in the cluster](https://docs.confluent.io/cloud/current/get-started/index.html#step-2-create-a-ak-topic)

To authorize access from the plugin to your cluster, you need to generate an API Key and secret.
In the *Kafka credentials* pane, leave *Global access* selected, and click *Generate API key & download*. This creates an API key and secret that allows the plugin to access your cluster, and downloads the key and secret to your computer.

Enable the plugin on a service-less route with the following command, replacing the placeholder values with the appropriate values for topic, cluster API key and cluster API secret:

```bash
curl -X POST http://localhost:8001/routes/my-route/plugins \
    --data "name=confluent" \
    --data "config.bootstrap_servers[1].host=localhost" \
    --data "config.bootstrap_servers[1].port=9092" \
    --data "config.cluster_api_key=my-api-key" \
    --data "config.cluster_api_secret=my-api-secret" \
    --data "config.topic=my-confluent-topic" \
```

You can make a sample request with:

    ``` bash
    curl -X POST http://localhost:8000 --header 'Host: confluent.dev' foo=bar
    ```

You should receive a `200 { message: "message sent" }` response.
To check that the message has been added to the topic in the Confluent Cloud console:
1. From the navigation menu, select *Topics* to show the list of topics in your cluster.
2. Select the topic you sent messages to.
3. In the topic detail page, select the *Messages* tab to view the messages being produced to the topic.
