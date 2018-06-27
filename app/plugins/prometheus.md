---
id: page-plugin
title: Plugins - Prometheus
header_title: Prometheus
header_icon: /assets/images/icons/plugins/prometheus.png
breadcrumbs:
  Plugins: /plugins
nav:
  - label: Usage
    items:
      - label: Log Format
      - label: Kong Process Errors
description: |
  This plugin exposes metrics in [Prometheus Exposition format](https://github.com/prometheus/docs/blob/master/content/docs/instrumenting/exposition_formats.md). It allows you to integrate with your existing monitoring and alerting system.

params:
  name: prometheus

---


#### Enable the plugin

```bash
$ curl http://localhost:8001/plugins name=prometheus
```

#### Reading metrics into Prometheus

Metrics are availble on the admin API at `/metrics` endpoint:

```bash
$ curl http://localhost:8001/metrics
root@vagrant-ubuntu-trusty-64:~# curl -D - http://localhost:8001/metrics
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

In case Admin API of Kong is protected behind a firewall or requires
authentication, you have a couple of options:


1. Kong Enterprise users can protect the admin `/metrics` endpoint with an [RBAC user](/enterprise/0.32-x/setting-up-admin-api-rbac) that the Prometheus servers uses to access the metric data.

2. If your proxy nodes also serve the Admin API, then you can create a route
to `/metrics` endpoint and apply a IP restriction plugin.

    ```
    curl -X POST http://localhost:8001/services -d name=prometheusEndpoint -d url=http://localhost:8001/metrics
    curl -X POST http://localhost:8001/services/prometheusEndpoint/routes -d paths[]=/metrics
    curl -X POST http://localhost:8001/services/prometheusEndpoint/plugins -d name=ip-restriction -d config.whitelist=10.0.0.0/24
    ```

3. This plugin has the capability to serve the content on a
different port using a custom server block in Kong's NGINX template.

    Please note that this requires a custom NGINX template for Kong.

    You can add the following block to a custom NGINX template which can be used by Kong:

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
