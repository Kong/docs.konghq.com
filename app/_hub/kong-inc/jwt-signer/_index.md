---
name: Kong JWT Signer
publisher: Kong Inc.
desc: Verify and sign one or two tokens in a request
description: |
  The Kong JWT Signer plugin makes it possible to verify, sign, or re-sign
  one or two tokens in a request. With a two token request, one token
  is allocated to an end user and the other token to the client application,
  for example.

  The plugin refers to tokens as an _access token_
  and _channel token_. Tokens can be any valid verifiable tokens. The plugin
  supports both opaque tokens through introspection,
  and signed JWT tokens through signature verification. There are many
  configuration parameters available to accommodate your requirements.
enterprise: true
plus: true
type: plugin
kong_version_compatibility:
  community_edition:
    compatible: null
  enterprise_edition:
    compatible: true
---
