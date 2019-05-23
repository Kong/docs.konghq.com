---

name: LDAP Authentication Advanced
publisher: Kong Inc.
version: 0.35-x

desc: Secure Kong clusters, routes and services with username and password protection
description: |
  Add LDAP Bind Authentication with username and password protection. The plugin will check for valid credentials in the `Proxy-Authorization` and `Authorization` header (in this order).

enterprise: true
type: plugin
categories:
  - authentication

kong_version_compatibility:
    community_edition:
      compatible:
    enterprise_edition:
      compatible:
        - 0.35-x
        - 0.34-x

params:
  name: ldap-auth-advanced
  api_id: true
  service_id: true
  route_id: true
  consumer_id: true
  config:
    - name: ldap_host
      required:
      default:
      value_in_examples:
      description: |
        Host on which the LDAP server is running
    - name: ldap_port
      required:
      default:
      value_in_examples:
      description: |
        TCP port where the LDAP server is listening
    - name: ldap_password
      required:
      default:
      value_in_examples:
      description: |
        The password to the LDAP server
    - name: start_tls
      required:
      default: "`false`"
      value_in_examples:
      description: |
        Set it to `true` to issue StartTLS (Transport Layer Security) extended operation over `ldap` connection
    - name: ldaps
      required:
      default: "`false`"
      value_in_examples:
      description: |
        Set it to `true` to use `ldaps`, a secure protocol (that can be configured 
        to TLS) to connect to the LDAP server.
    - name: base_dn
      required:
      default:
      value_in_examples:
      description: |
        Base DN as the starting point for the search; e.g., "dc=example,dc=com"
    - name: verify_ldap_host
      required:
      default: "`false`"
      value_in_examples:
      description: |
        Set it to `true` to authenticate LDAP server. The server certificate will be verified according to the CA certificates specified by the `lua_ssl_trusted_certificate` directive.
    - name: attribute
      required:
      default:
      value_in_examples:
      description: |
        Attribute to be used to search the user; e.g., "cn"
    - name: cache_ttl
      required:
      default: "`60`"
      value_in_examples:
      description: |
        Cache expiry time in seconds
    - name: timeout
      required: false
      default: "`10000`"
      value_in_examples:
      description: |
        An optional timeout in milliseconds when waiting for connection with LDAP server
    - name: keepalive
      required: false
      default: "`10000`"
      value_in_examples:
      description: |
        An optional value in milliseconds that defines for how long an idle connection to LDAP server will live before being closed
    - name: anonymous
      required: false
      default:
      value_in_examples:
      description: |
        An optional string (consumer uuid) value to use as an "anonymous" consumer if authentication fails. If empty (default), the request will fail with an authentication failure `4xx`. Please note that this value must refer to the Consumer `id` attribute which is internal to Kong, and **not** its `custom_id`.
    - name: header_type
      required: false
      default: "`ldap`"
      value_in_examples:
      description: |
        An optional string to use as part of the Authorization header. By default, a valid Authorization header looks like this: `Authorization: ldap base64(username:password)`. If `header_type` is set to "basic" then the Authorization header would be `Authorization: basic base64(username:password)`. Note that `header_type` can take any string, not just `"ldap"` and `"basic"`.
    - name: consumer_optional
      required: false
      default: "`false`"
      value_in_examples:
      description: |
        Whether consumer is optional
    - name: consumer_by
      required: false
      default: "`[ "username", "custom_id" ]`"
      value_in_examples:
      description: |
        Whether to authenticate consumer based on `username` and/or `custom_id`
    - name: hide_credentials
      required: false
      default: "`false`"
      value_in_examples:
      description: |
        An optional boolean value telling the plugin to hide the credential to the upstream server. It will be removed by Kong before proxying the request.
    - name: bind_dn
      required:
      default:
      value_in_examples:
      description: |
        The DN to bind to. Used to perform LDAP search of user. This bind_dn 
        should have permissions to search for the user being authenticated.

---

### Usage

In order to authenticate the user, client must set credentials in
`Proxy-Authorization` or `Authorization` header in following format:

credentials := [ldap | LDAP] base64(username:password)

The plugin will validate the user against the LDAP server and cache the
credential for future requests for the duration specified in
`config.cache_ttl`.

#### Upstream Headers

When a client has been authenticated, the plugin will append some headers to the
 request before proxying it to the upstream service, so that you can identify 
 the consumer in your code:

* `X-Credential-Username`, the `username` of the Credential (only if the 
consumer is not the 'anonymous' consumer)
* `X-Anonymous-Consumer`, will be set to `true` when authentication failed, and 
the 'anonymous' consumer was set instead.
* `X-Consumer-ID`, the ID of the 'anonymous' consumer on Kong (only if 
authentication failed and 'anonymous' was set)
* `X-Consumer-Custom-ID`, the `custom_id` of the 'anonymous' consumer (only if 
authentication failed and 'anonymous' was set)
* `X-Consumer-Username`, the `username` of the 'anonymous' consumer (only if 
authentication failed and 'anonymous' was set)


#### LDAP Search and config.bind_dn

LDAP directory searching is performed during the request/plugin lifecycle. It is
used to retrieve the fully qualified DN of the user so a bind 
request can be performed with the user's given LDAP username and password. The 
search for the user being authenticated uses the `config.bind_dn` property. The 
search uses `scope="sub"`, `filter="<config.attribute>=<username>"`, and
`base_dn=<config.base_dn>`. Here is an example of how it performs the search 
using the `ldapsearch` command line utility:

```bash
$ ldapsearch -x -h "<config.ldap_host>" -D "<config.bind_dn>" -b 
"<config.attribute>=<username><config.base_dn>" -w "<config.ldap_password>"
```

[api-object]: /latest/admin-api/#api-object
[configuration]: /latest/configuration
[consumer-object]: /latest/admin-api/#consumer-object
[faq-authentication]: /about/faq/#how-can-i-add-an-authentication-layer-on-a-microservice/api?
