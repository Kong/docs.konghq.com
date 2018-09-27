---
redirect_to: /hub/kong-inc/ldap-auth


# !!!!!!!!!!!!!!!!!!!!!!!!   WARNING   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#
# FIXME This file is dead code - it is no longer being rendered or utilized,
# and updates to this file will have no effect.
#
# The remaining contents of this file (below) will be deleted soon.
#
# Updates to the content below should instead be made to the file(s) in /app/_hub/
#
# !!!!!!!!!!!!!!!!!!!!!!!!   WARNING   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!


id: page-plugin
title: Plugins - LDAP Authentication
header_title: LDAP Authentication
header_icon: /assets/images/icons/plugins/ldap-authentication.png
breadcrumbs:
  Plugins: /plugins
nav:
  - label: Getting Started
    items:
      - label: Configuration
  - label: Usage
    items:
      - label: Upstream Headers

description: |
  Add LDAP Bind Authentication to a Route (or the deprecated API entity) with username and password protection. The plugin will check for valid credentials in the `Proxy-Authorization` and `Authorization` header (in this order).

params:
  name: ldap-auth
  api_id: true
  service_id: false
  route_id: true
  consumer_id: false
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
      default:
      value_in_examples: 389
      description: TCP port where the LDAP server is listening.
    - name: start_tls
      required: true
      default: "`false`"
      description: |
        Set it to `true` to issue StartTLS (Transport Layer Security) extended operation over `ldap` connection.
    - name: base_dn
      required: true
      default:
      value_in_examples: dc=example,dc=com
      description: Base DN as the starting point for the search.
    - name: verify_ldap_host
      required: true
      default: "`false`"
      description: |
        Set it to `true` to authenticate LDAP server. The server certificate will be verified according to the CA certificates specified by the `lua_ssl_trusted_certificate` directive.
    - name: attribute
      required: true
      default:
      value_in_examples: cn
      description: Attribute to be used to search the user.
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
      description: An optional value in milliseconds that defines for how long an idle connection to LDAP server will live before being closed.
    - name: anonymous
      required: false
      default:
      description: |
        An optional string (consumer uuid) value to use as an "anonymous" consumer if authentication fails. If empty (default), the request will fail with an authentication failure `4xx`. Please note that this value must refer to the Consumer `id` attribute which is internal to Kong, and **not** its `custom_id`.
    - name: header_type
      required: false
      default: "`ldap`"
      value_in_examples: ldap
      description: |
        An optional string to use as part of the Authorization header. By default, a valid Authorization header looks like this: `Authorization: ldap base64(username:password)`. If `header_type` is set to "basic" then the Authorization header would be `Authorization: basic base64(username:password)`. Note that `header_type` can take any string, not just `"ldap"` and `"basic"`.
  extra:
    <div class="alert alert-warning">
        <strong>Note:</strong> The <code>config.header_type</code> option was introduced in Kong 0.12.0. Previous versions of this plugin behave as if <code>ldap</code> was set for this value.
    </div>

---

## Usage

In order to authenticate the user, client must set credentials in `Proxy-Authorization` or `Authorization` header in following format

credentials := [ldap | LDAP] base64(username:password)

The plugin will validate the user against the LDAP server and cache the credential for future requests for the duration specified in `config.cache_ttl`.

### Upstream Headers

When a client has been authenticated, the plugin will append some headers to the request before proxying it to the upstream service, so that you can identify the consumer in your code:

* `X-Credential-Username`, the `username` of the Credential (only if the consumer is not the 'anonymous' consumer)
* `X-Anonymous-Consumer`, will be set to `true` when authentication failed, and the 'anonymous' consumer was set instead.
* `X-Consumer-ID`, the ID of the 'anonymous' consumer on Kong (only if authentication failed and 'anonymous' was set)
* `X-Consumer-Custom-ID`, the `custom_id` of the 'anonymous' consumer (only if authentication failed and 'anonymous' was set)
* `X-Consumer-Username`, the `username` of the 'anonymous' consumer (only if authentication failed and 'anonymous' was set)

[api-object]: /latest/admin-api/#api-object
[configuration]: /latest/configuration
[consumer-object]: /latest/admin-api/#consumer-object
[faq-authentication]: /about/faq/#how-can-i-add-an-authentication-layer-on-a-microservice/api?
