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
      value_in_examples: null
      description: |
        Schema used to validate client-originated text frames. The semantics of
        this field depend on the validation type set by `client.text.type`.
    - name: client.text.type
      required: semi
      default: null
      datatype: string
      encrypted: false
      value_in_examples: null
      description: |
        The validation type to use. Currently only `"draft4"` is supported.
    - name: client.binary.schema
      required: semi
      default: null
      datatype: string
      encrypted: false
      value_in_examples: null
      description: |
        Schema used to validate client-originated binary frames. The semantics of
        this field depend on the validation type set by `client.binary.type`.
    - name: client.binary.type
      required: semi
      default: null
      datatype: string
      encrypted: false
      value_in_examples: null
      description: |
        The validation type to use. Currently only `"draft4"` is supported.
    - name: upstream.text.schema
      required: semi
      default: null
      datatype: string
      encrypted: false
      value_in_examples: null
      description: |
        Schema used to validate upstream-originated text frames. The semantics of
        this field depend on the validation type set by `upstream.text.type`.
    - name: upstream.text.type
      required: semi
      default: null
      datatype: string
      encrypted: false
      value_in_examples: null
      description: |
        The validation type to use. Currently only `"draft4"` is supported.
    - name: upstream.binary.schema
      required: semi
      default: null
      datatype: string
      encrypted: false
      value_in_examples: null
      description: |
        Schema used to validate upstream-originated binary frames. The semantics of
        this field depend on the validation type set by `upstream.binary.type`.
    - name: upstream.binary.type
      required: semi
      default: null
      datatype: string
      encrypted: false
      value_in_examples: null
      description: |
        The validation type to use. Currently only `"draft4"` is supported.

---

## Usage