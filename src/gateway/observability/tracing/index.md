---
title: Tracing
---

## Core instrumentations

| OT Category               | Kong Components             | Name                                 | Span data                           | Notes                                                   |
| ------------------------- | --------------------------- | ------------------------------------ | ----------------------------------- | ------------------------------------------------------- |
| Database                  | Storage                     | DB query                             | SQL                                 | database spec                                           |
| Redis                     | Redis call                  | database spec                        |                                     |                                                         |
| Redis cluster             | Redis call                  | extra support for resty.rediscluster |                                     |                                                         |
| LMDB                      | Transactions                | database spec                        |                                     |                                                         |
| HTTP                      | Core                        | HTTP Server Request / Consumer       | Nginx server request                | http spec                                               |
| Balancer Retry / Upstream | Nginx balancer retries data | http spec                            |                                     |                                                         |
| Core / Plugins            | HTTP Client Request         | HTTP client request                  | http spec, resty.http, e.g. plugins |                                                         |
| RPC                       | Core                        | gRPC                                 | gRPC call                           | rpc spec                                                |
| Messaging                 | Stream                      | Pub                                  | OpenResty pub/sub                   | messaging spec                                          |
| Sub                       | OpenResty pub/sub           |                                      |                                     |                                                         |
| Kafka                     |                             | messaging spec                       |                                     |                                                         |
| FAAS                      | Plugins                     | AWS Lambda                           | remote call                         | faas spec                                               |
| Azure functions           |                             |                                      |                                     |                                                         |
| Exceptions                | Errors                      | OpenResty errors                     |                                     | Capture runtime errors (logs can be linked by trace_id) |
| Networking                | Core                        | DNS query                            | host, success                       | general spec                                            |
| Plugins                   | LDAP                        | LDAP operations                      | ldap spec                           |                                                         |
| LDAP Enhanced             | LDAP operations             | ldap spec                            |                                     |                                                         |
| OpenID Connect            |                             |                                      |                                     |                                                         |
| GraphQL                   | GraphQL query               |                                      |                                     |                                                         |
| Vault                     | Vault query                 |                                      |                                     |                                                         |
| Kong Internal             | Core                        | Router                               | Execution time                      |                                                         |
| Plugin execution          | Plugin name, execution time | start/end time only                  |                                     |                                                         |

## Propagation

The tracing API support to propagate the following headers:
- `w3c` - [W3C trace context](https://www.w3.org/TR/trace-context/)
- `b3`, `b3-single` - [Zipkin headers](https://github.com/openzipkin/b3-propagation)
- `jaeger` - [Jaeger headers](https://www.jaegertracing.io/docs/client-libraries/#propagation-format)
- `ot` - [OpenTracing headers](https://github.com/opentracing/specification/blob/master/rfc/trace_identifiers.md)
- `datadog` - [Datadog headers](https://docs.datadoghq.com/tracing/agent/propagation/)

The tracing API will detect the propagation format from the headers, and will use the appropriate format to propagate the span context.
If no appropriate format is found, then will fallback to the default format, which can be specified.
