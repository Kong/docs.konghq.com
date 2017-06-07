---
id: page-plugin
title: Plugins - Cross-origin resource sharing
header_title: CORS
header_icon: /assets/images/icons/plugins/cors.png
breadcrumbs:
  Plugins: /plugins
nav:
  - label: Getting Started
    items:
      - label: Configuration
  - label: Known Issues
    items:
      - label: CORS Limitations
---

Easily add __Cross-origin resource sharing *(CORS)*__ to your API by enabling
this plugin.

----

## Configuration

Configuring the plugin is as simple as a single API call, you can configure and
enable it for your [API][api-object] by executing the following request on your
Kong server:

```bash
$ curl -X POST http://kong:8001/apis/{api}/plugins \
    --data "name=cors" \
    --data "config.origins=mockbin.com" \
    --data "config.methods=GET, POST" \
    --data "config.headers=Accept, Accept-Version, Content-Length, Content-MD5, Content-Type, Date, X-Auth-Token" \
    --data "config.exposed_headers=X-Auth-Token" \
    --data "config.credentials=true" \
    --data "config.max_age=3600"
```

`api`: The `id` or `name` of the API that this plugin configuration will target

You can also apply it for every API using the `http://kong:8001/plugins/`
endpoint. Read the [Plugin Reference](/docs/latest/admin-api/#add-plugin) for
more information.

form parameter                             | default | description
---:                                       | ---     | ---
`name`                                     |         | Name of the plugin to use, in this case: `cors`
`config.origins`<br>*optional*             |         | A comma-separated list of allowed domains for the `Access-Control-Allow-Origin` header. If you wish to allow all origins, add `*` as a single value to this configuration field. The accepted values can either be flat strings or PCRE regexes. **NOTE**: Prior to Kong 0.10.x, this parameter was `config.origin` (note the change in trailing `s`), and only accepted a single value, or the `*` special value.
`config.methods`<br>*optional*             | `GET,HEAD,PUT,PATCH,POST,DELETE` | Value for the `Access-Control-Allow-Methods` header, expects a comma delimited string (e.g. `GET,POST`).
`config.headers`<br>*optional*             | Value of the `Access-Control-Request-Headers`<br>request header | Value for the `Access-Control-Allow-Headers` header, expects a comma delimited string (e.g. `Origin, Authorization`).
`config.exposed_headers`<br>*optional*     |         | Value for the `Access-Control-Expose-Headers` header, expects a comma delimited string (e.g. `Origin, Authorization`). If not specified, no custom headers are exposed.
`config.credentials`<br>*optional*         | `false` | Flag to determine whether the `Access-Control-Allow-Credentials` header should be sent with `true` as the value.
`config.max_age`<br>*optional*             |         | Indicated how long the results of the preflight request can be cached, in `seconds`.
`config.preflight_continue`<br>*optional*  | `false` | A boolean value that instructs the plugin to proxy the `OPTIONS` preflight request to the upstream API.

----

## Known issues

Below is a list of known issues or limitations for this plugin.

### CORS Limitations

If the client is a browser, there is a known issue with this plugin caused by a
limitation of the CORS specification that doesn't allow to specify a custom
`Host` header in a preflight `OPTIONS` request.

Because of this limitation, this plugin will only work for APIs that have been
configured with a `uris` setting, and it will not work for APIs that
are being resolved using a custom DNS (the `hosts` property).

To learn how to configure `uris` for an API, please read the [Proxy
Reference][proxy-reference].

[api-object]: /docs/latest/admin-api/#api-object
[configuration]: /docs/latest/configuration
[proxy-reference]: /docs/latest/proxy
