---
redirect_to: /hub/kong-inc/rate-limiting-advanced


# !!!!!!!!!!!!!!!!!!!!!!!!   WARNING   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#
# FIXME This file is dead code - it is no longer being rendered or utilized,
# and updates to this file will have no effect.
#
# The remaining contents of this file (below) will be deleted soon.
#
# Updates to the content below should instead be made to the file(s) in /app/_hub/
#
# !!!!!!!!!!!!!!!!!!!!!!!!   WARNING   !!!!!!!!!!!!!!!!!!!!!!!!!!!!!


title: Rate Limiting Advanced Plugin
---
# Rate Limiting Advanced Plugin
## Configuration

Method 1: apply it on top of an API by executing the following request on your Kong server:

```
$ curl -i -X POST http://kong:8001/apis/{api}/plugins \
  --data name=rate-limiting-advanced \
  --data config.limit=10 \
  --data config.sync_rate=10 \
  --data config.window_size=60
```

Method 2: apply it globally (on all APIs) by executing the following request on your Kong server:

```
$ curl -i -X POST http://kong:8001/plugins \
  --data name=rate-limiting-advanced \
  --data config.limit=10 \
  --data config.sync_rate=10 \
  --data config.window_size=60
```
## Configuration Parameters

| Form Parameter | default | description
|----------------|---------|-------------
| `name`|| The name of the plugin to use, in this case: `rate-limiting-advanced`.
|`config.limit`|| one of more request per window to apply
|`config.window_size`||One more more window sizes to apply (defined in seconds).
|`config.identifier` | `consumer` | How to define the rate limit key. Can be `ip`, `credential`, or `consumer`.
|`config.dictionary_name`| `kong_rate_limiting_counters` | The shared dictionary where counters will be stored until the next sync cycle.
|`config.sync_rate` | | How often to sync counter data to the central data store. A value of 0 results in synchronous behavior; a value of -1 ignores sync behavior entirely and only stores counters in node memory. A value greater than 0 will sync the counters in that many number of seconds.
|`config.namespace` <br>*optional* | `random string`|The rate limiting library namespace to use for this plugin instance. Counter data and sync configuration is shared in a namespace.
|`config.strategy`| `cluster` | The sync strategy to use; `cluster` and `redis` are supported.
|`config.redis.host` <br>*semi-optional* | | Host to use for Redis connection when the `redis` strategy is defined.
|`config.redis.port` <br>*semi-optional* ||Port to use for Redis connection when the `redis` strategy is defined.
|`config.redis.timeout` <br>*semi-optional* | | Connection timeout to use for Redis connection when the `redis` strategy is defined.
|`config.redis.password` <br>*semi-optional* || Password to use for Redis connection when the `redis` strategy is defined. If undefined, no AUTH commands are sent to Redis.
|`config.redis.database` <br>*semi-optional* |`0`|Database to use for Redis connection when the redis strategy is defined.
|`config.redis.sentinel_master` <br>*semi-optional* ||Sentinel master to use for Redis connection when the `redis` strategy is defined. Defining this value implies using Redis Sentinel.
|`config.redis.sentinel_role` <br>*semi-optional* ||Sentinel role to use for Redis connection when the `redis` strategy is defined. Defining this value implies using Redis Sentinel.
|`config.redis.sentinel_addresses` <br>*semi-optional* ||Sentinel addresses to use for Redis connection when the `redis` strategy is defined. Defining this value implies using Redis Sentinel.
|`config.window_type`| `sliding` | This sets the time window to either `sliding` or `fixed`

**Note:  Redis configuration values are ignored if the "cluster" strategy is used.**

**Note: PostgreSQL 9.5+ is required when using the "cluster" strategy with "postgres" as the backing Kong cluster data store. This requirement varies from the PostgreSQL 9.4+ requirement as described in the <a href="/install/source">Kong Community Edition documentation</a>.**

**Note: The `dictionary_name` directive was added to prevent the usage of the `kong` shared dictionary, which could lead to `no memory` errors**

---

## Notes
An arbitrary number of limits/window sizes can be applied per plugin instance. This allows users to create multiple rate limiting windows (e.g., rate limit per minute and per hour, and/or per any arbitrary window size); because of limitation with Kong's plugin configuration interface, each *nth* limit will apply to each *nth* window size. For example:

```
$ curl -i -X POST http://kong:8001/apis/{api}/plugins \
  --data name=rate-limiting-advanced \
  --data config.limit=10,100 \
  --data config.window_size=60,3600 \
  --data config.sync_rate=10
```
This will apply rate limiting policies, one of which will trip when 10 hits have been counted in 60 seconds, or when 100 hits have been counted in 3600 seconds.
