---
title: Rate Limiting
content-type: tutorial
book: get-started
chapter: 3
---

Rate limiting is used to control the rate of requests sent to an upstream service. 
It can be used to prevent DoS attacks, limit web scraping, and other forms of overuse. 
Without rate limiting, clients have unlimited access to your upstream services, which
may negatively impact availability.

## The Rate Limiting plugin

{{site.base_gateway}} imposes rate limits on clients through the use of the [Rate Limiting plugin](/hub/kong-inc/rate-limiting). 
When rate limiting is enabled, clients are restricted in the number of requests that can be made in a configurable period of time.
The plugin supports identifying clients as [consumers](/gateway/latest/admin-api/#consumer-object) 
or by the client IP address of the requests.

{:.note}
> This tutorial uses the [Rate Limiting](/hub/kong-inc/rate-limiting) <span class="badge free"></span> plugin. Also available is the 
[Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced) <span class="badge enterprise"></span> 
plugin. The advanced version provides additional features like support for the sliding window algorithm
and advanced Redis support for greater performance.

## Managing rate limiting

The following tutorial walks through managing rate limiting across various aspects in {{site.base_gateway}}.

### Prerequisites

This chapter is part of the *Get Started with Kong* series. For the best experience, it is recommended that you follow the
series from the beginning. 

Start with the introduction [Get Kong](/gateway/latest/get-started/get-kong), which includes
tool prerequisites and instructions for running a local {{site.base_gateway}}.

Step two of the guide, [Services and Routes](/gateway/latest/get-started/services-and-routes),
includes instructions for installing a mock service used throughout this series. 

If you haven't completed these steps already, complete them before proceeding.

### Global rate limiting 

Installing the plugin globally means *every* proxy request to {{site.base_gateway}}
will be subject to rate limit enforcement.

1. **Enable rate limiting**

   The rate limiting plugin is installed by default on {{site.base_gateway}}, and can be enabled
   by sending a `POST` request to the [plugins](/gateway/latest/admin-api/#add-plugin) object on the Admin API: 
   
   ```sh
   curl -i -X POST http://localhost:8001/plugins \
     --data name=rate-limiting \
     --data config.minute=5 \
     --data config.policy=local
   ```

   This command has instructed {{site.base_gateway}} to impose a maximum of 5 requests per minute per client IP address
   for all routes and services.

   The `policy` configuration determines where {{site.base_gateway}} retrieves and increments limits. See the full
   [plugin configuration reference](/hub/kong-inc/rate-limiting/#configuration) for details.
   
   You will see a response that contains the new plugin configuration, including identification information similar to:

   ```text
   ...
   "id": "fc559a2d-ac80-4be8-8e43-cb705524be7f",
   "name": "rate-limiting",
   "enabled": true
   ...
   ```

1. **Validate**

   After configuring rate limiting, you can verify that it was configured correctly and is working, 
   by sending more requests then allowed in the configured time limit.

{% capture global_instructions %}
{% navtabs %}
{% navtab Command Line %}

Run the following command to quickly send 6 mock requests:

```sh
for _ in {1..6}; do {curl -s -i localhost:8000/mock/request; echo; sleep 1; } done
```

{% endnavtab %}
{% navtab Web browser %}

Open [http://localhost:8000/mock/request](http://localhost:8000/mock/request) in your browser 
and refresh the page 6 times within 1 minute. 

{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{{ global_instructions | indent }}

   After the 6th request, you should receive a 429 "API rate limit exceeded" error:
   ```
   {
      "message": "API rate limit exceeded"
   }
   ```

### Service level rate limiting

The Rate Limiting plugin can be enabled for specific services. The request is the same as above, 
but posted to the service URL:

```sh
curl -X POST http://localhost:8001/services/example_service/plugins \
   --data "name=rate-limiting" \
   --data config.minute=5 \
   --data config.policy=local
```

### Route level rate limiting

The Rate Limiting plugin can be enabled for specific routes. The request is the same as above,
but posted to the route URL:

```sh
curl -X POST http://localhost:8001/routes/mock/plugins \
   --data "name=rate-limiting" \
   --data config.minute=5 \
   --data config.policy=local
```

### Consumer level rate limiting

In {{site.base_gateway}}, [consumers](/gateway/latest/admin-api/#consumer-object) are an abstraction
that defines a user of a service. Consumer-level rate limiting can be used to limit request rates per consumer.

1. **Create a consumer**

   Consumers are created using the [consumer object](/gateway/latest/admin-api/#consumer-object) in the Admin API. 

   ```sh
   curl -X POST http://localhost:8001/consumers/ \
     --data username=jsmith
   ```

1. **Enable rate limiting for the consumer**

   Using the consumer id, enable rate limiting for all routes and services for 
   the `jsmith` consumer.

   ```sh
   curl -X POST http://localhost:8001/plugins \
      --data "name=rate-limiting" \
      --data "consumer.id=jsmith" \
      --data "config.second=5" \
   ```

## The Rate Limiting Advanced plugin

Rate Limiting Advanced provides:

* Additional configurations: `limit`, `window_size`, and `sync_rate`
* Support for Redis Sentinel, Redis cluster, and Redis SSL
* Increased performance: Rate Limiting Advanced has better throughput performance with better accuracy. 
  Configure `sync_rate` to periodically sync with backend storage.
* More limiting algorithms to choose from: These algorithms are more accurate and they enable configuration 
  with more specificity. Learn more about our algorithms in How to Design a Scalable Rate Limiting Algorithm.
* Consumer groups support: apply different rate limiting configurations to select groups of consumers.

### Additional configuration

The configuration process for the Rate Limiting Advanced plugin is similar to configuring the Rate Limiting plugin. 
To configure the Rate Limiting Advanced plugin create a `POST` request like this: 

```sh
curl -i -X POST http://localhost:8001/plugins \
   --data name=rate-limiting-advanced \
   --data config.limit=5 \
   --data config.window_size=30 \
   --data config.sync_rate=-1
```

This request utilizes the `config.limit`, `config.window_size` and `config.sync_rate` form parameters. 

* config.limit: Number of requests allows per window.
* config.window_size: Window size to track request for in seconds. 
* config.sync_rate: how often to sync counter data to the central data store.    `-1` ignores sync behavior 
  entirely and only stores counters in node memory, `>0 ` sync the counters in that many number of seconds. 

The word "window" here refers to a window of time, and the requests that can be made within that time frame. 
In the request you created, 5 requests can be made within a 30 second window of time. On the 6th request, 
the server will return a `429` response code. You can add multiple `window_size` and `config.limit` parameters 
to this request to specify, with granularity, the rate limiting rules.  

