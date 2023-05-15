## Quickstart

The following guidelines assume that both {{site.ee_product_name}} and `Kafka` have been
installed on your local machine.

{:.note}
> **Note**: We use `zookeeper` in the following example, which is not required or has been removed on some Kafka versions. Refer to the [Kafka ZooKeeper documentation](https://kafka.apache.org/documentation/#zk) for more information.

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
See [Certificate Object](/gateway/latest/admin-api/#certificate-object)
in the Admin API documentation for information on how to set up Certificates.

## SASL Authentication

This plugin supports the following authentication mechanisms:

- **PLAIN:** Enable this mechanism by setting `config.authentication.mechanism` to `PLAIN`.
  You also need to provide a username and password with the config options `config.authentication.user`
  and `config.authentication.password` respectively.

- **SCRAM**: In cryptography, the Salted Challenge Response Authentication Mechanism (SCRAM)
  is a family of modern, password-based challenge–response authentication mechanisms
  providing authentication of a user to a server. The Kafka Log plugin supports the following:

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
