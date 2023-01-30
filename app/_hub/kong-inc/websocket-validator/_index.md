---
name: WebSocket Validator
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
    compatible: true

cloud: true

enterprise: true

plus: true

---

## Usage

{:.note}
> **Note**: Currently, the only supported validation type is [JSON schema
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
curl -i -X POST http://HOSTNAME:8001/services/SERVICE/plugins \
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
  service: SERVICE
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


Here's an example sequence for this configuration:


```
 .------.                               .----.                          .--------.
 |Client|                               |Kong|                          |Upstream|
 '------'                               '----'                          '--------'
    |                                     |                                 |
    |     text(`{ "name": "Alex" }`)      |                                 |
    |>----------------------------------->|                                 |
    |                                     |                                 |
    |                                     |    text(`{ "name": "Alex" }`)   |
    |                                     |>------------------------------->|
    |                                     |                                 |
    |     text(`{ "name": "Kiran" }`)     |                                 |
    |>----------------------------------->|                                 |
    |                                     |                                 |
    |                                     |   text(`{ "name": "Kiran" }`)   |
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
