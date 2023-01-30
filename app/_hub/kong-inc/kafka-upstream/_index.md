---
name: Kafka Upstream
publisher: Kong Inc.
desc: Transform requests into Kafka messages in a Kafka topic.
description: |
  This plugin transforms requests into [Kafka](https://kafka.apache.org/) messages
  in an [Apache Kafka](https://kafka.apache.org/) topic. For more information, see
  [Kafka topics](https://kafka.apache.org/documentation/#intro_concepts_and_terms).

  Kong also provides a Kafka Log plugin for publishing logs to a Kafka topic.
  See [Kafka Log](/hub/kong-inc/kafka-log/).
type: plugin
enterprise: true
plus: true
categories:
  - transformations
kong_version_compatibility:
  community_edition:
    compatible: null
  enterprise_edition:
    compatible: true
---

### Enable on a service-less route

```bash
curl -X POST http://kong:8001/routes/my-route/plugins \
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

This plugin uses the [lua-resty-kafka](https://github.com/kong/lua-resty-kafka) client.

{% if_plugin_version gte:2.6.x %}

When encoding request bodies, several things happen:

* For requests with a content-type header of `application/x-www-form-urlencoded`, `multipart/form-data`,
  or `application/json`, this plugin passes the raw request body in the `body` attribute, and tries
  to return a parsed version of those arguments in `body_args`. If this parsing fails, an error message is
  returned and the message is not sent.
* If the `content-type` is not `text/plain`, `text/html`, `application/xml`, `text/xml`, or `application/soap+xml`,
  then the body will be base64-encoded to ensure that the message can be sent as JSON. In such a case,
  the message has an extra attribute called `body_base64` set to `true`.

## TLS

Enable TLS by setting `config.security.ssl` to `true`.

## mTLS

Enable mTLS by setting a valid UUID of a certificate in `config.security.certificate_id`.

Note that this option needs `config.security.ssl` set to true.
See [Certificate Object](https://docs.konghq.com/gateway/latest/admin-api/#certificate-object)
in the Admin API documentation for information on how to set up Certificates.

## SASL Authentication

To use SASL authentication, set the configuration option `config.authentication.strategy` to `sasl`.

Make sure that these mechanism are enabled on the Kafka side as well.

This plugin supports the following authentication mechanisms:

- **PLAIN:** Enable this mechanism by setting `config.authentication.mechanism` to `PLAIN`.
  You also need to provide a username and password with the config options `config.authentication.user`
  and `config.authentication.password` respectively.

- **SCRAM**: In cryptography, the Salted Challenge Response Authentication Mechanism (SCRAM)
  is a family of modern, password-based challenge–response authentication mechanisms
  providing authentication of a user to a server. The Kafka Upstream plugin supports the following:

    - **SCRAM-SHA-256:** Enable this mechanism by setting `config.authentication.mechanism`
    to `SCRAM-SHA-256`. You also need to provide a username and password with the config options
    `config.authentication.user` and `config.authentication.password` respectively.

    {% if_plugin_version gte:2.8.x %}
    - **SCRAM-SHA-512:** Enable this mechanism by setting `config.authentication.mechanism`
      to `SCRAM-SHA-512`. You also need to provide a username and password with the config options
      `config.authentication.user` and `config.authentication.password` respectively.
    {% endif_plugin_version %}

- **Delegation Tokens:** Delegation Tokens can be generated in Kafka and then used to authenticate
  this plugin. `Delegation Tokens` leverage the `SCRAM-SHA-256` authentication mechanism. The `tokenID`
  is provided with the `config.authentication.user` field and the `token-hmac` is provided with the
  `config.authentication.password` field. To indicate that a token is used you have to set the
  `config.authentication.tokenauth` setting to `true`.

  [Read more on how to create, renew, and revoke delegation tokens.](https://docs.confluent.io/platform/current/kafka/authentication_sasl/authentication_sasl_delegation.html#authentication-using-delegation-tokens)

{% endif_plugin_version %}

## Known issues and limitations

Known limitations:

1. Message compression is not supported.
2. The message format is not customizable.

## Quickstart

The following steps assume that {{site.base_gateway}} is installed and the Kafka Upstream plugin is enabled.

{:.note}
> **Note**: We use `zookeeper` in the following example, which is not required or has been removed on some Kafka versions. Refer to the [Kafka ZooKeeper documentation](https://kafka.apache.org/documentation/#zk) for more information.

1. Create a `kong-upstream` topic in your Kafka cluster:

    ```
    ${KAFKA_HOME}/bin/kafka-topics.sh --create \
        --zookeeper localhost:2181 \
        --replication-factor 1 \
        --partitions 10 \
        --topic kong-upstream
    ```

2. Create a Service-less Route, and add the `kafka-upstream` plugin to it:

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

3. In a different console, start a Kafka consumer:

    ```
    ${KAFKA_HOME}/bin/kafka-console-consumer.sh \
        --bootstrap-server localhost:9092 \
        --topic kong-upstream \
        --partition 0 \
        --from-beginning \
        --timeout-ms 1000
    ```

4. Make sample requests:

    ```
    curl -X POST http://localhost:8000 --header 'Host: kafka-upstream.dev' foo=bar
    ```

    You should receive a `200 { message: "message sent" }` response, and should see the request bodies appear on
    the Kafka consumer console you started in the previous step.

---
