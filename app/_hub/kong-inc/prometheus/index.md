---
name: Prometheus
publisher: Kong Inc.
version: 1.0.0

desc: Expose metrics related to Kong and proxied upstream services in Prometheus exposition format
description: |
    Expose metrics related to Kong and proxied upstream services in [Prometheus](https://prometheus.io/docs/introduction/overview/) exposition format, which can be scraped by a Prometheus Server.

type: plugin
categories:
  - analytics-monitoring

kong_version_compatibility:
    community_edition:
      compatible:
        - 1.1.x
        - 1.0.x
        - 0.14.x
    enterprise_edition:
      compatible:

params:
  name: prometheus
  service_id: true
  route_id: false
  protocols: ["http", "https", "tcp", "tls"]
  dbless_compatible: yes
  dbless_explanation: |
    The database will always be reported as “reachable” in prometheus with DB-less.

---

Metrics are available on the Admin API at the `http://localhost:8001/metrics`
endpoint. Note that the URL to the Admin API will be specific to your
installation; see _Accessing the metrics_ below.

This plugin records and exposes metrics at the node-level. Your Prometheus
server will need to discover all Kong nodes via a service discovery mechanism,
and consume data from each node's configured `/metric` endpoint. Kong nodes
that are set to proxy only (that is their Admin API has been disabled by
specifying `admin_listen = off`) will need to use a [custom Nginx
configuration template](/latest/configuration/#custom-nginx-configuration)
to expose the metrics data.

### Grafana dashboard

Metrics exported by the plugin can be graphed in Grafana using a drop in
dashboard: [https://grafana.com/dashboards/7424](https://grafana.com/dashboards/7424).

### Available metrics

- **Status codes**: HTTP status codes returned by upstream services.
  These are available per service and across all services.
- **Latencies Histograms**: Latency as measured at Kong:
   - **Request**: Total time taken by Kong and upstream services to serve
     requests.
   - **Kong**: Time taken for Kong to route a request and run all configured
     plugins.
   - **Upstream**: Time taken by the upstream service to respond to requests.
- **Bandwidth**: Total Bandwidth (egress/ingress) flowing through Kong.
  This metric is available per service and as a sum across all services.
- **DB reachability**: A gauge type with a value of 0 or 1, representing if DB
  can be reached by a Kong node or not.
- **Connections**: Various Nginx connection metrics like active, reading,
  writing, and number of accepted connections.

Here is an example of output you could expect from the `/metrics` endpoint:

```bash
$ curl -i http://localhost:8001/metrics
HTTP/1.1 200 OK
Server: openresty/1.11.2.5
Date: Mon, 11 Jun 2018 01:39:38 GMT
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
# HELP kong_nginx_metric_errors_total Number of nginx-lua-prometheus errors
# TYPE kong_nginx_metric_errors_total counter
kong_nginx_metric_errors_total 0
```

### Accessing the metrics

In most configurations, the Kong Admin API will be behind a firewall or would
need to be set up to require authentication, here are a couple of options to
allow access to the `/metrics` endpoint to Prometheus.


1. Kong Enterprise users can protect the admin `/metrics` endpoint with an
   [RBAC user](/enterprise/latest/setting-up-admin-api-rbac) that the
   Prometheus servers use to access the metric data. Access through any
   firewalls would also need to be configured.

2. You can proxy the Admin API through Kong itself then use plugins to limit
   access. For example, you can create a route `/metrics` endpoint and have
   Prometheus access this endpoint to slurp in the metrics while preventing
   others from access it. The specifics of how this is configured will depend
   on your specific setup. Read the docs [Securing the Admin
   API](https://docs.konghq.com/latest/secure-admin-api/#kong-api-loopback) for
   details.

3. Finally, you could serve the content on a different port with a custom server
   block using a [custom Nginx
   template](/latest/configuration/#custom-nginx-configuration) with Kong.

    The following block is an example custom nginx template which can be used
    by Kong:

    ```
    server {
        server_name kong_prometheus_exporter;
        listen 0.0.0.0:9542; # can be any other port as well

        location / {
            default_type text/plain;
            content_by_lua_block {
                local serve = require "kong.plugins.prometheus.serve"
                serve.prometheus_server()
            }
        }

        location /nginx_status {
            internal;
            access_log off;
            stub_status;
        }
    }
    ```
