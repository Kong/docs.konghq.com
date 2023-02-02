---
name: Kong JWT Signer
publisher: Kong Inc.
desc: Verify and sign one or two tokens in a request
description: |
  From \_index.md: The Kong JWT Signer plugin makes it possible to verify, sign, or re-sign
  one or two tokens in a request. With a two token request, one token
  is allocated to an end user and the other token to the client application,
  for example.
enterprise: true
plus: true
type: plugin
categories:
  - authentication
kong_version_compatibility:
  community_edition:
    compatible: null
  enterprise_edition:
    compatible: true
---

## Manage key signing

If you specify `config.access_token_keyset` or `config.channel_token_keyset` with either an
`http://` or `https://` prefix, it means that token signing keys are externally managed by you.
In that case, the plugin loads the keys just like it does for `config.access_token_jwks_uri`
and `config.channel_token_jwks_uri`. If the prefix is not `http://` or `https://`
(such as `"my-company"` or `"kong"`), Kong autogenerates JWKS for supported algorithms.

External JWKS specified with `config.access_token_keyset` or
`config.channel_token_keyset` should also contain private keys with supported `alg`,
either `"RS256"` or `"RS512"` for now. External URLs that contain private keys should
be protected so that only Kong can access them. Currently, Kong doesn't add any authentication
headers when it loads the keys from an external endpoint, so you have to do it with network
level restrictions. If it is a common need to manage private keys externally
instead of allowing Kong to autogenerate them, we can add another parameter
for adding an authentication header (possibly similar to
`config.channel_token_introspection_authorization`).

The key size (the modulo) for RSA keys is currently hard-coded to 2048 bits.
