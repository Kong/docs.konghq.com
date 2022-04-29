---
name: GraphQL Rate Limiting Advanced
publisher: Kong Inc.
version: 0.2.x
desc: Provide rate limiting for GraphQL queries
description: |
  The GraphQL Rate Limiting Advanced plugin provides rate limiting for GraphQL queries. The
  GraphQL Rate Limiting plugin extends the
  [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced/) plugin.
type: plugin
enterprise: true
plus: true
categories:
  - traffic-control
kong_version_compatibility:
  enterprise_edition:
    compatible:
      - 2.8.x
      - 2.7.x
      - 2.6.x
      - 2.5.x
      - 2.4.x
      - 2.3.x
      - 2.2.x
      - 2.1.x
      - 1.5.x
params:
  name: graphql-rate-limiting-advanced
  service_id: true
  route_id: true
  dbless_compatible: partially
  dbless_explanation: |
    The cluster strategy is not supported in DB-less and hybrid modes. For Kong
    Gateway in DB-less or hybrid mode, use the `redis` strategy.
  config:
    - name: cost_strategy
      required: true
      default: default
      value_in_examples: null
      datatype: string
      description: |
        Strategy to use to evaluate query costs. Either `default` or
        `node_quantifier`. See [default](/hub/kong-inc/graphql-rate-limiting-advanced/#default) and
        [node_quantifier](/hub/kong-inc/graphql-rate-limiting-advanced/#node_quantifier) respectively.
    - name: max_cost
      required: false
      default: 0
      value_in_examples: null
      datatype: number
      description: |
        A defined maximum cost per query. 0 means unlimited.
    - name: score_factor
      required: false
      default: 1
      value_in_examples: null
      datatype: number
      description: |
        A scoring factor to multiply (or divide) the cost. The `score_factor` must always be greater than 0.
    - name: limit
      required: true
      default: null
      value_in_examples:
        - '5'
      datatype: array of number elements
      description: |
        One or more requests-per-window limits to apply.
    - name: window_size
      required: true
      default: null
      value_in_examples:
        - '30'
      datatype: array of number elements
      description: |
        One or more window sizes to apply a limit to (defined in seconds).
    - name: identifier
      required: true
      default: consumer
      value_in_examples: null
      datatype: string
      description: |
        How to define the rate limit key. Can be `ip`, `credential`, `consumer`.
    - name: header_name
      required: semi
      datatype: string
      description: |
        Header name to use as the rate limit key when the `header` identifier is defined.
    - name: dictionary_name
      required: true
      default: kong_rate_limiting_counters
      value_in_examples: null
      datatype: string
      description: |
        The shared dictionary where counters will be stored until the next sync cycle.
    - name: sync_rate
      required: true
      default: null
      value_in_examples: -1
      datatype: number
      description: |
        How often to sync counter data to the central data store. A value of 0
        results in synchronous behavior; a value of -1 ignores sync behavior
        entirely and only stores counters in node memory. A value greater than
        0 syncs the counters in that many number of seconds.
    - name: namespace
      required: false
      default: random string
      value_in_examples: null
      datatype: string
      description: |
        The rate limiting library namespace to use for this plugin instance. Counter data and sync configuration is shared in a namespace.
    - name: strategy
      required: null
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
    - name: redis.host
      required: semi
      default: null
      value_in_examples: null
      datatype: string
      description: |
        Host to use for Redis connection when the `redis` strategy is defined.
    - name: redis.port
      required: semi
      default: null
      value_in_examples: null
      datatype: integer
      description: |
        Port to use for Redis connection when the `redis` strategy is defined.
    - name: redis.ssl
      required: false
      default: false
      value_in_examples: null
      datatype: boolean
      description: |
        If set to true, then uses SSL to connect to Redis.

        **Note:** This parameter is only available for Kong Gateway versions
        2.2.x and later.
    - name: redis.ssl_verify
      required: false
      default: false
      value_in_examples: null
      datatype: boolean
      description: |
        If set to true, then verifies the validity of the server SSL certificate. Note that you need to configure the
        [lua_ssl_trusted_certificate](/gateway/latest/reference/configuration/#lua_ssl_trusted_certificate)
        to specify the CA (or server) certificate used by your redis server. You may also need to configure
        [lua_ssl_verify_depth](/gateway/latest/reference/configuration/#lua_ssl_verify_depth) accordingly.

        **Note:** This parameter is only available for Kong Gateway versions
        2.2.x and later.
    - name: redis.server_name
      required: false
      default: null
      value_in_examples: null
      datatype: string
      description: |
        Specifies the server name for the new TLS extension Server Name Indication (SNI) when connecting over SSL.

        **Note:** This parameter is only available for Kong Gateway versions
        2.2.x and later.
    - name: redis.timeout
      required: semi
      default: 2000
      value_in_examples: null
      datatype: number
      description: |
        Connection timeout (in milliseconds) to use for Redis connection when the `redis` strategy is defined.
    - name: redis.username
      required: semi
      default: null
      value_in_examples: null
      datatype: string
      description: |
        Username to use for Redis connection when the `redis` strategy is defined and ACL authentication is desired.
        If undefined, ACL authentication will not be performed. This requires Redis v6.0.0+.

        This field is _referenceable_, which means it can be securely stored as a
        [secret](/gateway/latest/plan-and-deploy/security/secrets-management/getting-started)
        in a vault. References must follow a [specific format](/gateway/latest/plan-and-deploy/security/secrets-management/reference-format).
    - name: redis.password
      required: semi
      default: null
      value_in_examples: null
      datatype: string
      description: |
        Password to use for Redis connection when the `redis` strategy is defined.
        If undefined, no AUTH commands are sent to Redis.

        This field is _referenceable_, which means it can be securely stored as a
        [secret](/gateway/latest/plan-and-deploy/security/secrets-management/getting-started)
        in a vault. References must follow a [specific format](/gateway/latest/plan-and-deploy/security/secrets-management/reference-format).
    - name: redis.database
      required: semi
      default: 0
      value_in_examples: null
      datatype: integer
      description: |
        Database to use for Redis connection when the `redis` strategy is defined.
    - name: redis.sentinel_master
      required: semi
      default: null
      value_in_examples: null
      datatype: string
      description: |
        Sentinel master to use for Redis connection when the `redis` strategy is defined. Defining this value implies using Redis Sentinel.
    - name: redis.sentinel_username
      required: semi
      default: null
      value_in_examples: null
      datatype: string
      description: |
        Sentinel username to authenticate with a Redis Sentinel instance.
        If undefined, ACL authentication will not be performed. This requires Redis v6.2.0+.

        This field is _referenceable_, which means it can be securely stored as a
        [secret](/gateway/latest/plan-and-deploy/security/secrets-management/getting-started)
        in a vault. References must follow a [specific format](/gateway/latest/plan-and-deploy/security/secrets-management/reference-format).
    - name: redis.sentinel_password
      required: semi
      default: null
      value_in_examples: null
      datatype: string
      description: |
        Sentinel password to authenticate with a Redis Sentinel instance.
        If undefined, no AUTH commands are sent to Redis Sentinels.

        This field is _referenceable_, which means it can be securely stored as a
        [secret](/gateway/latest/plan-and-deploy/security/secrets-management/getting-started)
        in a vault. References must follow a [specific format](/gateway/latest/plan-and-deploy/security/secrets-management/reference-format).
    - name: redis.sentinel_role
      required: semi
      default: null
      value_in_examples: null
      datatype: string
      description: |
        Sentinel role to use for Redis connection when the `redis` strategy is defined. Defining this value implies using Redis Sentinel.
    - name: redis.sentinel_addresses
      required: semi
      default: null
      value_in_examples: null
      datatype: array of string elements
      description: |
        Sentinel addresses to use for Redis connection when the `redis` strategy is defined. Defining this value implies using Redis Sentinel.
    - name: redis.cluster_addresses
      required: semi
      default: null
      value_in_examples: null
      datatype: array of string elements
      description: |
        Cluster addresses to use for Redis connection when the `redis` strategy is defined. Defining this value implies using Redis cluster.
    - name: redis.keepalive_backlog
      required: false
      default: null
      value_in_examples: null
      datatype: integer
      description: |
        If specified, limits the total number of opened connections for a pool. If the 
        connection pool is full, all connection queues beyond the maximum limit go into 
        the backlog queue. Once the backlog queue is full, subsequent connect operations 
        will fail and return `nil`. Queued connect operations resume once the number of 
        connections in the pool is less than `keepalive_pool_size`. Note that queued 
        connect operations are subject to set timeouts.
    - name: redis.keepalive_pool
      required: false
      default: generated from string template
      value_in_examples: null
      datatype: string
      description: |
        The custom name of the connection pool. If not specified, the connection pool
        name is generated from the string template `"<host>:<port>"` or `"<unix-socket-path>"`.
    - name: redis.keepalive_pool_size
      required: false
      default: 30
      value_in_examples: null
      datatype: integer
      description: |
        The size limit for every cosocket connection pool associated with every remote
        server, per worker process. If no `keepalive_pool_size` is specified and no `keepalive_backlog`
        is specified, no pool is created. If no `keepalive_pool_size` is specified and `keepalive_backlog`
        is specified, then the pool uses the default value `30`.
    - name: window_type
      required: true
      default: sliding
      value_in_examples: null
      datatype: string
      description: |
        Sets the time window to either `sliding` or `fixed`.
    - name: hide_client_headers
      required: false
      default: false
      value_in_examples: null
      datatype: boolean
      description: |
        Optionally hide informative response headers. Available options: `true` or `false`.
  extra: |
    > Note: Redis configuration values are ignored if the `cluster` strategy is used.

    **Notes:**

     * PostgreSQL 9.5+ is required when using the `cluster` strategy with `postgres` as the backing Kong cluster data store. This requirement varies from the PostgreSQL 9.4+ requirement as described in the <a href="/install/source">Kong Community Edition documentation</a>.

     * The `dictionary_name` directive was added to prevent the usage of the `kong` shared dictionary, which could lead to `no memory` errors.
---

The **GraphQL Rate Limiting Advanced** plugin is an extension of the
**Rate Limiting Advanced** plugin and provides rate limiting for
GraphQL queries.

Due to the nature of client-specified GraphQL queries, the same HTTP request
to the same URL with the same method can vary greatly in cost depending on the
semantics of the GraphQL operation in the body.

A common pattern to protect your GraphQL API is then to analyze and
assign costs to incoming GraphQL queries and rate limit the consumer's
cost for a given time window.

## Costs in GraphQL queries

GraphQL query costs are evaluated by introspecting the endpoint's GraphQL schema
and applying cost decoration to parts of the schema tree.

Initially all nodes start with zero cost, with any operation at cost 1.
Add rate-limiting constraints on any subtree. If subtree omitted, then
rate-limit window applies on the whole tree (any operation).

Since there are many ways of approximating the cost of a GraphQL query, the
plugin exposes two strategies: `default` and `node_quantifier`.

The following example queries can be run on this [SWAPI playground].

[SWAPI playground]: https://swapi-graphql.eskerda.now.sh

### `default`

The default strategy is meant as a good middle ground for general GraphQL
queries, where it's difficult to assert a clear cost strategy, so every operation
has a cost of 1.

```
query { # + 1
  allPeople {  # + 1
    people { # + 1
      name # + 1
    }
  }
}

# total cost: 4
```

Default node costs can be defined by decorating the schema:

| `type_path`               | `mul_arguments`   | `mul_constant`    | `add_arguments`   | `add_constant`
|---------------------------|-------------------|-------------------|-------------------|---------------
| Query.allPeople           | ["first"]         | 1                 | []                | 1
| Person.vehicleConnection  | ["first"]         | 1                 | []                | 1


```
query { # + 1
  allPeople(first:20) { # * 20 + 1
    people { # + 1
      name # + 1
      vehicleConnection(first:10) { # * 10 + 1
        vehicles { # + 1
          id  # + 1
          name # + 1
          cargoCapacity # + 1
        }
      }
    }
  }
}

# total cost: ((((4 * 10 + 1) + 1) + 1) * 20 + 1) + 1 = 862
```

Generally speaking, vehicleConnection weight (4) is applied 10 times, and the
total weight of it (40) 20 times, which gives us a rough 800.

Cost constants can be atomically defined as:

| `type_path`               | `mul_arguments`   | `mul_constant`    | `add_arguments`   | `add_constant`
|---------------------------|-------------------|-------------------|-------------------|---------------
| Query.allPeople           | ["first"]         | 2                 | []                | 2
| Person.vehicleConnection  | ["first"]         | 1                 | []                | 5
| Vehicle.name              | []                | 1                 | []                | 8

On this example, `Vehicle.name` and `Person.vehicleConnection` have specific
weights of 8 and 5 respectively. `allPeople` weights 2, and also has double
its weight when multiplied by arguments.

```
query { # + 1
  allPeople(first:20) { # 2 * 20 + 2
    people { # + 1
      name # + 1
      vehicleConnection(first:10) { # * 10 + 5
        vehicles { # + 1
          id  # + 1
          name # + 8
          cargoCapacity # + 1
        }
      }
    }
  }
}

# total cost: ((((11 * 10 + 5) + 1) + 1) * 2 * 20 + 2) + 1 = 4683
```

### `node_quantifier`

This strategy is fit for GraphQL schemas that enforce quantifier arguments on
any connection, providing a good approximation on the number of nodes visited
for satisfying a query. Any query without decorated quantifiers has a cost of 1.
It is roughly based on [github's GraphQL resource limits].

[github's GraphQL resource limits]: https://developer.github.com/v4/guides/resource-limitations/

```
query {
  allPeople(first:100) { # 1
    people {
      name
      vehicleConnection(first:10) { # 100
        vehicles {
          name
          filmConnection(first:5) { # 10 * 100
            films{
              title
              characterConnection(first:50) { # 5 * 10 * 100
                characters {
                  name
                }
              }
            }
          }
        }
      }
    }
  }
}
# total cost: 1 + 100 + 10 * 100 + 5 * 10 * 100 = 6101
```

| `type_path`               | `mul_arguments`   | `mul_constant`    | `add_arguments`   | `add_constant`
|---------------------------|-------------------|-------------------|-------------------|---------------
| Query.allPeople           | ["first"]         | 1                 | []                | 1
| Person.vehicleConnection  | ["first"]         | 1                 | []                | 1
| Vehicle.filmConnection    | ["first"]         | 1                 | []                | 1
| Film.characterConnection  | ["first"]         | 1                 | []                | 1

Roughly speaking:

* `allPeople` returns 100 nodes, and has been called once
* `vehicleConnection` returns 10 nodes, and has been called 100 times
* `filmConnection` returns 5 nodes, and has been called 10 * 100 times
* `characterConnection` returns 50 nodes, and has been called 5 * 10 * 100 times


Specific costs per node can be specified by adding a constant:

| `type_path`               | `mul_arguments`   | `mul_constant`    | `add_arguments`   | `add_constant`
|---------------------------|-------------------|-------------------|-------------------|---------------
| Query.allPeople           | ["first"]         | 1                 | []                | 1
| Person.vehicleConnection  | ["first"]         | 1                 | []                | 42
| Vehicle.filmConnection    | ["first"]         | 1                 | []                | 1
| Film.characterConnection  | ["first"]         | 1                 | []                | 1


```
query {
  allPeople(first:100) { # 1
    people {
      name
      vehicleConnection(first:10) { # 100 * 42
        vehicles {
          name
          filmConnection(first:5) { # 10 * 100
            films{
              title
              characterConnection(first:50) { # 5 * 10 * 100
                characters {
                  name
                }
              }
            }
          }
        }
      }
    }
  }
}
# total cost: 1 + 100 * 42 + 10 * 100 + 5 * 10 * 100 = 10201
```

## Usage

The following configuration example targets a GraphQL endpoint at our [SWAPI playground].

### Add a GraphQL service and route

```sh
curl -X POST http://kong:8001/services \
  --data "name=example" \
  --data "host=mockbin.org" \
  --data "port=443" \
  --data "protocol=https"

curl -X POST http://kong:8001/services/example/routes \
  --data "hosts=example.com"
```

### Enable the plugin on the service

Example using a single time window:

```sh
curl -i -X POST http://kong:8001/services/example/plugins \
  --data name=graphql-rate-limiting-advanced \
  --data config.limit=100 \
  --data config.window_size=60 \
  --data config.sync_rate=10
```

Example using multiple time windows:

```sh
curl -i -X POST --url http://kong:8001/services/example/plugins \
  --data 'name=graphql-rate-limiting-advanced' \
  --data 'config.window_size[]=60' \
  --data 'config.window_size[]=3600' \
  --data 'config.limit[]=10' \
  --data 'config.limit[]=100' \
  --data 'config.sync_rate=10'
```

### Decorate gql schema for costs

Cost decoration schema looks like:

| Form Parameter    | default   | description
|-------------------|-----------|-------------
| `type_path`       |           | Path to node to decorate
| `add_constant`    | `1`       | Node weight when added
| `add_arguments`   | `[]`      | List of arguments to add to add_constant
| `mul_constant`    | `1`       | Node weight multiplier value
| `mul_arguments`   | `[]`      | List of arguments that multiply weight


Cost decoration is available on the following routes:

#### `/services/{service}/graphql-rate-limiting-advanced/costs`

* **GET**: list of costs associated to a service schema
* **PUT**, **POST**: add a cost to a service schema


For example:

```sh
curl -X POST http://kong:8001/services/example/graphql-rate-limiting-advanced/costs \
  --data type_path="Query.allPeople" \
  --data mul_arguments="first"


curl -X POST http://kong:8001/services/example/graphql-rate-limiting-advanced/costs \
  --data type_path="Person.vehicleConnection" \
  --data mul_arguments="first"
  --data add_constant=42

curl -X POST http://kong:8001/services/example/graphql-rate-limiting-advanced/costs \
  --data type_path="Vehicle.filmConnection" \
  --data mul_arguments="first"


curl -X POST http://kong:8001/services/example/graphql-rate-limiting-advanced/costs \
  --data type_path="Film.characterConnection" \
  --data mul_arguments="first"
```


#### `/graphql-rate-limiting-advanced/costs`

* **GET**: list of all costs on any service
* **PUT**, **POST**: add a cost to a service schema


#### `/graphql-rate-limiting-advanced/costs/{cost_id}`

* **GET**: get cost associated by id
* **PATCH**: modify cost associated by id
* **DELETE**: delete cost associated by id


### Changing the default strategy

```sh
curl -X POST http://kong:8001/services/example/plugins \
  --data name=graphql-rate-limiting-advanced \
  --data config.limit=100 \
  --data config.limit=10000 \
  --data config.window_size=60 \
  --data config.window_size=3600 \
  --data config.sync_rate=10 \
  --data config.cost_strategy=default
```

```sh
curl -i -X PATCH http://kong:8001/plugins/{plugin_id} \
  --data config.cost_strategy=node_quantifier
```

### Limit query cost by using `config.max_cost`

It's usually a good idea to define a maximum cost applied to any query,
regardless if the call is within the rate limits for a consumer.

By defining a `max_cost` on our service, we are ensuring no query will run with
a cost higher than our set `max_cost`. By default it's set to 0, which means
no limit.

```sh
curl -X POST http://kong:8001/services/example/plugins \
  --data name=graphql-rate-limiting-advanced \
  --data config.limit=100 \
  --data config.limit=10000 \
  --data config.window_size=60 \
  --data config.window_size=3600 \
  --data config.sync_rate=0 \
  --data config.max_cost=5000
```

To update `max_cost`:

```sh
curl -X PATCH http://kong:8001/plugins/{plugin_id} \
  --data config.max_cost=10000
```

### Using `config.score_factor` to modify costs

GraphQL query cost depends on multiple factors based on our resolvers
and the implementation of the schema. Cost on queries, depending on the cost
strategy might turn very high when using quantifiers, or very low with no
quantifiers at all. By using `config.score_factor` the cost can be divided
or multiplied to a certain order of magnitude.

For example, a `score_factor` of `0.01` will divide the costs by 100, meaning
every cost unit represents 100 nodes.

```sh
curl -X POST http://kong:8001/services/example/plugins \
  --data name=graphql-rate-limiting-advanced \
  --data config.limit=100 \
  --data config.limit=10000 \
  --data config.window_size=60 \
  --data config.window_size=3600 \
  --data config.sync_rate=0 \
  --data config.max_cost=5000 \
  --data config.score_factor=0.01
```

To update `score_factor`:

```sh
curl -i -X PATCH http://kong:8001/plugins/{plugin_id} \
  --data config.score_factor=1
```

---

## Changelog

### Kong Gateway 2.8.x (plugin version 0.2.5)

* Added the `redis.username` and `redis.sentinel_username` configuration parameters.

* The `redis.username`, `redis.password`, `redis.sentinel_username`, and `redis.sentinel_password`
configuration fields are now marked as referenceable, which means they can be securely stored as
[secrets](/gateway/latest/plan-and-deploy/security/secrets-management/getting-started)
in a vault. References must follow a [specific format](/gateway/latest/plan-and-deploy/security/secrets-management/reference-format).

* Fixed plugin versions in the documentation. Previously, the plugin versions
were labelled as `1.3-x` and `2.3.x`. They are now updated to align with the
plugin's actual versions, `0.1.x` and `0.2.x`.
