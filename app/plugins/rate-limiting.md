---
id: page-plugin
title: Plugins - Rate Limiting
header_title: Rate Limiting
header_icon: /assets/images/icons/plugins/rate-limiting.png
breadcrumbs:
  Plugins: /plugins
---

Rate limit how many HTTP requests a developer can make in a given period of seconds, minutes, hours, days, months or years. If the API has no authentication layer, the **Client IP** address will be used, otherwise the Consumer will be used if an authentication plugin has been configured.

----

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
    --data "config.second=5" \
    --data "config.hour=10000"
```

`api`: The `id` or `name` of the API that this plugin configuration will target

form parameter | required        | description
---            | ---             | ---
`name`         | *required*      | The name of the plugin to use, in this case: `ratelimiting`
`consumer_id`  | *optional*      | The CONSUMER ID that this plugin configuration will target. This value can only be used if [authentication has been enabled][faq-authentication] so that the system can identify the user making the request.
`config.second` | *semi-optional* |  The amount of HTTP requests the developer can make per second. At least one limit must exist.
`config.minute` | *semi-optional* |  The amount of HTTP requests the developer can make per minute. At least one limit must exist.
`config.hour`   | *semi-optional* |  The amount of HTTP requests the developer can make per hour. At least one limit must exist.
`config.day`    | *semi-optional* |  The amount of HTTP requests the developer can make per day. At least one limit must exist.
`config.month`  | *semi-optional* |  The amount of HTTP requests the developer can make per month. At least one limit must exist.
`config.year`   | *semi-optional* |  The amount of HTTP requests the developer can make per year. At least one limit must exist.

[api-object]: /docs/latest/admin-api/#api-object
[configuration]: /docs/latest/configuration
[consumer-object]: /docs/latest/admin-api/#consumer-object
[faq-authentication]: /about/faq/#how-can-i-add-an-authentication-layer-on-a-microservice/api?
