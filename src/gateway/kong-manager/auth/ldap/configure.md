---
title: Enable LDAP for Kong Manager
badge: enterprise
---

{{site.base_gateway}} offers the ability to bind authentication for Kong Manager
*Admins* to a company's Active Directory using the
[LDAP Authentication Advanced plugin](/hub/kong-inc/ldap-auth-advanced).

Using the configuration below, it is unnecessary to
manually apply the LDAP plugin; the configuration alone will enable LDAP
Authentication for Kong Manager.

## Enable LDAP

Ensure Kong is configured with the following properties either in the
`kong.conf` configuration file or using environment variables:

```
admin_gui_auth = ldap-auth-advanced
enforce_rbac = on
admin_gui_session_conf = { "secret":"set-your-string-here" }
admin_gui_auth_conf = {                                       \
    "anonymous":"",                                           \
    "attribute":"<ENTER_YOUR_ATTRIBUTE_HERE>",                \
    "bind_dn":"<ENTER_YOUR_BIND_DN_HERE>",                    \
    "base_dn":"<ENTER_YOUR_BASE_DN_HERE>",                    \
    "cache_ttl": 2,                                           \
    "consumer_by":["username", "custom_id"],                  \
    "header_type":"Basic",                                    \
    "keepalive":60000,                                        \
    "ldap_host":"<ENTER_YOUR_LDAP_HOST_HERE>",                \
    "ldap_password":"<ENTER_YOUR_LDAP_PASSWORD_HERE>",        \
    "ldap_port":389,                                          \
    "start_tls":false,                                        \
    "ldaps":false,                                            \
    "timeout":10000,                                          \
    "verify_ldap_host":true                                   \
}
```

Attribute | Description
----------|-------------
`attribute` | The attribute used to identify LDAP users. <br> For example, to map LDAP users to admins by their username, set `uid`.
`bind_dn` | LDAP Bind DN (Distinguished Name). Used to perform LDAP search for the user. This `bind_dn` should have permissions to search for the user being authenticated. <br> For example, `uid=einstein,ou=scientists,dc=ldap,dc=com`.
`base_dn` | LDAP Base DN (Distinguished Name). <br> For example, `ou=scientists,dc=ldap,dc=com`.
`ldap_host`| LDAP host domain. <br> For example, `ec2-XX-XXX-XX-XXX.compute-1.amazonaws.com`.
`ldap_port`| The default LDAP port is 389. 636 is the port required for SSL LDAP and AD. If `ldaps` is configured, you must use port 636. For more complex Active Directory (AD) environments, instead of Domain Controller and port 389, consider using a Global Catalog host and port, which is port 3268 by default.    
`ldap_password` | LDAP password. <br> As with any configuration property, sensitive information may be set as an environment variable instead of being written directly in the configuration file.
`ldaps` | Set it to `true` to use `ldaps`, a secure protocol (that can be configured to TLS) to connect to the LDAP server. If the `ldaps` setting is enabled, ensure the `start_tls` setting is disabled.

The **Sessions plugin** (configured with `admin_gui_session_conf`) requires a secret and is configured securely by default.

* Under all circumstances, the `secret` must be manually set to a string.
* If using HTTP instead of HTTPS, `cookie_secure` must be manually set to `false`.
{% if_version lte:3.1.x -%}
* If using different domains for the Admin API and Kong Manager, `cookie_samesite` must be set to `off`.
{% endif_version -%}
{% if_version gte:3.2.x -%}
* If using different domains for the Admin API and Kong Manager, `cookie_same_site` must be set to `Lax`.
{% endif_version %}

Learn more about these properties in [Session Security in Kong Manager](/gateway/{{page.release}}/kong-manager/auth/sessions/#session-security), and see [example configurations](/gateway/{{page.release}}/kong-manager/auth/sessions/#example-configurations).

After starting Kong with the desired configuration, you can create new *Admins*
whose usernames match those in the AD. Those users will then be able to accept
invitations to join Kong Manager and log in with their LDAP credentials.

### Using Service Directory Mapping on the CLI

{% include_cached /md/gateway/ldap-service-directory-mapping.md %}
