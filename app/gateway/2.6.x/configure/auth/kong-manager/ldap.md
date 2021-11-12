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
configuration file or using environment variables:

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
    "timeout":10000,                                          \
    "verify_ldap_host":true                                   \
}
```

* `"attribute":"<ENTER_YOUR_ATTRIBUTE_HERE>"`: The attribute used to identify LDAP users
    * For example, to map LDAP users to admins by their username, `"attribute":"uid"`
* `"bind_dn":"<ENTER_YOUR_BIND_DN_HERE>"`: LDAP Bind DN (Distinguished Name)
    * Used to perform LDAP search of user. This bind_dn should have permissions to search
      for the user being authenticated.
    * For example, `uid=einstein,ou=scientists,dc=ldap,dc=com`
* `"base_dn":"<ENTER_YOUR_BASE_DN_HERE>"`: LDAP Base DN (Distinguished Name)
    * For example, `ou=scientists,dc=ldap,dc=com`
* `"ldap_host":"<ENTER_YOUR_LDAP_HOST_HERE>"`: LDAP host domain
    * For example, `"ec2-XX-XXX-XX-XXX.compute-1.amazonaws.com"`
* `"ldap_password":"<ENTER_YOUR_LDAP_PASSWORD_HERE>"`: LDAP password
    * *Note*: As with any configuration property, sensitive information may be set as an
      environment variable instead of being written directly in the configuration file.

The **Sessions Plugin** requries a secret and is configured securely by default.
* Under all circumstances, the `secret` must be manually set to a string.
* If using HTTP instead of HTTPS, `cookie_secure` must be manually set to `false`.
* If using different domains for the Admin API and Kong Manager, `cookie_samesite` must be set to `off`.
Learn more about these properties in [Session Security in Kong Manager](/gateway/{{page.kong_version}}/configure/auth/kong-manager/sessions/#session-security), and see [example configurations](/gateway/{{page.kong_version}}/configure/auth/kong-manager/sessions/#example-configurations).

After starting Kong with the desired configuration, you can create new *Admins*
whose usernames match those in the AD. Those users will then be able to accept
invitations to join Kong Manager and log in with their LDAP credentials.

### Using Service Directory Mapping on the CLI

{% include /md/{{page.kong_version}}/ldap/ldap-service-directory-mapping.md %}
