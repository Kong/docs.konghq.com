---
name: Request Transformer Advanced
publisher: Kong Inc.
desc: Use powerful regular expressions, variables, and templates to transform API requests
description: |
  Transform client requests before they reach the upstream server. The plugin lets you match portions of incoming requests using regular expressions, save those matched strings into variables, and substitute the strings into transformed requests via flexible templates.

  The Request Transformer Advanced plugin builds on the open-source [Request Transformer plugin](/hub/kong-inc/request-transformer/) with the following enhanced capability:
  * Limit the list of allowed parameters in the request body. Set this up with the `allow.body` configuration parameter.

enterprise: true
type: plugin
kong_version_compatibility:
  community_edition:
    compatible: null
  enterprise_edition:
    compatible: true
---
