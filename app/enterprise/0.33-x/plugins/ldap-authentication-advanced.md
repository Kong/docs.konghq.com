---
title: Plugins - LDAP Authentication Advanced
---
# LDAP Authentication Advanced Plugin

Add LDAP Bind Authentication with username and password protection. 
The plugin will check for valid credentials in the `Proxy-Authorization` 
and `Authorization` header (in this order).

## Configuration

```
curl -X POST http://kong:8001/routes/{route_id}/plugins \
    --data "name=ldap-auth-advanced"  \
    --data "config.hide_credentials=true" \
    --data "config.ldap_host=ldap.example.com" \
    --data "config.ldap_port=389" \
    --data "config.ldap_password=password" \
    --data "config.start_tls=false" \
    --data "config.base_dn=dc=example,dc=com" \
    --data "config.verify_ldap_host=false" \
    --data "config.attribute=cn" \
    --data "config.cache_ttl=60" \
    --data "config.header_type=ldap" \
    --data "config.bind_dn=dc=example" \
    --data "config.consumer_by=username"
```

`route_id`: the id of the Route that this plugin configuration will target.


#### Global plugins

All plugins can be configured using the `http://kong:8001/plugins/`
endpoint. A plugin which is not associated to any Service, Route or Consumer
(or API, if you are using an older version of Kong) is considered "global", and
will be run on every request. Read the <a href="/latest/admin-api/#add-plugin">
Plugin Reference</a> and the <a href="/latest/admin-api/#precedence">Plugin 
Precedence</a> sections for more information.


#### Parameters

Here's a list of all the parameters which can be used in this plugin's configuration:

Form Parameter | Default | Description
---------------|---------|------------
| `name` | `ldap-auth-advanced` | The name of the plugin.
| `route_id`<br>*optional* | | If present, plugin will be applied to the specified route.
| `ldap_host` | | Host on which the LDAP server is running.
| `ldap_port` | | TCP port where the LDAP server is listening.
| `ldap_password` | | The password to the LDAP server.
| `start_tls` | `false` | Set it to `true` to issue StartTLS (Transport Layer Security) extended operation over `ldap` connection.
| `base_dn` | | Base DN as the starting point for the search; e.g., "dc=example,dc=com"
| `verify_ldap_host` | `false` | Set it to `true` to authenticate LDAP server. The server certificate will be verified according to the CA certificates specified by the `lua_ssl_trusted_certificate` directive.
| `attribute` |  | Attribute to be used to search the user; e.g., "cn".
| `cache_ttl` | `60` | Cache expiry time in seconds.
| `timeout`<br>*optional*  | `10000` | An optional timeout in milliseconds when waiting for connection with LDAP server.
| `keepalive`<br>*optional*  | `10000` | An optional value in milliseconds that defines for how long an idle connection to LDAP server will live before being closed.
| `anonymous`<br>*optional*  | | An optional string (consumer uuid) value to use as an "anonymous" consumer if authentication fails. If empty (default), the request will fail with an authentication failure `4xx`. Please note that this value must refer to the Consumer `id` attribute which is internal to Kong, and **not** its `custom_id`.
| `header_type`<br>*optional* | `ldap` | An optional string to use as part of the Authorization header. By default, a valid Authorization header looks like this: `Authorization: ldap base64(username:password)`. If `header_type` is set to "basic" then the Authorization header would be `Authorization: basic base64(username:password)`. Note that `header_type` can take any string, not just `"ldap"` and `"basic"`.
| `consumer_optional`<br>*optional* | `false` | Whether consumer is optional.
| `consumer_by`<br>*optional* | `username` | Whether to authenticate consumer based on `username` or `custom_id`.
| `hide_credentials`<br>*optional* | `false` | An optional boolean value telling the plugin to hide the credential to the upstream server. It will be removed by Kong before proxying the request.
| `bind_dn` | | The DN to bind to.


## Usage

In order to authenticate the user, client must set credentials in
`Proxy-Authorization` or `Authorization` header in following format:

credentials := [ldap | LDAP] base64(username:password)

The plugin will validate the user against the LDAP server and cache the
credential for future requests for the duration specified in
`config.cache_ttl`.

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
