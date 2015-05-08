---
sitemap: true
id: page-plugin
title: Plugins - File Log
header_title: File Log
header_icon: /assets/images/icons/plugins/file-log.png
header_btn_text: Report Bug
header_btn_href: https://github.com/Mashape/kong/issues/new
header_btn_target: _blank
breadcrumbs:
  Plugins: /plugins
---

Log request and response data to the Kong Log File, by default located at `NGINX_WORKING_DIR/logs/error.log`.

---

## Installation

Add the plugin to the list of available plugins on every Kong server in your cluster by editing the [kong.yml][configuration] configuration file

```yaml
plugins_available:
  - filelog
```

Every node in the Kong cluster must have the same `plugins_available` property value.

## Configuration

Configuring the plugin is straightforward, you can add it on top of an [API][api-object] (or [Consumer][consumer-object]) by executing the following request on your Kong server:

```bash
$ curl -X POST http://kong:8001/plugins_configurations/ \
    --data "name=filelog" \
    --data "api_id=API_ID"
```

parameter                     | description
 ---                          | ---
`name`                        | The name of the plugin to use, in this case: `filelog`
`api_id`                      | The API ID that this plugin configuration will target
`consumer_id`<br>*optional*   | The CONSUMER ID that this plugin configuration will target

[api-object]: /docs/{{site.data.kong_latest.version}}/admin-api/#api-object
[configuration]: /docs/{{site.data.kong_latest.version}}/configuration
[consumer-object]: /docs/{{site.data.kong_latest.version}}/admin-api/#consumer-object
