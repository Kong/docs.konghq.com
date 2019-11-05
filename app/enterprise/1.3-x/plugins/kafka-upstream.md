---
title: Kafka Upstream Plugin
---

This plugin transforms requests into [Kafka](https://kafka.apache.org/) messages in a topic.

## Supported Kong Releases
Kong >= 1.0.x

## Installation

Manually download and install:
```
$ git clone https://github.com/kong/kong-plugin-kafka-upstream.git /path/to/kong/plugins/kong-plugin-kafka-upstream
$ cd /path/to/kong/plugins/kong-plugin-kafka-upstream
$ luarocks make *.rockspec
```

In both cases, you need to change your Kong [`plugins` configuration option](https://docs.konghq.com/1.3.x/configuration/#plugins)
to include this plugin:

```
plugins = bundled,kafka-upstream
```

Or, if you don't want to activate any of the bundled plugins:

```
plugins = kafka-upstream
```

Then reload kong:

```
kong reload
```

## Configuration

### Enabling on a serviceless route

```bash
$ curl -X POST http://kong:8001/routes/my-route/plugins \
    --data "name=kafka-upstream" \
    --data "config.bootstrap_servers[1].host=localhost" \
    --data "config.bootstrap_servers[1].port=9092" \
    --data "config.topic=kong-upstream" \
    --data "config.timeout=10000" \
    --data "config.keepalive=60000" \
    --data "config.forward_method=false",
    --data "config.forward_uri=false",
    --data "config.forward_headers=false",
    --data "config.forward_body=true",
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

### Parameters

Here's a list of all the parameters which can be used in this plugin's configuration:

| Form Parameter | default | description |
| ---            | ---     | ---         |
| `name`         |         | The name of the plugin to use, in this case `kafka-upstream` |
| `config.bootstrap_servers`  |       | List of bootstrap brokers in `{host: host, port: port}` format |
| `config.topic`              |       | Topic to publish to |
| `config.timeout`   <br /> <small>Optional</small>       | 10000 | Socket timeout in millis |
| `config.keepalive` <br /> <small>Optional</small>       | 60000 | Keepalive timeout in millis |
| `config.forward_method` <br /> <small>Optional</small>  | false | Include the request method in the message |
| `config.forward_uri` <br /> <small>Optional</small>     | false | Include the request uri and uri arguments (AKA query arguments) in the message |
| `config.forward_headers` <br /> <small>Optional</small> | false | Include the request headers in the message |
| `config.forward_body` <br /> <small>Optional</small>    | true  | Include the request body in the message |
| `config.producer_request_acks` <br /> <small>Optional</small>                              | 1       | The number of acknowledgments the producer requires the leader to have received before considering a request complete. Allowed values: 0 for no acknowledgments, 1 for only the leader and -1 for the full ISR |
| `config.producer_request_timeout` <br /> <small>Optional</small>                           | 2000    | Time to wait for a Produce response in millis |
| `config.producer_request_limits_messages_per_request` <br /> <small>Optional</small>       | 200     | Maximum number of messages to include into a single Produce request |
| `config.producer_request_limits_bytes_per_request` <br /> <small>Optional</small>          | 1048576 | Maximum size of a Produce request in bytes |
| `config.producer_request_retries_max_attempts` <br /> <small>Optional</small>              | 10      | Maximum number of retry attempts per single Produce request |
| `config.producer_request_retries_backoff_timeout` <br /> <small>Optional</small>           | 100     | Backoff interval between retry attempts in millis |
| `config.producer_async` <br /> <small>Optional</small>                                     | true    | Flag to enable asynchronous mode |
| `config.producer_async_flush_timeout` <br /> <small>Optional</small>                       | 1000    | Maximum time interval in millis between buffer flushes in in asynchronous mode |
| `config.producer_async_buffering_limits_messages_in_memory` <br /> <small>Optional</small> | 50000   | Maximum number of messages that can be buffered in memory in asynchronous mode |


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

