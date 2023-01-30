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

## Usage

To authenticate a user, the client must set credentials in either the
`Proxy-Authorization` or `Authorization` header in the following format:

    credentials := [ldap | LDAP] base64(username:password)

The Authorization header would look something like:

    Authorization:  ldap dGxibGVzc2luZzpLMG5nU3RyMG5n

The plugin validates the user against the LDAP server and caches the
credentials for future requests for the duration specified in
`config.cache_ttl`.

You can set the header type `ldap` to any string (such as `basic`) using
`config.header_type`.

### Upstream Headers

{% include_cached /md/plugins-hub/upstream-headers.md %}


[configuration]: /gateway/latest/reference/configuration
[consumer-object]: /gateway/latest/admin-api/#consumer-object



### Using Service Directory Mapping on the CLI

{% include /md/2.1.x/ldap/ldap-service-directory-mapping.md %}

---

