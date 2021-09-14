---

name: StatsD Advanced
publisher: Kong Inc.
version: 2.2.x

desc: Send metrics to StatsD with more flexible options
description: |
  Log [metrics](#metrics) for a Service, Route (or the deprecated API entity)
  to a StatsD server.
  It can also be used to log metrics on [Collectd](https://collectd.org/)
  daemon by enabling its
  [StatsD plugin](https://collectd.org/wiki/index.php/Plugin:StatsD).

  The StatsD Advanced plugin provides
  features not available in the open-source [StatsD](/hub/kong-inc/statsd/) plugin, such as:
  * Ability to choose status codes to log to metrics.
  * More granular status codes per workspace.
  * Ability to use TCP instead of UDP.

enterprise: true
type: plugin
categories:
  - logging

kong_version_compatibility:
    community_edition:
      compatible:
    enterprise_edition:
      compatible:
        - 2.4.x
        - 2.3.x
        - 2.2.x
        - 2.1.x
        - 1.5.x
        - 1.3-x
        - 0.36-x

params:
  name: statsd-advanced
  api_id: false
  service_id: true
  route_id: true
  consumer_id: true
  protocols: ["http", "https", "grpc", "grpcs", "tcp", "tls", "udp"]
  dbless_compatible: yes
  config:
    - name: host
      required: true
      default: "`127.0.0.1`"
      value_in_examples: 127.0.0.1
      datatype: string
      description: The IP address or hostname of StatsD server to send data to.
    - name: port
      required: true
      default: "`8125`"
      value_in_examples: 8125
      datatype: integer
      description: The port of StatsD server to send data to.
    - name: metrics
      required: true
      default: "All metrics are logged"
      datatype: Array of record elements
      description: |
        List of Metrics to be logged. Available values are described under [Metrics](#metrics).
    - name: prefix
      required: true
      default: "`kong`"
      datatype: string
      description: String to prefix to each metric's name.
    - name: hostname_in_prefix
      required: true
      default: "`false`"
      datatype: boolean
      description: Include the `hostname` in the `prefix` for each metric name.
    - name: udp_packet_size
      required: true
      default: "`0` (not combined)"
      datatype: number
      description: |
        Combine UDP packet up to the size configured. If zero (0), don't combine the
        UDP packet. Must be a number between 0 and 65507 (inclusive).
    - name: use_tcp
      required: true
      default: "`false`"
      datatype: boolean
      description: Use TCP instead of UDP.
    - name: allow_status_codes
      required: true
      default: "All responses are passed to log metrics"
      value_in_examples: ["200-205","400-499"]
      datatype: array of string elements
      description: List of status code ranges that are allowed to be logged in metrics.  
  extra: |
    By default, the plugin sends a packet for each metric it observes. The `udp_packet_size` option
    configures the greatest datagram size the plugin can combine. It should be less than
    65507 according to UDP protocol. Please consider the MTU of the network when setting this parameter.
---

## Metrics

Metric                     | Description | Namespace
---                        | ---         | ---
`request_count`            | the request count | kong.service.\<service_identifier>.request.count
`request_size`             | the request's body size in bytes | kong.service.\<service_identifier>.request.size
`response_size`            | the response's body size in bytes | kong.service.\<service_identifier>.response.size
`latency`                  | the time interval in milliseconds between the request and response | kong.service.\<service_identifier>.latency
`status_count`             | tracks each status code returned in a response | kong.service.\<service_identifier>.request.status.\<status>.count and kong.\<service_name>.request.status.\<status>.total
`unique_users`             | tracks unique users who made a requests to the underlying Service/Route | kong.service.\<service_identifier>.user.uniques
`request_per_user`         | tracks the request count per Consumer | kong.service.\<service_identifier>.user.\<consumer_id>.request.count
`upstream_latency`         | tracks the time in milliseconds it took for the final Service to process the request | kong.service.\<service_identifier>.upstream_latency
`kong_latency`             | tracks the internal Kong latency in milliseconds that it took to run all the Plugins | kong.service.\<service_identifier>.kong_latency
`status_count_per_user`    | tracks the status code for per Consumer per Service | kong.\<service_name>.user.\<customer_id>.request.status.\<status> and kong.\<service_name>.user.\<customer_id>.request.status.total
`status_count_per_workspace`         | the status code per Workspace | kong.service.\<service_identifier>.workspace.\<workspace_identifier>.status.\<status>
`status_count_per_user_per_route`    | the status code per Consumer per Route | kong.route.\<route_id>.user.\<customer_id>.status.\<status>
`shdict_usage`             | the usage of shared dict, sent once every minute |kong.node.\<node_hostname>.shdict.\<shdict_name>.free_space and kong.node.\<node_hostname>.shdict.\<shdict_name>.capacity

If a request URI doesn't match any Routes, the following metrics will be sent instead:

Metric                     | Description | Namespace
---                        | ---         | ---
`request_count`            | the request count | kong.global.unmatched.request.count
`request_size`             | the request's body size in bytes | kong.global.unmatched.request.size
`response_size`            | the response's body size in bytes | kong.global.unmatched.response.size
`latency`                  | the time interval between the request started and response received from the upstream server | kong.global.unmatched.latency
`status_count`             | the status count | kong.global.unmatched.status.\<status>.count
`kong_latency`             | the internal Kong latency in milliseconds that it took to run all the plugins | kong.global.unmatched.kong_latency

### Metric Fields

The plugin can be configured with any combination of [Metrics](#metrics), with each entry containing the following fields:

Field         | Description                                             | Datatype | Allowed values
---           | ---                                                     | ---        ---
`name`          | StatsD metric's name. Required.                       | String   | [Metrics](#metrics)          
`stat_type`     | Determines what sort of event a metric represents. Required.  | String   | `gauge`, `timer`, `counter`, `histogram`, `meter` and `set`|
`sample_rate`<br>*conditional*   | Sampling rate. Required.              | Number        | `number`                 
`consumer_identifier`<br>*conditional* | Authenticated user detail. Required.  | String   | One of the following options: `consumer_id`, `custom_id`, `username`
`service_identifier`<br>*conditional* | Service detail. Required.  | String   |  One of the following options:`service_id`, `service_name`, `service_host`, `service_name_or_host`
`workspace_identifier`<br>*conditional* | Workspace detail. Required.  | String | One of the following options:`workspace_id`, `workspace_name`

### Metric Behaviors

1.  By default, all metrics get logged.
2.  Metric with `stat_type` set to `counter` or `gauge` must have `sample_rate` defined as well.
3.  `unique_users` metric only works with `stat_type` as `set`.
4.  `status_count`, `status_count_per_user`, `status_count_per_user_per_route` and `request_per_user` work only with `stat_type` as `counter`.
5.  `shdict_usage` work only with `stat_type` as `gauge`.
6.  `status_count_per_user`, `request_per_user`, `unique_users` and `status_count_per_user_per_route` must have `customer_identifier` defined.
7.  All metrics can optionally configure `service_identifier`; by default it's set to `service_name_or_host`.
8.  `status_count_per_workspace` must have `workspace_identifier` defined.


## Kong Process Errors

{% include /md/plugins-hub/kong-process-errors.md %}
