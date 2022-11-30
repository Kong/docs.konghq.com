---
name: Datadog
publisher: Kong Inc.
desc: Visualize metrics on Datadog
description: |
  Log [metrics](#metrics) for a service or route to a local
  [Datadog agent](http://docs.datadoghq.com/guides/basic_agent_usage/).
type: plugin
categories:
  - analytics-monitoring
kong_version_compatibility:
  community_edition:
    compatible: true
  enterprise_edition:
    compatible: true
params:
  name: datadog
  service_id: true
  route_id: true
  consumer_id: true
  konnect_examples: false
  protocols:
    - name: http
    - name: https
    - name: tcp
    - name: tls
    - name: tls_passthrough
      minimum_version: "2.7.x"
    - name: udp
    - name: grpc
    - name: grpcs
  dbless_compatible: 'yes'
  config:
    - name: host
      required: false
      default: localhost
      value_in_examples: 127.0.0.1
      datatype: string
      description: The IP address or hostname to send data to.
    - name: port
      required: false
      default: 8125
      value_in_examples: 8125
      datatype: integer
      description: The port to send data to on the upstream server.
    - name: metrics
      required: true
      default: null
      datatype: array of record elements
      description: |
        List of metrics to be logged. Available values are described at [Metrics](#metrics).
        By default, the plugin logs all available metrics. If you specify an array of metrics,
        only the listed metrics are logged.
    - name: prefix
      required: false
      default: kong
      datatype: string
      description: String to be attached as a prefix to a metric's name.
    - name: service_name_tag
      minimum_version: "2.7.x"
      required: false
      default: name
      datatype: string
      description: String to be attached as the name of the service.
    - name: status_tag
      minimum_version: "2.7.x"
      required: false
      default: status
      datatype: string
      description: String to be attached as the tag of the HTTP status.
    - name: consumer_tag
      minimum_version: "2.7.x"
      required: false
      default: consumer
      datatype: string
      description: String to be attached as tag of the consumer.
---

## Metrics
The Datadog plugin currently logs the following metrics to the Datadog server about a service or route.

Metric                     | Description | Namespace
---                        | ---         | ---
`request_count`            | tracks the request | `kong.request.count`
`request_size`             | tracks the request's body size in bytes | `kong.request.size`
`response_size`            | tracks the response's body size in bytes | `kong.response.size`
`latency`                  | tracks the time interval between the request started and response received from the upstream server | `kong.latency`
`upstream_latency`         | tracks the time it took for the final service to process the request | `kong.upstream_latency`
`kong_latency`             | tracks the internal Kong latency that it took to run all the plugins | `kong.kong_latency`

The metrics will be sent with the tags `name` and `status` carrying the API name and HTTP status code respectively. If you specify `consumer_identifier` with the metric, a tag `consumer` will be added.

### Metric fields

Plugin can be configured with any combination of [Metrics](#metrics), with each entry containing the following fields.

Field           | Description                                           | Datatypes   | Allowed values
---             | ---                                                   | ---         | ---
`name`          | Datadog metric's name                                 | String      | [Metrics](#metrics)
`stat_type`     | Determines what sort of event the metric represents   | String      | `gauge`, `timer`, `counter`, `histogram`, `meter`, `set` {% if_plugin_version gte:2.7.x %}, `distribution` {% endif_plugin_version %}
`sample_rate`<br>*conditional*   | Sampling rate                        | Number      | `number`
`consumer_identifier`<br>*conditional* | Authenticated user detail       | String      | `consumer_id`, `custom_id`, `username`
`tags`<br>*optional* | List of tags                                      | Array of strings    | `key[:value]`

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

{% if_plugin_version gte:2.6.x %}

## Setting host and port per Kong node basis

When installing a multi-data center setup, you might want to set Datadog's agent host and port on a per Kong node basis. This configuration is possible by setting the host and port properties using environment variables.

{:.note}
> **Note:** `host` and `port` fields in the plugin config take precedence over environment variables.

Field           | Description                                           | Datatypes
---             | ---                                                   | ---
`KONG_DATADOG_AGENT_HOST` | The IP address or hostname to send data to. | string
`KONG_DATADOG_AGENT_PORT` | The port to send data to on the upstream server. | integer

{% endif_plugin_version %}

## Kong process errors

{% include /md/plugins-hub/kong-process-errors.md %}

## Changelog

**{{site.base_gateway}} 2.7.x**
* Added support for the `distribution` metric type.
* Allow service, consumer, and status tags to be customized through the configuration parameters `service_name_tag`, `consumer_tag`, and `status_tag`.

**{{site.base_gateway}} 2.6.x**
* The `host` and `port` configuration options can now be configured through the environment variables `KONG_DATADOG_AGENT_HOST` and `KONG_DATADOG_AGENT_PORT`.
This lets you set different destinations for each Kong node, which makes multi-DC setups easier, and in Kubernetes, lets you run a Datadog agent as a DaemonSet.
