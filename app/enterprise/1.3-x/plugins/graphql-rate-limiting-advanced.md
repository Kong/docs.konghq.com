---
title: GraphQL Rate Limiting Advanced
---

The GraphQL Rate limiting advanced plugin is an extension of the
enterprise rate-limiting plugin that provides rate-limiting for
GraphQL queries.

Due to the nature of client-specified GraphQL queries, the same HTTP request
to the same URL with the same method can vary greatly in cost depending on the
semantics of the GraphQL operation in the body.

A common pattern to protect your GraphQL API is then to analyze and
assign costs to incoming GraphQL queries and rate limit the consumer's
cost for a given time window.

## Configuration

This plugin is configured as the rate-limiting-advanced plugin, plus some additional
options related to graphql:

| Form Parameter    | default   | description
|-------------------|-----------|-------------
| `cost_strategy`   | `default` | Strategy to use to evaluate query costs.
| `max_cost`        | `0`       | A defined maximum cost per query. 0 means unlimited.
| `score_factor`    | `1.0`     | A scoring factor to multiply (or divide) the cost.


## Costs in GraphQL queries

GraphQL query costs are evaluated by introspecting the endpoint's graphql schema
and applying cost decoration to parts of the schema tree.

Initially all nodes start with zero cost, with any operation at cost 1.
Add rate-limiting constraints on any subtree. If subtree omitted, then
rate-limit window applies on the whole tree (any operation).

Since there are many ways of approximating the cost of a graphql query, the
plugin exposes two strategies: `default` and `node_quantifier`.

The following example queries can be run on this [SWAPI playground].

[SWAPI playground]: https://swapi-graphql.eskerda.now.sh

### `default`

The default strategy is meant as a good middle ground for general graphql
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

This strategy is fit for graphql schemas that enforce quantifier arguments on
any connection, providing a good approximation on the number of nodes visited
for satisfying a query. Any query without decorated quantifiers has a cost of 1.
It is roughly based on [github's Graphql resource limits].

[github's Graphql resource limits]: https://developer.github.com/v4/guides/resource-limitations/

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

* allPeople returns 100 nodes, and has been called once
* vehicleConnection returns 10 nodes, and has been called 100 times
* filmConnection returns 5 nodes, and has been called 10 * 100 times
* characterConnection returns 50 nodes, and has been called 5 * 10 * 100 times


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

### Add a GraphQL service

```
http -f :8001/services name=example host=swapi-graphql.eskerda.now.sh port=443 protocol=https
http -f :8001/services/example/routes hosts=example.com
```

### Enable the plugin on the service

```
$ curl -i -X POST http://kong:8001/services/{service}/plugins \
  --data name=rate-limiting-advanced \
  --data config.limit=100,10000 \
  --data config.window_size=60,3600 \
  --data config.sync_rate=10
```

### Decorate gql schema for costs

Cost decoration schema looks like:

| Form Parameter    | default   | description
|-------------------|-----------|-------------
| `type_path        |           | Path to node to decorate
| `add_constant`    | `1`       | Node weight when added
| `add_arguments`   | `[]`      | List of arguments to add to add_constant
| `mul_constant`    | `1`       | Node weight multiplier value
| `mul_arguments`   | `[]`      | List of arguments that multiply weight


Cost decoration is available on the following routes:

#### `/services/{service}/graphql-rate-limiting-advanced/costs`

* GET: list of costs associated to a service schema
* PUT, POST: add a cost to a service schema


#### `/graphql-rate-limiting-advanced/costs`

* GET: list of all costs on any service
* PUT, POST: add a cost to a service schema


#### `/graphql-rate-limiting-advanced/costs/{cost_id}`

* GET: get cost associated by id
* PATCH: modify cost associated by id
* DELETE: delete cost associated by id


For example:

```
http -f :8001/services/example/graphql-rate-limiting-advanced/costs type_path="Query.allPeople" mul_arguments="first"
http -f :8001/services/example/graphql-rate-limiting-advanced/costs type_path="Person.vehicleConnection" mul_arguments="first" add_constant=42
http -f :8001/services/example/graphql-rate-limiting-advanced/costs type_path="Vehicle.filmConnection" mul_arguments="first"
http -f :8001/services/example/graphql-rate-limiting-advanced/costs type_path="Film.characterConnection" mul_arguments="first"
```

### Changing the default strategy

```
$ curl -i -X POST http://kong:8001/services/{service}/plugins \
  --data name=rate-limiting-advanced \
  --data config.limit=100,10000 \
  --data config.window_size=60,3600 \
  --data config.sync_rate=10 \
  --data config.cost_strategy=node_quantifier
```

```
$ curl -i -X PATCH http://kong:8001/plugins/{plugin_id} \
  --data config.cost_strategy=node_quantifier
```

### Limit query cost by using `config.max_cost`

It's usually a good idea to define a maximum cost applied to any query, regardless
if the call is within the rate limits for a consumer.

By defining a `max_cost` on our service, we are ensuring no query will run with
a cost higher than our set `max_cost`. By default it's set to 0, which means
no limit.

```
$ curl -i -X POST http://kong:8001/services/{service}/plugins \
  --data name=rate-limiting-advanced \
  --data config.limit=100,10000 \
  --data config.window_size=60,3600 \
  --data config.sync_rate=10 \
  --data config.max_cost=5000
```

```
$ curl -i -X PATCH http://kong:8001/plugins/{plugin_id} \
  --data config.max_cost=5000
```

### Using `config.score_factor` to modify costs

GraphQL query cost depend on multiple factors depending on our resolvers
and the implementation of the schema. Cost on queries, depending on the cost
strategy might turn very high when using quantifiers, or very low with no
quantifiers at all. By using `config.score_factor` the cost can be divided
or multiplied to a certain order of mangitude.

For example, a `score_factor` of `0.01` will divide the costs by 100, meaning
every cost unit represents 100 nodes.

```
$ curl -i -X POST http://kong:8001/services/{service}/plugins \
  --data name=rate-limiting-advanced \
  --data config.limit=100,10000 \
  --data config.window_size=60,3600 \
  --data config.sync_rate=10 \
  --data config.score_factor=0.01
  --data config.max_cost=5000
```

```
$ curl -i -X PATCH http://kong:8001/plugins/{plugin_id} \
  --data config.score_factor=0.01
```
