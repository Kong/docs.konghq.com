---
name: ACL
publisher: Kong Inc.
desc: Control which Consumers can access Services
description: |
  Restrict access to a Service or a Route by adding Consumers to allowed or
  denied lists using arbitrary ACL groups. This plugin requires an
  [authentication plugin](/hub/#authentication) (such as
  [Basic Authentication](/hub/kong-inc/basic-auth/),
  [Key Authentication](/hub/kong-inc/key-auth/), [OAuth 2.0](/hub/kong-inc/oauth2/),
  and [OpenID Connect](/hub/kong-inc/openid-connect/))
  to have been already enabled on the Service or Route.
type: plugin
kong_version_compatibility:
  community_edition:
    compatible: true
  enterprise_edition:
    compatible: true
---

