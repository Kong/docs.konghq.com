## Changelog

### {{site.base_gateway}} 3.8.x
* This plugin now supports using the `/jwt-signer/jwks/:jwt_signer_jwks` endpoint in DB-less mode.

### {{site.base_gateway}} 3.7.x
* Added support for basic authentication and mTLS authentication to external JWKS services.
* The plugin now supports periodically rotating the JWKS. For example, to automatically rotate `access_token_jwks_uri`, you can set the configuration option [`access_token_jwks_uri_rotate_period`](/hub/kong-inc/jwt-signer/configuration/#config-access_token_jwks_uri_rotate_period).
* The plugin now supports adding the original JWT(s) to the upstream request header by specifying the names of the upstream request header with [`original_access_token_upstream_header`](/hub/kong-inc/jwt-signer/configuration/#config-original_access_token_upstream_header) and [`original_channel_token_upstream_header`](/hub/kong-inc/jwt-signer/configuration/#config-original_channel_token_upstream_header).
* [`access_token_upstream_header`](/hub/kong-inc/jwt-signer/configuration/#config-access_token_upstream_header), [`channel_token_upstream_header`](/hub/kong-inc/jwt-signer/configuration/#config-channel_token_upstream_header), [`original_access_token_upstream_header`](/hub/kong-inc/jwt-signer/configuration/#config-original_access_token_upstream_header), and [`original_channel_token_upstream_header`](/hub/kong-inc/jwt-signer/configuration/#config-original_channel_token_upstream_header) should not have the same value.
* The plugin now supports pseudo JSON values in [`add_claims`](/hub/kong-inc/jwt-signer/configuration/#config-add_claims) and [`set_claims`](/hub/kong-inc/jwt-signer/configuration/#config-set_claims). We can achieve the goal of passing multiple values to a key by passing a JSON string as the value. 
* Added [`add_access_token_claims`](/hub/kong-inc/jwt-signer/configuration/#config-add_access_token_claims), [`set_access_token_claims`](/hub/kong-inc/jwt-signer/configuration/#config-set_access_token_claims), [`add_channel_token_claims`](/hub/kong-inc/jwt-signer/configuration/#config-add_channel_token_claims), [`set_channel_token_claims`](/hub/kong-inc/jwt-signer/configuration/#config-set_channel_token_claims) for individually adding claims to access tokens and channel tokens.
* Added [`remove_access_token_claims`](/hub/kong-inc/jwt-signer/configuration/#config-remove_access_token_claims) and [`remove_channel_token_claims`](/hub/kong-inc/jwt-signer/configuration/#config-remove_channel_token_claims) to support the removal of claims.

### {{site.base_gateway}} 3.6.x
* Added support for consumer group scoping by using the PDK `kong.client.authenticate` function.

### {{site.base_gateway}} 2.7.x
> handler.lua version: 1.9.0

* Starting with {{site.base_gateway}} 2.7.0.0, if keyring encryption is enabled,
 the following fields  `d`, `p`, `q`, `dp`, `dq`, `qi`, and `k`inside
 `jwt_signer_jwks.previous[...].` and `jwt_signer_jwks.keys[...]` will be
 marked as encrypted.

  {:.important}
  > There's a bug in {{site.base_gateway}} that prevents keyring encryption
  from working on deeply nested fields, so the `encrypted=true` setting does not
  currently have any effect in this plugin.
