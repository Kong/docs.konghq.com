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

{{site.base_gateway}} imposes rate limits on clients through the use of the [Rate Limiting plugin](/hub/kong-inc/rate-limiting/). 
When rate limiting is enabled, clients are restricted in the number of requests that can be made in a configurable period of time.
The plugin supports identifying clients as [consumers](/gateway/latest/admin-api/#consumer-object) 
or by the client IP address of the requests.

{:.note}
> This tutorial uses the [Rate Limiting](/hub/kong-inc/rate-limiting/) <span class="badge free"></span> plugin. Also available is the 
[Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced) <span class="badge enterprise"></span> 
plugin. The advanced version provides additional features like support for the sliding window algorithm
and advanced Redis support for greater performance.

## Managing rate limiting

The following tutorial walks through managing rate limiting across various aspects in {{site.base_gateway}}.

### Prerequisites

This chapter is part of the *Get Started with Kong* series. For the best experience, it is recommended that you follow the
series from the beginning. 

Start with the introduction [Get Kong](/gateway/latest/get-started/), which includes
tool prerequisites and instructions for running a local {{site.base_gateway}}.

Step two of the guide, [Services and Routes](/gateway/latest/get-started/services-and-routes/),
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
for _ in {1..6}; do curl -s -i localhost:8000/mock/anything; echo; sleep 1; done
```

{% endnavtab %}
{% navtab Web browser %}

Open [http://localhost:8000/mock/anything](http://localhost:8000/mock/anything) in your browser 
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
curl -X POST http://localhost:8001/routes/example_route/plugins \
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
      --data "consumer.username=jsmith" \
      --data "config.second=5"
   ```

## Advanced rate limiting

In high scale production scenarios, effective rate limiting may require
advanced techniques. The basic Rate Limiting plugin described above 
only allows you to define limits over fixed-time windows. Fixed-time windows
are sufficient for many cases, however, there are disadvantages:
* Bursts of requests around the boundary time of the fixed window,
may result in strained resources as the window counter is reset in the middle
of the traffic burst. 
* Multiple client applications may be waiting for the fixed-time window to reset 
so they can resume making requests. When the fixed-window resets, multiple clients
may flood the system with requests, causing a stampeding effect on your upstream services.

The [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced/) <span class="badge enterprise"></span> 
plugin is an enhanced version of the Rate Limiting plugin. The advanced plugin 
provides additional limiting algorithm capabilities and superior performance compared
to the basic plugin. For more information on advanced rate limiting algorithms, see 
[How to Design a Scalable Rate Limiting Algorithm with Kong API](https://konghq.com/blog/how-to-design-a-scalable-rate-limiting-algorithm).

