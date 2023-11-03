---
title: Monitoring with Prometheus
content_type: how-to
---

[Prometheus](https://prometheus.io/) is a popular systems monitoring and alerting toolkit. Prometheus 
implements a multi-dimensional time series data model and distributed storage
system where metrics data is collected via a pull model over HTTP. 

{{site.base_gateway}} supports Prometheus with the [Prometheus Plugin](/hub/kong-inc/prometheus/) that exposes
{{site.base_gateway}} performance and proxied upstream service metrics on the `/metrics` endpoint.

This guide will help you setup a test {{site.base_gateway}} and
Prometheus service. Then you will generate sample requests to {{site.base_gateway}} and
observe the collected monitoring data.

### Prerequisites
This guide assumes the following tools are installed locally:
* [Docker](https://docs.docker.com/get-docker/) is used to run {{site.base_gateway}}, the supporting database, 
and Prometheus locally. 
* [curl](https://curl.se/) is used to send requests to {{site.base_gateway}}. `curl` is pre-installed on most systems.

### Configure Prometheus monitoring

1. Install {{site.base_gateway}}:

   {:.note}
      > This step is optional if you wish to use an existing {{site.base_gateway}} installation. When using an existing
        {{site.base_gateway}}, you will need to modify the commands to account for network
        connectivity and installed {{site.base_gateway}} services and routes.

   ```sh
   curl -Ls https://get.konghq.com/quickstart | bash -s -- -m
   ```
   The `-m` flag instructs the script to install a mock service that is used in this guide to generate sample metrics.

   Once the {{site.base_gateway}} is ready, you will see the following message:

   ```text
   ✔ Kong is ready!
   ```

1. Install the Prometheus {{site.base_gateway}} plugin:

   ```sh
   curl -s -X POST http://localhost:8001/plugins/ \
    --data "name=prometheus" 
   ```

   You should receive a JSON response with the details of the installed plugin.

1. Create a Prometheus configuration file named `prometheus.yml`
in the current directory, and copy the following values:

   ```text
   scrape_configs:
     - job_name: 'kong'
       scrape_interval: 5s
       static_configs:
         - targets: ['kong-quickstart-gateway:8001']
   ```

   See the Prometheus [Configuration Documentation](https://prometheus.io/docs/prometheus/latest/configuration/configuration/)
   for details on these settings.

1. Run a Prometheus server, and pass it the configuration file created in the previous step. Prometheus 
will begin to scrape metrics data from {{site.base_gateway}}.

   ```sh
   docker run -d --name kong-quickstart-prometheus \
      --network=kong-quickstart-net -p 9090:9090 \
      -v $(PWD)/prometheus.yml:/etc/prometheus/prometheus.yml \
      prom/prometheus:latest
   ```

1. Generate sample traffic to the mock service. This allows you to observe 
   metrics generated from the StatsD plugin. The following command generates 60 
   requests over one minute. Run the following in a new terminal:

   ```bash
   for _ in {1..60}; do {curl -s localhost:8000/mock/anything; sleep 1; } done
   ```

1. You can view the metric data directly from {{site.base_gateway}} by querying the
   `/metrics` endpoint on the [Admin API](/gateway/{{page.kong_version}}/admin-api/):

   ```sh
   curl -s localhost:8001/metrics
   ```

   {{site.base_gateway}} will report system wide performance metrics by default. 
   When the Plugin has been installed and traffic is being proxied, it will record 
   additional metrics across service, route, and upstream dimensions.

   The response will look similar to the following snippet:

   ```text
   # HELP kong_bandwidth Total bandwidth in bytes consumed per service/route in Kong
   # TYPE kong_bandwidth counter
   kong_bandwidth{service="mock",route="mock",type="egress"} 13579
   kong_bandwidth{service="mock",route="mock",type="ingress"} 540
   # HELP kong_datastore_reachable Datastore reachable from Kong, 0 is unreachable
   # TYPE kong_datastore_reachable gauge
   kong_datastore_reachable 1
   # HELP kong_http_status HTTP status codes per service/route in Kong
   # TYPE kong_http_status counter
   kong_http_status{service="mock",route="mock",code="200"} 6
   # HELP kong_latency Latency added by Kong, total request time and upstream latency for each service/route in Kong
   # TYPE kong_latency histogram
   kong_latency_bucket{service="mock",route="mock",type="kong",le="1"} 4
   kong_latency_bucket{service="mock",route="mock",type="kong",le="2"} 4
   ...
   ```

   See the [Kong Prometheus Plugin documentation](https://prometheus.io/docs/prometheus/latest/configuration/configuration://docs.konghq.com/hub/kong-inc/prometheus/)
   for details on the available metrics and configurations.

1. Prometheus provides multiple ways to query collected metric data. 
   
   You can view the [Prometheus expression](https://prometheus.io/docs/prometheus/latest/querying/basics/) viewer 
   by opening a browser to [http://localhost:9090/graph](http://localhost:9090/graph).

   You can also query Prometheus directly using it's
   [HTTP API](https://prometheus.io/docs/prometheus/latest/querying/api/):

   ```sh
   curl -s 'localhost:9090/api/v1/query?query=kong_http_status'
   ```

   Prometheus also [provides documentation](https://prometheus.io/docs/visualization/grafana/) 
   for setting up [Grafana](https://grafana.com/) as a visualization tool for the collected time series data.

### Cleanup

Once you are done experimenting with Prometheus and {{site.base_gateway}}, you can use the following
commands to stop and remove the services created in this guide:

```sh
docker stop kong-quickstart-prometheus
curl -Ls https://get.konghq.com/quickstart | bash -s -- -d
```

### More information
* [How to monitor with StatsD](/gateway/{{page.kong_version}}/production/monitoring/statsd/)
provides a guide to using [StatsD](https://github.com/statsd/statsd) for monitoring with the
[{{site.base_gateway}} Plugin](/hub/kong-inc/statsd/)
* See the [Tracing API Reference](/gateway/{{page.kong_version}}/production/tracing/api/) for information
on {{site.base_gateway}}'s tracing capabilities 

