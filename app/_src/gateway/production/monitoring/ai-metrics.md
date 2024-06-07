---
nav_title: Expose and Graphed Kong AI Metrics
title: Expose and Graphed Kong AI Metrics
minimum_version: 3.7.x
---

{:.note}
> This feature requires {{site.ee_product_name}}.

This guide walks you through getting and sending AI Metrics to Prometheus, and
setting the Grafana Dashboard.

## Overview

Kong's AI Gateway (AI Proxy) call LLM-based services according to the settings of the AI Proxy,
we will aggregate the LLM provider response to count the number of tokens used by the AI Proxy.
If you have defined input and output cost in the models we will also calculate cost aggregation.
The metrics details also exposed if the requests has been cached by Kong saving the cost of contacting
the LLM providers thus saving performance and money.

Expose metrics related to Kong and proxied upstream services in 
[Prometheus](https://prometheus.io/docs/introduction/overview/) 
exposition format, which can be scraped by a Prometheus Server.

Metrics tracked by this plugin are available on both the Admin API and Status
API at the `http://localhost:<port>/metrics`
endpoint. Note that the URL to those APIs will be specific to your
installation; see [Accessing the metrics](#accessing-the-metrics).

This plugin records and exposes metrics at the node level. Your Prometheus
server will need to discover all Kong nodes via a service discovery mechanism,
and consume data from each node's configured `/metrics` endpoint.

## Grafana dashboard

AI Metrics exported by the plugin can be graphed in Grafana using a drop-in
dashboard: [https://grafana.com/grafana/dashboards/21162-kong-cx-ai/](https://grafana.com/grafana/dashboards/21162-kong-cx-ai/).

![AI Grafana Dashboard](/assets/images/products/gateway/vitals/grafana-ai-dashboard.png)

## Available metrics

- **AI Requests**: AI request sent to LLM providers.
  These are available per provider, model, cache, database name (if cached), and workspace.
- **AI Cost:**: AI Cost charged by LLM providers.
  These are available per provider, model, cache, database name (if cached), and workspace.
- **AI Tokens** AI Tokens counted by LLM providers.
  These are available per provider, model, cache, database name (if cached), token type, and workspace.

AI metrics are disabled by default as it may create high cardinality of metrics and may
cause performance issues:

Here is an example of output you could expect from the `/metrics` endpoint:

```bash
curl -i http://localhost:8001/metrics
```

Response:
```sh
HTTP/1.1 200 OK
Server: openresty/1.15.8.3
Date: Tue, 7 Jun 2020 16:35:40 GMT
Content-Type: text/plain; charset=UTF-8
Transfer-Encoding: chunked
Connection: keep-alive
Access-Control-Allow-Origin: *

{% if_version gte:3.0.x %}
# HELP ai_requests_total AI requests total per ai_provider in Kong
# TYPE ai_requests_total counter
ai_requests_total{ai_provider="provider1",ai_model="model1",cache="true",db_name="db1",workspace="workspace1"} 100
# HELP ai_cost_total AI requests cost per ai_provider/cache in Kong
# TYPE ai_cost_total counter
ai_cost_total{ai_provider="provider1",ai_model="model1",cache="true",db_name="db1",workspace="workspace1"} 50
# HELP ai_tokens_total AI tokens total per ai_provider/cache in Kong
# TYPE ai_tokens_total counter
ai_tokens_total{ai_provider="provider1",ai_model="model1",cache="true",db_name="db1",token_type="input",workspace="workspace1"} 1000
ai_tokens_total{ai_provider="provider1",ai_model="model1",cache="true",db_name="db1",token_type="output",workspace="workspace1"} 2000
{% endif_version %}
```

{:.note}
> **Note:** If you don't use any cache plugins, then `cache` value will be `not_cached`
by default and `db_name` will be empty. 

## Accessing the metrics

In most configurations, the Kong Admin API will be behind a firewall or would
need to be set up to require authentication. Here are a couple of options to
allow access to the `/metrics` endpoint to Prometheus:


1. If the [Status API](/gateway/latest/reference/configuration/#status_listen)
   is enabled, then its `/metrics` endpoint can be used.
   This is the preferred method.

1. The `/metrics` endpoint is also available on the Admin API, which can be used
   if the Status API is not enabled. Note that this endpoint is unavailable
   when [RBAC](/gateway/api/admin-ee/latest/#/rbac/get-rbac-users/) is enabled on the
   Admin API (Prometheus does not support Key-Auth to pass the token).

---

