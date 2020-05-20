---
name: Datadog
publisher: Kong Inc.
version: 3.0.0

desc: Visualize metrics on Datadog
description: |
  Log [metrics](#metrics) for a Service, Route to a local
  [Datadog agent](http://docs.datadoghq.com/guides/basic_agent_usage/).

  <div class="alert alert-warning">
    <strong>Note:</strong> The functionality of this plugin as bundled
    with versions of Kong prior to 1.4.0 differs from what is documented herein.
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
        - 2.0.x
        - 1.5.x      
        - 1.4.x
        - 1.3.x
        - 1.2.x
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
        - 1.5.x
        - 1.3-x
        - 0.36-x
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
Plugin currently logs the following metrics to the Datadog server about a Service or Route.

Metric                     | description | namespace
---                        | ---         | ---
`request_count`            | tracks the request | kong.request.count
`request_size`             | tracks the request's body size in bytes | kong.request.size
`response_size`            | tracks the response's body size in bytes | kong.response.size
`latency`                  | tracks the time interval between the request started and response received from the upstream server | kong.latency
`upstream_latency`         | tracks the time it took for the final service to process the request | kong.upstream\_latency
`kong_latency`             | tracks the internal Kong latency that it took to run all the plugins | kong.kong\_latency

The metrics will be sent with the tags `name` and `status` carrying the API name and HTTP status code respectively. If you specify `consumer_identifier` with the metric, a tag `consumer` will be added.

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

## Migrating Datadog queries
The plugin updates replace the api, status, and consumer-specific metrics with a generic metric name.
You have to change your Datadog queries in dashboards and alerts to reflect the metrics updates.

For example, the following query:
```
avg:kong.sample_service.latency.avg{*}
```
would need to change to:

```
avg:kong.latency.avg{name:sample-service}
```

## Kong Process Errors

This logging plugin will only log HTTP request and response data. If you are
looking for the Kong process error file (which is the nginx error file), then
you can find it at the following path:
{[prefix](/{{site.data.kong_latest.release}}/configuration/#prefix)}/logs/error.log
