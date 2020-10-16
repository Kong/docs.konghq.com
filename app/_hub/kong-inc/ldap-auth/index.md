---
name: LDAP Authentication
publisher: Kong Inc.
version: 2.2.0

desc: Integrate Kong with an LDAP server
description: |
  Add LDAP Bind Authentication to a Route with username and password protection. The plugin
  checks for valid credentials in the `Proxy-Authorization` and `Authorization` headers
  (in that order).

  <div class="alert alert-warning">
    <strong>Note:</strong> The functionality of this plugin as bundled
    with versions of Kong prior to 0.14.1 and Kong Enterprise prior to 0.34
    differs from what is documented herein. Refer to the
    <a href="https://github.com/Kong/kong/blob/master/CHANGELOG.md">CHANGELOG</a>
    for details.
  </div>

type: plugin
categories:
  - authentication

kong_version_compatibility:
    community_edition:
      compatible:
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
        - 2.1.x
        - 1.5.x
        - 1.3-x
        - 0.36-x
        - 0.35-x
        - 0.34-x
        - 0.33-x
        - 0.32-x
        - 0.31-x

params:
  name: ldap-auth
  service_id: false
  route_id: true
  consumer_id: false
  protocols: ["http", "https", "gprc", "grpcs"]
  dbless_compatible: yes
  config:
    - name: hide_credentials
      required: false
      default: "`false`"
      value_in_examples: true
      description: An optional boolean value telling the plugin to hide the credential to the upstream server. It will be removed by Kong before proxying the request.
    - name: ldap_host
      required: true
      default:
      value_in_examples: ldap.example.com
      description: Host on which the LDAP server is running.
    - name: ldap_port
      required: true
      default: 389
      value_in_examples: 389
      description: TCP port where the LDAP server is listening.  389 is the default
        port for non-SSL LDAP and AD. 686 is the port required for SSL LDAP and AD. If `ldaps` is
        configured, you must use port 686.
    - name: start_tls
      required: true
      default: "`false`"
      description: |
        Set it to `true` to issue StartTLS (Transport Layer Security) extended operation over `ldap`
        connection. If the `start_tls` setting is enabled, ensure the `ldaps`
        setting is disabled.
    - name: ldaps
      required: true
      default: "`false`"
      description: |
        Set to `true` to connect using the LDAPS protocol (LDAP over TLS).  When `ldaps` is
        configured, you must use port 686. If the `ldap` setting is enabled, ensure the
        `start_tls` setting is disabled.
    - name: base_dn
      required: true
      default:
      value_in_examples: dc=example,dc=com
      description: Base DN as the starting point for the search; e.g., "dc=example,dc=com".
    - name: verify_ldap_host
      required: true
      default: "`false`"
      description: |
        Set to `true` to authenticate LDAP server. The server certificate will be verified according to the CA certificates specified by the `lua_ssl_trusted_certificate` directive.
    - name: attribute
      required: true
      default:
      value_in_examples: cn
      description: Attribute to be used to search the user; e.g., "cn".
    - name: cache_ttl
      required: true
      default: "`60`"
      description: Cache expiry time in seconds.
    - name: timeout
      required: false
      default: "`10000`"
      description: An optional timeout in milliseconds when waiting for connection with LDAP server.
    - name: keepalive
      required: false
      default: "`60000`"
      description: An optional value in milliseconds that defines how long an idle connection to LDAP server will live before being closed.
    - name: anonymous
      required: false
      default:
      description: |
        An optional string (consumer UUID) value to use as an "anonymous" consumer if authentication fails. If empty (default), the request will fail with an authentication failure `4xx`. The value must refer to the Consumer `id` attribute that is internal to Kong, **not** its `custom_id`.
    - name: header_type
      required: false
      default: "`ldap`"
      value_in_examples: ldap
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

[configuration]: /latest/configuration
[consumer-object]: /latest/admin-api/#consumer-object
[faq-authentication]: /about/faq/#how-can-i-add-an-authentication-layer-on-a-microservice/api?


### Using Service Directory Mapping on the CLI

{% include /md/2.1.x/ldap/ldap-service-directory-mapping.md %}
