---
nav_title: Costs API reference
---

## Managing costs in GraphQL queries

The GraphQL Rate Limiting Advanced plugin exposes several endpoints for cost management. 
They are available through the Kong Admin API.

To configure and enable the plugin itself, [use the `/plugins` API endpoint](/hub/kong-inc/graphql-rate-limiting-advanced/how-to/basic-example/).
The `/graphql-rate-limiting-advanced` endpoints only appear once the plugin has been enabled. 

### About costs

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
It is roughly based on [GitHub's GraphQL resource limits].

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

## Decorate GraphQL schema for costs

Cost decoration schema looks like:

| Form Parameter    | default   | description
|-------------------|-----------|-------------
| `type_path`       |           | Path to node to decorate
| `add_constant`    | `1`       | Node weight when added
| `add_arguments`   | `[]`      | List of arguments to add to `add_constant`
| `mul_constant`    | `1`       | Node weight multiplier value
| `mul_arguments`   | `[]`      | List of arguments that multiply weight



## Costs API endpoints

Cost decoration is available on the following routes:

### Manage costs for services

<div class="endpoint get">/services/{service}/graphql-rate-limiting-advanced/costs</div>

List of costs associated to a service schema.

<div class="endpoint put">/services/{service}/graphql-rate-limiting-advanced/costs</div>

<div class="endpoint post">/services/{service}/graphql-rate-limiting-advanced/costs</div>

Add a cost to a service schema.


Example requests:

```sh
curl -X POST http://localhost:8001/services/example-service/graphql-rate-limiting-advanced/costs \
  --data type_path="Query.allPeople" \
  --data mul_arguments="first"

curl -X POST http://localhost:8001/services/example-service/graphql-rate-limiting-advanced/costs \
  --data type_path="Person.vehicleConnection" \
  --data mul_arguments="first"
  --data add_constant=42

curl -X POST http://localhost:8001/services/example-service/graphql-rate-limiting-advanced/costs \
  --data type_path="Vehicle.filmConnection" \
  --data mul_arguments="first"

curl -X POST http://localhost:8001/services/example-service/graphql-rate-limiting-advanced/costs \
  --data type_path="Film.characterConnection" \
  --data mul_arguments="first"
```

### Manage costs globally

<div class="endpoint get">/graphql-rate-limiting-advanced/costs</div>

List of all costs on any service.


<div class="endpoint put">/graphql-rate-limiting-advanced/costs</div>

<div class="endpoint post">/graphql-rate-limiting-advanced/costs</div>

Add a cost to a service schema.


### Manage an individual cost

<div class="endpoint get">/graphql-rate-limiting-advanced/costs/{cost_id}</div>

Get cost associated by ID.

<div class="endpoint patch">/graphql-rate-limiting-advanced/costs/{cost_id}</div>

Modify cost associated by ID.

<div class="endpoint delete">/graphql-rate-limiting-advanced/costs/{cost_id}</div>

Delete cost associated by ID.

