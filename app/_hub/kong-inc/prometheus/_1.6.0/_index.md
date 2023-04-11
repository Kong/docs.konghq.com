Metrics tracked by this plugin are available on both the Admin API and Status
API at the `http://localhost:PORT/metrics`
endpoint. Note that the URL to those APIs will be specific to your
installation, see [Accessing the metrics](#accessing-the-metrics).

This plugin records and exposes metrics at the node level. Your Prometheus
server must discover all Kong nodes via a service discovery mechanism
and consume data from each node's configured `/metrics` endpoint.

## Grafana dashboard

Metrics exported by the plugin can be graphed in Grafana using a drop in
dashboard: [https://grafana.com/dashboards/7424](https://grafana.com/dashboards/7424).

## Available metrics

- **Status codes**: HTTP status codes returned by upstream services.
  These are available per service, across all services, and per route per consumer.
- **Latencies Histograms**: Latency (in ms), as measured at Kong:
   - **Request**: Total time taken by Kong and upstream services to serve
     requests.
   - **Kong**: Time taken for Kong to route a request and run all configured
     plugins.
   - **Upstream**: Time taken by the upstream service to respond to requests.
- **Bandwidth**: Total Bandwidth (egress/ingress) flowing through Kong.
  This metric is available per service and as a sum across all services.
- **DB reachability**: A gauge type with a value of 0 or 1, which represents
  whether DB can be reached by a Kong node.
- **Connections**: Various Nginx connection metrics like active, reading,
  writing, and number of accepted connections.
- **Target Health**: The healthiness status (`healthchecks_off`, `healthy`, `unhealthy`, or `dns_error`) of targets
  belonging to a given upstream as well as their subsystem (`http` or `stream`).
- **Dataplane Status**: The last seen timestamp, config hash, config sync status, and certificate expiration timestamp for
data plane nodes is exported to control plane.
{% if_plugin_version gte:2.3.x %}
- **Enterprise License Information**: The {{site.base_gateway}} license expiration date, features, and
license signature. Those metrics are only exported on {{site.base_gateway}}.
{% endif_plugin_version %}
{% if_plugin_version gte:2.8.x %}
- **DB Entity Count** <span class="badge enterprise"></span> : A gauge metric that
    measures the current number of database entities.
- **Number of Nginx timers** : A gauge metric that measures the total number of Nginx
    timers, in Running or Pending state.
{% endif_plugin_version %}

Here is an example of output you could expect from the `/metrics` endpoint:

{% if_plugin_version gte:2.5.x %}
```bash
$ curl -i http://localhost:8001/metrics
HTTP/1.1 200 OK
Server: openresty/1.15.8.3
Date: Tue, 7 Jun 2020 16:35:40 GMT
Content-Type: text/plain; charset=UTF-8
Transfer-Encoding: chunked
Connection: keep-alive
Access-Control-Allow-Origin: *

# HELP kong_bandwidth Total bandwidth in bytes consumed per service/route in Kong
# TYPE kong_bandwidth counter
kong_bandwidth{type="egress",service="google",route="google.route-1"} 1277
kong_bandwidth{type="ingress",service="google",route="google.route-1"} 254
{% if_plugin_version gte:2.8.x %}
# HELP kong_nginx_timers Number of nginx timers
# TYPE kong_nginx_timers gauge
kong_nginx_timers{state="running"} 3
kong_nginx_timers{state="pending"} 1
{% endif_plugin_version %}
# HELP kong_datastore_reachable Datastore reachable from Kong, 0 is unreachable
# TYPE kong_datastore_reachable gauge
kong_datastore_reachable 1
# HELP kong_http_consumer_status HTTP status codes for customer per service/route in Kong
# TYPE kong_http_consumer_status counter
kong_http_consumer_status{service="s1",route="s1.route-1",code="200",consumer="CONSUMER_USERNAME"} 3
# HELP kong_http_status HTTP status codes per service/route in Kong
# TYPE kong_http_status counter
kong_http_status{code="301",service="google",route="google.route-1"} 2
# HELP kong_latency Latency added by Kong in ms, total request time and upstream latency for each service in Kong
# TYPE kong_latency histogram
kong_latency_bucket{type="kong",service="google",route="google.route-1",le="00001.0"} 1
kong_latency_bucket{type="kong",service="google",route="google.route-1",le="00002.0"} 1
.
.
.
kong_latency_bucket{type="kong",service="google",route="google.route-1",le="+Inf"} 2
kong_latency_bucket{type="request",service="google",route="google.route-1",le="00300.0"} 1
kong_latency_bucket{type="request",service="google",route="google.route-1",le="00400.0"} 1
.
.
kong_latency_bucket{type="request",service="google",route="google.route-1",le="+Inf"} 2
kong_latency_bucket{type="upstream",service="google",route="google.route-1",le="00300.0"} 2
kong_latency_bucket{type="upstream",service="google",route="google.route-1",le="00400.0"} 2
.
.
kong_latency_bucket{type="upstream",service="google",route="google.route-1",le="+Inf"} 2
kong_latency_count{type="kong",service="google",route="google.route-1"} 2
kong_latency_count{type="request",service="google",route="google.route-1"} 2
kong_latency_count{type="upstream",service="google",route="google.route-1"} 2
kong_latency_sum{type="kong",service="google",route="google.route-1"} 2145
kong_latency_sum{type="request",service="google",route="google.route-1"} 2672
kong_latency_sum{type="upstream",service="google",route="google.route-1"} 527
# HELP kong_nginx_http_current_connections Number of HTTP connections
# TYPE kong_nginx_http_current_connections gauge
kong_nginx_http_current_connections{state="accepted"} 8
kong_nginx_http_current_connections{state="active"} 1
kong_nginx_http_current_connections{state="handled"} 8
kong_nginx_http_current_connections{state="reading"} 0
kong_nginx_http_current_connections{state="total"} 8
kong_nginx_http_current_connections{state="waiting"} 0
kong_nginx_http_current_connections{state="writing"} 1
# HELP kong_memory_lua_shared_dict_bytes Allocated slabs in bytes in a shared_dict
# TYPE kong_memory_lua_shared_dict_bytes gauge
kong_memory_lua_shared_dict_bytes{shared_dict="kong",kong_subsystem="http"} 40960
.
.
# HELP kong_memory_lua_shared_dict_total_bytes Total capacity in bytes of a shared_dict
# TYPE kong_memory_lua_shared_dict_total_bytes gauge
kong_memory_lua_shared_dict_total_bytes{shared_dict="kong",kong_subsystem="http"} 5242880
.
.
# HELP kong_memory_workers_lua_vms_bytes Allocated bytes in worker Lua VM
# TYPE kong_memory_workers_lua_vms_bytes gauge
kong_memory_workers_lua_vms_bytes{pid="7281",kong_subsystem="http"} 41124353
# HELP kong_data_plane_config_hash Config hash value of the data plane
# TYPE kong_data_plane_config_hash gauge
kong_data_plane_config_hash{node_id="d4e7584e-b2f2-415b-bb68-3b0936f1fde3",hostname="ubuntu-bionic",ip="127.0.0.1"} 1.7158931820287e+38
# HELP kong_data_plane_last_seen Last time data plane contacted control plane
# TYPE kong_data_plane_last_seen gauge
kong_data_plane_last_seen{node_id="d4e7584e-b2f2-415b-bb68-3b0936f1fde3",hostname="ubuntu-bionic",ip="127.0.0.1"} 1600190275
# HELP kong_data_plane_version_compatible Version compatible status of the data plane, 0 is incompatible
# TYPE kong_data_plane_version_compatible gauge
kong_data_plane_version_compatible{node_id="d4e7584e-b2f2-415b-bb68-3b0936f1fde3",hostname="ubuntu-bionic",ip="127.0.0.1",kong_version="2.4.1"} 1
# HELP kong_nginx_metric_errors_total Number of nginx-lua-prometheus errors
# TYPE kong_nginx_metric_errors_total counter
kong_nginx_metric_errors_total 0
# HELP kong_upstream_target_health Health status of targets of upstream. States = healthchecks_off|healthy|unhealthy|dns_error, value is 1 when state is populated.
kong_upstream_target_health{upstream="UPSTREAM_NAME",target="TARGET",address="IP:PORT",state="healthchecks_off",subsystem="http"} 0
kong_upstream_target_health{upstream="UPSTREAM_NAME",target="TARGET",address="IP:PORT",state="healthy",subsystem="http"} 1
kong_upstream_target_health{upstream="UPSTREAM_NAME",target="TARGET",address="IP:PORT",state="unhealthy",subsystem="http"} 0
kong_upstream_target_health{upstream="UPSTREAM_NAME",target="TARGET",address="IP:PORT",state="dns_error",subsystem="http"} 0

{% if_plugin_version gte:2.8.x %}
# HELP kong_db_entities_total Total number of Kong db entities
# TYPE kong_db_entities_total gauge
kong_db_entities_total 42
# HELP kong_db_entity_count_errors Errors during entity count collection
# TYPE kong_db_entity_count_errors counter
kong_db_entity_count_errors 0
{% endif_plugin_version %}
```

{:.note}
> **Note:** Upstream targets' health information is exported once per subsystem. If both
stream and HTTP listeners are enabled, targets' health will appear twice. Health metrics
have a `subsystem` label to indicate which subsystem the metric refers to.

{% endif_plugin_version %}

{% if_plugin_version lte:2.4.x %}

```bash
$ curl -i http://localhost:8001/metrics
HTTP/1.1 200 OK
Server: openresty/1.15.8.3
Date: Tue, 7 Jun 2020 16:35:40 GMT
Content-Type: text/plain; charset=UTF-8
Transfer-Encoding: chunked
Connection: keep-alive
Access-Control-Allow-Origin: *

# HELP kong_bandwidth_total Total bandwidth in bytes for all proxied requests in Kong
# TYPE kong_bandwidth_total counter
kong_bandwidth_total{type="egress"} 1277
kong_bandwidth_total{type="ingress"} 254
# HELP kong_bandwidth Total bandwidth in bytes consumed per service in Kong
# TYPE kong_bandwidth counter
kong_bandwidth{type="egress",service="google"} 1277
kong_bandwidth{type="ingress",service="google"} 254
# HELP kong_datastore_reachable Datastore reachable from Kong, 0 is unreachable
# TYPE kong_datastore_reachable gauge
kong_datastore_reachable 1
# HELP kong_http_status_total HTTP status codes aggreggated across all services in Kong
# TYPE kong_http_status_total counter
kong_http_status_total{code="301"} 2
# HELP kong_http_status HTTP status codes per service in Kong
# TYPE kong_http_status counter
kong_http_status{code="301",service="google"} 2
# HELP kong_latency Latency added by Kong, total request time and upstream latency for each service in Kong
# TYPE kong_latency histogram
kong_latency_bucket{type="kong",service="google",le="00001.0"} 1
kong_latency_bucket{type="kong",service="google",le="00002.0"} 1
.
.
.
kong_latency_bucket{type="kong",service="google",le="+Inf"} 2
kong_latency_bucket{type="request",service="google",le="00300.0"} 1
kong_latency_bucket{type="request",service="google",le="00400.0"} 1
.
.
kong_latency_bucket{type="request",service="google",le="+Inf"} 2
kong_latency_bucket{type="upstream",service="google",le="00300.0"} 2
kong_latency_bucket{type="upstream",service="google",le="00400.0"} 2
.
.
kong_latency_bucket{type="upstream",service="google",le="+Inf"} 2
kong_latency_count{type="kong",service="google"} 2
kong_latency_count{type="request",service="google"} 2
kong_latency_count{type="upstream",service="google"} 2
kong_latency_sum{type="kong",service="google"} 2145
kong_latency_sum{type="request",service="google"} 2672
kong_latency_sum{type="upstream",service="google"} 527
# HELP kong_latency_total Latency added by Kong, total request time and upstream latency aggreggated across all services in Kong
# TYPE kong_latency_total histogram
kong_latency_total_bucket{type="kong",le="00001.0"} 1
kong_latency_total_bucket{type="kong",le="00002.0"} 1
.
.
kong_latency_total_bucket{type="kong",le="+Inf"} 2
kong_latency_total_bucket{type="request",le="00300.0"} 1
kong_latency_total_bucket{type="request",le="00400.0"} 1
.
.
kong_latency_total_bucket{type="request",le="+Inf"} 2
kong_latency_total_bucket{type="upstream",le="00300.0"} 2
kong_latency_total_bucket{type="upstream",le="00400.0"} 2
.
.
.
kong_latency_total_bucket{type="upstream",le="+Inf"} 2
kong_latency_total_count{type="kong"} 2
kong_latency_total_count{type="request"} 2
kong_latency_total_count{type="upstream"} 2
kong_latency_total_sum{type="kong"} 2145
kong_latency_total_sum{type="request"} 2672
kong_latency_total_sum{type="upstream"} 527
# HELP kong_nginx_http_current_connections Number of HTTP connections
# TYPE kong_nginx_http_current_connections gauge
kong_nginx_http_current_connections{state="accepted"} 8
kong_nginx_http_current_connections{state="active"} 1
kong_nginx_http_current_connections{state="handled"} 8
kong_nginx_http_current_connections{state="reading"} 0
kong_nginx_http_current_connections{state="total"} 8
kong_nginx_http_current_connections{state="waiting"} 0
kong_nginx_http_current_connections{state="writing"} 1
# HELP kong_memory_lua_shared_dict_bytes Allocated slabs in bytes in a shared_dict
# TYPE kong_memory_lua_shared_dict_bytes gauge
kong_memory_lua_shared_dict_bytes{shared_dict="kong",kong_subsystem="http"} 40960
.
.
# HELP kong_memory_lua_shared_dict_total_bytes Total capacity in bytes of a shared_dict
# TYPE kong_memory_lua_shared_dict_total_bytes gauge
kong_memory_lua_shared_dict_total_bytes{shared_dict="kong",kong_subsystem="http"} 5242880
.
.
# HELP kong_memory_workers_lua_vms_bytes Allocated bytes in worker Lua VM
# TYPE kong_memory_workers_lua_vms_bytes gauge
kong_memory_workers_lua_vms_bytes{pid="7281",kong_subsystem="http"} 41124353
# HELP kong_data_plane_config_hash Config hash value of the data plane
# TYPE kong_data_plane_config_hash gauge
kong_data_plane_config_hash{node_id="d4e7584e-b2f2-415b-bb68-3b0936f1fde3",hostname="ubuntu-bionic",ip="127.0.0.1"} 1.7158931820287e+38
# HELP kong_data_plane_last_seen Last time data plane contacted control plane
# TYPE kong_data_plane_last_seen gauge
kong_data_plane_last_seen{node_id="d4e7584e-b2f2-415b-bb68-3b0936f1fde3",hostname="ubuntu-bionic",ip="127.0.0.1"} 1600190275
# HELP kong_data_plane_version_compatible Version compatible status of the data plane, 0 is incompatible
# TYPE kong_data_plane_version_compatible gauge
kong_data_plane_version_compatible{node_id="d4e7584e-b2f2-415b-bb68-3b0936f1fde3",hostname="ubuntu-bionic",ip="127.0.0.1",kong_version="2.4.1"} 1
# HELP kong_nginx_metric_errors_total Number of nginx-lua-prometheus errors
# TYPE kong_nginx_metric_errors_total counter
kong_nginx_metric_errors_total 0
# HELP kong_upstream_target_health Health status of targets of upstream. States = healthchecks_off|healthy|unhealthy|dns_error, value is 1 when state is populated.
kong_upstream_target_health{upstream="<upstream_name>",target="<target>",address="<ip>:<port>",state="healthchecks_off"} 0
kong_upstream_target_health{upstream="<upstream_name>",target="<target>",address="<ip>:<port>",state="healthy"} 1
kong_upstream_target_health{upstream="<upstream_name>",target="<target>",address="<ip>:<port>",state="unhealthy"} 0
kong_upstream_target_health{upstream="<upstream_name>",target="<target>",address="<ip>:<port>",state="dns_error"} 0
```
{% endif_plugin_version %}


## Accessing the metrics

In most configurations, the Kong Admin API will be behind a firewall or would
need to be set up to require authentication. Here are a couple of options to
allow access to the `/metrics` endpoint to Prometheus:


1. If the [Status API](/gateway/latest/reference/configuration/#status_listen)
   is enabled, then its `/metrics` endpoint can be used.
   This is the preferred method.

1. The `/metrics` endpoint is also available on the Admin API, which can be used
   if the Status API is not enabled. Note that this endpoint is unavailable
   when [RBAC](/gateway/latest/admin-api/rbac/reference/) is enabled on the
   Admin API (Prometheus does not support Key-Auth to pass the token).

---


