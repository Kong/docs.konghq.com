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
$ curl -X POST http://kong:8001/apis/{api_id}/plugins \
    --data "name=ratelimiting" \
    --data "value.limit=1000" \
    --data "value.period=hour"
```

`api_id`: The API ID that this plugin configuration will target

form parameter                               | description
 ---                                    | ---
`name`                                  | The name of the plugin to use, in this case: `ratelimiting`
`consumer_id`<br>*optional*             | The CONSUMER ID that this plugin configuration will target
`value.limit`                           | The amount of HTTP requests the developer can make in the given period of time
`value.period`                          | Can be one between: `second`, `minute`, `hour`, `day`, `month`, `year`

[api-object]: /docs/{{site.data.kong_latest.version}}/admin-api/#api-object
[configuration]: /docs/{{site.data.kong_latest.version}}/configuration
[consumer-object]: /docs/{{site.data.kong_latest.version}}/admin-api/#consumer-object
