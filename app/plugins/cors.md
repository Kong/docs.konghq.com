---
id: page-plugin
title: Plugins - Cross-origin resource sharing
header_title: CORS
header_icon: /assets/images/icons/plugins/cors.png
breadcrumbs:
  Plugins: /plugins
---

Easily add __Cross-origin resource sharing *(CORS)*__ to your API by enabling this plugin.

----

## Installation

Add the plugin to the list of available plugins on every Kong server in your cluster by editing the [kong.yml][configuration] configuration file:

```yaml
plugins_available:
  - cors
```

Every node in your Kong cluster should have the same `plugins_available` property value.

## Configuration

Configuring the plugin is as simple as a single API call, you can configure and enable it for your [API][api-object] by executing the following request on your Kong server:

```bash
$ curl -X POST http://kong:8001/apis/{api}/plugins \
    --data "name=cors" \
    --data "value.origin=mockbin.com" \
    --data "value.methods=GET, POST" \
    --data "value.headers=Accept, Accept-Version, Content-Length, Content-MD5, Content-Type, Date, X-Auth-Token" \
    --data "value.exposed_headers=X-Auth-Token" \
    --data "value.credentials=true" \
    --data "value.max_age=3600"
```

`api`: The `id` or `name` of the API that this plugin configuration will target

form parameter                            | description
---:                                      | ---
`name`                                    | Name of the plugin to use, in this case: `cors`
`value.origin`<br>*optional*              | Value for the `Access-Control-Allow-Origin` header, expects a `String`. Defaults to `*`
`value.methods`<br>*optional*             | Value for the `Access-Control-Allow-Methods` header, expects a comma delimited string (e.g. `GET,POST`). Defaults to `GET,HEAD,PUT,PATCH,POST,DELETE`.
`value.headers`<br>*optional*             | Value for the `Access-Control-Allow-Headers` header, expects a comma delimited string (e.g. `Origin, Authorization`). Defaults to the value of the `Access-Control-Request-Headers` header.
`value.exposed_headers`<br>*optional*     | Value for the `Access-Control-Expose-Headers` header, expects a comma delimited string (e.g. `Origin, Authorization`). If not specified, no custom headers are exposed.
`value.credentials`<br>*optional*         | Flag to determine whether the `Access-Control-Allow-Credentials` header should be sent with `true` as the value. Defaults to `false`.
`value.max_age`<br>*optional*             | Indicated how long the results of the preflight request can be cached, in `seconds`.
`value.preflight_continue`<br>*optional*  | A boolean value that instructs the plugin to proxy the `OPTIONS` preflight request to the upstream API. Defaults to `false`.

[api-object]: /docs/{{site.data.kong_latest.release}}/admin-api/#api-object
[configuration]: /docs/{{site.data.kong_latest.release}}/configuration
