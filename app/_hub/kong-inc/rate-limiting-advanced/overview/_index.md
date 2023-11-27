---
nav_title: Overview
---

Rate limit how many HTTP requests can be made in a given time frame.

The Rate Limiting Advanced plugin offers more functionality than the {{site.base_gateway}} (OSS) [Rate Limiting plugin](/hub/kong-inc/rate-limiting/), such as:
* Enhanced capabilities to tune the rate limiter, provided by the parameters `limit` and `window_size`. Learn more in [Multiple Limits and Window Sizes](#multi-limits-windows)
* Support for Redis Sentinel, Redis cluster, and Redis SSL
* Increased performance: Rate Limiting Advanced has better throughput performance with better accuracy. The plugin allows you to tune performance and accuracy via a configurable synchronization of counter data with the backend storage. This can be controlled by setting the desired value on the `sync_rate` parameter.
* More limiting algorithms to choose from: These algorithms are more accurate and they enable configuration with more specificity. Learn more about our algorithms in [How to Design a Scalable Rate Limiting Algorithm](https://konghq.com/blog/how-to-design-a-scalable-rate-limiting-algorithm).
* More control over which requests contribute to incrementing the rate limiting counters via the `disable_penalty` parameter
{% if_plugin_version gte:3.4.x %}
* Consumer groups support: Apply different rate limiting configurations to select groups of consumers. Learn more in [Rate limiting for consumer groups](/hub/kong-inc/rate-limiting-advanced/how-to/)
{% endif_plugin_version %}


## Headers sent to the client

When this plugin is enabled, Kong sends some additional headers back to the client
indicating the allowed limits, how many requests are available, and how long it will take
until the quota will be restored.

For example:

```plaintext
RateLimit-Limit: 6
RateLimit-Remaining: 4
RateLimit-Reset: 47
```

The plugin also sends headers indicating the limits in the time frame and the number
of remaining minutes:

```plaintext
X-RateLimit-Limit-Minute: 10
X-RateLimit-Remaining-Minute: 9
```

You can optionally hide the limit and remaining headers with the `hide_client_headers` option.

If more than one limit is being set, the plugin returns a combination of more time limits:

```plaintext
X-RateLimit-Limit-Second: 5
X-RateLimit-Remaining-Second: 4
X-RateLimit-Limit-Minute: 10
X-RateLimit-Remaining-Minute: 9
```

If any of the limits configured has been reached, the plugin returns an `HTTP/1.1 429` status
code to the client with the following JSON body:

```plaintext
{ "message": "API rate limit exceeded" }
```

The [`Retry-After`] header will be present on `429` errors to indicate how long the service is
expected to be unavailable to the client. When using `window_type=sliding` and `RateLimit-Reset`, `Retry-After`
may increase due to the rate calculation for the sliding window.

{:.important}
> The headers `RateLimit-Limit`, `RateLimit-Remaining`, and `RateLimit-Reset` are based on the Internet-Draft [RateLimit Header Fields for HTTP](https://datatracker.ietf.org/doc/draft-ietf-httpapi-ratelimit-headers) and may change in the future to respect specification updates.

## Multiple limits and window sizes {#multi-limits-windows}

An arbitrary number of limits/window sizes can be applied per plugin instance. This allows you to create
multiple rate limiting windows (e.g., rate limit per minute and per hour, and per any arbitrary window size).
Because of limitations with Kong's plugin configuration interface, each *nth* limit will apply to each *nth* window size.
For example:

```sh
curl -X POST http://localhost:8001/services/example-service/plugins \
  --data "name=rate-limiting-advanced" \
  --data "config.limit=10" \
  --data "config.limit=100" \
  --data "config.window_size=60" \
  --data "config.window_size=3600"
```

This example applies rate limiting policies, one of which will trip when 10 hits have been counted in 60 seconds,
or the other when 100 hits have been counted in 3600 seconds. For more information, see the
[Enterprise Rate Limiting Library](/gateway/latest/reference/rate-limiting/).

The number of configured window sizes and limits parameters must be equal (as shown above);
otherwise, an error occurs:

```plaintext
You must provide the same number of windows and limits
```

## Implementation considerations

### Limit by IP Address

If limiting by IP address, it's important to understand how the IP address is determined. The IP address is determined by the request header sent to Kong from downstream. In most cases, the header has a name of `X-Real-IP` or `X-Forwarded-For`. 

By default, Kong uses the header name `X-Real-IP`. If a different header name is required, it needs to be defined using the [real_ip_header](/gateway/latest/reference/configuration/#real_ip_header) Nginx property. Depending on the environmental network setup, the [trusted_ips](/gateway/latest/reference/configuration/#trusted_ips) Nginx property may also need to be configured to include the load balancer IP address.

### Strategies

The plugin supports three strategies.

| Strategy    | Pros | Cons   |
| --------- | ---- | ------ |
| `local`   | Minimal performance impact. | Less accurate. Unless there's a consistent-hashing load balancer in front of Kong, it diverges when scaling the number of nodes.
| `cluster` | Accurate, no extra components to support. | Each request forces a read and a write on the data store. Therefore, relatively, the biggest performance impact. |
| `redis`   | Accurate, less performance impact than a `cluster` policy. | Needs a Redis installation. Bigger performance impact than a `local` policy. |

Two common use cases are:

1. _Every transaction counts_. The highest level of accuracy is needed. An example is a transaction with financial
   consequences.
2. _Backend protection_. Accuracy is not as relevant. The requirement is
   only to protect backend services from overloading that's caused either by specific
   users or by attacks.

#### Every transaction counts

In this scenario, because accuracy is important, the `local` policy is not an option. Consider the support effort you might need
for Redis, and then choose either `cluster` or `redis`.

You could start with the `cluster` policy, and move to `redis`
if performance reduces drastically.

Do remember that you cannot port the existing usage metrics from the data store to Redis.
This might not be a problem with short-lived metrics (for example, seconds or minutes)
but if you use metrics with a longer time frame (for example, months), plan
your switch carefully.

#### Backend protection

If accuracy is of lesser importance, choose the `local` policy. You might need to experiment a little
before you get a setting that works for your scenario. As the cluster scales to more nodes, more user requests are handled.
When the cluster scales down, the probability of false negatives increases. So, adjust your limits when scaling.

For example, if a user can make 100 requests every second, and you have an
equally balanced 5-node Kong cluster, setting the `local` limit to something like 30 requests every second
should work. If you see too many false negatives, increase the limit.

To minimize inaccuracies, consider using a consistent-hashing load balancer in front of
Kong. The load balancer ensures that a user is always directed to the same Kong node, thus reducing
inaccuracies and preventing scaling problems.

#### Fallback from Redis

When the `redis` strategy is used and a {{site.base_gateway}} node is disconnected from Redis, the `rate-limiting-advanced` plugin will fall back to `local`. This can happen when the Redis server is down or the connection to Redis broken.
{{site.base_gateway}} keeps the local counters for rate limiting and syncs with Redis once the connection is re-established.
{{site.base_gateway}} will still rate limit, but the {{site.base_gateway}} nodes can't sync the counters. As a result, users will be able
to perform more requests than the limit, but there will still be a limit per node.

{% if_plugin_version gte:3.4.x%}
## Rate limiting for consumer groups

As of {{site.base_gateway}} 3.4, you can use the [consumer groups entity](https://developer.konghq.com/spec/937dcdd7-4485-47dc-af5f-b805d562552f/25d728a0-cfe3-4cf4-8e90-93a5bb15cfd9#/default/post-consumer_groups) to manage custom rate limiting configurations for
subsets of consumers. This is enabled by default **without** using the `/consumer_groups/:id/overrides` endpoint.


You can see an example of this in the [Enforcing rate limiting tiers with the Rate Limiting Advanced plugin](/hub/kong-inc/rate-limiting-advanced/how-to/) guide.

{% endif_plugin_version %}

{% if_plugin_version gte:2.7.x lte:3.3.x %}
## Rate limiting for consumer groups

You can use consumer groups to manage custom rate limiting configuration for
subsets of consumers. To use consumer groups, you'll need to configure the following parameters:

* `config.enforce_consumer_groups`: Set to true.
* `config.consumer_groups`: Provide a list of consumer groups that this plugin allows overrides for.

For guides on working with consumer groups, see the consumer group
[examples](/gateway/latest/admin-api/consumer-groups/examples) and
[API reference](/gateway/latest/admin-api/consumer-groups/reference) in
the Admin API documentation.

{% endif_plugin_version %}
