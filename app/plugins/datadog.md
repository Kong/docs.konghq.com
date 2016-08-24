---
id: page-plugin
title: Plugins - Datadog
header_title: Datadog
header_icon: /assets/images/icons/plugins/datadog.png
breadcrumbs:
  Plugins: /plugins
nav:
  - label: Getting Started
    items:
      - label: Configuration
  - label: Usage
    items:
      - label: Metrics
---

Log API metrics like request count, request size, response status and latency to the local [Datadog agent](http://docs.datadoghq.com/guides/basic_agent_usage/).

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

You can also apply it for every API using the `http://kong:8001/plugins/` endpoint. Read the [Plugin Reference](/docs/latest/admin-api/#add-plugin) for more information.

parameter                      | default     | description
---                            | ---         | ---
`name`                         |             | The name of the plugin to use, in this case: `datadog`
`consumer_id`<br>*optional*    |             | The CONSUMER ID that this plugin configuration will target. This value can only be used if [authentication has been enabled][faq-authentication] so that the system can identify the user making the request.
`config.host`<br>*optional*    | `127.0.0.1` | The IP address or host name to send data to
`config.port`<br>*optional*    | `8125`      | The port to send data to on the upstream server
`config.metrics`<br>*optional* | All metrics<br>are logged | The metrics to be logged. Available values are described at [Metrics](#metrics).
`config.timeout`<br>*optional* | `10000`     | An optional timeout in milliseconds when sending data to the upstream server

[api-object]: /docs/latest/admin-api/#api-object
[configuration]: /docs/latest/configuration
[consumer-object]: /docs/latest/admin-api/#consumer-object
[faq-authentication]: /about/faq/#how-can-i-add-an-authentication-layer-on-a-microservice/api?

----

## Metrics

Plugin currently logs following metrics to the Datadog server.

Metric                     | description | namespace
---                        | ---         | -----
`request_count`              | Increment the count of request made to the API by 1 | kong.\<api_name>.request.count
`request_size`               | logs the request's body size in bytes | kong.\<api_name>.request.size
`response_size`               | logs the response's body size in bytes | kong.\<api_name>.request.size
`latency`                   | logs the time interval between the request started and response received from the upstream server | kong.\<api_name>.latency
`status_count`               | For each status code returned, increment its counter by 1 | kong.\<api_name>.\<http_status_code>.count
`unique_users`               | count of users made a request to the api | kong.\<api_name>.user.uniques
`request_per_user`            | For each request by the user, increment its counter by 1 | kong.\<api_name>.\<consumer_id>.count
