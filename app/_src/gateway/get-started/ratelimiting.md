---
title: Configure Rate Limiting
content-type: tutorial
---


## What is rate limiting?

Rate limiting is used to control the rate of requests sent to an upstream service. It can be used to prevent DoS attacks, limit web scraping, and other forms of overuse. Without rate limiting, a user may make requests as often as they like, this leads to traffic spikes and it can impact other users of your upstream services. In {{site.base_gateway}} rate limiting allows you to set parameters that limit requests to your upstream service.


## The rate limiting plugin

{{site.base_gateway}} manages rate limiting through the use of Kong's [Rate Limiting plugin](/hub/kong-inc/rate-limiting/). The rate limiting plugin has an open source and an enterprise version, with the enterprise version giving you access to features like [sliding window algorithm support](https://en.wikipedia.org/wiki/Sliding_window_protocol), and Redis support.


The rate limiting plug-ins limit how often each user can call the API. This protects them from inadvertent or malicious overuse. Without rate limiting, each user may request as often as they like, which can lead to “spikes” of requests that starve other consumers. After rate limiting is enabled, they are limited to a fixed number of requests per second. Kong offers an open source and an Enterprise version of the rate limiting plug-in, with the Enterprise version providing support for the sliding window algorithm to prevent the API from being overloaded near window boundaries, and adds Redis support for greater performance. For this guide we will use the Enterprise version of plug-in.  More details on the advanced rate limiting plug-in can be found here.


Kong's [Rate Limiting plugin](/hub/kong-inc/rate-limiting/) lets you restrict how many requests your upstream services receive from your API consumers, or how often each user can call the API.

{:.note}
> The [**Rate Limiting Advanced**](/hub/kong-inc/rate-limiting-advanced/) <span class="badge enterprise"></span> plugin provides support for the sliding window algorithm to prevent the API from being overloaded near the window boundaries, and adds Redis support for greater performance.



## Configure the Rate Limiting plugin


To activate a plugin send a `POST` request to the [plugins](/gateway/latest/admin-api/#add-plugin) object of the Admin API:

```sh
curl -i -X POST http://localhost:8001/plugins \
  --data name=rate-limiting \
  --data config.minute=5 \
  --data config.policy=local
```

This request configures the rate limiting plugin to enforce rate limiting on requests that exceed 5 per minute.

### validate rate limiting

After configuring rate limiting, you can verify that it was configured correctly and is working, by creating 6 requests within a 5 minute period.
To validate rate limiting, send a request to the API six (6) times from the CLI to confirm the requests are rate limited.
If you configured {{site.base_gateway}} with the [configure services and routes](/gateway/latest/get-started/configure-services-and-routes/) guide use the example below, otherwise substitute the existing values for your own:

{% navtabs %}
{% navtab Admin API %}

```sh
curl -i -X GET http://localhost:8000/mock/anything
```

{% endnavtab %}
{% navtab Web browser %}

Or you can follow these instructions from your web browser:

1. Enter `localhost:8000/mock` and refresh your browser six times.
    After the sixth request, you’ll receive an error message.
2. Wait at least 30 seconds and try again.
    The service will be accessible until the sixth access attempt within a 30-second window.

{% endnavtab %}
{% endnavtabs %}

After the 6th request, you should receive a 429 "API rate limit exceeded" error:
```
{
"message": "API rate limit exceeded"
}
```

Every request triggers a counter that checks against the policy that was configured in the `POST` request.
The value `config.policy = local` instructs {{site.base_gateway}} to store the policies and counters locally in memory.
The available options for `config.policy` are:

* `local` - Counters are stored locally in-memory on the node.
* `cluster` - Counters are stored in the Kong data store and shared across the nodes.
* `redis` - Counters are stored on a Redis server and shared across the nodes.


### Rate limiting by domain


The Rate Limiting plugin can be enabled and associated to three different scopes:

* Service — restricts every consumer making requests to the service.

* Route — restricts every consumer making requests to the specific route of the service.

* Consumer — restricts only that specified consumer making requests to any routes of the service, using a `consumer_id`.


### Service-level rate limiting

You can rate limit specific services in order to restrict requests to an upstream application.

```sh

curl -X POST http://localhost:8001/services/example_service/plugins \
--data "name=rate-limiting" \
--data config.minute=5 \
--data config.policy=local

```


### Route-level rate limiting

You can limit traffic to a specific route:

```sh

curl -X POST http://localhost:8001/routes/mock/plugins \
--data "name=rate-limiting" \
--data "config.minute=2" \
--data "config.hour=100"

```

If you did not follow the [configure services and routes](/gateway/latest/get-started/configure-services-and-routes/) guide, replace the `mock` value with a `route_id`.


### Consumer-level rate limiting

Consumer-level rate limiting can be used when trying to apply rate limiting rules to specific consumer. Consumers are created using the [consumer object](/gateway/latest/admin-api/#consumer-object) in the Admin API. Because you haven't created a consumer yet, to try this type of rate limiting out you will have to first create a consumer:


```sh

curl -X POST http://localhost:8001/consumers/ \
  --data username=example_consumer

```

And with the `example_consumer` variable, create another request to the `plugins` object, and pass `example_consumer` to the `consumer.id` parameter.
```sh

curl -X POST http://localhost:8001/plugins \
--data "name=rate-limiting" \
--data "consumer.id=example_consumer" \
--data "config.second=5" \
```


## The Rate Limiting Advanced plugin

Rate Limiting Advanced provides:

* Additional configurations: `limit`, `window_size`, and `sync_rate`
* Support for Redis Sentinel, Redis cluster, and Redis SSL
* Increased performance: Rate Limiting Advanced has better throughput performance with better accuracy. Configure `sync_rate` to periodically sync with backend storage.
* More limiting algorithms to choose from: These algorithms are more accurate and they enable configuration with more specificity. Learn more about our algorithms in How to Design a Scalable Rate Limiting Algorithm.
* Consumer groups support: apply different rate limiting configurations to select groups of consumers.


### Additional configuration

The configuration process for the Rate Limiting Advanced plugin is similar to configuring the Rate Limiting plugin. To configure the Rate Limiting Advanced plugin create a `POST` request like this:

```sh

curl -i -X POST http://localhost:8001/plugins \
--data name=rate-limiting-advanced \
--data config.limit=5 \
--data config.window_size=30

```

This request utilizes the `config.limit` and `config.window_size` form parameters.


* config.limit: Number of requests allows per window.
* config.window_size: Window size to track request for in seconds.
* config.sync_rate: how often to sync counter data to the central data store. 	`-1` ignores sync behavior entirely and only stores counters in node memory, `>0 ` sync the counters in that many number of seconds.


The word "window" here refers to a window of time, and the requests that can be made within that time frame. In the request you created, 5 requests can be made within a 30 second window of time. On the 6th request, the server will return a `429` response code. You can add multiple `window_size` and `config.limit` parameters to this request to specify, with granularity, the rate limiting rules.  


### Next steps

The next tutorial in this series walks you through how and why to [configure proxy caching](/gateway/latest/get-started/configure-ratelimiting/).
