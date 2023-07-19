The GraphQL Rate Limiting Advanced plugin provides rate limiting for GraphQL queries. The
GraphQL Rate Limiting plugin extends the
[Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced/) plugin.

Due to the nature of client-specified GraphQL queries, the same HTTP request
to the same URL with the same method can vary greatly in cost depending on the
semantics of the GraphQL operation in the body.

A common pattern to protect your GraphQL API is then to analyze and
assign costs to incoming GraphQL queries and rate limit the consumer's
cost for a given time window.

{:.note}
> **Notes:**
  * Redis configuration values are ignored if the `cluster` strategy is used.
  * PostgreSQL 9.5+ is required when using the `cluster` strategy with `postgres` as the backing Kong cluster datastore.
  * The `dictionary_name` directive was added to prevent the usage of the `kong` shared dictionary, which could lead to `no memory` errors.
