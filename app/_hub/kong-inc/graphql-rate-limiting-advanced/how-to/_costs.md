---
nav_title: Managing costs
title: Managing costs
---

## Managing costs

The following configuration example targets a GraphQL endpoint at our [SWAPI playground].

See the [Costs API reference](/hub/kong-inc/graphql-rate-limiting-advanced/api/) for more information.

### Add a GraphQL service and route

```sh
curl -X POST http://localhost:8001/services \
  --data "name=example" \
  --data "host=httpbin.org" \
  --data "port=443" \
  --data "protocol=https"
curl -X POST http://localhost:8001/services/example/routes \
  --data "hosts=example.com"
```

### Enable the plugin on the service

Example using a single time window:

```sh
curl -i -X POST http://localhost:8001/services/example/plugins \
  --data name=graphql-rate-limiting-advanced \
  --data config.limit=100 \
  --data config.window_size=60 \
  --data config.sync_rate=10
```

Example using multiple time windows:

```sh
curl -i -X POST --url http://localhost:8001/services/example/plugins \
  --data 'name=graphql-rate-limiting-advanced' \
  --data 'config.window_size[]=60' \
  --data 'config.window_size[]=3600' \
  --data 'config.limit[]=10' \
  --data 'config.limit[]=100' \
  --data 'config.sync_rate=10'
```

### Changing the default strategy

```sh
curl -X POST http://localhost:8001/services/example/plugins \
  --data name=graphql-rate-limiting-advanced \
  --data config.limit=100 \
  --data config.limit=10000 \
  --data config.window_size=60 \
  --data config.window_size=3600 \
  --data config.sync_rate=10 \
  --data config.cost_strategy=default
```

```sh
curl -i -X PATCH http://localhost:8001/plugins/{plugin_id} \
  --data config.cost_strategy=node_quantifier
```

### Limit query cost by using `config.max_cost`

It's usually a good idea to define a maximum cost applied to any query,
regardless if the call is within the rate limits for a consumer.

By defining a `max_cost` on our service, we are ensuring no query will run with
a cost higher than our set `max_cost`. By default it's set to 0, which means
no limit.

```sh
curl -X POST http://localhost:8001/services/example/plugins \
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
curl -X PATCH http://localhost:8001/plugins/{plugin_id} \
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
curl -X POST http://localhost:8001/services/example/plugins \
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
curl -i -X PATCH http://localhost:8001/plugins/{plugin_id} \
  --data config.score_factor=1
```

[SWAPI playground]: https://swapi-graphql.eskerda.now.sh