## Changelog

**{{site.base_gateway}} 3.0.x**
* High cardinality metrics are now disabled by default.
* Decreased performance penalty to proxy traffic when collecting metrics.
* The following metric names were adjusted to add units to standardize where possible:
  * `http_status` to `http_requests_total`
  * `latency` to `kong_request_latency_ms`/`kong_upstream_latency_ms`/`kong_kong_latency_ms`
  * `kong_bandwidh` to `kong_bandwidth_bytes`
  * `nginx_http_current_connections`/`nginx_stream_current_connections` to `nginx_connections_total`
  * Removed: `http_consumer_status`
* New metric: `session_duration_ms` for monitoring stream connections
* New metric: `node_info` is a single gauge set to 1 that outputs the node's ID and {{site.base_gateway}} version
* Latency was split into four different metrics: `kong_latency_ms`, `upstream_latency_ms`, `request_latency_ms` (HTTP), and `session_duration_ms` (stream). Buckets details follow:
  * Kong Latency and Upstream Latency can operate at orders of different magnitudes. Separate these buckets to reduce memory overhead.
* `request_count` and `consumer_status` were merged into `http_requests_total`. If the `per_consumer` config is set to false, the `consumer` label will be empty.  If the `per_consumer` config is true, the `consumer` label will be filled.
* `http_requests_total` has a new label [`source`](/gateway/latest/plugin-development/pdk/kong.response/#kongresponseget_source/). It can be set to `exit`, `error`, or `service`.
* All Memory metrics have a new label, `node_id`.
* Plugin version bumped to 3.0.0
* The `node_id` label was added to memory metrics.

**{{site.base_gateway}} (Enterprise) 2.8.3.2**
* Adds new directives in `kong.conf` to enable or disable high cardinality metrics.
  * `prometheus_plugin_status_code_metrics`: enables or disables reporting the HTTP/Stream status codes per service/route.
  * `prometheus_plugin_latency_metrics`: enables or disables reporting the latency added by Kong, request time and upstream latency.
  * `prometheus_plugin_bandwidth_metrics`: enables or disables reporting the bandwidth consumed by service/route.
  * `prometheus_plugin_upstream_health_metrics`: enables or disables reporting the upstream health status.

**{{site.base_gateway}} 2.8.x**
* Adds a new metric:
  * `kong_nginx_timers` (gauge): total number of Nginx timers, in Running or Pending state.
* Add two new metrics:
  * `kong_db_entities_total` (gauge): total number of entities in the database
  * `kong_db_entity_count_errors` (counter): measures the number of errors
      encountered during the measurement of `kong_db_entities_total`

**{{site.base_gateway}} 2.5.x**
* New `data_plane_cluster_cert_expiry_timestamp` metric
* Added `subsystem` label to Upstream Target health metrics

**{{site.base_gateway}} 2.4.x**
* Added the `per_consumer` configuration parameter to export per-consumer status.

**{{site.base_gateway}} 2.3.x**
* The plugin can now export Kong Enterprise licensing information.
