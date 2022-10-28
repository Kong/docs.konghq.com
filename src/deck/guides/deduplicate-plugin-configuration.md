---
title: De-duplicate Plugin Configuration
content_type: how-to
---

In some use cases, you might want to create a number of plugins associated with
different entities in Kong but with the same configuration. In such a case,
if you change anything in the configuration of the plugin, you will have to
repeat it for each instance of the plugin.

In other use cases, the plugin configuration could be decided by a different
team, while the main {{site.base_gateway}}
configuration is directly used by an API owner.

decK supports both of these use cases.

## Set up de-deduplicated plugin configuration

Let's take an example configuration file:

```yaml
consumers:
- username: foo
  tags:
  - silver-tier
  plugins:
  - name: rate-limiting
    config:
      day: null
      fault_tolerant: true
      hide_client_headers: false
      hour: null
      limit_by: consumer
      minute: 10
      month: null
      policy: redis
      redis_database: 0
      redis_host: redis.common.svc
      redis_password: null
      redis_port: 6379
      redis_timeout: 2000
      second: null
      year: null
    enabled: true
    run_on: first
    protocols:
    - http
    - https
- username: bar
  tags:
  - silver-tier
  plugins:
  - name: rate-limiting
    config:
      day: null
      fault_tolerant: true
      hide_client_headers: false
      hour: null
      limit_by: consumer
      minute: 10
      month: null
      policy: redis
      redis_database: 0
      redis_host: redis.common.svc
      redis_password: null
      redis_port: 6379
      redis_timeout: 2000
      second: null
      year: null
    enabled: true
    run_on: first
    protocols:
    - http
    - https
- username: baz
  tags:
  - gold-tier
  plugins:
  - name: rate-limiting
    config:
      day: null
      fault_tolerant: true
      hide_client_headers: false
      hour: null
      limit_by: consumer
      minute: 20
      month: null
      policy: redis
      redis_database: 0
      redis_host: redis.common.svc
      redis_password: null
      redis_port: 6379
      redis_timeout: 2000
      second: null
      year: null
    enabled: true
    run_on: first
    protocols:
    - http
    - https
- username: fub
  tags:
  - gold-tier
  plugins:
  - name: rate-limiting
    config:
      day: null
      fault_tolerant: true
      hide_client_headers: false
      hour: null
      limit_by: consumer
      minute: 20
      month: null
      policy: redis
      redis_database: 0
      redis_host: redis.common.svc
      redis_password: null
      redis_port: 6379
      redis_timeout: 2000
      second: null
      year: null
    enabled: true
    run_on: first
    protocols:
    - http
    - https
```

Here, we have two groups of consumers:
- `silver-tier` consumers who can access our APIs at 10 requests per minute
- `gold-tier` consumers who can access our APIs at 20 requests per minute

Now, if we want to increase the rate limits or change the host of the Redis
server, then we have to edit the configuration of each and every instance of
the plugin.

To reduce this repetition, you can de-duplicate plugin configuration and
reference it where we you need to use it. This works across multiple files as well.

The above file now becomes:

```yaml
_plugin_configs:
  silver-tier-limit:
    day: null
    fault_tolerant: true
    hide_client_headers: false
    hour: null
    limit_by: consumer
    minute: 14
    month: null
    policy: redis
    redis_database: 0
    redis_host: redis.common.svc
    redis_password: null
    redis_port: 6379
    redis_timeout: 2000
    second: null
    year: null
  gold-tier-limit:
    day: null
    fault_tolerant: true
    hide_client_headers: false
    hour: null
    limit_by: consumer
    minute: 20
    month: null
    policy: redis
    redis_database: 0
    redis_host: redis.common.svc
    redis_password: null
    redis_port: 6379
    redis_timeout: 2000
    second: null
    year: null
consumers:
- username: foo
  tags:
  - silver-tier
  plugins:
  - name: rate-limiting
    _config: silver-tier-limit
    enabled: true
    protocols:
    - http
    - https
- username: bar
  tags:
  - silver-tier
  plugins:
  - name: rate-limiting
    _config: silver-tier-limit
    enabled: true
    protocols:
    - http
    - https
- username: baz
  tags:
  - gold-tier
  plugins:
  - name: rate-limiting
    _config: gold-tier-limit
    enabled: true
    protocols:
    - http
    - https
- username: fub
  tags:
  - gold-tier
  plugins:
  - name: rate-limiting
    _config: gold-tier-limit
    enabled: true
    protocols:
    - http
    - https
```

Now, you can edit plugin configuration in a single place and you can see its
effect across multiple entities. Under the hood, decK takes the change and
applies it to each entity which references the plugin configuration that has
been changed. As always, use `deck diff` to inspect the changes before you
apply those to your Kong clusters.

## Overriding fields in plugin configs

Settings configured in `_plugin_configs` are applied to all plugins with the same tag.
While those settings provide the baseline configuration, you can change specific
fields as needed for the entities that consume them.

Specific values set for entities take precedence over values defined in `_plugin_configs`.

For example, say that consumer `fub` in the previous example is still in the
`gold-tier-limit`, but needs a rate limit of `50` minutes instead of `20`.
You can change this value just for that specific consumer:

```yaml
- username: fub
  tags:
  - gold-tier
  plugins:
  - name: rate-limiting
    _config: gold-tier-limit
    config:
      minute: 50
    enabled: true
    protocols:
    - http
    - https
```

Now compare the two gold tier consumers, `baz` and `fub`.

First check `baz`:

```sh
curl -i -X http://localhost:8001/consumers/baz/plugins
```

Find the `minute` configuration in the result. This consumer picks up the
setting of the `gold-tier-limit`, which is `minute: 20`.

Now check `fub`:

```sh
curl -i -X http://localhost:8001/consumers/fub/plugins
```

Find the `minute` configuration in the result.
This consumer has its own rate limit, `minute: 50`.
