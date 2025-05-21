---
nav_title: Overview
---

With Kafka at its core, [Confluent](https://confluent.io) offers complete, fully managed, cloud-native data streaming that's available everywhere your data and applications reside.

<!-- I modified this a bit to point to Apacha  Kafka installations -->
Kong also provides Kafka Log and Kafka Upstream plugins for publishing logs and messages to an Apache Kafka topic:

* See [Kafka Log](/hub/kong-inc/kafka-log/)
* See [Kafka Upstream](/hub/kong-inc/kafka-upstream/)

{:.note}
> **Note**: This plugin has the following known limitations:
> * Message compression is not supported.
> * The message format is not customizable.
> * {{site.base_gateway}} does not support Kafka 4.0.


## Quickstart

### Prerequisites

Follow the links to Confluent's documentation site to:
1. [Create a Kafka cluster in Confluent Cloud](https://docs.confluent.io/cloud/current/get-started/index.html#step-1-create-a-ak-cluster-in-ccloud)
2. [Create a Kafka topic in the cluster](https://docs.confluent.io/cloud/current/get-started/index.html#step-2-create-a-ak-topic)

### Generate API Key

To authorize access from the plugin to your cluster, you need to generate an API Key and secret.
In the **Kafka credentials** pane, leave **Global access** selected, and click **Generate API key & download**. This creates an API key and secret that allows the plugin to access your cluster, and downloads the key and secret to your computer.

### Enable the Confluent Plugin

Create a testing route with the following command:
```bash
curl -X POST http://localhost:8001/routes --data "name=test-confluent" --data "hosts[1]=test-confluent"
```

Enable the plugin on the route with the following command, replacing the placeholder values with the appropriate values for bootstrap server, bootstrap server port, cluster API key, cluster API secret, and topic:

```bash
curl -X POST http://localhost:8001/routes/test-confluent/plugins \
    --data "name=confluent" \
    --data "config.bootstrap_servers[1].host=my-bootstrap-server" \
    --data "config.bootstrap_servers[1].port=my-bootstrap-port" \
    --data "config.cluster_api_key=my-api-key" \
    --data-urlencode "config.cluster_api_secret=my-api-secret" \
    --data "config.topic=my-confluent-topic" \
```

You can make a sample request with:

``` bash
curl -X POST http://localhost:8000 --header 'Host: test-confluent' foo=bar
```

You should receive a `200 { message: "message sent" }` response.

### Validate in Confluent

To check that the message has been added to the topic in the Confluent Cloud console:
1. From the navigation menu, select **Topics** to show the list of topics in your cluster.
2. Select the topic you sent messages to.
3. In the topic detail page, select the **Messages** tab to view the messages being produced to the topic.

## Schema Registry Support

The Confluent plugin supports integration with Schema Registry for AVRO and JSON schemas. Currently, only Confluent Schema Registry is supported.

For more information about Schema Registry integration, see the [Schema Registry documentation](/hub/kong-inc/schema-registry/).

## Configuration

To configure Schema Registry with the Kafka Upstream plugin, use the `schema_registry` parameter in your plugin configuration. See the [Schema Registry Configuration](/hub/kong-inc/schema-registry/configuration/) for specific Schema Registry options.

## Related Resources

- [Schema Registry](/hub/kong-inc/schema-registry/)
- [Confluent Schema Registry Documentation](https://docs.confluent.io/platform/current/schema-registry/index.html)
