---
name: Key Authentication
publisher: Kong Inc.
desc: Add key authentication to your Services
description: |
  Add key authentication (also sometimes referred to as an _API key_) to a service or a route.
  Consumers then add their API key either in a query string parameter, a header, or a
  request body to authenticate their requests.

  This plugin can be used for authentication in conjunction with the
  [Application Registration](/hub/kong-inc/application-registration/) plugin.

  **Tip:** The Kong Gateway [Key Authentication Encrypted](/hub/kong-inc/key-auth-enc/)
    plugin provides the ability to encrypt keys. Keys are encrypted at rest in the API gateway datastore.
type: plugin
kong_version_compatibility:
  community_edition:
    compatible: true
  enterprise_edition:
    compatible: true
---
