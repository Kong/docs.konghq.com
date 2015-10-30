---
id: page-plugin
title: Plugins - Galileo
header_title: Galileo
header_icon: /assets/images/icons/plugins/galileo.png
redirect_from: /plugins/mashape-analytics/
breadcrumbs:
  Plugins: /plugins
---

Logs request and response data to [Galileo][galileo]. Works with any Galileo subscription plan, including the FREE plan with 24h data retention.

----

## Installation

Add the plugin to the list of available plugins on every Kong server in your cluster by editing the [kong.yml][configuration] configuration file:

```yaml
plugins_available:
  - mashape-analytics
```

Every node in the Kong cluster must have the same `plugins_available` property value.

## Configuration

Configuring the plugin is straightforward, you can add it on top of an [API][api-object] (or [Consumer][consumer-object]) by executing the following request on your Kong server:

```bash
$ curl -X POST http://kong:8001/apis/{api}/plugins/ \
    --data "name=mashape-analytics" \
    --data "config.service_token=YOUR_SERVICE_TOKEN"
```

`api`: The `id` or `name` of the API that this plugin configuration will target

parameter                        | description
---                              | ---
`name`                           | The name of the plugin to use, in this case: `mashape-analytics`
`consumer_id`<br>*optional*      | The CONSUMER ID that this plugin configuration will target. This value can only be used if [authentication has been enabled][faq-authentication] so that the system can identify the user making the request.
`config.service_token`            | The service token provided to you by [Galileo][galileo]
`config.batch_size`               | Default: `100`. The size at which the buffer gets emptied and sent to Galileo
`config.log_body`                 | Default: `false`. Wether or not the request and response bodies should be sent to Galileo
`config.delay`                    | Default: `2`. The maximum time (in seconds) before the buffer gets sent if no calls are received during that period
`config.environment`<br>*optional*| A string describing your application environment

**Note**: If you are enabling the `log_body` option, make sure the buffer size never exceeds 1Mb, or the Galileo server will refuse the batch. You can ensure this by setting a lower `batch_size` value.`

[galileo]: https://getgalileo.io/
[api-object]: /docs/latest/admin-api/#api-object
[configuration]: /docs/latest/configuration
[consumer-object]: /docs/latest/admin-api/#consumer-object
[faq-authentication]: /about/faq/#how-can-i-add-an-authentication-layer-on-a-microservice/api?
