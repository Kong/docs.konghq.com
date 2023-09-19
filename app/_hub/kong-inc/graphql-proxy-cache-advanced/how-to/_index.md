---
nav_title: Getting Started with GraphQL and Kong Gateway
title: Getting Started with GraphQL and Kong Gateway
---

## About GraphQL with Kong Gateway

GraphQL decouples apps from services by introducing a flexible query language. Instead of a custom API for each screen, app developers describe the data they need, service developers describe what they can supply, and GraphQL automatically matches the two together. Teams ship faster across more platforms, with new levels of visibility and control over the use of their data. To learn more about how teams benefit, read why [GraphQL is important](https://www.apollographql.com/why-graphql/).

The GraphQL paradigm differs from traditional API-based systems. Depending on the resolver implementation details, one query can potentially generate an arbitrary number of requests. Proxy caching and rate limiting on top of GraphQL is key but usually overlooked as a hard problem to solve, since traditional proxy caching and rate limiting is not a good fit for GraphQL.

Kong easily integrates with existing GraphQL infrastructure out of the box. By introspecting the GraphQL schema and queries, Kong provides enterprise-grade proxy caching and rate limiting specifically tailored for GraphQL.

For rate limiting, see the [GraphQL Rate Limiting Advanced plugin](/hub/kong-inc/graphql-rate-limiting-advanced/how-to/).

## Prerequisite

You have an existing a GraphQL upstream.

## Add your service and route on Kong

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

## Add the GraphQL Proxy Cache Advanced plugin to the service

Proxy caching for GraphQL provides advanced caching over queries:

```sh
curl -i -X POST \
  --url http://localhost:8001/services/example-service/plugins/ \
  --data 'name=graphql-proxy-cache-advanced' \
  --data 'config.strategy=memory'
```

