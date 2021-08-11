---

name: Rate Limiting Advanced
publisher: Kong Inc.
version: 2.3.x
# internal plugin version 1.3.8

desc: Upgrades Kong Rate Limiting with more flexibility and higher performance
description: |
  The Rate Limiting Advanced plugin for Konnect Enterprise is a re-engineered version of the Kong Gateway (OSS) [Rate Limiting plugin](/hub/kong-inc/rate-limiting/).

  As compared to the standard Rate Limiting plugin, Rate Limiting Advanced provides:
  * Additional configurations: `limit`, `window_size`, and `sync_rate`
  * Support for Redis Sentinel, Redis cluster, and Redis SSL
  * Increased performance: Rate Limiting Advanced has better throughput performance with better accuracy. Configure `sync_rate` to periodically sync with backend storage.
  * More limiting algorithms to choose from: These algorithms are more accurate and they enable configuration with more specificity. Learn more about our algorithms in [How to Design a Scalable Rate Limiting Algorithm](https://konghq.com/blog/how-to-design-a-scalable-rate-limiting-algorithm/).

type: plugin
enterprise: true
categories:
  - traffic-control

kong_version_compatibility:
    community_edition:
      compatible:
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
  name: rate-limiting-advanced
  service_id: true
  route_id: true
  consumer_id: true
  protocols: ["http", "https", "grpc", "grpcs"]
  dbless_compatible: partially
  dbless_explanation: |
   The cluster strategy is not supported in DB-less and hybrid modes. For Kong
   Gateway in DB-less or hybrid mode, use the `redis` strategy.
  config:
    - name: limit
      required: true
      default:
      value_in_examples: [ "5" ]
      datatype: array of number elements
      description: |
        One or more requests-per-window limits to apply. There must be a matching
        number of window limits and sizes specified.
    - name: window_size
      required: true
      default:
      value_in_examples: [ "30" ]
      datatype: array of number elements
      description: |
        One or more window sizes to apply a limit to (defined in seconds). There
        must be a matching number of window limits and sizes specified.
    - name: identifier
      required: true
      default: consumer
      value_in_examples: consumer
      datatype: string
      description: |
        How to define the rate limit key. Can be `ip`, `credential`, `consumer`, `service`, or `header`.
    - name: header_name
      required: semi
      datatype: string
      description: |
        Header name to use as the rate limit key when the `header` identifier is defined.
    - name: dictionary_name
      required: true
      default: kong_rate_limiting_counters
      value_in_examples:
      datatype: string
      description: |
        The shared dictionary where counters will be stored until the next sync cycle.
    - name: sync_rate
      required: true
      default:
      value_in_examples: -1
      datatype: number
      description: |
        How often to sync counter data to the central data store. A value of 0
        results in synchronous behavior; a value of -1 ignores sync behavior
        entirely and only stores counters in node memory. A value greater than
        0 will sync the counters in the specified number of seconds.
    - name: namespace
      required: true
      default: random_auto_generated_string
      value_in_examples:
      datatype: string
      description: |
        The rate limiting library namespace to use for this plugin instance. Counter
        data and sync configuration is shared in a namespace.
    - name: strategy
      required: true
      default: cluster
      value_in_examples: cluster
      datatype: string
      description: |
        The rate-limiting strategy to use for retrieving and incrementing the
        limits. Available values are:
        - `cluster`: Counters are stored in the Kong datastore and shared across
         the nodes.
        - `redis`: Counters are stored on a Redis server and shared
        across the nodes.

        In DB-less and hybrid modes, the `cluster` config strategy is not
        supported.

        In Konnect Cloud, the default strategy is `redis`.

        {:.important}
        > There is no local storage strategy. However, you can achieve local
        rate limiting by using a placeholder `strategy` value (either `cluster` or `redis`)
        and a `sync_rate` of `-1`. This setting stores counters in-memory on the
        node.
        <br><br>If using `redis` as the placeholder value, you must fill in all
        additional `redis` configuration parameters with placeholder values.

        For details on which strategy should be used, refer to the
        [implementation considerations](/hub/kong-inc/rate-limiting/#implementation-considerations).
    - name: hide_client_headers
      required: false
      default: false
      value_in_examples: false
      datatype: boolean
      description: |
        Optionally hide informative response headers. Available options: `true` or `false`.
    - name: redis.host
      required: semi
      default:
      value_in_examples:
      datatype: string
      description: |
        Host to use for Redis connection when the `redis` strategy is defined.
    - name: redis.port
      required: semi
      default: 6379
      value_in_examples:
      datatype: integer
      description: |
        Specifies the Redis server port when using the `redis` strategy. Must be a
        value between 0 and 65535. Default: 6379.
    - name: redis.ssl
      required: false
      default: false
      value_in_examples:
      datatype: boolean
      description: |
        If set to true, then uses SSL to connect to Redis.

        **Note:** This parameter is only available for Kong Enterprise versions
        2.2.x and later.
    - name: redis.ssl_verify
      required: false
      default: false
      value_in_examples:
      datatype: boolean
      description: |
        If set to true, then verifies the validity of the server SSL certificate. Note that you need to configure the
        [lua_ssl_trusted_certificate](/enterprise/latest/property-reference/#lua_ssl_trusted_certificate)
        to specify the CA (or server) certificate used by your redis server. You may also need to configure
        [lua_ssl_verify_depth](/enterprise/latest/property-reference/#lua_ssl_verify_depth) accordingly.

        **Note:** This parameter is only available for Kong Enterprise versions
        2.2.x and later.
    - name: redis.server_name
      required: false
      default:
      value_in_examples:
      datatype: string
      description: |
        Specifies the server name for the new TLS extension Server Name Indication (SNI) when connecting over SSL.

        **Note:** This parameter is only available for Kong Enterprise versions
        2.2.x and later.
    - name: redis.timeout
      required: semi
      default: 2000
      value_in_examples:
      datatype: number
      description: |
        Connection timeout (in milliseconds) to use for Redis connection when the `redis` strategy is defined.
        This field is deprecated and replaced with `redis.connect_timeout`, `redis.send_timeout`, and `redis.read_timeout`.
        The `redis.timeout` field will continue to work in a backwards compatible way, but it is recommended to use the replacement fields.
        If set to something other than the default, a deprecation warning will be logged in the log file, stating the field's deprecation
        and planned removal in v3.x.x.
    - name: redis.connect_timeout
      required: semi
      default: 2000
      datatype: number
      description: |
        Connection timeout to use for Redis connection when the `redis` strategy is defined.
    - name: redis.send_timeout
      required: semi
      default: 2000
      datatype: number
      description: |
        Send timeout to use for Redis connection when the `redis` strategy is defined.
    - name: redis.read_timeout
      required: semi
      default: 2000
      datatype: number
      description: |
        Read timeout to use for Redis connection when the `redis` strategy is defined.
    - name: redis.password
      required: semi
      default:
      value_in_examples:
      datatype: string
      description: |
        Password to use for Redis connection when the `redis` strategy is defined. If undefined, no AUTH commands are sent to Redis.
    - name: redis.database
      required: semi
      default: 0
      value_in_examples:
      datatype: integer
      description: |
        Database to use for Redis connection when the `redis` strategy is defined.
    - name: redis.sentinel_master
      required: semi
      default:
      value_in_examples:
      datatype: string
      description: |
        Sentinel master to use for Redis connections when the `redis` strategy is defined.
        Defining this value implies using Redis Sentinel.
    - name: redis.sentinel_password
      required: semi
      default:
      value_in_examples:
      datatype: string
      description: |
            Sentinel password to authenticate with a Redis Sentinel instance. If undefined, no AUTH commands are sent to Redis Sentinels.
            **Note:** This parameter is only available for Kong Enterprise versions
            1.3.0.2 and later.
    - name: redis.sentinel_role
      required: semi
      default:
      value_in_examples:
      datatype: string
      description: |
        Sentinel role to use for Redis connections when the `redis` strategy is defined.
        Defining this value implies using Redis Sentinel. Available options:  `master`, `slave`, `any`.
    - name: redis.sentinel_addresses
      required: semi
      default:
      value_in_examples:
      datatype: array of string elements
      description: |
        Sentinel addresses to use for Redis connections when the `redis` strategy is defined.
        Defining this value implies using Redis Sentinel. Each string element must
        be a hostname. The minimum length of the array is 1 element.
    - name: redis.cluster_addresses
      required: semi
      default:
      value_in_examples:
      datatype: array of string elements
      description: |
        Cluster addresses to use for Redis connections when the `redis` strategy is defined.
        Defining this value implies using Redis cluster. Each string element must
        be a hostname. The minimum length of the array is 1 element.
    - name: window_type
      required: true
      default: sliding
      value_in_examples:
      datatype: string
      description: |
        Sets the time window type to either `sliding` (default) or `fixed`.
    - name: retry_after_jitter_max
      required: true
      default: 0
      value_in_examples:
      datatype: number
      description: |
        The upper bound of a jitter (random delay) in seconds to be added to the `Retry-After`
        header of denied requests (status = `429`) in order to prevent all the clients
        from coming back at the same time. The lower bound of the jitter is `0`; in this case,
        the `Retry-After` header is equal to the `RateLimit-Reset` header.
  extra: |
    **Notes:**

     * The plugin does not support the `cluster` strategy in
       [hybrid mode](/enterprise/latest/deployment/hybrid-mode/).
       The `redis` strategy must be used instead.

     * Redis configuration values are ignored if the `cluster` strategy is used.

     * PostgreSQL 9.5+ is required when using the `cluster` strategy with `postgres` as the backing Kong cluster data store.

     * The `dictionary_name` directive was added to prevent the usage of the `kong` shared dictionary,
       which could lead to `no memory` errors.

---

### Headers sent to the client

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


### Multiple Limits and Window Sizes {#multi-limits-windows}

An arbitrary number of limits/window sizes can be applied per plugin instance. This allows you to create
multiple rate limiting windows (e.g., rate limit per minute and per hour, and per any arbitrary window size).
Because of limitations with Kong's plugin configuration interface, each *nth* limit will apply to each *nth* window size.
For example:

<pre><code>curl -X POST http://kong:8001/services/<div contenteditable="true">{SERVICE}</div>/plugins \
  --data name=rate-limiting-advanced \
  --data config.limit=10 \
  --data config.limit=100 \
  --data config.window_size=60 \
  --data config.window_size=3600 \
  --data config.sync_rate=10</code></pre>

This example applies rate limiting policies, one of which will trip when 10 hits have been counted in 60 seconds,
or the other when 100 hits have been counted in 3600 seconds. For more information, see the
[Enterprise Rate Limiting Library](/enterprise/latest/rate-limiting/).

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
