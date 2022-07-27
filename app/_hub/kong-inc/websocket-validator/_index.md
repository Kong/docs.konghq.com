---
name: Websocket Validator
publisher: Kong Inc.

categories:
  - traffic-control

type: plugin

desc: Validate WebSocket messages before they are proxied
description: |
  Validate individual WebSocket messages against to a user-specified schema
  before proxying them.

  Message schema can be configured by type (text or binary) and sender (client
  or upstream).

  When an incoming message is invalid according to the schema, a close frame is
  sent to the sender (status: `1007`) and the peer before closing the
  connection.


kong_version_compatibility:
  enterprise_edition:
    compatible:
      - 3.0.x

cloud: true

enterprise: true

plus: true

params:
  name: websocket-validator
  service_id: true
  route_id: true
  consumer_id: false
  protocols: ["ws", "wss"]
  dbless_compatible: 'yes'
  config:

    - name: client.text.schema
      required: semi
      default: null
      datatype: string
      encrypted: false
      value_in_examples: '''{ "type": "object" }'''
      description: |
        Schema used to validate client-originated text frames. The semantics of
        this field depend on the validation type set by `config.client.text.type`.

    - name: client.text.type
      required: semi
      default: null
      datatype: string
      encrypted: false
      value_in_examples: '''draft4'''
      description: |
        The corresponding validation library for `config.client.text.schema`.
        Currently only `draft4` is supported.


    - name: client.binary.schema
      required: semi
      default: null
      datatype: string
      encrypted: false
      value_in_examples: null
      description: |
        Schema used to validate client-originated binary frames. The semantics of
        this field depend on the validation type set by `config.client.binary.type`.

    - name: client.binary.type
      required: semi
      default: null
      datatype: string
      encrypted: false
      value_in_examples: null
      description: |
        The corresponding validation library for `config.client.binary.schema`.
        Currently only `draft4` is supported.


    - name: upstream.text.schema
      required: semi
      default: null
      datatype: string
      encrypted: false
      value_in_examples: null
      description: |
        Schema used to validate upstream-originated text frames. The semantics of
        this field depend on the validation type set by `config.upstream.text.type`.

    - name: upstream.text.type
      required: semi
      default: null
      datatype: string
      encrypted: false
      value_in_examples: null
      description: |
        The corresponding validation library for `config.upstream.text.schema`.
        Currently only `draft4` is supported.


    - name: upstream.binary.schema
      required: semi
      default: null
      datatype: string
      encrypted: false
      value_in_examples: null
      description: |
        Schema used to validate upstream-originated binary frames. The semantics of
        this field depend on the validation type set by `config.upstream.binary.type`.

    - name: upstream.binary.type
      required: semi
      default: null
      datatype: string
      encrypted: false
      value_in_examples: null
      description: |
        The corresponding validation library for `config.upstream.binary.schema`.
        Currently only `draft4` is supported.
  extra: |
    At least one complete message validation configuration must be defined:
      * `config.client.text.type` + `config.client.text.schema`
      * `config.client.binary.type` + `config.client.binary.schema`
      * `config.upstream.text.type` + `config.upstream.text.schema`
      * `config.upstream.binary.type` + `config.upstream.binary.schema`

---

## Usage

**NOTE:** Currently, the only supported validation type is [JSON schema
draft4](https://json-schema.org/specification-links.html#draft-4), so all
examples will use this.

### Validate client text frames

This example validates that client text frames:

* Are valid JSON
* Are a JSON object (`{}`)
* Have a `name` attribute (of any type)


{% navtabs %}
{% navtab With a database %}


``` bash
curl -i -X POST http://kong:8001/services/{service}/plugins \
  --data "name=websocket-validator" \
  --data "config.client.text.type=draft4" \
  --data 'config.client.text.schema={ "type": "object", "required": ["name"] }'
```
{% endnavtab %}

{% navtab Without a database %}

Add the following entry to the `plugins:` section in the declarative configuration file:

``` yaml
plugins:
- name: websocket-validator
  service: {service}
  config:
    client:
      text:
        type: draft4
        schema: |
          {
            "type": "object",
            "required": [ "name" ]
          }
```

{% endnavtab %}
{% endnavtabs %}


Example sequence for this configuration:


```
 .------.                               .----.                          .--------.
 |Client|                               |Kong|                          |Upstream|
 '------'                               '----'                          '--------'
    |                                     |                                 |
    |   text(`{ "name": "Michael" }`)     |                                 |
    |>----------------------------------->|                                 |
    |                                     |                                 |
    |                                     |  text(`{ "name": "Michael" }`)  |
    |                                     |>------------------------------->|
    |                                     |                                 |
    |    text(`{ "name": "Bob" }`)        |                                 |
    |>----------------------------------->|                                 |
    |                                     |                                 |
    |                                     |    text(`{ "name": "Bob" }`)    |
    |                                     |>------------------------------->|
    |                                     |                                 |
    |  text(`{ "missing_name": true }`)   |                                 |
    |>----------------------------------->|                                 |
    |                                     |                                 |
    |         close(status=1007)          |                                 |
    |<-----------------------------------<|                                 |
    |                                     |                                 |
    |                                     |             close()             |
    |                                     |>------------------------------->|
 .------.                               .----.                          .--------.
 |Client|                               |Kong|                          |Upstream|
 '------'                               '----'                          '--------'
```
