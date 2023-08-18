Rate limit how many HTTP requests can be made in a given time frame.

The Rate Limiting Advanced plugin offers more functionality than the Kong Gateway (OSS) [Rate Limiting plugin](/hub/kong-inc/rate-limiting/), such as:
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
> The headers `RateLimit-Limit`, `RateLimit-Remaining`, and `RateLimit-Reset` are based on the Internet-Draft [RateLimit Header Fields for HTTP](https://tools.ietf.org/html/draft-polli-ratelimit-headers-02) and may change in the future to respect specification updates.

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

### Fallback to IP

When the selected strategy cannot be retrieved, the `rate-limiting-advanced` plugin will fall back
to limit using IP as the identifier. This can happen for several reasons, such as the
selected header was not sent by the client or the configured service was not found.

[`Retry-After`]: https://tools.ietf.org/html/rfc7231#section-7.1.3

### Fallback from Redis

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
