---
name: Kafka Upstream
publisher: Kong Inc.

desc: Transform requests into Kafka messages in a Kafka topic
description: |
   This plugin transforms requests into [Kafka](https://kafka.apache.org/) messages in a Kafka topic.

type: plugin
enterprise: true
categories:
  - transformations

kong_version_compatibility:
    community_edition:
      compatible:
    enterprise_edition:
      compatible:
        - 2.3.x
        - 2.2.x
        - 2.1.x
        - 1.5.x
        - 1.3-x

params:

  name: kafka-upstream
  config:
    - name: bootstrap_servers
      required: true
      value_in_examples: <BOOTSTRAP_SERVERS>
      urlencode_in_examples: true
      default:
      description: |
        List of bootstrap brokers in a `{host: host, port: port}` format.
    - name: topic
      required: true
      value_in_examples: <TOPIC>
      urlencode_in_examples: true
      default:
      description: |
         The Kafka topic to publish to.
    - name: timeout
      required: false
      default: "`10000`"
      value_in_examples: 10000
      description: |
         Socket timeout in milliseconds.
    - name: keepalive
      required: false
      default: "`60000`"
      value_in_examples: 60000
      description: |
         Keepalive timeout in milliseconds.
    - name: forward_method
      required: false
      default: "`false`"
      description: |
         Include the request method in the message.
    - name: forward_uri
      required: false
      default: "`false`"
      description: |
         Include the request URI and URI arguments (i.e., query arguments) in the message.
    - name: forward_headers
      required: false
      default: "`false`"
      description: |
         Include the request headers in the message.
    - name: forward_body
      required: false
      default: "`true`"
      description: |
         Include the request headers in the message.
    - name: producer_request_acks
      required: false
      default: "`1`"
      value_in_examples: -1
      description: |
         The number of acknowledgments the producer requires the leader to have received before considering a request complete. Allowed values are 0 for no acknowledgments, 1 for only the leader, and -1 for the full ISR.
    - name: producer_request_timeout
      required: false
      default: "`2000`"
      value_in_examples: 2000
      description: |
         Time to wait for a Produce response in milliseconds
    - name: producer_request_limits_messages_per_request
      required: false
      default: "`200`"
      value_in_examples: 200
      description: |
         Maximum number of messages to include into a single Produce request.
    - name: producer_request_limits_bytes_per_request
      required: false
      default: "`1048576`"
      value_in_examples: 1048576
      description: |
         Maximum size of a Produce request in bytes.
    - name: producer_request_retries_max_attempts
      required: false
      default: "`10`"
      value_in_examples: 10
      description: |
         Maximum number of retry attempts per single Produce request.
    - name: producer_request_retries_backoff_timeout
      required: false
      default: "`100`"
      description: |
       Backoff interval between retry attempts in milliseconds.
    - name: producer_async
      required: false
      default: "`true`"
      description: |
         Flag to enable asynchronous mode.
    - name: producer_async_flush_timeout
      required: false
      default: "`1000`"
      description: |
         Maximum time interval in milliseconds between buffer flushes in asynchronous mode.
    - name: producer_async_buffering_limits_messages_in_memory
      required: false
      default: "`50000`"
      description: |
         Maximum number of messages that can be buffered in memory in asynchronous mode.

---

### Enabling on a serviceless route

```bash
$ curl -X POST http://kong:8001/routes/my-route/plugins \
    --data "name=kafka-upstream" \
    --data "config.bootstrap_servers[1].host=localhost" \
    --data "config.bootstrap_servers[1].port=9092" \
    --data "config.topic=kong-upstream" \
    --data "config.timeout=10000" \
    --data "config.keepalive=60000" \
    --data "config.forward_method=false" \
    --data "config.forward_uri=false" \
    --data "config.forward_headers=false" \
    --data "config.forward_body=true" \
    --data "config.producer_request_acks=1" \
    --data "config.producer_request_timeout=2000" \
    --data "config.producer_request_limits_messages_per_request=200" \
    --data "config.producer_request_limits_bytes_per_request=1048576" \
    --data "config.producer_request_retries_max_attempts=10" \
    --data "config.producer_request_retries_backoff_timeout=100" \
    --data "config.producer_async=true" \
    --data "config.producer_async_flush_timeout=1000" \
    --data "config.producer_async_buffering_limits_messages_in_memory=50000"
```

## Implementation details

This plugin makes use of [lua-resty-kafka](https://github.com/doujiang24/lua-resty-kafka) client under the hood.

When encoding request bodies, several things happen:

* For requests with content-type header of `application/x-www-form-urlencoded`, `multipart/form-data`
  or `application/json`, this plugin will pass the request body "raw" on the `body` attribute, but also try
  to return a parse version of those arguments in `body_args`. If this parsing fails, an error message will be
  returned and the message will not be sent.
* If the `content-type` is not `text/plain`, `text/html`, `application/xml`, `text/xml` or `application/soap+xml`,
  then the body will be base64-encoded to ensure that the message can be sent as JSON. In such a case,
  the message will have an extra attribute called `body_base64` set to `true`.

## Known issues and limitations

Known limitations:

1. There is no support for TLS
2. There is no support for Authentication
3. There is no support for message compression
4. The message format is not customizable

## Quickstart

The following guidelines assume that both `Kong` and `Kafka` have been installed on your local machine:

1. Install `kong-plugin-kafka-upstream` as mentioned on the "Installation" section of this readme.

2. Create `kong-upstream` topic in your `Kafka` cluster:

    ```
    ${KAFKA_HOME}/bin/kafka-topics.sh --create \
        --zookeeper localhost:2181 \
        --replication-factor 1 \
        --partitions 10 \
        --topic kong-upstream
    ```

3. Create a Service-less Route, and add the `kong-plugin-kafka-upstream` plugin to it:

    ```
    curl -X POST http://localhost:8001/routes \
        --data "name=kafka-upstream" \
        --data "hosts[]=kafka-upstream.dev"
    ```

    ```
    curl -X POST http://localhost:8001/routes/kafka-upstream/plugins \
        --data "name=kafka-upstream" \
        --data "config.bootstrap_servers[1].host=localhost" \
        --data "config.bootstrap_servers[1].port=9092" \
        --data "config.topic=kong-upstream"
    ```

4. (On a different console) start a Kafka consumer:

    ```
    ${KAFKA_HOME}/bin/kafka-console-consumer.sh \
        --bootstrap-server localhost:9092 \
        --topic kong-upstream \
        --partition 0 \
        --from-beginning \
        --timeout-ms 1000
    ```

5. Make sample requests:

    ```
    curl -X POST http://localhost:8000 --header 'Host: kafka-upstream.dev' foo=bar
    ```

    You should receive a `200 { message: "message sent" }` response, and should see the request bodies appear on
    the Kafka consumer console you started on the previous step.
