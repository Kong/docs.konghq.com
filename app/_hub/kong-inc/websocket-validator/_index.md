---
name: WebSocket Validator
publisher: Kong Inc.

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
