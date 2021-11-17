---
name: Datadog
publisher: Kong Inc.
version: 3.1.x
# internal handler version 3.1.0

desc: Visualize metrics on Datadog
description: |
  Log [metrics](#metrics) for a Service, Route to a local
  [Datadog agent](http://docs.datadoghq.com/guides/basic_agent_usage/).

type: plugin
categories:
  - analytics-monitoring

kong_version_compatibility:
    community_edition:
      compatible:
        - 2.6.x
        - 2.5.x
        - 2.4.x
        - 2.3.x      
        - 2.2.x
        - 2.1.x
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
        - 2.4.x
        - 2.3.x
        - 2.2.x
        - 2.1.x
        - 0.36-x

params:
  name: datadog
  service_id: true
  route_id: true
  consumer_id: true
  konnect_examples: false
  protocols: ["http", "https", "tcp", "tls", "udp"]
  dbless_compatible: yes
  config:
    - name: host
      required: true
      default: "`localhost`"
      value_in_examples: 127.0.0.1
      datatype: string
      description: The IP address or host name to send data to.
    - name: port
      required: true
      default: "`8125`"
      value_in_examples: 8125
      datatype: integer
      description: The port to send data to on the upstream server
    - name: metrics
      required: true
      default:
      datatype: array of record elements
      description: |
        List of Metrics to be logged. Available values are described at [Metrics](#metrics).
        By default, the plugin logs all available metrics. If you specify an array of metrics,
        only the listed metrics are logged.
    - name: prefix
      required: true
      default: "`kong`"
      datatype: string
      description: String to be attached as prefix to metric's name.

---

## Metrics
The Datadog plugin currently logs the following metrics to the Datadog server about a Service or Route.

Metric                     | Description | Namespace
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

Field           | Description                                           | Datatypes   | Allowed values
---             | ---                                                   | ---         | ---
`name`          | Datadog metric's name                                 | String      | [Metrics](#metrics)
`stat_type`     | determines what sort of event the metric represents   | String      | `gauge`, `timer`, `counter`, `histogram`, `meter` and `set`
`sample_rate`<br>*conditional*   | sampling rate                        | Number      | `number`
`consumer_identifier`<br>*conditional*| authenticated user detail       | String      | `consumer_id`, `custom_id`, `username`
`tags`<br>*optional*| List of tags                                      | Array of strings    | `key[:value]`

### Metric requirements

- All metrics get logged by default.
- Metrics with `stat_type` as `counter` or `gauge` must have `sample_rate` defined as well.

## Migrating Datadog queries
The plugin updates replace the api, status, and consumer-specific metrics with a generic metric name.
You must change your Datadog queries in dashboards and alerts to reflect the metrics updates.

For example, the following query:
```
avg:kong.sample_service.latency.avg{*}
```
would need to change to:

```
avg:kong.latency.avg{name:sample-service}
```

## Setting host and port per Kong node basis

When installing a multi-data center setup, you might want to set Datadog's agent host and port on a per Kong node basis. This configuration is possible by setting the host and port properties using environment variables.

{:.note}
> **Note:** `host` and `port` fields in the plugin config take precedence over environment variables.

Field           | Description                                           | Datatypes
---             | ---                                                   | ---
`KONG_DATADOG_AGENT_HOST` | The IP address or host name to send data to. | string
`KONG_DATADOG_AGENT_PORT` | The port to send data to on the upstream server | integer

## Kong Process Errors

{% include /md/plugins-hub/kong-process-errors.md %}
