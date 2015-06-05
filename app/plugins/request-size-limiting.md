---
id: page-plugin
title: Plugins - Request Size Limiting
header_title: Request Size Limiting
header_icon: /assets/images/icons/plugins/request-size-limiting.png
breadcrumbs:
  Plugins: /plugins
---

Block incoming requests whose body is greater than a specific size in mega bytes.

---

## Installation

Add the plugin to the list of available plugins on every Kong server in your cluster by editing the [kong.yml][configuration] configuration file:

```yaml
plugins_available:
  - requestsizelimiting
```

Every node in the Kong cluster should have the same `plugins_available` property value.

## Configuration

Configuring the plugin is straightforward, you can add it on top of an [API][api-object] (or [Consumer][consumer-object]) by executing the following request on your Kong server:

```bash
$ curl -X POST http://kong:8001/apis/{api_id}/plugins \
    --data "name=requestsizelimiting" \
    --data "allowed_payload_size=128" \
```

`api_id`: The API ID that this plugin configuration will target

form parameter                               | description
 ---                                    | ---
`name`                                  | The name of the plugin to use, in this case: `requestsizelimiting`
`consumer_id`<br>*optional*             | The CONSUMER ID that this plugin configuration will target
`allowed_payload_size`<br>*optional*    | Allowed request payload size in mega bytes, default is `128` (128000000 Bytes)

[api-object]: /docs/{{site.data.kong_latest.version}}/admin-api/#api-object
[configuration]: /docs/{{site.data.kong_latest.version}}/configuration
[consumer-object]: /docs/{{site.data.kong_latest.version}}/admin-api/#consumer-object
