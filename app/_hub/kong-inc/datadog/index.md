---
name: Datadog
publisher: Kong Inc.
version: 1.0.0

desc: Visualize metrics on Datadog
description: |
  Log [metrics](#metrics) for a Service, Route to a local
  [Datadog agent](http://docs.datadoghq.com/guides/basic_agent_usage/).

  <div class="alert alert-warning">
    <strong>Note:</strong> The functionality of this plugin as bundled
    with versions of Kong prior to 0.11.0 differs from what is documented herein.
    Refer to the
    <a href="https://github.com/Kong/kong/blob/master/CHANGELOG.md">CHANGELOG</a>
    for details.
  </div>

type: plugin
categories:
  - analytics-monitoring

kong_version_compatibility:
    community_edition:
      compatible:
        - 1.1.x
        - 1.0.x
        - 0.14.x
        - 0.13.x
        - 0.12.x
        - 0.11.x
        - 0.10.x
        - 0.9.x
        - 0.8.x
        - 0.7.x
        - 0.6.x
    enterprise_edition:
      compatible:
        - 0.35-x
        - 0.34-x
        - 0.33-x
        - 0.32-x
        - 0.31-x

params:
  name: datadog
  service_id: true
  route_id: true
  consumer_id: true
  protocols: ["http", "https"]
  dbless_compatible: yes
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

Plugin currently logs following metrics to the Datadog server about a Service or Route.

Metric                     | description | namespace
---                        | ---         | ---
`request_count`            | tracks the request | kong.\<service_name>.request.count
`request_size`             | tracks the request's body size in bytes | kong.\<service_name>.request.size
`response_size`            | tracks the response's body size in bytes | kong.\<service_name>.response.size
`latency`                  | tracks the time interval between the request started and response received from the upstream server | kong.\<service_name>.latency
`status_count`             | tracks each status code returned as response | kong.\<service_name>.status.\<status>.count and kong.\<service_name>.status.\<status>.total
`unique_users`             | tracks unique users made a request | kong.\<service_name>.user.uniques
`request_per_user`         | tracks request/user | kong.\<service_name>.user.\<consumer_id>.count
`upstream_latency`         | tracks the time it took for the final service to process the request | kong.\<service_name>.upstream_latency
`kong_latency`             | tracks the internal Kong latency that it took to run all the plugins | kong.\<service_name>.kong_latency
`status_count_per_user`    | tracks request/status/user | kong.\<service_name>.user.\<customer_id>.status.\<status> and kong.\<service_name>.user.\<customer_id>.status.total

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
