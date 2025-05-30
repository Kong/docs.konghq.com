---
nav_title: Overview
---

## Introduction

Schema Registry is a feature that allows Kong to integrate with schema registry services to validate and serialize/deserialize messages in a standardized format. Schema registries provide a centralized repository for managing and validating schemas for data formats like AVRO and JSON.

Currently, Kong supports integration with:
- **Confluent Schema Registry** for AVRO and JSON schemas

Support for additional schema registry providers may be added in future releases.

## How Schema Registry Works

### Producer Workflow

When a producer plugin (like Kafka Log) is configured with Schema Registry, the following workflow occurs:

```
┌─────────┐     ┌─────────────┐     ┌───────────────┐     ┌──────────────────┐
│ Request │────>│ Kong Plugin │────>│ Fetch Schema  │────>│ Validate Message │
└─────────┘     └─────────────┘     │ from Registry │     │ Against Schema   │
                                    └───────────────┘     └──────────┬───────┘
                                                                     │
                                                                     ▼
                                    ┌─────────────┐     ┌──────────────────┐
                                    │ Forward to  │<────│ Serialize Using  │
                                    │ Kafka       │     │ Schema           │
                                    └─────────────┘     └──────────────────┘
```

If validation fails, the request is rejected with an appropriate error message.

### Consumer Workflow

When a consumer plugin (like Kafka Consume) is configured with Schema Registry, the following workflow occurs:

```
┌─────────┐     ┌─────────────┐     ┌───────────────┐     ┌──────────────────┐
│ Kafka   │────>│ Kong Plugin │────>│ Extract       │────>│ Fetch Schema     │
│ Message │     └─────────────┘     │ Schema ID     │     │ from Registry    │
└─────────┘                         └───────────────┘     └──────────┬───────┘
                                                                     │
                                                                     ▼
                                    ┌─────────────┐     ┌──────────────────┐
                                    │ Return to   │<────│ Deserialize      │
                                    │ Client      │     │ Using Schema     │
                                    └─────────────┘     └──────────────────┘
```

## Benefits

Using a schema registry with Kong provides several benefits:

- **Data Validation**: Ensures messages conform to a predefined schema before being processed
- **Schema Evolution**: Manages schema changes and versioning
- **Interoperability**: Enables seamless communication between different services using standardized data formats
- **Reduced Overhead**: Minimizes the need for custom validation logic in your applications


## Supported Plugins

The following Kong plugins currently support schema registry integration:

### Producer Plugins
These plugins produce messages to Kafka and can use Schema Registry for serialization:
- [Kafka Log](/hub/kong-inc/kafka-log/)
- [Kafka Upstream](/hub/kong-inc/kafka-upstream/)
- [Confluent](/hub/kong-inc/confluent/)

### Consumer Plugins
These plugins consume messages from Kafka and can use Schema Registry for deserialization:
- [Kafka Consume](/hub/kong-inc/kafka-consume/)
- [Confluent Consume](/hub/kong-inc/confluent-consume/)

## Configuration

Schema registry configuration is specified within the plugin configuration. See the [Configuration](/hub/kong-inc/schema-registry/configuration/) section for details.



## Related Resources

- [Confluent Schema Registry Documentation](https://docs.confluent.io/platform/current/schema-registry/index.html)
- [AVRO Specification](https://avro.apache.org/docs/current/spec.html)
