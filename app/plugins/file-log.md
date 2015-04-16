---
layout: plugin
title: Plugins - File Log
header_title: File Log
header_icon: /assets/images/icons/plugins/file-log.png
---

Log request and response data to the Kong Log File

---

## Installation

<!---
Make sure every Kong server in your cluster has the required dependency by executing:

```bash
$ kong install filelog
```
-->

Add the plugin to the list of available plugins on every Kong server in your cluster by editing the [kong.yml](/docs/{{site.data.kong_latest}}/getting-started/configuration) configuration file

```yaml
plugins_available:
  - filelog
```

Every node in the Kong cluster must have the same `plugins_available` property value.

## Configuration

Configuring the plugin is straightforward, you can add it on top of an [API](/docs/{{site.data.kong_latest}}/api/#api-object) (or [Consumer](/docs/{{site.data.kong_latest}}/api/#consumer-object)) by executing the following request on your Kong server:

```bash
curl -d "name=filelog&api_id=API_ID" http://kong:8001/plugins_configurations/
```

| parameter                    | description                                                |
|------------------------------|------------------------------------------------------------|
| name                         | The name of the plugin to use, in this case: `tcplog`   |
| api_id                       | The API ID that this plugin configuration will target             |
| *consumer_id*             | Optionally the CONSUMER ID that this plugin configuration will target |
