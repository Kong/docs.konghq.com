---
id: page-plugin
title: Plugins - Response Transformer
header_title: Response Transformer
header_icon: /assets/images/icons/plugins/response-transformer.png
breadcrumbs:
  Plugins: /plugins
---

Transform the response sent by the upstream server on the fly on Kong, before returning the response to the client.

----

## Installation

Add the plugin to the list of available plugins on every Kong server in your cluster by editing the [kong.yml][configuration] configuration file:

```yaml
plugins_available:
  - response-transformer
```

Every node in your Kong cluster should have the same `plugins_available` property value.

## Configuration

Configuring the plugin is as simple as a single API call, you can configure and enable it for your [API][api-object] (or [Consumer][consumer-object]) by executing the following request on your Kong server:

```bash
$ curl -X POST http://kong:8001/apis/{api}/plugins \
    --data "name=response-transformer" \
    --data "config.add.headers=x-new-header:some_value, x-another-header:some_value" \
    --data "config.add.json=new-json-key:some_value, another-json-key:some_value" \
    --data "config.remove.headers=x-toremove, x-another-one" \
    --data "config.remove.json=json-key-toremove, another-json-key"
```

`api`: The `id` or `name` of the API that this plugin configuration will target

form parameter                        | description
---:                                  | ---
`name`                                | Name of the plugin to use, in this case: `response-transformer`
`consumer_id`<br>*optional*           | The CONSUMER ID that this plugin configuration will target. This value can only be used if [authentication has been enabled][faq-authentication] so that the system can identify the user making the request.
`config.add.headers`<br>*optional*     | Comma separated list of `headername:value` to add to the response headers.
`config.add.json`<br>*optional*        | Comma separated list of `jsonkey:value` to add to a JSON response body.
`config.remove.headers`<br>*optional*  | Comma separated list of header names to remove from the response headers.
`config.remove.json`<br>*optional*     | Comma separated list of JSON key names to remove from a JSON response body.

[api-object]: /docs/{{site.data.kong_latest.release}}/admin-api/#api-object
[consumer-object]: /docs/{{site.data.kong_latest.release}}/admin-api/#consumer-object
[configuration]: /docs/{{site.data.kong_latest.release}}/configuration
[faq-authentication]: /about/faq/#how-can-i-add-an-authentication-layer-on-a-microservice/api?
