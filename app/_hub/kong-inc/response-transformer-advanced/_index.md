---
name: Response Transformer Advanced
publisher: Kong Inc.
desc: Modify the upstream response before returning it to the client
description: |
  Transform the response sent by the upstream server on the fly before returning
  the response to the client.

  The Response Transformer Advanced plugin is a superset of the
  open source [Response Transformer plugin](/hub/kong-inc/response-transformer/), and
  provides additional features:

  * When transforming a JSON payload, transformations are applied to nested JSON objects and
    arrays. This can be turned off and on using the `config.dots_in_keys` configuration parameter.
    See [Arrays and nested objects](#arrays-and-nested-objects).
  * Transformations can be restricted to responses with specific status codes using various
    `config.*.if_status` configuration parameters.
  * JSON body contents can be restricted to a set of allowed properties with
    `config.allow.json`.
  * The entire response body can be replaced using `config.replace.body`.
  * Arbitrary transformation functions written in Lua can be applied.
  * The plugin will decompress and recompress Gzip-compressed payloads
    when the `Content-Encoding` header is `gzip`.

  Response Transformer Advanced includes the following additional configurations: `add.if_status`, `append.if_status`,
  `remove.if_status`, `replace.body`, `replace.if_status`, `transform.functions`, `transform.if_status`,
  `allow.json`, `rename.if_status`, `transform.json`, and `dots_in_keys`.

  <div class="alert alert-warning">
    <strong>Note on transforming bodies:</strong> Be aware of the performance of transformations on the
    response body. In order to parse and modify a JSON body, the plugin needs to retain it in memory,
    which might cause pressure on the worker's Lua VM when dealing with large bodies (several MBs).
    Because of Nginx's internals, the <code>Content-Length</code> header will not be set when transforming a response body.
  </div>
type: plugin
categories:
  - transformations
enterprise: true
kong_version_compatibility:
  enterprise_edition:
    compatible: true
---
