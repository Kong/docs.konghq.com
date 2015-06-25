---
id: page-plugin
title: Plugins - Analytics
header_title: Analytics
header_icon: /assets/images/icons/plugins/analytics.png
breadcrumbs:
  Plugins: /plugins
---

Logs your traffic to [Mashape Analytics][analytics].

---

## Installation

Add the plugin to the list of available plugins on every Kong server in your cluster by editing the [kong.yml][configuration] configuration file:

```yaml
plugins_available:
  - analytics
```

Every node in the Kong cluster must have the same `plugins_available` property value.

## Configuration

Configuring the plugin is straightforward, you can add it on top of an [API][api-object] (or [Consumer][consumer-object]) by executing the following request on your Kong server:

```bash
$ curl -X POST http://kong:8001/apis/{api_name_or_id}/plugins/ \
    --data "name=analytics" \
    --data "service_token=YOUR_SERVICE_TOKEN"
```

parameter                        | description
 ---                             | ---
`name`                           | The name of the plugin to use, in this case: `analytics`
`consumer_id`<br>*optional*      | The CONSUMER ID that this plugin configuration will target
`value.service_token`            | The service token provided to you by [Mashape Analytics][analytics]
`batch_size`                     | Default: `100`. The size at which the buffer gets emptied and sent to Mashape Analytics
`log_body`                       | Default: `false`. Wether or not the request and response bodies should be sent to Mashape Analytics
`delay`                          | Default: `10`. The maximum time (in seconds) before the buffer gets sent if no calls are received during that period
`value.environment`<br>*optional*| A string describing your application environment

[analytics]: https://analytics.mashape.com

[api-object]: /docs/{{site.data.kong_latest.version}}/admin-api/#api-object
[configuration]: /docs/{{site.data.kong_latest.version}}/configuration
[consumer-object]: /docs/{{site.data.kong_latest.version}}/admin-api/#consumer-object

