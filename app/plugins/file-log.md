---
title: Plugins - File Log
sitemap: true
show_faq: true
layout: page
id: page-plugin
header_title: File Log
header_icon: /assets/images/icons/plugins/file-log.png
header_caption: logging
breadcrumbs:
  Plugins: /plugins
  TCP Log: /plugins/file-log/
---

---

#### Log request and response data to the Kong Log File

---

## Installation

Make sure every Kong server in your cluster has the required dependency by executing:

```bash
$ kong install filelog
```

Add the plugin to the list of available plugins on every Kong server in your cluster by editing the “kong.yml” configuration file

```yaml
plugins_available:
  - filelog
```

## Usage

Using the plugin is straightforward, you can add it on top of an API by executing the following request on your Kong server:

```bash
curl -d "name=file-log&api_id=API_ID" http://kong:8001/plugins/
```

| parameter                    | description                                                |
|------------------------------|------------------------------------------------------------|
| name                         | The name of the plugin to use, in this case: `tcplog`   |
| api_id                       | The API ID that this plugin configuration will target             |
| *application_id*             | Optionally the APPLICATION ID that this plugin configuration will target |
