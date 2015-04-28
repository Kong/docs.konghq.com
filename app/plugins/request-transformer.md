---
sitemap: true
id: page-plugin
title: Plugins - Request Transformer
header_title: Request Transformer
header_icon: /assets/images/icons/plugins/transformations.png
header_btn_text: Report Bug
header_btn_href: mailto:support@mashape.com?subject={{ page.header_title }} Plugin Bug
breadcrumbs:
  Plugins: /plugins
---

Transform the request sent by a client on the fly on Kong, before hitting the final server.

---

## Installation

<!---
Make sure every Kong server in your cluster has the required dependency by executing:

```bash
$ kong install request_transformer
```
-->

Add the plugin to the list of available plugins on every Kong server in your cluster by editing the [kong.yml](/docs/{{site.data.kong_latest.version}}/getting-started/configuration) configuration file

```yaml
plugins_available:
  - request_transformer
```

Every node in your Kong cluster should have the same `plugins_available` property value.

## Configuration

Configuring the plugin is as simple as a single API call, you can configure and enable it for your [API](/docs/{{site.data.kong_latest.version}}/admin-api/#api-object) by executing the following request on your Kong server:

```bash
$ curl -X POST http://kong:8001/plugins_configurations/ \
    --data "name=request_transformer" \
    --data "api_id=API_ID" \
    --data "value.add.headers=x-new-header:some_value, x-another-header:some_value" \
    --data "value.add.querystring=new-param:some_value, another-param:some_value" \
    --data "value.add.form=new-form-param:some_value, another-form-param:some_value" \
    --data "value.remove.headers=x-toremove, x-another-one" \
    --data "value.remove.querystring=param-toremove, param-another-one" \
    --data "value.remove.form=formparam-toremove, formparam-another-one"
```

parameter                                           | description
 ---:                                               | ---
`name`                                              | Name of the plugin to use, in this case: `request_transformer`
`api_id`                                            | API identifier of the API this plugin should be enabled on.
`value.add.headers`<br>*optional*                   | Comma separated list of `headername:value` to add to the request headers.
`value.add.querystring`<br>*optional*               | Comma separated list of `paramname:value` to add to the request querystring.
`value.add.form`<br>*optional*                      | Comma separated list of `paramname:value` to add to the request body in urlencoded format.
`value.remove.headers`<br>*optional*                | Comma separated list of header names to remove from the request.
`value.remove.querystring`<br>*optional*            | Comma separated list of parameter names to remove from the request querystring.
`value.remove.form`<br>*optional*                   | Comma separated list of parameter names to remove from the request body.
