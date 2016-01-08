---
id: page-plugin
title: Plugins - Request Transformer
header_title: Request Transformer
header_icon: /assets/images/icons/plugins/request-transformer.png
breadcrumbs:
  Plugins: /plugins
nav:
  - label: Getting Started
    items:
      - label: Configuration
---

Transform the request sent by a client on the fly on Kong, before hitting the upstream server.

----

## Configuration

Configuring the plugin is as simple as a single API call, you can configure and enable it for your [API][api-object] (or [Consumer][consumer-object]) by executing the following request on your Kong server:

```bash
$ curl -X POST http://kong:8001/apis/{api}/plugins \
    --data "name=request-transformer" \
    --data "config.add.headers=x-new-header:some_value, x-another-header:some_value" \
    --data "config.add.querystring=new-param:some_value, another-param:some_value" \
    --data "config.add.form=new-form-param:some_value, another-form-param:some_value" \
    --data "config.remove.headers=x-toremove, x-another-one" \
    --data "config.remove.querystring=param-toremove, param-another-one" \
    --data "config.remove.form=formparam-toremove, formparam-another-one"
```

`api`: The `id` or `name` of the API that this plugin configuration will target

form parameter                            | description
---:                                      | ---
`name`                                    | Name of the plugin to use, in this case: `request-transformer`
`consumer_id`<br>*optional*               | The CONSUMER ID that this plugin configuration will target. This value can only be used if [authentication has been enabled][faq-authentication] so that the system can identify the user making the request.
`config.add.headers`<br>*optional*         | Comma separated list of `headername:value` to add to the request headers.
`config.add.querystring`<br>*optional*     | Comma separated list of `paramname:value` to add to the request querystring.
`config.add.form`<br>*optional*            | Comma separated list of `paramname:value` to add to the request body in urlencoded format.
`config.remove.headers`<br>*optional*      | Comma separated list of header names to remove from the request.
`config.remove.querystring`<br>*optional*  | Comma separated list of parameter names to remove from the request querystring.
`config.remove.form`<br>*optional*         | Comma separated list of parameter names to remove from the request body.

[api-object]: /docs/latest/admin-api/#api-object
[consumer-object]: /docs/latest/admin-api/#consumer-object
[configuration]: /docs/latest/configuration
[faq-authentication]: /about/faq/#how-can-i-add-an-authentication-layer-on-a-microservice/api?
