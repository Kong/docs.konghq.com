---
name: LDAP Authentication
publisher: Kong Inc.
version: 2.2.x
# internal handler version 2.2.0

desc: Integrate Kong with an LDAP server
description: |
  Add LDAP Bind Authentication to a Route with username and password protection. The plugin
  checks for valid credentials in the `Proxy-Authorization` and `Authorization` headers
  (in that order).

  {:.tip}
  > **Tip:** The
  [LDAP Authentication Advanced plugin](/hub/kong-inc/ldap-auth-advanced/) provides
  additional features not available in this open source LDAP plugin, such as LDAP searches
  for group and consumer mapping:
  * Ability to authenticate based on username or custom ID.
  * The ability to bind to an enterprise LDAP directory with a password.
  * The ability to authenticate/authorize using a group base DN and specific group member or group name attributes.

type: plugin
categories:
  - authentication

kong_version_compatibility:
    community_edition:
      compatible:
        - 2.4.x
        - 2.3.x
        - 2.2.x
        - 2.1.x
        - 2.0.x
        - 1.5.x
        - 1.4.x
        - 1.3.x
        - 1.2.x
        - 1.1.x
        - 1.0.x
        - 0.14.x
        - 0.13.x
        - 0.12.x
        - 0.11.x
        - 0.10.x
        - 0.9.x
        - 0.8.x
    enterprise_edition:
      compatible:
        - 2.4.x
        - 2.3.x
        - 2.2.x
        - 2.1.x
        - 1.5.x
        - 1.3-x
        - 0.36-x

params:
  name: ldap-auth
  service_id: false
  route_id: true
  consumer_id: false
  protocols: ["http", "https", "gprc", "grpcs"]
  dbless_compatible: yes
  config:
    - name: hide_credentials
      required: true
      default: "`false`"
      value_in_examples: true
      datatype: boolean
      description: An optional boolean value telling the plugin to hide the credential to the upstream server. It will be removed by Kong before proxying the request.
    - name: ldap_host
      required: true
      default:
      value_in_examples: ldap.example.com
      datatype: string
      description: Host on which the LDAP server is running.
    - name: ldap_port
      required: true
      default: 389
      value_in_examples: 389
      datatype: number
      description: |
        TCP port where the LDAP server is listening. 389 is the default
        port for non-SSL LDAP and AD. 636 is the port required for SSL LDAP and AD. If `ldaps` is
        configured, you must use port 636.
    - name: start_tls
      required: true
      default: "`false`"
      datatype: boolean
      description: |
        Set it to `true` to issue StartTLS (Transport Layer Security) extended operation over `ldap`
        connection. If the `start_tls` setting is enabled, ensure the `ldaps`
        setting is disabled.
    - name: ldaps
      required: true
      default: "`false`"
      datatype: boolean
      description: |
        Set to `true` to connect using the LDAPS protocol (LDAP over TLS).  When `ldaps` is
        configured, you must use port 636. If the `ldap` setting is enabled, ensure the
        `start_tls` setting is disabled.
    - name: base_dn
      required: true
      default:
      value_in_examples: dc=example,dc=com
      datatype: string
      description: Base DN as the starting point for the search; e.g., "dc=example,dc=com".
    - name: verify_ldap_host
      required: true
      default: "`false`"
      datatype: boolean
      description: |
        Set to `true` to authenticate LDAP server. The server certificate will be verified according to the CA certificates specified by the `lua_ssl_trusted_certificate` directive.
    - name: attribute
      required: true
      default:
      value_in_examples: cn
      datatype: string
      description: Attribute to be used to search the user; e.g., "cn".
    - name: cache_ttl
      required: true
      default: "`60`"
      datatype: number
      description: Cache expiry time in seconds.
    - name: timeout
      required: false
      default: "`10000`"
      datatype: number
      description: An optional timeout in milliseconds when waiting for connection with LDAP server.
    - name: keepalive
      required: false
      default: "`60000`"
      datatype: number
      description: |
        An optional value in milliseconds that defines how long an idle connection to LDAP server will live before being closed.
    - name: anonymous
      required: false
      default:
      datatype: string
      description: |
        An optional string (consumer UUID) value to use as an "anonymous" consumer if authentication fails. If empty (default), the request will fail with an authentication failure `4xx`.

        **Note:** The value must refer to the Consumer `id` attribute that is internal to Kong, **not** its `custom_id`.
    - name: header_type
      required: false
      default: "`ldap`"
      value_in_examples: ldap
      datatype: string
      description: |
        An optional string to use as part of the Authorization header. By default, a valid Authorization header looks like this: `Authorization: ldap base64(username:password)`. If `header_type` is set to "basic", then the Authorization header would be `Authorization: basic base64(username:password)`. Note that `header_type` can take any string, not just `"ldap"` and `"basic"`.
  extra:
    <div class="alert alert-warning">
        <strong>Note:</strong> The <code>config.header_type</code> option was
        introduced in Kong 0.12.0. Previous versions of this plugin behave as if
        <code>ldap</code> was set for this value.
    </div>

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

When a client has been authenticated, the plugin appends some headers to the
request before proxying it to the upstream service so that you can identify
the consumer in your code:

* `X-Anonymous-Consumer`, will be set to `true` when authentication failed, and the 'anonymous' consumer was set instead.
* `X-Consumer-ID`, the ID of the 'anonymous' consumer on Kong (only if authentication failed and 'anonymous' was set)
* `X-Consumer-Custom-ID`, the `custom_id` of the 'anonymous' consumer (only if authentication failed and 'anonymous' was set)
* `X-Consumer-Username`, the `username` of the 'anonymous' consumer (only if authentication failed and 'anonymous' was set)
* `X-Credential-Identifier`, the identifier of the Credential (only if the consumer is not the 'anonymous' consumer)

<div class="alert alert-warning">
  <strong>Note:</strong>`X-Credential-Username` was deprecated in favor of `X-Credential-Identifier` in Kong 2.1.
</div>

[configuration]: /gateway-oss/latest/configuration
[consumer-object]: /gateway-oss/latest/admin-api/#consumer-object



### Using Service Directory Mapping on the CLI

{% include /md/2.1.x/ldap/ldap-service-directory-mapping.md %}
