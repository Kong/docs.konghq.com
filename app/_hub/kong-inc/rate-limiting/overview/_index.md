---
nav_title: Overview
---

Rate limit how many HTTP requests can be made in a given period of seconds, minutes, hours, days, months, or years.
If the underlying service or route has no authentication layer,
the **Client IP** address is used. Otherwise, the consumer is used if an
authentication plugin has been configured.
 
The advanced version of this plugin, [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced/),
provides the ability to apply
[multiple limits in sliding or fixed windows](/hub/kong-inc/rate-limiting-advanced/#multi-limits-windows).

{:.note}
> **Note:** At least one limit (`second`, `minute`, `hour`, `day`, `month`, `year`) must be configured. 
Multiple limits can be configured.

## Headers sent to the client

When this plugin is enabled, Kong sends additional headers
to show the allowed limits, number of available requests,
and the time remaining (in seconds) until the quota is reset. Here's an example header:

```
RateLimit-Limit: 6
RateLimit-Remaining: 4
RateLimit-Reset: 47
```

The plugin also sends headers to show the time limit and the minutes still available:

```
X-RateLimit-Limit-Minute: 10
X-RateLimit-Remaining-Minute: 9
```

If more than one time limit is set, the header contains all of these:

```
X-RateLimit-Limit-Second: 5
X-RateLimit-Remaining-Second: 4
X-RateLimit-Limit-Minute: 10
X-RateLimit-Remaining-Minute: 9
```

When a limit is reached, the plugin returns an `HTTP/1.1 429` status code, with the following JSON body:

```json
{ "message": "API rate limit exceeded" }
```

{:.important}
> The headers `RateLimit-Limit`, `RateLimit-Remaining`, and `RateLimit-Reset` are based on the Internet-Draft [RateLimit Header Fields for HTTP](https://datatracker.ietf.org/doc/draft-ietf-httpapi-ratelimit-headers/) and may change in the future to respect specification updates.

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
| `redis`   | Accurate<sup>1</sup>, less performance impact than a `cluster` policy. | Needs a Redis installation. Bigger performance impact than a `local` policy. |

{:.note .no-icon}
> **\[1\]**: Only when `sync_rate` option is set to `-1` (synchronous behavior). When using Redis, it's possible to set the sync rate to a positive value, which can lead to some inaccuracies. See the [configuration reference](/hub/kong-inc/rate-limiting/configuration/#config-sync_rate) for more details.

Two common use cases are:

1. _Every transaction counts_. The highest level of accuracy is needed. An example is a transaction with financial
   consequences.
2. _Backend protection_. Accuracy is not as relevant. The requirement is
   only to protect backend services from overloading that's caused either by specific
   users or by attacks.

{:.warning}
> **Note**: **Enterprise-Only**: The Kong Community Edition of this Rate Limiting plugin does not
include [Redis Cluster](https://redis.io/docs/management/scaling/) or [Redis Sentinel](https://redis.io/topics/sentinel) support. Only [{{site.ee_product_name}}](https://www.konghq.com/kong) customers can use Redis Cluster or Redis Sentinel with Kong Rate Limiting, enabling them to deliver highly performant and available primary-replica deployments.

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

#### Fallback to IP

When the selected policy cannot be retrieved, the plugin falls back
to limiting usage by identifying the IP address. This can happen for several reasons, such as the
selected header was not sent by the client or the configured service was not found.

---

