---
name: StatsD Advanced
publisher: Kong Inc.
version: 2.2.x
desc: Send metrics to StatsD with more flexible options
description: |
  Log [metrics](#metrics) for a Service, route
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
  - analytics-monitoring
kong_version_compatibility:
  community_edition:
    compatible: null
  enterprise_edition:
    compatible:
    - 2.8.x
    - 2.7.x
    - 2.6.x
    - 2.5.x
    - 2.4.x
    - 2.3.x
    - 2.2.x
    - 2.1.x
    - 1.5.x
    - 1.3-x
    - 0.36-x
---

## Metrics

Metric                     | Description | Namespace
---                        | ---         | ---
`request_count`            | the request count | `kong.service.\<service_identifier>.request.count`
`request_size`             | the request's body size in bytes | `kong.service.\<service_identifier>.request.size`
`response_size`            | the response's body size in bytes | `kong.service.\<service_identifier>.response.size`
`latency`                  | the time interval in milliseconds between the request and response | `kong.service.\<service_identifier>.latency`
`status_count`             | tracks each status code returned in a response | `kong.service.\<service_identifier>.request.status.\<status>.count` and `kong.\<service_name>.request.status.\<status>.total`
`unique_users`             | tracks unique users who made a requests to the underlying Service/Route | `kong.service.\<service_identifier>.user.uniques`
`request_per_user`         | tracks the request count per Consumer | `kong.service.\<service_identifier>.user.\<consumer_id>.request.count`
`upstream_latency`         | tracks the time in milliseconds it took for the final Service to process the request | `kong.service.\<service_identifier>.upstream_latency`
`kong_latency`             | tracks the internal Kong latency in milliseconds that it took to run all the Plugins | `kong.service.\<service_identifier>.kong_latency`
`status_count_per_user`    | tracks the status code for per Consumer per Service | `kong.\<service_name>.user.\<customer_id>.request.status.\<status>` and `kong.\<service_name>.user.\<customer_id>.request.status.total`
`status_count_per_workspace`         | the status code per Workspace | `kong.service.\<service_identifier>.workspace.\<workspace_identifier>.status.\<status>`
`status_count_per_user_per_route`    | the status code per Consumer per Route | `kong.route.\<route_id>.user.\<customer_id>.status.\<status>`
`shdict_usage`             | the usage of shared dict, sent once every minute |`kong.node.\<node_hostname>.shdict.\<shdict_name>.free_space` and `kong.node.\<node_hostname>.shdict.\<shdict_name>.capacity`

If a request URI doesn't match any Routes, the following metrics will be sent instead:

Metric                     | Description | Namespace
---                        | ---         | ---
`request_count`            | the request count | `kong.global.unmatched.request.count`
`request_size`             | the request's body size in bytes | `kong.global.unmatched.request.size`
`response_size`            | the response's body size in bytes | `kong.global.unmatched.response.size`
`latency`                  | the time interval between the request started and response received from the upstream server | `kong.global.unmatched.latency`
`status_count`             | the status count | `kong.global.unmatched.status.\<status>.count`
`kong_latency`             | the internal Kong latency in milliseconds that it took to run all the plugins | `kong.global.unmatched.kong_latency`

### Metric Fields

The plugin can be configured with any combination of [Metrics](#metrics), with each entry containing the following fields:

Field         | Description                                             | Datatype | Allowed values
---           | ---                                                     | ---        ---
`name`          | StatsD metrics name. Required.                       | String   | [Metrics](#metrics)          
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
