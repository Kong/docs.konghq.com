---
name: StatsD
publisher: Kong Inc.
version: 1.0.0

desc: Send request and response logs to StatsD
description: |
  Log [metrics](#metrics) for a Service, Route
  to a StatsD server.
  It can also be used to log metrics on [Collectd](https://collectd.org/)
  daemon by enabling its [Statsd
  plugin](https://collectd.org/wiki/index.php/Plugin:StatsD).

  This plugin is the open-source version of the [StatsD Advanced plugin](/hub/kong-inc/statsd-advanced/), which provides additional features such as:
  * Ability to choose status codes to log to metrics.
  * More granular status codes per workspace.
  * Ability to use TCP instead of UDP.

type: plugin
categories:
  - logging

kong_version_compatibility:
    community_edition:
      compatible:
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
  name: statsd
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
      description: The IP address or host name to send data to.
    - name: port
      required: true
      default: "`8125`"
      value_in_examples: 8125
      datatype: integer
      description:  The port of StatsD server to send data to.
    - name: metrics
      required: true
      default: "All metrics are logged"
      datatype: Array of record elements
      description: List of Metrics to be logged. Available values are described under [Metrics](#metrics).
    - name: prefix
      required: true
      default: "`kong`"
      datatype: string
      description: String to prefix to each metric's name.

---

## Metrics

Metrics the plugin supports logging into the StatsD server.

Metric                     | Description | Namespace
---                        | ---         | ---
`request_count`            | tracks the request | kong.\<service_name>.request.count
`request_size`             | tracks the request's body size in bytes | kong.\<service_name>.request.size
`response_size`            | tracks the response's body size in bytes | kong.\<service_name>.response.size
`latency`                  | tracks the time interval in milliseconds between the request started and response received from the upstream server | kong.\<service_name>.latency
`status_count`             | tracks each status code returned in a response | kong.\<service_name>.request.status.\<status>.count and kong.\<service_name>.request.status.\<status>.total
`unique_users`             | tracks unique users who made a requests to the underlying Service/Route | kong.\<service_name>.user.uniques
`request_per_user`         | tracks request/user | kong.\<service_name>.user.\<consumer_id>.request.count
`upstream_latency`         | tracks the time it took for the final service to process the request | kong.\<service_name>.upstream_latency
`kong_latency`             | tracks the internal Kong latency that it took to run all the plugins | kong.\<service_name>.kong_latency
`status_count_per_user`    | tracks request/status/user | kong.\<service_name>.user.\<customer_id>.request.status.\<status> and kong.\<service_name>.user.\<customer_id>.request.status.total

### Metric Fields

The plugin can be configured with any combination of [Metrics](#metrics), with each entry containing the following fields:

Field         | Description                                             | Datatypes | Allowed values
---           | ---                                                     | ---       | ---
`name`          | StatsD metric's name. Required.                       | String   | [Metrics](#metrics)
`stat_type`     | Determines what sort of event the metric represents. Required.  | String   | `gauge`, `timer`, `counter`, `histogram`, `meter`, and `set`|
`sample_rate`<br>*conditional*   | Sampling rate. Required.             | Number | `number`
`consumer_identifier`<br>*conditional*| Authenticated user detail. Required.   | String    | One of the following options: `consumer_id`, `custom_id`, `username`

### Metric Requirements

1.  By default, all metrics get logged.
2.  Metric with `stat_type` set to `counter` or `gauge` must have `sample_rate` defined as well.
3.  `unique_users` metric only works with `stat_type` as `set`.
4.  `status_count`, `status_count_per_user` and `request_per_user` work only with `stat_type`  as `counter`.
5.  `status_count_per_user`, `request_per_user` and `unique_users` must have `customer_identifier` defined.


## Kong Process Errors

{% include /md/plugins-hub/kong-process-errors.md %}
