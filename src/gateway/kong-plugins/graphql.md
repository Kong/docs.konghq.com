---
title: Getting Started with GraphQL and Kong Gateway
badge: enterprise
---

GraphQL decouples apps from services by introducing a flexible query language. Instead of a custom API for each screen, app developers describe the data they need, service developers describe what they can supply, and GraphQL automatically matches the two together. Teams ship faster across more platforms, with new levels of visibility and control over the use of their data. To learn more about how teams benefit, read why [GraphQL is important](https://www.apollographql.com/why-graphql/).

{{site.base_gateway}} is an API gateway and platform. That means it is a form of middleware between computing clients and your API-based applications. {{site.base_gateway}} quickly and consistently extends the features of your APIs. Some of the popular features deployed through {{site.base_gateway}} include authentication, security, traffic control, serverless, analytics & monitoring, request/response transformations, and logging. To learn more about these features, see the [Hub page](/hub/) for plugins. For more about the benefits of Kong in general, please see the [FAQ](https://konghq.com/faqs).

The GraphQL paradigm differs from traditional API-based systems. Depending on the resolver implementation details, one query can potentially generate an arbitrary number of requests. Proxy caching and rate limiting on top of GraphQL is key but usually overlooked as a hard problem to solve, since traditional proxy-caching and rate-limiting is not a good fit for GraphQL.

Kong easily integrates with existing GraphQL infrastructure out of the box. By introspecting the GraphQL schema and queries, Kong provides enterprise-grade proxy-caching and rate-limiting specifically tailored for GraphQL.

## Existing GraphQL infrastructure

Use {{site.base_gateway}} to protect and manage an existing GraphQL endpoint. The following will set up a {{site.base_gateway}} instance on top of a GraphQL upstream and set up key-auth, proxy-caching and rate-limiting.

### Add your Service and Route on Kong

After installing and starting {{site.base_gateway}}, use the Admin API on port 8001 to add a new Service and Route. In this example, {{site.base_gateway}} will reverse proxy every incoming request with the specified incoming host to the associated upstream URL. You can implement very complex routing mechanisms beyond simple host matching.


```sh
curl -i -X POST \
  --url http://localhost:8001/services/ \
  --data 'name=graphql-service' \
  --data 'url=http://example.com'
```

```sh
curl -i -X POST \
  --url http://localhost:8001/services/example-service/routes \
  --data 'hosts[]=example.com' \
```  

### Add GraphQL Plugins on the Service

Proxy caching for GraphQL provides advanced caching over queries.

```sh
curl -i -X POST \
  --url http://localhost:8001/services/example-service/plugins/ \
  --data 'name=graphql-proxy-cache-advanced' \
  --data 'config.strategy=memory'
```

Protect your upstream GraphQL service with rate limiting. By introspecting your schema, it will analyze query costs and provide an enterprise-grade rate-limiting strategy.

```sh
curl -i -X POST http://kong:8001/services/example-service/plugins \
  --data name=graphql-rate-limiting-advanced \
  --data config.limit=100,10000 \
  --data config.window_size=60,3600 \
  --data config.sync_rate=10
```

The GraphQL Rate Limiting Advanced plugin supports two rate-limiting strategies. The default strategy will try to estimate cost on queries by counting the nesting of nodes. The default strategy is meant as a good middle ground for general GraphQL queries, where it's difficult to assert a clear cost strategy, so every operation has a cost of 1.

A more advanced strategy is available for GraphQL schemas that enforce quantifier arguments on any connection, providing a good approximation on the number of nodes visited for satisfying a query. Any query without decorated quantifiers has a cost of 1. It is roughly based on [GitHub's GraphQL resource limits](https://developer.github.com/v4/guides/resource-limitations/).

Read more about rate-limiting here: [GraphQL Rate Limiting Advanced Plugin](/hub/kong-inc/graphql-rate-limiting-advanced)

### New upstream

We have prepared a [quickstart guide](https://github.com/Kong/kong-apollo-quickstart) that will help you build your new GraphQL service on top of Kong and Apollo.
