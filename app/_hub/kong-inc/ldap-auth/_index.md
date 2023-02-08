---
name: LDAP Authentication
publisher: Kong Inc.
version: 2.2.x
desc: Integrate Kong with an LDAP server
description: |
  Add LDAP Bind Authentication to a Route with username and password protection. The plugin
  checks for valid credentials in the `Proxy-Authorization` and `Authorization` headers
  (in that order).

  This plugin is the open-source version of the [LDAP Authentication Advanced plugin](/hub/kong-inc/ldap-auth-advanced/), which provides
  additional features such as LDAP searches for group and consumer mapping:
  * Ability to authenticate based on username or custom ID.
  * The ability to bind to an enterprise LDAP directory with a password.
  * The ability to authenticate/authorize using a group base DN and specific group member or group name attributes.
type: plugin
categories:
  - authentication
kong_version_compatibility:
  community_edition:
    compatible: true
  enterprise_edition:
    compatible: true
---
