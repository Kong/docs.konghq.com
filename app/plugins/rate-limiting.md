---
id: page-plugin
title: Plugins - Rate Limiting
header_title: Rate Limiting
header_icon: /assets/images/icons/plugins/rate-limiting.png
breadcrumbs:
  Plugins: /plugins
---

Rate limit how many HTTP requests a developer can make in a given period of seconds, minutes, hours, days months or years. If the API has no authentication layer, the **Client IP** address will be used, otherwise the consume will be used if an authentication plugin has been configured.

---

## Installation

Add the plugin to the list of available plugins on every Kong server in your cluster by editing the [kong.yml][configuration] configuration file:

```yaml
plugins_available:
  - ratelimiting
```

Every node in the Kong cluster should have the same `plugins_available` property value.

## Configuration

Configuring the plugin is straightforward, you can add it on top of an [API][api-object] (or [Consumer][consumer-object]) by executing the following request on your Kong server:

```bash
$ curl -X POST http://kong:8001/apis/{api}/plugins \
    --data "name=ratelimiting" \
    --data "value.second=5" \
    --data "value.hour=10000"
```

`api`: The `id` or `name` of the API that this plugin configuration will target

form parameter                               | description
 ---                                    | ---
`name`                                  | The name of the plugin to use, in this case: `ratelimiting`
`consumer_id`<br>*optional*             | The CONSUMER ID that this plugin configuration will target. This value can only be used if [authentication has been enabled][faq-authentication] so that the system can identify the user making the request.
`value.second`<br>*semi-optional*       | The amount of HTTP requests the developer can make per second. At least one limit must exist.
`value.minute`<br>*semi-optional*       | The amount of HTTP requests the developer can make per minute. At least one limit must exist.
`value.hour`<br>*semi-optional*         | The amount of HTTP requests the developer can make per hour. At least one limit must exist.
`value.day`<br>*semi-optional*          | The amount of HTTP requests the developer can make per day. At least one limit must exist.
`value.month`<br>*semi-optional*        | The amount of HTTP requests the developer can make per month. At least one limit must exist.
`value.year`<br>*semi-optional*         | The amount of HTTP requests the developer can make per year. At least one limit must exist.

[api-object]: /docs/{{site.data.kong_latest.version}}/admin-api/#api-object
[configuration]: /docs/{{site.data.kong_latest.version}}/configuration
[consumer-object]: /docs/{{site.data.kong_latest.version}}/admin-api/#consumer-object
[faq-authentication]: /docs/{{site.data.kong_latest.version}}/faq/#how-can-i-add-an-authentication-layer-on-a-microservice/api?
