---
name: Kafka Log
publisher: Kong Inc.
version: 1.5.x # 0.1.1 internal handler

desc: Publish logs to a Kafka topic
description: |
   Publish request and response logs to an [Apache Kafka](https://kafka.apache.org/) topic.
   For more information, see [Kafka topics](https://kafka.apache.org/documentation/#intro_concepts_and_terms).

   Kong also provides a Kafka plugin for request transformations. See [Kafka Upstream](/hub/kong-inc/kafka-upstream/).

type: plugin
enterprise: true
plus: true
categories:
  - logging

kong_version_compatibility:
    community_edition:
      compatible:
    enterprise_edition:
      compatible:
        - 2.4.x
        - 2.3.x
        - 2.2.x
        - 2.1.x
        - 1.5.x

params:

  name: kafka-log
  protocols: ["http", "https", "grpc", "grpcs", "tcp", "tls", "udp"]
  config:
    - name: bootstrap_servers
      required: true
      value_in_examples: BOOTSTRAP_SERVERS
      urlencode_in_examples: true
      default:
      datatype: set of record elements
      description: |
        Set of bootstrap brokers in a `{host: host, port: port}` list format. For examples, see the
        [Quickstart](#quickstart).
    - name: topic
      required: true
      value_in_examples: TOPIC
      urlencode_in_examples: true
      default:
      datatype: string
      description: The Kafka topic to publish to.
    - name: timeout
      required: false
      default: "`10000`"
      value_in_examples: TIMEOUT
      datatype: integer
      description: Socket timeout in milliseconds.
    - name: keepalive
      required: false
      default: "`60000`"
      value_in_examples: KEEPALIVE
      datatype: integer
      description: Keepalive timeout in milliseconds.
    - name: producer_request_acks
      required: false
      default: "`1`"
      value_in_examples: PRODUCER_REQUEST_ACKS
      datatype: integer
      description: |
         The number of acknowledgments the producer requires the leader to have received before
         considering a request complete. Allowed values: `0` for no acknowledgments; `1` for only the leader;
         and `-1` for the full ISR (In-Sync Replica set).
    - name: producer_request_timeout
      required: false
      default: "`2000`"
      value_in_examples: PRODUCER_REQUEST_TIMEOUT
      datatype: integer
      description: |
        Time to wait for a Produce response in milliseconds.
    - name: producer_request_limits_messages_per_request
      required: false
      default: "`200`"
      value_in_examples: PRODUCER_REQUEST_LIMITS_MESSAGES_PER_REQUEST
      datatype: integer
      description: Maximum number of messages to include in a single Produce request.
    - name: producer_request_limits_bytes_per_request
      required: false
      default: "`1048576`"
      value_in_examples: PRODUCER_REQUEST_LIMITS_BYTES_PER_REQUEST
      datatype: integer
      description: Maximum size of a Produce request in bytes.
    - name: producer_request_retries_max_attempts
      required: false
      default: "`10`"
      value_in_examples: PRODUCER_REQUEST_RETRIES_MAX_ATTEMPTS
      datatype: integer
      description: Maximum number of retry attempts per single Produce request.
    - name: producer_request_retries_backoff_timeout
      required: false
      default: "`100`"
      datatype: integer
      description: Backoff interval between Produce retry attempts in milliseconds.
    - name: producer_async
      required: false
      default: "`true`"
      datatype: boolean
      description: |
        Flag to enable asynchronous mode.
    - name: producer_async_flush_timeout
      required: false
      default: "`1000`"
      datatype: integer
      description: |
        Maximum time interval in milliseconds between buffer flushes in asynchronous mode.
    - name: producer_async_buffering_limits_messages_in_memory
      required: false
      default: "`50000`"
      datatype: integer
      description: |
        Maximum number of messages that can be buffered in memory in asynchronous mode.
    - name: api_version
      required: false
      default: "`0`"
      datatype: integer
      description: |
        API version of a Produce request. Allowed values: `0`, `1`, or `2`.
---

## Quickstart

The following guidelines assume that both {{site.ee_product_name}} and `Kafka` have been
installed on your local machine.

1. Create a `kong-log` topic in your Kafka cluster:

    ```
    ${KAFKA_HOME}/bin/kafka-topics.sh --create \
        --zookeeper localhost:2181 \
        --replication-factor 1 \
        --partitions 10 \
        --topic kong-log
    ```

2. Add the `kafka-log` plugin globally:

    ```
    curl -X POST http://localhost:8001/plugins \
        --data "name=kafka-log" \
        --data "config.bootstrap_servers[1].host=localhost" \
        --data "config.bootstrap_servers[1].port=9092" \
        --data "config.topic=kong-log"
    ```

3. Make sample requests:

    ```
    for i in {1..50} ; do curl http://localhost:8000/request/$i ; done
    ```

4. Verify the contents of the Kafka `kong-log` topic:

    ```
    ${KAFKA_HOME}/bin/kafka-console-consumer.sh \
        --bootstrap-server localhost:9092 \
        --topic kong-log \
        --partition 0 \
        --from-beginning \
        --timeout-ms 1000
    ```

## Log format

Similar to the [HTTP Log Plugin](https://docs.konghq.com/hub/kong-inc/http-log#log-format).

## Implementation details

This plugin makes use of the [lua-resty-kafka](https://github.com/doujiang24/lua-resty-kafka) client under the hood.

## Known issues and limitations

There is currently no support for:

- TLS
- authentication
- message compression


[badge-travis-url]: https://travis-ci.com/Kong/kong-plugin-kafka-log/branches
[badge-travis-image]: https://travis-ci.com/Kong/kong-plugin-kafka-log.svg?token=BfzyBZDa3icGPsKGmBHb&branch=master
