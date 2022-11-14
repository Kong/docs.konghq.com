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
params:
  name: ldap-auth-advanced
  service_id: true
  route_id: true
  consumer_id: false
  protocols:
    - http
    - https
    - gprc
    - grpcs
    - ws
    - wss
  dbless_compatible: 'yes'
  config:
    - name: ldap_host
      required: true
      default: null
      value_in_examples: ldap.example.com
      datatype: string
      description: |
        Host on which the LDAP server is running.
    - name: ldap_port
      required: true
      default: 389
      value_in_examples: 389
      datatype: number
      description: |
        TCP port where the LDAP server is listening. 389 is the default
        port for non-SSL LDAP and AD. 636 is the port required for SSL LDAP and AD. If `ldaps` is
        configured, you must use port 636.
    - name: ldap_password
      required: null
      default: null
      value_in_examples: null
      datatype: string
      encrypted: true
      referenceable: true
      description: |
        The password to the LDAP server.
    - name: start_tls
      required: true
      default: '`false`'
      value_in_examples: true
      datatype: boolean
      description: |
        Set it to `true` to issue StartTLS (Transport Layer Security) extended operation
        over `ldap` connection. If the `start_tls` setting is enabled, ensure the `ldaps`
        setting is disabled.
    - name: ldaps
      required: true
      default: '`false`'
      value_in_examples: null
      datatype: boolean
      description: |
        Set it to `true` to use `ldaps`, a secure protocol (that can be configured
        to TLS) to connect to the LDAP server. When `ldaps` is
        configured, you must use port 636. If the `ldap` setting is enabled, ensure the
        `start_tls` setting is disabled.
    - name: base_dn
      required: true
      default: null
      value_in_examples: 'dc=example,dc=com'
      datatype: string
      description: |
        Base DN as the starting point for the search; e.g., "dc=example,dc=com".
    - name: verify_ldap_host
      required: true
      default: '`false`'
      value_in_examples: false
      datatype: boolean
      description: |
        Set to `true` to authenticate LDAP server. The server certificate will be verified according to the CA certificates specified by the `lua_ssl_trusted_certificate` directive.
    - name: attribute
      required: true
      default: null
      value_in_examples: cn
      datatype: string
      description: |
        Attribute to be used to search the user; e.g., "cn".
    - name: cache_ttl
      required: true
      default: '`60`'
      value_in_examples: 60
      datatype: number
      description: |
        Cache expiry time in seconds.
    - name: timeout
      required: false
      default: '`10000`'
      value_in_examples: null
      datatype: number
      description: |
        An optional timeout in milliseconds when waiting for connection with LDAP server.
    - name: keepalive
      required: false
      default: '`60000`'
      value_in_examples: null
      datatype: number
      description: |
        An optional value in milliseconds that defines how long an idle connection to LDAP server will live before being closed.
    - name: anonymous
      required: false
      default: null
      value_in_examples: null
      datatype: string
      description:
        An optional string (consumer UUID or username) value to use as an “anonymous” consumer if authentication fails. If empty (default null), the request will fail with an authentication failure `4xx`. Note that this value must refer to the consumer `id` or `username` attribute, and **not** its `custom_id`.
      minimum_version: "3.1.0"
    - name: anonymous
      required: false
      default: null
      value_in_examples: null
      datatype: string
      description: |
        An optional string (consumer UUID) value to use as an anonymous consumer if authentication fails.
        If empty (default), the request will fail with an authentication failure `4xx`. Note that this value
        must refer to the consumer `id` attribute that is internal to Kong Gateway, and **not** its `custom_id`.
      maximum_version: "3.0.0"
    - name: header_type
      required: false
      default: '`ldap`'
      value_in_examples: ldap
      datatype: string
      description: |
        An optional string to use as part of the Authorization header. By default, a valid Authorization header looks like this:
        `Authorization: ldap base64(username:password)`. If `header_type` is set to "basic", then the Authorization header would be
        `Authorization: basic base64(username:password)`. Note that `header_type` can take any string, not just `"ldap"` and `"basic"`.
    - name: consumer_optional
      required: false
      default: '`false`'
      value_in_examples: null
      datatype: boolean
      description: |
        Whether consumer mapping is optional. If `consumer_optional=true`, the plugin will not attempt to associate a consumer with the
        LDAP authenticated user. If `consumer_optional=false`, LDAP authenticated users can still access upstream resources.

        To prevent access from LDAP users that are not associated with consumers, set `consumer_optional=false`, set the `anonymous` field to an
        existing `consumer_id`, then use the [Request Termination plugin](/hub/kong-inc/request-termination/) to deny any requests from the anonymous consumer.
    - name: consumer_by
      required: false
      default: '`[ "username", "custom_id" ]`'
      value_in_examples: null
      datatype: array of string elements
      description: |
        Whether to authenticate consumers based on `username`, `custom_id`, or both.
    - name: hide_credentials
      required: true
      default: '`false`'
      value_in_examples: null
      datatype: boolean
      description: |
        An optional boolean value telling the plugin to hide the credential to the upstream server. It will be removed by Kong before proxying the request.
    - name: bind_dn
      required: false
      default: null
      value_in_examples: null
      datatype: string
      referenceable: true
      description: |
        The DN to bind to. Used to perform LDAP search of user. This `bind_dn`
        should have permissions to search for the user being authenticated.
    - name: group_base_dn
      required: null
      default: matches `conf.base_dn`
      value_in_examples: null
      datatype: string
      description: |
        Sets a distinguished name (DN) for the entry where LDAP searches for groups begin. This field is case-insensitive.
    - name: group_name_attribute
      required: null
      default: matches `conf.attribute`
      value_in_examples: null
      datatype: string
      description: |
        Sets the attribute holding the name of a group, typically
        called `name` (in Active Directory) or `cn` (in OpenLDAP). This
        field is case-insensitive.
    - name: group_member_attribute
      required: null
      default: '`memberOf`'
      value_in_examples: null
      datatype: string
      description: |
        Sets the attribute holding the members of the LDAP group. This field is case-sensitive.
    - name: log_search_results
      required: false
      default: '`false`'
      value_in_examples: null
      datatype: boolean
      description: |
        Displays all the LDAP search results received from the LDAP
        server for debugging purposes. Not recommended to be enabled in
        a production environment.
      minimum_version: "2.3.x"
    - name: groups_required
      required: false
      default: null
      datatype: array of string elements
      description: |
        The groups required to be present in the LDAP search result for successful authorization. This config parameter works in both **AND** / **OR** cases.
        - When `["group1 group2"]` are in the same array indices, both `group1` AND `group2` need to be present in the LDAP search result.
        - When `["group1", "group2"]` are in different array indices, either `group1` OR `group2` need to be present in the LDAP search result.
      minimum_version: "3.0.x"
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

## Changelog

**{{site.base_gateway}} 3.0.x**
* Added the `groups_required` parameter.
* The deprecated `X-Credential-Username` header has been removed.
* The character `.` is now allowed in group attributes.
* The character `:` is now allowed in the password field.

**{{site.base_gateway}} 2.8.x**

* The `ldap_password` and `bind_dn` configuration fields are now marked as
referenceable, which means they can be securely stored as
[secrets](/gateway/latest/plan-and-deploy/security/secrets-management/getting-started)
in a vault. References must follow a [specific format](/gateway/latest/kong-enterprise/security/secrets-management/reference-format).

**{{site.base_gateway}} 2.7.x**

* Starting with {{site.base_gateway}} 2.7.0.0, if keyring encryption is enabled,
 the `config.ldap_password` parameter value will be encrypted.

**{{site.base_gateway}} 2.3.x**

* Added the parameter `log_search_results`, which lets the plugin display all the LDAP search results received from the LDAP server.
* Added new debug log statements for authenticated groups.
