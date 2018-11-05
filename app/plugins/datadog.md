---
redirect_to: /hub/kong-inc/datadog


# !!!!!!!!!!!!!!!!!!!!!!!!   WARNING   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#
# FIXME This file is dead code - it is no longer being rendered or utilized,
# and updates to this file will have no effect.
#
# The remaining contents of this file (below) will be deleted soon.
#
# Updates to the content below should instead be made to the file(s) in /app/_hub/
#
# !!!!!!!!!!!!!!!!!!!!!!!!   WARNING   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!


id: page-plugin
title: Plugins - Datadog
header_title: Datadog
header_icon: /assets/images/icons/plugins/datadog.png
breadcrumbs:
  Plugins: /plugins
nav:
  - label: Usage
    items:
      - label: Metrics
description: |
  Log [metrics](#metrics) for a Service, Route (or the deprecated API entity) to a local
  [Datadog agent](http://docs.datadoghq.com/guides/basic_agent_usage/).

params:
  name: datadog
  api_id: true
  service_id: true
  route_id: true
  consumer_id: true
  config:
    - name: host
      required: false
      default: "`127.0.0.1`"
      value_in_examples: 127.0.0.1
      description: The IP address or host name to send data to.
    - name: port
      required: false
      default: "`8125`"
      value_in_examples: 8125
      description: The port to send data to on the upstream server
    - name: metrics
      required: false
      default: All metrics are logged
      description: |
        List of Metrics to be logged. Available values are described at [Metrics](#metrics).
    - name: prefix
      required: false
      default: "`kong`"
      description: String to be attached as prefix to metric's name.

---

## Metrics

Plugin currently logs following metrics to the Datadog server about a Service, Route, or an API entity (which is deprecated since 0.13.0).

Metric                     | description | namespace
---                        | ---         | ---
`request_count`            | tracks the request | kong.\<api_name>.request.count
`request_size`             | tracks the request's body size in bytes | kong.\<api_name>.request.size
`response_size`            | tracks the response's body size in bytes | kong.\<api_name>.response.size
`latency`                  | tracks the time interval between the request started and response received from the upstream server | kong.\<api_name>.latency
`status_count`             | tracks each status code returned as response | kong.\<api_name>.status.\<status>.count and kong.\<api_name>.status.\<status>.total
`unique_users`             | tracks unique users made a request to the api | kong.\<api_name>.user.uniques
`request_per_user`         | tracks request/user | kong.\<api_name>.user.\<consumer_id>.count
`upstream_latency`         | tracks the time it took for the final service to process the request | kong.\<api_name>.upstream_latency
`kong_latency`             | tracks the internal Kong latency that it took to run all the plugins | kong.\<api_name>.kong_latency
`status_count_per_user`    | tracks request/status/user | kong.\<api_name>.user.\<customer_id>.status.\<status> and kong.\<api_name>.user.\<customer_id>.status.total

### Metric fields

Plugin can be configured with any combination of [Metrics](#metrics), with each entry containing the following fields.

Field           | description                                           | allowed values
---             | ---                                                   | ---
`name`          | Datadog metric's name                                 | [Metrics](#metrics)
`stat_type`     | determines what sort of event the metric represents   | `gauge`, `timer`, `counter`, `histogram`, `meter` and `set`
`sample_rate`<br>*conditional*   | sampling rate                        | `number`
`customer_identifier`<br>*conditional*| authenticated user detail       | `consumer_id`, `custom_id`, `username`
`tags`<br>*optional*| List of tags                                      | `key[:value]`

### Metric requirements

1.  by default all metrics get logged.
2.  metric with `stat_type` as `counter` or `gauge` must have `sample_rate` defined as well.
3.  `unique_users` metric only works with `stat_type` as `set`.
4.  `status_count`, `status_count_per_user` and `request_per_user` work only with `stat_type`  as `counter`.
5.  `status_count_per_user`, `request_per_user` and `unique_users` must have `customer_identifier` defined.


## Kong Process Errors

This logging plugin will only log HTTP request and response data. If you are
looking for the Kong process error file (which is the nginx error file), then
you can find it at the following path:
{[prefix](/{{site.data.kong_latest.release}}/configuration/#prefix)}/logs/error.log
