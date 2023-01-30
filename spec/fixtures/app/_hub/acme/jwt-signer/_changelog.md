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
