---
nav_title: Overview
---

Log [metrics](#metrics) for a service or route to a StatsD server.
It can also be used to log metrics on [Collectd](https://collectd.org/)
daemon by enabling its
[StatsD plugin](https://collectd.org/wiki/index.php/Plugin:StatsD).

By default, the plugin sends a packet for each metric it observes. The `udp_packet_size` option
configures the greatest datagram size the plugin can combine. It should be less than
65507 according to UDP protocol. Consider the MTU of the network when setting this parameter.

{% if_version gte:3.3.x %}
## Queueing

The StatsD plugin uses a queue to decouple the production and
consumption of data. This reduces the number of concurrent requests
made to the upstream server under high load situations and provides
buffering during temporary network or upstream outages.

You can set several parameters to configure the behavior and capacity
of the queues used by the plugin. For more information about how to
use these parameters, see
[Plugin Queuing Reference](/gateway/latest/kong-plugins/queue/reference/)
in the {{site.base_gateway}} documentation.

The queue parameters all reside in a record under the key `queue` in
the `config` parameter section of the plugin.
{% endif_version %}


---

## Metrics

{% if_plugin_version gte:3.0.x %}
Metric                     | Description | Namespace syntax
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
`shdict_usage`             | The usage of a shared dict, sent once every minute. <br><br> Monitors any `lua_shared_dict` used by {{site.base_gateway}}. You can find all the shared dicts {{site.base_gateway}} has configured using the [`/status`](/gateway/latest/admin-api/#health-routes) endpoint of the Admin API. <br><br>For example, the metric might report on `shdict.kong_locks` or `shdict.kong_counters`. | `kong.node.<node_hostname>.shdict.<lua_shared_dict>.free_space` and <br>`kong.node.<node_hostname>.shdict.<lua_shared_dict>.capacity`
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
