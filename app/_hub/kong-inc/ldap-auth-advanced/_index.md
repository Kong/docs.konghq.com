---
name: LDAP Authentication Advanced
publisher: Kong Inc.
desc: 'Secure Kong clusters, Routes, and Services with username and password protection'
description: |
  Add LDAP Bind Authentication with username and password protection. The plugin
  checks for valid credentials in the `Proxy-Authorization` and `Authorization` headers
  (in that order).

  The LDAP Authentication Advanced plugin
  provides features not available in the open-source [LDAP Authentication plugin](/hub/kong-inc/ldap-auth/),
  such as LDAP searches for group and consumer mapping:
  * Ability to authenticate based on username or custom ID.
  * The ability to bind to an enterprise LDAP directory with a password.
  * The ability to obtain LDAP groups and set them in a header to the request before proxying to the upstream. This is useful for Kong Manager role mapping.
enterprise: true
plus: true
type: plugin
kong_version_compatibility:
  community_edition:
    compatible: true
  enterprise_edition:
    compatible: true
---
