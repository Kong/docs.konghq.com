---
id: page-plugin
title: Plugins - Response Rate Limiting
header_title: Response Rate Limiting
header_icon: /assets/images/icons/plugins/response-rate-limiting.png
breadcrumbs:
  Plugins: /plugins
---

This plugin allows you to limit the number of requests a developer can make based on a custom response header returned by the upstream API. You can arbitrary set as many rate-limiting objects as you want and instruct Kong to increase or decrease them by any number of units. Each custom rate-limiting object can limit the inbound requests per seconds, minutes, hours, days, months or years.

----

## Installation

Add the plugin to the list of available plugins on every Kong server in your cluster by editing the [kong.yml][configuration] configuration file:

```yaml
plugins_available:
  - response-ratelimiting
```

Every node in the Kong cluster should have the same `plugins_available` property value.

## Configuration

Configuring the plugin is straightforward, you can add it on top of an [API][api-object] (or [Consumer][consumer-object]) by executing the following request on your Kong server:

```bash
$ curl -X POST http://kong:8001/apis/{api}/plugins \
    --data "name=response-ratelimiting" \
    --data "config.limits.{limit_name}.minute=10"
```

`api`: The `id` or `name` of the API that this plugin configuration will target

form parameter | required        | description
---            | ---             | ---
`name`         | *required*      | The name of the plugin to use, in this case: `response-ratelimiting`
`consumer_id`  | *optional*      | The CONSUMER ID that this plugin configuration will target. This value can only be used if [authentication has been enabled][faq-authentication] so that the system can identify the user making the request.
`config.limits.{limit_name}` | *required*      |  This is a list of custom objects that you can set on the API, with arbitrary names set in the `{limit_name`} placeholder, like `config.limits.sms.minute=20` if your object is called "SMS".
`config.limits.{limit_name}.second` | *semi-optional* | The amount of HTTP requests the developer can make per second. At least one limit must exist.
`config.limits.{limit_name}.minute` | *semi-optional* | The amount of HTTP requests the developer can make per minute. At least one limit must exist.
`config.limits.{limit_name}.hour` | *semi-optional* | The amount of HTTP requests the developer can make per hour. At least one limit must exist.
`config.limits.{limit_name}.day` | *semi-optional* | The amount of HTTP requests the developer can make per day. At least one limit must exist.
`config.limits.{limit_name}.month` | *semi-optional* | The amount of HTTP requests the developer can make per month. At least one limit must exist.
`config.limits.{limit_name}.year` | *semi-optional* | The amount of HTTP requests the developer can make per year. At least one limit must exist.

[api-object]: /docs/{{site.data.kong_latest.release}}/admin-api/#api-object
[configuration]: /docs/{{site.data.kong_latest.release}}/configuration
[consumer-object]: /docs/{{site.data.kong_latest.release}}/admin-api/#consumer-object
[faq-authentication]: /about/faq/#how-can-i-add-an-authentication-layer-on-a-microservice/api?
