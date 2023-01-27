---
name: StatsD
publisher: Kong Inc.
desc: Send metrics to StatsD
description: |
  Log [metrics](#metrics) for a Service or Route to a StatsD server.
  It can also be used to log metrics on [Collectd](https://collectd.org/)
  daemon by enabling its
  [StatsD plugin](https://collectd.org/wiki/index.php/Plugin:StatsD).
type: plugin
categories:
  - analytics-monitoring
kong_version_compatibility:
  community_edition:
    compatible: true

  enterprise_edition:
    compatible: true

params:
  name: statsd
  service_id: true
  route_id: true
  consumer_id: true
  protocols:
    - name: http
    - name: https
    - name: grpc
    - name: grpcs
    - name: tcp
    - name: tls
    - name: tls_passthrough
      minimum_version: "2.7.x"
    - name: udp
    - name: ws
      minimum_version: "3.0.x"
    - name: wss
      minimum_version: "3.0.x"
  dbless_compatible: 'yes'
  config:
    - name: host
      required: true
      default: '`127.0.0.1`'
      value_in_examples: 127.0.0.1
      datatype: string
      description: The IP address or hostname of StatsD server to send data to.
    - name: port
      required: true
      default: '`8125`'
      value_in_examples: 8125
      datatype: integer
      description: The port of StatsD server to send data to.
    - name: metrics
      required: true
      default: All metrics are logged
      datatype: Array of record elements
      description: |
        List of metrics to be logged. Available values are described under [Metrics](#metrics).
    - name: prefix
      required: true
      default: '`kong`'
      datatype: string
      description: String to prefix to each metric's name.
    - name: hostname_in_prefix
      required: true
      default: '`false`'
      datatype: boolean
      description: Include the `hostname` in the `prefix` for each metric name.
      minimum_version: "3.0.x"
    - name: udp_packet_size
      required: true
      default: '`0` (not combined)'
      datatype: number
      description: |
        Combine UDP packet up to the size configured. If zero (0), don't combine the
        UDP packet. Must be a number between 0 and 65507 (inclusive).
    - name: use_tcp
      required: true
      default: '`false`'
      datatype: boolean
      description: Use TCP instead of UDP.
      minimum_version: "3.0.x"
    - name: allow_status_codes
      required: true
      default: All responses are passed to log metrics
      value_in_examples:
        - 200-205
        - 400-499
      datatype: array of string elements
      description: List of status code ranges that are allowed to be logged in metrics.
      minimum_version: "3.0.x"
    - name: consumer_identifier_default
      required: true
      default: 'custom_id'
      datatype: string
      description: The default consumer identifier of metrics. This takes effect when a metric's consumer identifier is omitted. Allowed values are `custom_id`, `consumer_id`, `username`.
      minimum_version: "3.0.x"
    - name: service_identifier_default
      required: true
      default: 'service_name_or_host'
      datatype: string
      description: The default service identifier of metrics. This takes effect when a metric's service identifier is omitted. Allowed values are `service_name_or_host`, `service_id`, `service_name`, `service_host`.
      minimum_version: "3.0.x"
    - name: workspace_identifier_default
      required: true
      default: 'workspace_id'
      datatype: string
      description: The default workspace identifier of metrics. This will take effect when a metric's workspace identifier is omitted. Allowed values are `workspace_id`, `workspace_name`.
      minimum_version: "3.0.x"
    - name: flush_timeout
      required: true
      default: '`2`'
      value_in_examples: 2
      datatype: number
      description: |
        Optional time in seconds. If `queue_size` > 1, this is the max idle time before sending a log with less than `queue_size` records.
      minimum_version: "3.1.x"
      maximum_version: "3.2.x"
    - name: retry_count
      required: true
      default: 10
      value_in_examples: 10
      datatype: integer
      description: Number of times to retry when sending data to the upstream server.
      minimum_version: "3.1.x"
      maximum_version: "3.2.x"
    - name: queue_size
      required: true
      default: 1
      datatype: integer
      description: Maximum number of log entries to be sent on each message to the upstream server.
      minimum_version: "3.1.x"
      maximum_version: "3.2.x"
    - name: queue
      required: false
      datatype: record
      description: Configuration parameters for queue (XXX link to queue parameters missing)
      minimum_version: "3.3.x"
    - name: tag_style
      required: false
      datatype: string
      description: The tag style configurations to send metrics with [tags](https://github.com/prometheus/statsd_exporter#tagging-extensions). Defaults to `nil`, which doesn't add any tags to the metrics. Allowed values are  `dogstatsd`, `influxdb`, `librato`, and `signalfx`.
      minimum_version: 3.2.x
  extra: |
    By default, the plugin sends a packet for each metric it observes. The `udp_packet_size` option
    configures the greatest datagram size the plugin can combine. It should be less than
    65507 according to UDP protocol. Consider the MTU of the network when setting this parameter.
---

## Queueing

{% include /md/plugins-hub/queue-parameters.md %}

---

## Metrics

{% if_plugin_version gte:3.0.x %}
Metric                     | Description | Namespace
---                        | ---         | ---
`request_count`            | The number of requests. | `kong.service.<service_identifier>.request.count`
`request_size`             | The request's body size in bytes. | `kong.service.<service_identifier>.request.size`
`response_size`            | The response's body size in bytes. | `kong.service.<service_identifier>.response.size`
`latency`                  | The time interval in milliseconds between the request and response. | `kong.service.<service_identifier>.latency`
`status_count`             | Tracks each status code returned in a response. | `kong.service.<service_identifier>.status.<status>`
`unique_users`             | Tracks unique users who made requests to the underlying Service or route. | `kong.service.<service_identifier>.user.uniques`
`request_per_user`         | Tracks the request count per consumer. | `kong.service.<service_identifier>.user.<consumer_identifier>.request.count`
`upstream_latency`         | Tracks the time in milliseconds it took for the final Service to process the request. | `kong.service.<service_identifier>.upstream_latency`
`kong_latency`             | Tracks the internal Kong latency in milliseconds that it took to run all the plugins. | `kong.service.<service_identifier>.kong_latency`
`status_count_per_user`    | Tracks the status code per consumer per service. | `kong.service.<service_identifier>.user.<consumer_identifier>.status.<status>`
`status_count_per_workspace`         | The status code per workspace. | `kong.service.<service_identifier>.workspace.<workspace_identifier>.status.<status>`
`status_count_per_user_per_route`    | The status code per consumer per route. | `kong.route.<route_id>.user.<consumer_identifier>.status.<status>`
`shdict_usage`             | The usage of shared dict, sent once every minute. | `kong.node.<node_hostname>.shdict.<shdict_name>.free_space` and `kong.node.<node_hostname>.shdict.<shdict_name>.capacity`
`cache_datastore_hits_total`            | The total number of cache hits. (Kong Enterprise only) | `kong.service.<service_identifier>.cache_datastore_hits_total`
`cache_datastore_misses_total`            | The total number of cache misses. (Kong Enterprise only) | `kong.service.<service_identifier>.cache_datastore_misses_total`

{% endif_plugin_version %}
{% if_plugin_version lte:2.8.x %}
Metric                     | Description | Namespace
---                        | ---         | ---
`request_count`            | The number of requests. | `kong.<service_identifier>.request.count`
`request_size`             | The request's body size in bytes. | `kong.<service_identifier>.request.size`
`response_size`            | The response's body size in bytes. | `kong.<service_identifier>.response.size`
`latency`                  | The time interval in milliseconds between the request and response. | `kong.<service_identifier>.latency`
`status_count`             | Tracks each status code returned in a response. | `kong.<service_identifier>.request.status.<status>.count` and `kong.<service_name>.request.status.<status>.total`
`unique_users`             | Tracks unique users who made requests to the underlying Service or Route. | `kong.<service_identifier>.user.uniques`
`request_per_user`         | Tracks the request count per Consumer. | `kong.<service_identifier>.user.<consumer_identifier>.request.count`
`upstream_latency`         | Tracks the time in milliseconds it took for the final Service to process the request. | `kong.<service_identifier>.upstream_latency`
`kong_latency`             | Tracks the internal Kong latency in milliseconds that it took to run all the plugins. | `kong.<service_identifier>.kong_latency`
`status_count_per_user`    | Tracks the status code for per Consumer per Service. | `kong.<service_identifier>.user.<consumer_identifier>.request.status.<status>` and `kong.<service_identifier>.user.<consumer_identifier>.request.status.total`
{% endif_plugin_version %}

If a request URI doesn't match any Routes, the following metrics are sent instead:

Metric                     | Description | Namespace
---                        | ---         | ---
`request_count`            | The request count. | `kong.global.unmatched.request.count`
`request_size`             | The request's body size in bytes. | `kong.global.unmatched.request.size`
`response_size`            | The response's body size in bytes. | `kong.global.unmatched.response.size`
`latency`                  | The time interval between when the request started and when the response is received from the upstream server. | `kong.global.unmatched.latency`
`status_count`             | The status count. | `kong.global.unmatched.status.<status>.count`
`kong_latency`             | The internal Kong latency in milliseconds that it took to run all the plugins. | `kong.global.unmatched.kong_latency`

{% if_plugin_version gte:3.2.x %}
If you enable the `tag_style` configuration for the StatsD plugin, the following metrics are sent instead:

Metric                     | Description | Namespace
---                        | ---         | ---
`request_count`            | The number of requests. | `kong.request.count`
`request_size`             | The request's body size in bytes. | `kong.request.size`
`response_size`            | The response's body size in bytes. | `kong.response.size`
`latency`                  | The time interval in milliseconds between the request and response. | `kong.latency`
`request_per_user`         | Tracks the request count per consumer. | `kong.request.count`
`upstream_latency`         | Tracks the time in milliseconds it took for the final service to process the request. | `kong.upstream_latency`
`shdict_usage`             | The usage of shared dict, sent once every minute. | `kong.shdict.free_space` and `kong.shdict.capacity`
`cache_datastore_hits_total`            | The total number of cache hits. (Kong Enterprise only) | `kong.cache_datastore_hits_total`
`cache_datastore_misses_total`            | The total number of cache misses. (Kong Enterprise only) | `kong.cache_datastore_misses_total`



The StatsD plugin supports Librato, InfluxDB, DogStatsD, and SignalFX-style tags, which are used like Prometheus labels.

* **Librato-style tags**: Must be appended to the metric name with a delimiting #, for example:
`metric.name#tagName=val,tag2Name=val2:0|c`
See the [Librato StatsD](https://github.com/librato/statsd-librato-backend#tags) documentation for more information.

* **InfluxDB-style tags**: Must be appended to the metric name with a delimiting comma, for example:
`metric.name,tagName=val,tag2Name=val2:0|c`
See the [InfluxDB StatsD](https://www.influxdata.com/blog/getting-started-with-sending-statsd-metrics-to-telegraf-influxdb/#introducing-influx-statsd) documentation for more information.

* **DogStatsD-style tags**: Appended as a |# delimited section at the end of the metric, for example:
`metric.name:0|c|#tagName:val,tag2Name:val2`
See the [Datadog StatsD Tags](https://docs.datadoghq.com/developers/dogstatsd/data_types/#tagging) documentation for more information about the concept description and Datagram Format.
[AWS CloudWatch](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-Agent-custom-metrics-statsd.html) also uses the DogStatsD protocol.

* **SignalFX dimension**: Add the tags to the metric name in square brackets, for example:
`metric.name[tagName=val,tag2Name=val2]:0|c`
See the [SignalFX StatsD](https://github.com/signalfx/signalfx-agent/blob/main/docs/monitors/collectd-statsd.md#adding-dimensions-to-statsd-metrics) documentation for more information.

When the `tag_style` config is enabled, {{site.base_gateway}} uses a filter label, like `service`, `route`, `workspace`, `consumer`, `node`, or `status`, on the metrics tags to see if these can be found. For `shdict_usage` metrics, only `node` and `shdict` are added.

For example:

```
kong.request.size,workspace=default,route=d02485d7-8a28-4ec2-bc0b-caabed82b499,status=200,consumer=d24d866a-020a-4605-bc3c-124f8e1d5e3f,service=bdabce05-e936-4673-8651-29d2e9eca382,node=c80a9c5845bd:120|c
```

{% endif_plugin_version %}

### Metric Fields

The plugin can be configured with any combination of [Metrics](#metrics), with each entry containing the following fields:

Field         | Description                                             | Datatype | Allowed values
---           | ---                                                     | ---        ---
`name` <br>*required*         | StatsD metric's name.                      | String   | [Metrics](#metrics)          
`stat_type`  <br>*required*     | Determines what sort of event a metric represents.  | String   | `gauge`, `timer`, `counter`, `histogram`, `meter` and `set`|
`sample_rate`<br>*required* <br>*conditional*   | Sampling rate.              | Number        | `number`                 
`consumer_identifier`<br>*conditional* | Authenticated user detail.  | String   | One of the following options: `consumer_id`, `custom_id`, `username`, `null`
{% if_plugin_version gte:3.0.x %}
`service_identifier`<br>*conditional* | Service detail.  | String   |  One of the following options: `service_id`, `service_name`, `service_host`, `service_name_or_host`, `null`
`workspace_identifier`<br>*conditional* | Workspace detail.  | String | One of the following options:`workspace_id`, `workspace_name`, `null`
{% endif_plugin_version %}

### Metric behaviors

* By default, all metrics get logged.
* Metric with `stat_type` set to `counter` or `gauge` must have `sample_rate` defined as well.
* `unique_users` metric only works with `stat_type` as `set`.
{% if_plugin_version lte:2.8.x %}
* `status_count`, `status_count_per_user` and `request_per_user` work only with `stat_type`  as `counter`.
* `status_count_per_user`, `request_per_user` and `unique_users` must have `customer_identifier` defined.
{% endif_plugin_version %}
{% if_plugin_version gte:3.0.x %}
* `status_count`, `status_count_per_user`, `status_count_per_user_per_route` and `request_per_user` work only with `stat_type` as `counter`.
* `shdict_usage` work only with `stat_type` as `gauge`.
* `status_count_per_user`, `request_per_user`, `unique_users` and `status_count_per_user_per_route` must have `customer_identifier` defined.
* All metrics can optionally configure `service_identifier`; by default it's set to `service_name_or_host`.
* `status_count_per_workspace` must have `workspace_identifier` defined.
{% endif_plugin_version %}


## Kong Process Errors

{% include /md/plugins-hub/kong-process-errors.md %}

---
## Changelog

**{{site.base_gateway}} 3.2.x**
* Added the `tag_style` configuration parameter. This allows you to send metrics with [tags](https://github.com/prometheus/statsd_exporter#tagging-extensions). Defaults to `nil`, which doesn't add any tags to the metrics.

**{{site.base_gateway}} 3.1.x**
* Added support for managing queues and connection retries when sending messages to the upstream with 
the `queue_size`,`flush_timeout`, and `retry_count` configuration parameters. 

### {{site.base_gateway}} 3.0.x

* Merged features of the StatsD Advanced plugin into the StatsD plugin. The StatsD plugin now includes the following:
  * New parameters for StatsD: `hostname_in_prefix`, `udp_packet_size`, `ues_tcp`, `allow_status_codes`, `consumer_identifier_default`, `service_identifier_default`, `workspace_identifier_default`.
  * New metrics: `status_count_per_workspace`, `status_count_per_user_per_route`, `shdict_usage`
  * New metric fields: `service_identifier`, `workspace_identifier`

* Breaking changes
  * The metric name that is related to the service has been renamed by adding a `service.` prefix. e.g. `kong.service.<service_identifier>.request.count`
  * The metric `kong.<service_identifier>.request.status.<status>.count` from metrics `status_count` and `status_count_per_user` has been renamed to `kong.service.<service_identifier>.status.<status>.count`
  * The metric `*.status.<status>.total` from metrics `status_count` and `status_count_per_user` has been removed.
  * The metric `kong.<service_identifier>.request_size` and `kong.<service_identifier>.response_size` stat type has been changed from `timer` to `counter`.
