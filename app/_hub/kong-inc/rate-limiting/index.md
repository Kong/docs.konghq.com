---
name: Rate Limiting
publisher: Kong Inc.
redirect_from:
  - /enterprise/0.35-x/rate-limiting/
version: 2.2.x

desc: Rate-limit how many HTTP requests can be made in a period of time
description: |
  Rate limit how many HTTP requests can be made in a given period of seconds, minutes, hours, days, months, or years.
  If the underlying Service/Route (or deprecated API entity) has no authentication layer,
  the **Client IP** address will be used; otherwise, the Consumer will be used if an
  authentication plugin has been configured.

  **Tip:** The [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced/)
    plugin provides the ability to apply
    [multiple limits in sliding or fixed windows](/hub/kong-inc/rate-limiting-advanced/#multi-limits-windows).

type: plugin
categories:
  - traffic-control

kong_version_compatibility:
  community_edition:
    compatible:
      - 2.4.x
      - 2.3.x
      - 2.2.x
      - 2.1.x
      - 2.0.x
      - 1.4.x
      - 1.3.x
      - 1.2.x
      - 1.1.x
      - 1.0.x
      - 0.14.x
      - 0.13.x
      - 0.12.x
      - 0.11.x
      - 0.10.x
      - 0.9.x
      - 0.8.x
      - 0.7.x
      - 0.6.x
      - 0.5.x
      - 0.4.x
      - 0.3.x
      - 0.2.x
  enterprise_edition:
    compatible:
      - 2.4.x
      - 2.3.x
      - 2.2.x
      - 2.1.x
      - 1.5.x
      - 1.3-x
      - 0.36-x

params:
  name: rate-limiting
  service_id: true
  route_id: true
  consumer_id: true
  protocols: ['http', 'https']
  dbless_compatible: partially
  dbless_explanation: |
    The plugin will run fine with the `local` policy (which doesn't use the database) or
    the `redis` policy (which uses an independent Redis, so it is compatible with DB-less).

    The plugin will not work with the `cluster` policy, which requires writes to the database.

  config:
    - name: second
      required: semi
      value_in_examples: 5
      datatype: number
      description: The number of HTTP requests that can be made per second.
    - name: minute
      required: semi
      datatype: number
      description: The number of HTTP requests that can be made per minute.
    - name: hour
      required: semi
      value_in_examples: 10000
      datatype: number
      description: The number of HTTP requests that can be made per hour.
    - name: day
      required: semi
      datatype: number
      description: The number of HTTP requests that can be made per day.
    - name: month
      required: semi
      datatype: number
      description: The number of HTTP requests that can be made per month.
    - name: year
      required: semi
      datatype: number
      description: The number of HTTP requests that can be made per year.
    - name: limit_by
      required: false
      default: '`consumer`'
      datatype: string
      description: |
        The entity that will be used when aggregating the limits: `consumer`, `credential`, `ip`, `service`, `header`, `path`. If the value for the entity chosen to aggregate the limit cannot be determined, the system will always fallback to `ip`. If value `service` is chosen, the `service_id` configuration must be provided. If value `header` is chosen, the `header_name` configuration must be provided. If value `path` is chosen, the `path` configuration must be provided.
    - name: service_id
      required: semi
      datatype: string
      description: The service id to be used if `limit_by` is set to `service`.
    - name: header_name
      required: semi
      datatype: string
      description: Header name to be used if `limit_by` is set to `header`.
    - name: path
      required: semi
      datatype: string
      description: Path to be used if `limit_by` is set to `path`.
    - name: policy
      required: false
      value_in_examples: "local"
      default: '`cluster`'
      datatype: string
      description: |
        The rate-limiting policies to use for retrieving and incrementing the
        limits. Available values are:
        - `local`: Counters are stored locally in-memory on the node.
        - `cluster`: Counters are stored in the Kong datastore and shared across
        the nodes.
        - `redis`: Counters are stored on a Redis server and shared
        across the nodes.

        In DB-less and hybrid modes, the `cluster` config policy is not supported.
        For DB-less mode, use one of `redis` or `local`; for hybrid mode, use
        `redis`, or `local` for data planes only.

        In Konnect Cloud, the default policy is `redis`.

        For details on which policy should be used, refer to the
        [implementation considerations](#implementation-considerations).
    - name: fault_tolerant
      required: false
      default: '`true`'
      datatype: boolean
      description: |
        A boolean value that determines if the requests should be proxied even if Kong has troubles connecting a third-party datastore. If `true`, requests will be proxied anyway, effectively disabling the rate-limiting function until the datastore is working again. If `false`, then the clients will see `500` errors.
    - name: hide_client_headers
      required: false
      default: '`false`'
      datatype: boolean
      description: Optionally hide informative response headers.
    - name: redis_host
      required: semi
      datatype: string
      description: |
        When using the `redis` policy, this property specifies the address to the Redis server.
    - name: redis_port
      required: false
      default: '`6379`'
      datatype: integer
      description: |
        When using the `redis` policy, this property specifies the port of the Redis server. By default is `6379`.
    - name: redis_password
      required: false
      datatype: string
      description: |
        When using the `redis` policy, this property specifies the password to connect to the Redis server.
    - name: redis_timeout
      required: false
      default: '`2000`'
      datatype: number
      description: |
        When using the `redis` policy, this property specifies the timeout in milliseconds of any command submitted to the Redis server.
    - name: redis_database
      required: false
      default: '`0`'
      datatype: integer
      description: |
        When using the `redis` policy, this property specifies the Redis database to use.
  extra:
    <div class="alert alert-warning">
        <strong>Note:</strong> At least one limit (`second`, `minute`, `hour`, `day`, `month`, `year`) must be configured. Multiple limits can be configured.
    </div>

---

## Headers sent to the client

When this plugin is enabled, Kong sends some additional headers back to the client
indicating the allowed limits, how many requests remain available,
and the time remaining until the quota is reset (number of seconds). For example:

```
RateLimit-Limit: 6
RateLimit-Remaining: 4
RateLimit-Reset: 47
```

The plugin also sends headers that indicate the limits in the time frame and the number of minutes remaining:

```
X-RateLimit-Limit-Minute: 10
X-RateLimit-Remaining-Minute: 9
```

Or, it returns a combination of more time limits, if more than one is being set:

```
X-RateLimit-Limit-Second: 5
X-RateLimit-Remaining-Second: 4
X-RateLimit-Limit-Minute: 10
X-RateLimit-Remaining-Minute: 9
```

If any of the limits configured is being reached, the plugin returns a `HTTP/1.1 429` status code to the client with the following JSON body:

```json
{ "message": "API rate limit exceeded" }
```

**NOTE**:

<div class="alert alert-warning">
The headers `RateLimit-Limit`, `RateLimit-Remaining` and `RateLimit-Reset` are based on the Internet-Draft <a href="https://tools.ietf.org/html/draft-polli-ratelimit-headers-01">RateLimit Header Fields for HTTP</a> and may change in the future, respecting updates to the specification.
</div>

## Implementation considerations

The plugin supports three policies, which each have their specific pros and cons.

| policy    | pros                                                        | cons                                                                                                                                |
| --------- | ----------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| `cluster` | accurate, no extra components to support                    | relatively the biggest performance impact, each request forces a read and a write on the underlying datastore.                      |
| `redis`   | accurate, lesser performance impact than a `cluster` policy | extra redis installation required, bigger performance impact than a `local` policy                                                  |
| `local`   | minimal performance impact                                  | less accurate, and unless a consistent-hashing load balancer is used in front of Kong, it diverges when scaling the number of nodes |

There are two use cases that are most common:

1. _every transaction counts_. These are for example transactions with financial
   consequences. Here the highest level of accuracy is required.
2. _backend protection_. This is where accuracy is not as relevant, but it is
   merely used to protect backend services from overload. Either by specific
   users, or to protect against an attack in general.

**NOTE**:

<div class="alert alert-warning">
  <strong>Enterprise-Only</strong> The Kong Community Edition of this Rate Limiting plugin does not
include <a href="https://redis.io/topics/sentinel">Redis Sentinel</a> support.
<a href="https://www.konghq.com/enterprise/">Kong Enterprise Subscription</a> customers have the option
of using Redis Sentinel with Kong Rate Limiting to deliver highly available primary-replica deployments.
</div>

### Every transaction counts

In this scenario, the `local` policy is not an option. So here the decision is between
the extra performance of the `redis` policy against its extra support effort. Based on that balance,
the choice should either be `cluster` or `redis`.

The recommendation is to start with the `cluster` policy, with the option to move over to `redis`
if performance reduces drastically. Keep in mind existing usage metrics cannot
be ported from the datastore to redis. Generally with shortlived metrics (per second or per minute)
this is not an issue, but with longer lived ones (months) it might be, so you might want to plan
your switch more carefully.

### Backend protection

If accuracy is of lesser importance, the `local` policy can be used. It might require some experimenting
to get the proper setting. For example, if the user is bound to 100 requests per second, and you have an
equally balanced 5 node Kong cluster, setting the `local` limit to something like 30 requests per second
should work. If you are worried about too many false-negatives, increase the value.

Keep in mind as the cluster scales to more nodes, the users will get more requests granted, and likewise
when the cluster scales down the probability of false-negatives increases. So in general, update your
limits when scaling.

The above-mentioned inaccuracy can be mitigated by using a consistent-hashing load balancer in front of
Kong, which ensures the same user is always directed to the same Kong node. This will both reduce the
inaccuracy and prevent the scaling issues.

Most likely the user will be granted more than was agreed when using the `local` policy, but it will
effectively block any attacks while maintaining the best performance.

### Fallback to IP

When the selected policy cannot be retrieved, the rate-limiting plugin will fallback
to limit using IP as the identifier. This can happen for several reasons, such as the
selected header was not sent by the client or the configured service was not found.

[api-object]: /gateway-oss/latest/admin-api/#api-object
[configuration]: /gateway-oss/latest/configuration
[consumer-object]: /gateway-oss/latest/admin-api/#consumer-object

