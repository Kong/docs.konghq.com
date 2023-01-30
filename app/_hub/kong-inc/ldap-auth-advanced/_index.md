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


### LDAP Search and `config.bind_dn`

LDAP directory searching is performed during the request/plugin lifecycle. It is
used to retrieve the fully qualified DN of the user so a bind
request can be performed with a user's given LDAP username and password. The
search for the user being authenticated uses the `config.bind_dn` property. The
search uses `scope="sub"`, `filter="<config.attribute>=<username>"`, and
`base_dn=<config.base_dn>`. Here is an example of how it performs the search
using the `ldapsearch` command line utility:

```bash
ldapsearch -x \
  -h "<config.ldap_host>" \
  -D "<config.bind_dn>" \
  -b "<config.attribute>=<username><config.base_dn>" \
  -w "<config.ldap_password>"
```

[api-object]: /gateway/latest/admin-api/#api-object
[configuration]: /gateway/latest/reference/configuration
[consumer-object]: /gateway/latest/admin-api/#consumer-object



### Using Service Directory Mapping on the CLI

{% include /md/2.1.x/ldap/ldap-service-directory-mapping.md %}

## Notes

{% if_plugin_version lte:2.8.x %}

`config.group_base_dn` and `config.base_dn` do not accept an array and
it has to fully match the full DN the group is in - it won’t work if it
is specified a more generic DN, therefore it needs to be specific. For
example, considering a case where there are nested `"OU's"`. If a
top-level DN such as `"ou=dev,o=company"` is specified instead of
`"ou=role,ou=groups,ou=dev,o=company"`, the authentication will fail.

{% endif_plugin_version %}

Referrals are not supported in the plugin. A workaround is
to hit the LDAP Global Catalog instead, which is usually listening on a
different port than the default `389`. That way, referrals don't get sent
back to the plugin.

{% if_plugin_version lte:2.8.x %}

The plugin doesn’t authenticate users (allow/deny requests) based on group
membership. For example:
- If the user is a member of an LDAP group, the request is allowed.
- if the user is not a member of an LDAP group, the request is still allowed.

{% endif_plugin_version %}

The plugin obtains LDAP groups and sets them in a header, `x-authenticated-groups`,
to the request before proxying to the upstream. This is useful for Kong Manager role
mapping.

---
