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

