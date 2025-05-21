---
nav_title: Configuration
---

## Configuration Parameters

The Schema Registry integration is configured within the supported plugins. The configuration differs slightly between producer plugins (like Kafka Log) and consumer plugins (like Kafka Consume).

### Confluent Schema Registry

Currently, Kong supports integration with Confluent Schema Registry for both AVRO and JSON schemas. Only one schema registry provider can be configured at a time.

#### Common Parameters (Both Producers and Consumers)

| Parameter | Description |
|-----------|-------------|
| `schema_registry.confluent.url` | The URL of the Confluent Schema Registry service |
| `schema_registry.confluent.authentication.mode` | Authentication mode for the Schema Registry. Options: `none`, `basic` |
| `schema_registry.confluent.authentication.username` | (Optional) Username for basic authentication |
| `schema_registry.confluent.authentication.password` | (Optional) Password for basic authentication |

#### Producer-Specific Parameters
For plugins that produce messages to Kafka (Kafka Log, Kafka Upstream, Confluent):

| Parameter | Description |
|-----------|-------------|
| `schema_registry.confluent.value_schema.subject_name` | The subject name for the value schema in the Schema Registry |
| `schema_registry.confluent.value_schema.schema_version` | (Optional) Specific schema version to use. Can be a version number or `latest` to always use the most recent version |

#### Consumer-Specific Parameters
For plugins that consume messages from Kafka (Kafka Consume, Confluent Consume):

| Parameter | Description |
|-----------|-------------|
| No additional parameters required | Consumers automatically detect and use the schema ID embedded in the messages |

## Example Configurations

### Producer Plugin Example (Kafka Log)

```json
{
  "name": "kafka-log",
  "config": {
    "bootstrap_servers": [
      {
        "host": "kafka-server-1",
        "port": 9092
      }
    ],
    "topic": "kong-logs",
    "schema_registry": {
      "confluent": {
        "url": "http://schema-registry:8081",
        "authentication": {
          "mode": "basic",
          "username": "user",
          "password": "password"
        },
        "value_schema": {
          "subject_name": "kong-logs-value",
          "schema_version": "latest"
        }
      }
    }
  }
}
```

### Consumer Plugin Example (Kafka Consume)

```json
{
  "name": "kafka-consume",
  "config": {
    "bootstrap_servers": [
      {
        "host": "kafka-server-1",
        "port": 9092
      }
    ],
    "topics": [
      {
        "name": "kong-logs"
      }
    ],
    "schema_registry": {
      "confluent": {
        "url": "http://schema-registry:8081",
        "authentication": {
          "mode": "basic",
          "username": "user",
          "password": "password"
        }
      }
    },
    "mode": "http-get"
  }
}
```
