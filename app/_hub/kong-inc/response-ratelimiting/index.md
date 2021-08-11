---
name: Response Rate Limiting
publisher: Kong Inc.
version: 1.0.0

desc: Rate-limiting based on a custom response header value
description: |
  This plugin allows you to limit the number of requests a developer can make
  based on a custom response header returned by the upstream service. You can
  arbitrarily set as many rate-limiting objects (or quotas) as you want and
  instruct Kong to increase or decrease them by any number of units. Each custom
  rate-limiting object can limit the inbound requests per seconds, minutes, hours,
  days, months, or years.

  If the underlying Service/Route has no authentication
  layer, the **Client IP** address will be used; otherwise, the Consumer will be
  used if an authentication plugin has been configured.


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
        - 1.5.x
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
  name: response-ratelimiting
  api_id: false
  service_id: true
  route_id: true
  consumer_id: true
  protocols: ["http", "https"]
  dbless_compatible: partially
  dbless_explanation: |
    The plugin will run fine with the `local` policy (which doesn't use the database) or
    the `redis` policy (which uses an independent Redis, so it is compatible with DB-less).

    The plugin will not work with the `cluster` policy, which requires writes to the database.

  config:
    - name: limits.{limit_name}
      required: true
      value_in_examples: <SMS>
      datatype: string
      description: This is a list of custom objects that you can set, with arbitrary names set in the `{limit_name`} placeholder, like `config.limits.sms.minute=20` if your object is called "SMS".
    - name: limits.{limit_name}.second
      required: semi
      datatype: number
      description: The amount of HTTP requests the developer can make per second. At least one limit must exist.
    - name: limits.{limit_name}.minute
      required: semi
      value_in_examples: 10
      datatype: number
      description: The amount of HTTP requests the developer can make per minute. At least one limit must exist.
    - name: limits.{limit_name}.hour
      required: semi
      datatype: number
      description: The amount of HTTP requests the developer can make per hour. At least one limit must exist.
    - name: limits.{limit_name}.day
      required: semi
      datatype: number
      description: The amount of HTTP requests the developer can make per day. At least one limit must exist.
    - name: limits.{limit_name}.month
      required: semi
      datatype: number
      description: The amount of HTTP requests the developer can make per month. At least one limit must exist.
    - name: limits.{limit_name}.year
      required: semi
      datatype: number
      description: The amount of HTTP requests the developer can make per year. At least one limit must exist.
    - name: header_name
      required: false
      default: "`X-Kong-Limit`"
      datatype: string
      description: The name of the response header used to increment the counters.
    - name: block_on_first_violation
      required: true
      default: "`false`"
      datatype: boolean
      description: A boolean value that determines if the requests should be blocked as soon as one limit is being exceeded. This will block requests that are supposed to consume other limits too.
    - name: limit_by
      required: false
      default: "`consumer`"
      datatype: string
      description: "The entity that will be used when aggregating the limits: `consumer`, `credential`, `ip`. If the `consumer` or the `credential` cannot be determined, the system will always fallback to `ip`."
    - name: policy
      required: false
      default: "`cluster`"
      value_in_examples: local
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
        [implementation considerations](/hub/kong-inc/rate-limiting/#implementation-considerations).

    - name: fault_tolerant
      required: true
      default: "`true`"
      datatype: boolean
      description: A boolean value that determines if the requests should be proxied even if Kong has troubles connecting a third-party datastore. If `true`, requests will be proxied anyway, effectively disabling the rate-limiting function until the datastore is working again. If `false`, then the clients will see `500` errors.
    - name: hide_client_headers
      required: true
      default: "`false`"
      datatype: boolean
      description: Optionally hide informative response headers.
    - name: redis_host
      required: semi
      datatype: string
      description: When using the `redis` policy, this property specifies the address to the Redis server.
    - name: redis_port
      required: false
      default: "`6379`"
      datatype: integer
      description: When using the `redis` policy, this property specifies the port of the Redis server.
    - name: redis_password
      required: false
      datatype: string
      description: When using the `redis` policy, this property specifies the password to connect to the Redis server.
    - name: redis_timeout
      required: false
      default: "`2000`"
      datatype: number
      description: When using the `redis` policy, this property specifies the timeout in milliseconds of any command submitted to the Redis server.
    - name: redis_database
      required: false
      default: "`0`"
      datatype: number
      description: When using the `redis` policy, this property specifies Redis database to use.

---

## Configuring Quotas

After adding the plugin, you can increment the configured limits by adding the following response header:

```
Header-Name: Limit=Value [,Limit=Value]
```

Because `X-Kong-Limit` is the default header name (you can optionally change it),
the request looks like:

```bash
$ curl -v -H 'X-Kong-Limit: limitname1=2, limitname2=4'
```

The above example increments the limit `limitname1` by 2 units, and `limitname2` by 4 units.

You can optionally increment more than one limit with comma-separated entries.
The header is removed before returning the response to the original client.

----

## Headers sent to the client

When the plugin is enabled, Kong sends some additional headers back to the
client telling how many units are available and how many are allowed.

For example, if you created a limit/quota called "Videos" with a per-minute limit:

```
X-RateLimit-Limit-Videos-Minute: 10
X-RateLimit-Remaining-Videos-Minute: 9
```

If more than one limit value is being set, it returns a combination of more time limits:

```
X-RateLimit-Limit-Videos-Second: 5
X-RateLimit-Remaining-Videos-Second: 5
X-RateLimit-Limit-Videos-Minute: 10
X-RateLimit-Remaining-Videos-Minute: 10
```

If any of the limits configured is being reached, the plugin
returns an `HTTP/1.1 429` (Too Many Requests) status code and an empty response body.

### Upstream Headers

The plugin appends the usage headers for each limit before proxying it to the
upstream service, so that you can properly refuse to process the request if there
are no more limits remaining. The headers are in the form of
`X-RateLimit-Remaining-{limit_name}`, for example:

```
X-RateLimit-Remaining-Videos: 3
X-RateLimit-Remaining-Images: 0
```

[api-object]: /gateway-oss/latest/admin-api/#api-object
[configuration]: /gateway-oss/latest/configuration
[consumer-object]: /gateway-oss/latest/admin-api/#consumer-object

