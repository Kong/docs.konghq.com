---
name: Key Authentication - Encrypted
publisher: Kong Inc.
desc: Add key authentication to your services
description: |
  Add key authentication (also sometimes referred to as an _API key_) to a service
  or a route. Consumers then add their key either in a query string parameter or a
  header to authenticate their requests. This plugin is functionally identical to the
  open source [Key Authentication](/hub/kong-inc/key-auth/) plugin, with the
  exception that API keys are stored in an encrypted format within the API gateway datastore.

  {:.note}
  > **Note**: Before configuring this plugin, you must enable Kong Gateway's encryption keyring. See the
  [keyring getting started guide](/gateway/latest/kong-enterprise/db-encryption#getting-started) for more details.

enterprise: true
cloud: false
type: plugin
kong_version_compatibility:
  enterprise_edition:
    compatible: true
---
