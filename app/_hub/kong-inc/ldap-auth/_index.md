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
    compatible:
      - 2.8.x
      - 2.7.x
      - 2.6.x
      - 2.5.x
      - 2.4.x
      - 2.3.x
      - 2.2.x
      - 2.1.x
      - 2.0.x
      - 1.5.x
      - 1.4.x
      - 1.3.x
      - 1.2.x
      - 1.1.x
      - 1.0.x
      - 0.14.x
      - 0.13.x
      - 0.12.x
      - 0.11.x
      - 0.10.x
      - 0.9.x
      - 0.8.x
  enterprise_edition:
    compatible:
      - 2.8.x
      - 2.7.x
      - 2.6.x
      - 2.5.x
      - 2.4.x
      - 2.3.x
      - 2.2.x
      - 2.1.x
      - 1.5.x
      - 1.3-x
      - 0.36-x
---
