---
title: Monitoring with StatsD
content_type: how-to
---

[StatsD](https://github.com/statsd/statsd) is a network daemon that collects
and aggregates performance metrics by listening on the network for 
text based statistics data, published by applications. 

This guide will help you setup a test {{site.base_gateway}} and
StatsD service. Then you will generate sample requests to {{site.base_gateway}} and
observe the collected monitoring data. 

### Prerequisites
* [Docker](https://docs.docker.com/get-docker/) is used to run StatsD and supporting services locally. 
* [curl](https://curl.se/) is used to send requests to {{site.base_gateway}}. `curl` is pre-installed on most systems.
* [Netcat](http://netcat.sourceforge.net/) is installed as `nc` on the system `PATH`. `nc` is used to send requests 
  to the StatsD management interface. `nc` is pre-installed on many systems.

### Configure StatsD monitoring

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

1. Run a StatsD container to capture monitoring data:

   ```sh
   docker run -d --rm -p 8126:8126 \
     --name kong-quickstart-statsd --network=kong-quickstart-net \
     statsd/statsd:latest
   ```

1. Install the [StatsD {{site.base_gateway}} plugin](/hub/kong-inc/statsd/), 
   configuring the hostname and port of the listening StatsD service:

   ```sh
   curl -X POST http://localhost:8001/plugins/ \
       --data "name=statsd"  \
       --data "config.host=kong-quickstart-statsd" \
       --data "config.port=8125"
   ```

   You should receive a JSON response with details about the installed plugin.

1. Generate sample traffic to the mock service. This allows you to observe 
   metrics generated from the StatsD plugin. The following command generates 60 
   requests over one minute. Run the following in a new terminal:

   ```sh
   for _ in {1..60}; do {curl localhost:8000/mock/anything; sleep 1; } done
   ```

1. Query the StatsD management interface to see the collected metrics from {{site.base_gateway}}:

   ```sh
   echo "counters" | nc localhost 8126
   ```

   You should see a response similar to the following:

   ```text
   {
     'statsd.bad_lines_seen': 0,
     'statsd.packets_received': 56,
     'statsd.metrics_received': 56,
     'kong.mock.request.count': 7,
     'kong.mock.request.status.200': 7,
     'kong.mock.request.status.total': 7
   }
   END
   ```

See the [StatsD plugin](/hub/kong-inc/statsd/) 
documentation for more information about how to use and configure the plugin.

### Clean up

Once you are done experimenting with StatsD and {{site.base_gateway}}, you can use the following
commands to stop and remove the software ran in this guide:

```sh
docker stop kong-quickstart-statsd
curl -Ls https://get.konghq.com/quickstart | bash -s -- -d
```

### More information
* [How to monitor with Prometheus](/gateway/{{page.kong_version}}/production/monitoring/prometheus/) 
describes how to use [Prometheus](https://prometheus.io/docs/introduction/overview/) to monitor {{site.base_gateway}} using the  
[Prometheus plugin](/hub/kong-inc/prometheus/).
* See the [Tracing API Reference](/gateway/{{page.kong_version}}/production/tracing/api/) for information
about {{site.base_gateway}}'s tracing capabilities.
