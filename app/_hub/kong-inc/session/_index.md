---
name: Session
publisher: Kong Inc.
desc: Support sessions for Kong Authentication Plugins.
description: |
  The Kong Session Plugin can be used to manage browser sessions for APIs proxied
  through the Kong API Gateway. It provides configuration and management for
  session data storage, encryption, renewal, expiry, and sending browser cookies.
  It is built using
  [lua-resty-session](https://github.com/bungle/lua-resty-session).

  For information about configuring and using the Sessions plugin with the Dev
  Portal, see [Sessions in the Dev Portal](/gateway/latest/developer-portal/configuration/authentication/sessions/#configuration-to-use-the-sessions-plugin-with-the-dev-portal).
type: plugin
categories:
  - authentication
kong_version_compatibility:
  community_edition:
    compatible: true
  enterprise_edition:
    compatible: true
---

