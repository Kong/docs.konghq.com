---
name: OAuth 2.0 Authentication
publisher: Kong Inc.
desc: Add OAuth 2.0 authentication to your services
description: |
  Add an OAuth 2.0 authentication layer with the [Authorization Code Grant](https://tools.ietf.org/html/rfc6749#section-4.1), [Client Credentials](https://tools.ietf.org/html/rfc6749#section-4.4),
  [Implicit Grant](https://tools.ietf.org/html/rfc6749#section-4.2), or [Resource Owner Password Credentials Grant](https://tools.ietf.org/html/rfc6749#section-4.3) flow.

  {:.important}
  > **Note:** As per the OAuth2 specs, this plugin requires the
    underlying service to be served over HTTPS. To avoid any
    confusion, we recommend that you configure the route used to serve the
    underlying service to only accept HTTPS traffic (using its `protocols`
    property).

cloud: false
type: plugin
categories:
  - authentication
kong_version_compatibility:
  community_edition:
    compatible: true
  enterprise_edition:
    compatible: true
---
