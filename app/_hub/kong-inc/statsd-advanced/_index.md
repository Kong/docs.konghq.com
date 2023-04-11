## Metrics

Metric                     | Description | Namespace
---                        | ---         | ---
`request_count`            | The request count. | `kong.service.\<service_identifier>.request.count`
`request_size`             | The request's body size in bytes. | `kong.service.\<service_identifier>.request.size`
`response_size`            | The response's body size in bytes. | `kong.service.\<service_identifier>.response.size`
`latency`                  | The time interval in milliseconds between the request and response. | `kong.service.\<service_identifier>.latency`
`status_count`             | Tracks each status code returned in a response. | `kong.service.\<service_identifier>.request.status.\<status>.count` and `kong.\<service_name>.request.status.\<status>.total`
`unique_users`             | Tracks unique users who made a requests to the underlying service/route. | `kong.service.\<service_identifier>.user.uniques`
`request_per_user`         | Tracks the request count per consumer. | `kong.service.\<service_identifier>.user.\<consumer_id>.request.count`
`upstream_latency`         | Tracks the time in milliseconds it took for the final Service to process the request. | `kong.service.\<service_identifier>.upstream_latency`
`kong_latency`             | Tracks the internal Kong latency that it took to run all of the plugins, in milliseconds.| `kong.service.\<service_identifier>.kong_latency`
`status_count_per_user`    | Tracks the status code per consumer per service. | `kong.\<service_name>.user.\<customer_id>.request.status.\<status>` and `kong.\<service_name>.user.\<customer_id>.request.status.total`
`status_count_per_workspace`         | the status code per workspace. | `kong.service.\<service_identifier>.workspace.\<workspace_identifier>.status.\<status>`
`status_count_per_user_per_route`    | the status code per consumer per Route. | `kong.route.\<route_id>.user.\<customer_id>.status.\<status>`
`shdict_usage`             | the usage of a shared dict, sent once every minute. |`kong.node.\<node_hostname>.shdict.\<shdict_name>.free_space` and `kong.node.\<node_hostname>.shdict.\<shdict_name>.capacity`

If a request URI doesn't match any Routes, the following metrics will be sent instead:

Metric                     | Description | Namespace
---                        | ---         | ---
`request_count`            | The request count. | `kong.global.unmatched.request.count`
`request_size`             | The request's body size in bytes. | `kong.global.unmatched.request.size`
`response_size`            | The response's body size in bytes. | `kong.global.unmatched.response.size`
`latency`                  | The time interval between when the request started and the response was received from the upstream server. | `kong.global.unmatched.latency`
`status_count`             | The status count. | `kong.global.unmatched.status.\<status>.count`
`kong_latency`             | The internal Kong latency that it took to run all of the plugins, in milliseconds. | `kong.global.unmatched.kong_latency`

### Metric Fields

The plugin can be configured with any combination of [Metrics](#metrics), with each entry containing the following fields:

Field         | Description                                             | Datatype | Allowed values
---           | ---                                                     | ---        ---
`name`          | StatsD metrics name. Required.                       | String   | [Metrics](#metrics)          
`stat_type`     | Determines what sort of event a metric represents. Required.  | String   | `gauge`, `timer`, `counter`, `histogram`, `meter` and `set`|
`sample_rate`<br>*conditional*   | Sampling rate. Required.              | Number        | `number`                 
`consumer_identifier`<br>*conditional* | Authenticated user detail.  | String   | One of the following options: `consumer_id`, `custom_id`, `username`, `null`
`service_identifier`<br>*conditional* | Service detail.  | String   |  One of the following options:`service_id`, `service_name`, `service_host`, `service_name_or_host`, `null`
`workspace_identifier`<br>*conditional* | Workspace detail.  | String | One of the following options:`workspace_id`, `workspace_name`, `null`

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
