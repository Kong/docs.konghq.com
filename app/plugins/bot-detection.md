---
id: page-plugin
title: Plugins - Bot Detection
header_title: Bot Detection
header_icon: /assets/images/icons/plugins/bot-detection.png
breadcrumbs:
  Plugins: /plugins
nav:
  - label: Getting Started
    items:
      - label: Configuration
      - label: Default rules
---

Protects your upstream service from most common bots and has the capability of whitelisting and blacklisting custom clients.

----

## Configuration

Configuring the plugin is straightforward, you can add it on top of a [Service][service-object], a [Route][route-object], or an [API][api-object] by executing the following request on your Kong server:

```bash
$ curl -X POST http://kong:8001/plugins \
    --data "name=bot-detection" \
    --data "service_id={service}"  \
    --data "route_id={route}"  \
    --data "api_id={api}"  \
    --data "config.whitelist=group1, group2"
    
```

`service`: The `id` of the Service that this plugin configuration will target
`route`: The `id` of the Route that this plugin configuration will target
`api`: The `id` of the API that this plugin configuration will target

The term `target` is used to refer any of the possible targets for the plugin.

You can also apply it globally using the `http://kong:8001/plugins/` by not specifying the target. Read the [Plugin Reference](/docs/latest/admin-api/#add-plugin) for more information.

form parameter                    | default   | description
---                               |---        | ---
`name`                            |           | The name of the plugin to use, in this case: `bot-detection`
`config.whitelist`<br>*optional*  |           | A comma separated array of regular expressions that should be whitelisted. The regular expressions will be checked against the `User-Agent` header.
`config.blacklist`<br>*optional*  |           | A comma separated array of regular expressions that should be blacklisted. The regular expressions will be checked against the `User-Agent` header.

----

## Default rules

The plugin already includes a basic list of rules that will be checked on every request. You can find this list on GitHub at [https://github.com/Mashape/kong/blob/master/kong/plugins/bot-detection/rules.lua](https://github.com/Mashape/kong/blob/master/kong/plugins/bot-detection/rules.lua).

[service-object]: /docs/latest/admin-api/#service-object
[route-object]: /docs/latest/admin-api/#route-object
[api-object]: /docs/latest/admin-api/#api-object
[configuration]: /docs/latest/configuration
[consumer-object]: /docs/latest/admin-api/#consumer-object
[faq-authentication]: /about/faq/#how-can-i-add-an-authentication-layer-on-a-microservice/api?
