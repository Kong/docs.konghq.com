---
title: Monitoring with StatsD
content_type: how-to
---

[StatsD](https://github.com/statsd/statsd) is a network daemon that collects
and aggreates performance metrics by listening on the network for simple 
text based statistics data published by applications. 

This guide will help you setup a test {{site.base_gateway}} and
StatsD service. Then you will generate sample requests to {{site.base_gateway}} and
observe the collected monitoring data.

### Prerequisites
This guide assumes each of the following tools are installed locally. 
* [Docker](https://docs.docker.com/get-docker/) is used to run Kong, the supporting database, and StatsD locally. 
* [curl](https://curl.se/) is used to send requests to the gateway. Most systems come with `curl` pre-installed.
* [Netcat](http://netcat.sourceforge.net/) installed as `nc` on the `PATH`. `nc` is used to send requests 
  to the StatsD management interface. Many systems come with `nc` pre-installed.

### Guide

1. Run the following command to start {{site.base_gateway}} using Docker:

   ```sh
   curl -Ls get.konghq.com/quickstart | sh -s
   ```

   You should see the following message when {{site.base_gateway}} is ready:

   ```text
   ✔ Kong is ready!
   ```

   The script has also installed a mock service to make testing easier. You will use this 
   service later to generate metrics data. You can send a sample request with:

   ```sh
   curl localhost:8000/mock/requests
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

   You should receive a JSON response with the details of the installed plugin.

1. Generate sample traffic to the mock service. This will allow you to observe 
   metrics generated from the StatsD plugin. The following command will generate 60 
   requests over 1 minute. Run the following in a new terminal:

   ```sh
   for _ in {1..60}; do {curl localhost:8000/mock/request; sleep 1; } done
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

The [Kong Hub StatsD Plugin](/hub/kong-inc/statsd/) 
contains the full documentation on the plugin usage and configuration

### Cleanup

Once you are done experimenting with StatsD and {{site.base_gateway}}, use the following
commands to stop and remove the services created in this guide:

```sh
docker stop kong-quickstart-statsd
curl -Ls get.konghq.com/quickstart | sh -s -- -d
```

### More Information
* [How to monitor with Prometheus](/gateway/{{page.gateway_version}}/kong-production/monitoring/prometheus/) 
provides a guide to using [Prometheus](https://prometheus.io/docs/introduction/overview/) for monitoring with the 
[{{site.base_gateway}} Plugin](/hub/kong-inc/prometheus/)
* See the [Tracing API Reference](/gateway/{{page.kong_version}}/kong-production/tracing/api/) for information
on {{site.base_gateway}}'s tracing capabilites
