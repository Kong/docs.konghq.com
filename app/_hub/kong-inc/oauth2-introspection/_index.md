---
name: OAuth 2.0 Introspection
publisher: Kong Inc.
desc: Integrate Kong with a third-party OAuth 2.0 Authorization Server
description: |
  Validate access tokens sent by developers using a third-party OAuth 2.0
  Authorization Server by leveraging its introspection endpoint
  ([RFC 7662](https://tools.ietf.org/html/rfc7662)). This plugin assumes that
  the consumer already has an access token that will be validated against a
  third-party OAuth 2.0 server.

  {:.note}
  > **Note**: The [OpenID Connect Plugin][oidcplugin] supports
  OAuth 2.0 Token Introspection as well and offers functionality beyond
  this plugin, such as restricting access by scope.

  [oidcplugin]: /hub/kong-inc/openid-connect/
enterprise: true
plus: true
type: plugin
kong_version_compatibility:
  community_edition:
    compatible: null
  enterprise_edition:
    compatible: true
---
