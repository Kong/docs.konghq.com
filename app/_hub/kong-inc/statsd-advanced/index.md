---

name: StatsD Advanced
publisher: Kong Inc.
version: 0.34-x

desc: Send metrics to StatsD with more flexible options
description: |
  Log [metrics](#metrics) for a Service, Route (or the deprecated API entity)
  to a StatsD server.
  It can also be used to log metrics on [Collectd](https://collectd.org/)
  daemon by enabling its [StatsD
  plugin](https://collectd.org/wiki/index.php/Plugin:StatsD).

enterprise: true
type: plugin
categories:
  - logging

kong_version_compatibility:
    community_edition:
      compatible:
    enterprise_edition:
      compatible:
        - 0.34-x

params:
  name: statsd-advanced
  api_id: true
  service_id: true
  route_id: true
  consumer_id: true
  config:
    - name: host
      required:
      default: "`127.0.0.1`"
      value_in_examples: 127.0.0.1
      description: The IP address or host name of StatsD server to send data to
    - name: port
      required:
      default: "`8125`"
      value_in_examples: 8125
      description: The port of StatsD server to send data to
    - name: metrics
      required:
      default: "All metrics<br>are logged"
      description: |
        List of Metrics to be logged. Available values are described under [Metrics](#metrics).
    - name: prefix
      required:
      default: "`kong`"
      description: String to be prefixed to each metric's name
    - name: udp_packet_size
      required:
      default: "`0` (not combined)"
      description: Combine UDP packet up to the size configured
    - name: use_tcp
      required:
      default: "`false`"
      description: Use TCP instead of UDP
  extra: |
    By default the Plugin sends a packet for each metric it observes. `udp_packet_size` configures the greatest datagram size the Plugin can combine. It should be less than 65507 according to UDP protocol. Please consider the MTU of the network when setting this parameter.
---

## Metrics

Metric                     | description | namespace
---                        | ---         | ---
`request_count`            | the request count | kong.service.\<service_identifier>.request.count
`request_size`             | the request's body size in bytes | kong.service.\<service_identifier>.request.size
`response_size`            | the response's body size in bytes | kong.service.\<service_identifier>.response.size
`latency`                  | the time interval between the request and response | kong.service.\<service_identifier>.latency
`status_count`             | the status code | kong.service.\<service_identifier>.status.\<status>.count
`unique_users`             | the unique users who made requests to the underlying Service/Route | kong.service.\<service_identifier>.user.uniques
`request_per_user`         | the request count per Consumer | kong.service.\<service_identifier>.user.\<consumer_id>.count
`upstream_latency`         | the time it took for the final Service to process the request | kong.service.\<service_identifier>.upstream_latency
`kong_latency`             | the internal Kong latency that it took to run all the Plugins | kong.service.\<service_identifier>.kong_latency
`status_count_per_user`    | the status code for per Consumer per Service | kong.service.\<service_identifier>.user.\<customer_id>.status.\<status>
`status_count_per_workspace`         | the status code per Workspace | kong.service.\<service_identifier>.workspace.\<workspace_identifier>.status.\<status>
`status_count_per_user_per_route`    | the status code per Consumer per Route | kong.route.\<route_id>.user.\<customer_id>.status.\<status>
`shdict_usage`             | the usage of shared dict, sent once every minute |kong.node.\<node_hostname>.shdict.\<shdict_name>.free_space and kong.node.\<node_hostname>.shdict.\<shdict_name>.capacity


If a request URI doesn't match any Routes, the following metrics will be sent instead:

Metric                     | description | namespace
---                        | ---         | ---
`request_count`            | the request count | kong.global.unmatched.request.count
`request_size`             | the request's body size in bytes | kong.global.unmatched.request.size
`response_size`            | the response's body size in bytes | kong.global.unmatched.response.size
`latency`                  | the time interval between the request started and response received from the upstream server | kong.global.unmatched.latency
`status_count`             | the status code | kong.global.unmatched.status.\<status>.count
`kong_latency`             | the internal Kong latency that it took to run all the Plugins | kong.global.unmatched.kong_latency

### Metric Fields

Plugin can be configured with any combination of [Metrics](#metrics), with each entry containing the following fields:

Field         | description                                             | allowed values
---           | ---                                                     | ---
`name`          | StatsD metric's name                                  | [Metrics](#metrics)          
`stat_type`     | determines what sort of event the metric represents   | `gauge`, `timer`, `counter`, `histogram`, `meter` and `set`|
`sample_rate`<br>*conditional*   | sampling rate                        | `number`                 
`customer_identifier`<br>*conditional* | authenticated user detail       | `consumer_id`, `custom_id`, `username`
`service_identifier`<br>*conditional* | Service detail       | `service_id`, `service_name`, `service_host`, `service_name_or_host`
`workspace_identifier`<br>*conditional* | Workspace detail       | `workspace_id`, `workspace_name`

### Metric Behaviors

1.  By default all metrics get logged.
2.  Metric with `stat_type` set to `counter` or `gauge` must have `sample_rate` defined as well.
3.  `unique_users` metric only works with `stat_type` as `set`.
4.  `status_count`, `status_count_per_user`, `status_count_per_user_per_route` and `request_per_user` work only with `stat_type` as `counter`.
5.  `shdict_usage` work only with `stat_type` as `gauge`.
6.  `status_count_per_user`, `request_per_user`, `unique_users` and `status_count_per_user_per_route` must have `customer_identifier` defined.
7.  All metrics can optionally configure `service_identifier`; by default it's set to `service_name_or_host`.
8.  `status_count_per_workspace` must have `workspace_identifier` defined.


## Kong Process Errors

This logging Plugin will only log HTTP request and response data. If you are
looking for the Kong process error file (which is the nginx error file), then
you can find it at the following path:
{[prefix](/{{site.data.kong_latest.release}}/configuration/#prefix)}/logs/error.log
