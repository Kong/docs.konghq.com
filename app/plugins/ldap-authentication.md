---
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
---

Add LDAP Bind Authentication to your APIs, with username and password protection. The plugin will check for valid credentials in the `Proxy-Authorization` and `Authorization` header (in this order).

----

## Configuration

Configuring the plugin is straightforward, you can add it on top of an [API][api-object] by executing the following request on your Kong server:

```bash
$ curl -X POST http://kong:8001/apis/{api}/plugins \
    --data "name=ldap-auth" \
    --data "config.hide_credentials=true" \
    --data "config.ldap_host=ldap.example.com" \
    --data "config.ldap_port=398" \
    --data "config.base_dn=dc=example,dc=com" \
    --data "config.attribute=cn" \
    --data "config.cache_ttl=60" 
```

`api`: The `id` or `name` of the API that this plugin configuration will target

You can also apply it for every API using the `http://kong:8001/plugins/` endpoint. Read the [Plugin Reference](/docs/latest/admin-api/#add-plugin) for more information.

form parameter                           | default | description
---                                      | ---     | ---
`name`                                   |         | The name of the plugin to use, in this case: `ldap-auth`.
`config.hide_credentials`<br>*optional*  | `false` | An optional boolean value telling the plugin to hide the credential to the upstream API server. It will be removed by Kong before proxying the request.
`config.ldap_host`                       |         | Host on which the LDAP server is running.
`config.ldap_port`                       |         | TCP port where the LDAP server is listening.
`config.start_tls`                       | `false` | Set it to `true` to issue StartTLS (Transport Layer Security) extended operation over `ldap` connection.
`config.base_dn`                         |         | Base DN as the starting point for the search.
`config.verify_ldap_host`                | `false` | Set it to `true` to authenticate LDAP server. The server certificate will be verified according to the CA certificates specified by the `lua_ssl_trusted_certificate` directive.
`config.attribute`                       |         | Attribute to be used to search the user.
`config.cache_ttl`                       | `60`    | Cache expiry time in seconds.
`config.timeout`<br>*optional*           | `10000` | An optional timeout in milliseconds when waiting for connection with LDAP server.
`config.keepalive`<br>*optional*         | `60000` | An optional value in milliseconds that defines for how long an idle connection to LDAP server will live before being closed.
----

## Usage

In order to authenticate the user, client must set credentials in `Proxy-Authorization` or `Authorization` header in following format

credentials := [ldap | LDAP] base64(username:password)

The plugin will validate the user against the LDAP server and cache the credential for future requests for the duration specified in `config.cache_ttl`.

### Upstream Headers

When a client has been authenticated, the plugin will append some headers to the request before proxying it to the upstream API/Microservice, so that you can identify the consumer in your code:

* `X-Credential-Username`, the `username` of the Credential

[api-object]: /docs/latest/admin-api/#api-object
[configuration]: /docs/latest/configuration
[consumer-object]: /docs/latest/admin-api/#consumer-object
[faq-authentication]: /about/faq/#how-can-i-add-an-authentication-layer-on-a-microservice/api?
