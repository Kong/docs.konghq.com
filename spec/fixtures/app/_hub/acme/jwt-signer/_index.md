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
params:
  name: jwt-signer
  service_id: true
  route_id: true
  consumer_id: false
  protocols:
    - name: http
    - name: https
    - name: grpc
    - name: grpcs
  dbless_compatible: 'yes'
  config:
    - name: realm
      required: false
      default: ngx.var.host
      datatype: string
      description: |
        When authentication or authorization fails, or there is an unexpected
        error, the plugin sends an `WWW-Authenticate` header with the `realm`
        attribute value.
  extra: |
    **Configuration Notes:**

    Most of the parameters are optional, but you need to specify some options to actually
    make the plugin work:

    * For example, signature verification cannot be done without the plugin knowing about
    config.access_token_jwks_uri and/or config.channel_token_jwks_uri.

    * Also for introspection to work, you need to specify introspection endpoints
    config.access_token_introspection_endpoint and/or `config.channel_token_introspection_endpoint.
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

---
## Changelog

### 2.7.x
> handler.lua version: 1.9.0

* Starting with {{site.base_gateway}} 2.7.0.0, if keyring encryption is enabled,
 the following fields  `d`, `p`, `q`, `dp`, `dq`, `qi`, and `k`inside
 `jwt_signer_jwks.previous[...].` and `jwt_signer_jwks.keys[...]` will be
 marked as encrypted.

  {:.important}
  > There's a bug in {{site.base_gateway}} that prevents keyring encryption
  from working on deeply nested fields, so the `encrypted=true` setting does not
  currently have any effect in this plugin.
