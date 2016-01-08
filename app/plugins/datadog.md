---
id: page-plugin
title: Plugins - Datadog Metrics log
header_title: Datadog Metrics log
header_icon: /assets/images/icons/plugins/datadog.png
breadcrumbs:
  Plugins: /plugins
nav:
  - label: Getting Started
    items:
      - label: Configuration
  - label: Usage
    items:
      - label: Log Format
---

Log Api metrics like request count, request size, response status and latency to Statsd server over UDP.

----

## Configuration

Configuring the plugin is straightforward, you can add it on top of an [API][api-object] (or [Consumer][consumer-object]) by executing the following request on your Kong server:

```bash
$ curl -X POST http://kong:8001/apis/{api}/plugins \
    --data "name=datadog" \
    --data "config.host=127.0.0.1" \
    --data "config.port=8125" \
    --data "config.timeout=1000"
```

`api`: The `id` or `name` of the API that this plugin configuration will target

parameter                     | description
---                           | ---
`name`                        | The name of the plugin to use, in this case: `datadog`
`consumer_id`<br>*optional* | The CONSUMER ID that this plugin configuration will target. This value can only be used if [authentication has been enabled][faq-authentication] so that the system can identify the user making the request.
`config.host`<br>*optional* | Default `127.0.0.1`. The IP address or host name to send data to
`config.port`<br>*optional* | Default `8125`. The port to send data to on the upstream server
`config.metrics`<br>*optional* | The metrics to be logged, by default all are logged
`config.timeout`<br>*optional* | Default `10000`. An optional timeout in milliseconds when sending data to the upstream server

[api-object]: /docs/latest/admin-api/#api-object
[configuration]: /docs/latest/configuration
[consumer-object]: /docs/latest/admin-api/#consumer-object
[faq-authentication]: /about/faq/#how-can-i-add-an-authentication-layer-on-a-microservice/api?

----

## Metrics

Plugin currently logs four metrics, request_count, request_size, status_count and latency, to the statsd server.

Metric                     | description | namespace
---                        | ---         | -----
`request_count`              | Increment the count of request made to the Api by 1 | kong.\<api_name>.request.count
`request_size`               | logs the request's body size | kong.\<api_name>.request.size
`latency`                   | logs the time interval between the request started and response received from the upstream server | kong.\<api_name>.latency
`status_count`               | Increment the count of metric matching the status code by 1 | kong.\<api_name>.\<http_status_code>.count
