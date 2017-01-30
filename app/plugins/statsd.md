---
id: page-plugin
title: Plugins - StatsD
header_title: StatsD
header_icon: /assets/images/icons/plugins/statsd.png
breadcrumbs:
  Plugins: /plugins
nav:
  - label: Getting Started
    items:
      - label: Configuration
  - label: Usage
    items:
      - label: Metrics
      - label: Kong Process Errors
---

Log API metrics like request count, request size, response status and latency to the StatsD daemon.
It can also be used to log metrics on [Collectd](https://collectd.org/) daemon by enabling its [Statsd plugin](https://collectd.org/wiki/index.php/Plugin:StatsD).

----

## Configuration

Configuring the plugin is straightforward, you can add it on top of an [API][api-object] (or [Consumer][consumer-object]) by executing the following request on your Kong server:

```bash
$ curl -X POST http://kong:8001/apis/{api}/plugins \
    --data "name=statsd" \
    --data "config.host=127.0.0.1" \
    --data "config.port=8125"
```

`api`: The `id` or `name` of the API that this plugin configuration will target

You can also apply it for every API using the `http://kong:8001/plugins/` endpoint. Read the [Plugin Reference](/docs/latest/admin-api/#add-plugin) for more information.

parameter                     | default | description
---                           | ---     | ---
`name`                        |         | The name of the plugin to use, in this case: `statsd`
`consumer_id`<br>*optional*   |         | The CONSUMER ID that this plugin configuration will target. This value can only be used if [authentication has been enabled][faq-authentication] so that the system can identify the user making the request.
`config.host`<br>*optional*   | `127.0.0.1` | The IP address or host name to send data to
`config.port`<br>*optional*   | `8125`  | The port to send data to on the upstream server
`config.metrics`<br>*optional* | All metrics<br>are logged | List of Metrics to be logged. Available values are described under [Metrics](#metrics).

[api-object]: /docs/latest/admin-api/#api-object
[configuration]: /docs/latest/configuration
[consumer-object]: /docs/latest/admin-api/#consumer-object
[faq-authentication]: /about/faq/#how-can-i-add-an-authentication-layer-on-a-microservice/api?

----

## Metrics

Metrics the plugin supports logging to the StatsD server.

Metric                     | description | namespace
---                        | ---         | ---
`request_count`            | tracks api request | kong.\<api_name>.request.count
`request_size`             | tracks api request's body size in bytes | kong.\<api_name>.request.size
`response_size`            | tracks api response's body size in bytes | kong.\<api_name>.response.size
`latency`                  | tracks the time interval between the request started and response received from the upstream server | kong.\<api_name>.latency
`status_count`             | tracks each status code returned as response | kong.\<api_name>.status.\<status>.count and kong.\<api_name>.status.\<status>.total
`unique_users`             | tracks unique users made a request to the api | kong.\<api_name>.user.uniques
`request_per_user`         | tracks request/user | kong.\<api_name>.user.\<consumer_id>.count
`upstream_latency`         | tracks the time it took for the final service to process the request | kong.\<api_name>.upstream_latency
`kong_latency`             | tracks the internal Kong latency that it took to run all the plugins | kong.\<api_name>.kong_latency
`status_count_per_user`    | tracks request/status/user | kong.\<api_name>.user.\<customer_id>.status.\<status> and kong.\<api_name>.user.\<customer_id>.status.total

### Metric Fields

Plugin can be configured with any combination of [Metrics](#metrics), with each entry containing the following fields.

Field         | description                                                | allowed values
---           | ---                                                        | --- 
`name`          | StatsD metric's name                                     | [Metrics](#metrics)          
`stat_type`     | determines what sort of event the metric represents      | `gauge`, `timer`, `counter`, `histogram`, `meter` and `set`|
`sample_rate`<br>*conditional*   | sampling rate                           | `number`                 
`customer_identifier`<br>*conditional*| authenticated user detail          | `consumer_id`, `custom_id`, `username`

### Metric Requirements

1.  By default all metrics get logged.
2.  Metric with `stat_type` set to `counter` or `gouge` must have `sample_rate` defined as well.
3.  `unique_users` metric only works with `stat_type` as `set`.
4.  `status_count`, `status_count_per_user` and `request_per_user` work only with `stat_type`  as `counter`.
5.  `status_count_per_user`, `request_per_user` and `unique_users` must have `customer_identifier` defined.


## Kong Process Errors

This logging plugin will only log HTTP request and response data. If you are looking for the Kong process error file (which is the nginx error file), then you can find it at the following path: {[prefix](/docs/{{site.data.kong_latest.release}}/configuration/#prefix)}/logs/error.log
