---
title: Plugin Compatibility
---

DB-less mode is the preferred choice for controller-managed Kong and Kong
Enterprise clusters. However, not all plugins are available in DB-less mode.
Review the table below to check if a plugin you wish to use requires a
database.

Note that some DB-less compatible plugins have some limitations or require
non-default configuration for
[compatibility](/gateway-oss/latest/db-less-and-declarative-config/#plugin-compatibility).

## Kong

|  Plugin                 |  Kong                         |  Kong (DB-less)               |
|-------------------------|-------------------------------|-------------------------------|
|  acl                    |  <i class="fa fa-check"></i>  |  <i class="fa fa-check"></i>  |
|  aws-lambda             |  <i class="fa fa-check"></i>  |  <i class="fa fa-check"></i>  |
|  azure-functions        |  <i class="fa fa-check"></i>  |  <i class="fa fa-check"></i>  |
|  basic-auth             |  <i class="fa fa-check"></i>  |  <i class="fa fa-check"></i>  |
|  bot-detection          |  <i class="fa fa-check"></i>  |  <i class="fa fa-check"></i>  |
|  correlation-id         |  <i class="fa fa-check"></i>  |  <i class="fa fa-check"></i>  |
|  cors                   |  <i class="fa fa-check"></i>  |  <i class="fa fa-check"></i>  |
|  datadog                |  <i class="fa fa-check"></i>  |  <i class="fa fa-check"></i>  |
|  file-log               |  <i class="fa fa-check"></i>  |  <i class="fa fa-check"></i>  |
|  hmac-auth              |  <i class="fa fa-check"></i>  |  <i class="fa fa-check"></i>  |
|  http-log               |  <i class="fa fa-check"></i>  |  <i class="fa fa-check"></i>  |
|  ip-restriction         |  <i class="fa fa-check"></i>  |  <i class="fa fa-check"></i>  |
|  jwt                    |  <i class="fa fa-check"></i>  |  <i class="fa fa-check"></i>  |
|  key-auth               |  <i class="fa fa-check"></i>  |  <i class="fa fa-check"></i>  |
|  oauth2                 |  <i class="fa fa-check"></i>  |  <i class="fa fa-times"></i>  |
|  post-function          |  <i class="fa fa-check"></i>  |  <i class="fa fa-check"></i>  |
|  pre-function           |  <i class="fa fa-check"></i>  |  <i class="fa fa-check"></i>  |
|  prometheus             |  <i class="fa fa-check"></i>  |  <i class="fa fa-check"></i>  |
|  proxy-cache            |  <i class="fa fa-check"></i>  |  <i class="fa fa-check"></i>  |
|  rate-limiting          |  <i class="fa fa-check"></i>  |  <i class="fa fa-check"></i>  |
|  request-termination    |  <i class="fa fa-check"></i>  |  <i class="fa fa-check"></i>  |
|  request-transformer    |  <i class="fa fa-check"></i>  |  <i class="fa fa-check"></i>  |
|  response-ratelimiting  |  <i class="fa fa-check"></i>  |  <i class="fa fa-check"></i>  |
|  response-transformer   |  <i class="fa fa-check"></i>  |  <i class="fa fa-check"></i>  |
|  syslog                 |  <i class="fa fa-check"></i>  |  <i class="fa fa-check"></i>  |
|  tcp-log                |  <i class="fa fa-check"></i>  |  <i class="fa fa-check"></i>  |
|  udp-log                |  <i class="fa fa-check"></i>  |  <i class="fa fa-check"></i>  |
|  zipkin                 |  <i class="fa fa-check"></i>  |  <i class="fa fa-check"></i>  |

## Kong Enterprise

There are [two distributions of Kong Enterprise](https://github.com/Kong/kubernetes-ingress-controller/tree/master/docs/deployment#overview),
`kong-enterprise-k8s` (used with Kong for Kubernetes Enterprise) and
`kong-enterprise-edition` (used with Kong for Kubernetes with Kong Enterprise).

{% include md/enterprise/k8s-image-note.md %}

|  Plugin                          |  Kong for Kubernetes with Kong Enterprise  |  Kong for Kubernetes Enterprise           |
|----------------------------------|--------------------------------------------|-------------------------------------------|
|  acl                             |  <i class="fa fa-check"></i>               |  <i class="fa fa-check"></i>              |
|  aws-lambda                      |  <i class="fa fa-check"></i>               |  <i class="fa fa-check"></i>              |
|  azure-functions                 |  <i class="fa fa-check"></i>               |  <i class="fa fa-check"></i>              |
|  basic-auth                      |  <i class="fa fa-check"></i>               |  <i class="fa fa-check"></i>              |
|  bot-detection                   |  <i class="fa fa-check"></i>               |  <i class="fa fa-check"></i>              |
|  correlation-id                  |  <i class="fa fa-check"></i>               |  <i class="fa fa-check"></i>              |
|  cors                            |  <i class="fa fa-check"></i>               |  <i class="fa fa-check"></i>              |
|  datadog                         |  <i class="fa fa-check"></i>               |  <i class="fa fa-check"></i>              |
|  file-log                        |  <i class="fa fa-check"></i>               |  <i class="fa fa-check"></i>              |
|  hmac-auth                       |  <i class="fa fa-check"></i>               |  <i class="fa fa-check"></i>              |
|  http-log                        |  <i class="fa fa-check"></i>               |  <i class="fa fa-check"></i>              |
|  ip-restriction                  |  <i class="fa fa-check"></i>               |  <i class="fa fa-check"></i>              |
|  jwt                             |  <i class="fa fa-check"></i>               |  <i class="fa fa-check"></i>              |
|  key-auth                        |  <i class="fa fa-check"></i>               |  <i class="fa fa-check"></i>              |
|  oauth2                          |  <i class="fa fa-check"></i>               |  <i class="fa fa-times"></i>              |
|  post-function                   |  <i class="fa fa-check"></i>               |  <i class="fa fa-check"></i>              |
|  pre-function                    |  <i class="fa fa-check"></i>               |  <i class="fa fa-check"></i>              |
|  prometheus                      |  <i class="fa fa-check"></i>               |  <i class="fa fa-check"></i>              |
|  proxy-cache                     |  <i class="fa fa-check"></i>               |  <i class="fa fa-check"></i>              |
|  rate-limiting                   |  <i class="fa fa-check"></i>               |  <i class="fa fa-check"></i>              |
|  request-termination             |  <i class="fa fa-check"></i>               |  <i class="fa fa-check"></i>              |
|  request-transformer             |  <i class="fa fa-check"></i>               |  <i class="fa fa-check"></i>              |
|  response-ratelimiting           |  <i class="fa fa-check"></i>               |  <i class="fa fa-check"></i>              |
|  response-transformer            |  <i class="fa fa-check"></i>               |  <i class="fa fa-check"></i>              |
|  syslog                          |  <i class="fa fa-check"></i>               |  <i class="fa fa-check"></i>              |
|  tcp-log                         |  <i class="fa fa-check"></i>               |  <i class="fa fa-check"></i>              |
|  udp-log                         |  <i class="fa fa-check"></i>               |  <i class="fa fa-check"></i>              |
|  zipkin                          |  <i class="fa fa-check"></i>               |  <i class="fa fa-check"></i>              |
|  application-registration        |  <i class="fa fa-check"></i>               |  <i class="fa fa-times"></i><sup>1</sup>  |
|  canary release                  |  <i class="fa fa-check"></i>               |  <i class="fa fa-check"></i>              |
|  collector                       |  <i class="fa fa-check"></i>               |  <i class="fa fa-check"></i>              |
|  degraphql                       |  <i class="fa fa-check"></i>               |  <i class="fa fa-check"></i>              |
|  exit-transformer                |  <i class="fa fa-check"></i>               |  <i class="fa fa-times"></i>              |
|  forward-proxy                   |  <i class="fa fa-check"></i>               |  <i class="fa fa-check"></i>              |
|  graphql-proxy-cache-advanced    |  <i class="fa fa-check"></i>               |  <i class="fa fa-check"></i>              |
|  graphql-rate-limiting-advanced  |  <i class="fa fa-check"></i>               |  <i class="fa fa-check"></i>              |
|  jwt-signer                      |  <i class="fa fa-check"></i>               |  <i class="fa fa-check"></i>              |
|  kafka-log                       |  <i class="fa fa-check"></i>               |  <i class="fa fa-check"></i>              |
|  kafka-upstream                  |  <i class="fa fa-check"></i>               |  <i class="fa fa-check"></i>              |
|  key-auth-enc                    |  <i class="fa fa-check"></i>               |  <i class="fa fa-times"></i>              |
|  ldap-auth-advanced              |  <i class="fa fa-check"></i>               |  <i class="fa fa-check"></i>              |
|  mtls-auth                       |  <i class="fa fa-check"></i>               |  <i class="fa fa-check"></i>              |
|  oauth2-introspection            |  <i class="fa fa-check"></i>               |  <i class="fa fa-check"></i>              |
|  openid-connect                  |  <i class="fa fa-check"></i>               |  <i class="fa fa-check"></i>              |
|  proxy-cache-advanced            |  <i class="fa fa-check"></i>               |  <i class="fa fa-check"></i>              |
|  rate-limiting-advanced          |  <i class="fa fa-check"></i>               |  <i class="fa fa-check"></i>              |
|  request-transformer-advanced    |  <i class="fa fa-check"></i>               |  <i class="fa fa-times"></i><sup>2</sup>  |
|  request-validator               |  <i class="fa fa-check"></i>               |  <i class="fa fa-check"></i>              |
|  response-transformer-advanced   |  <i class="fa fa-check"></i>               |  <i class="fa fa-check"></i>              |
|  route-transformer-advanced      |  <i class="fa fa-check"></i>               |  <i class="fa fa-times"></i>              |
|  statsd-advanced                 |  <i class="fa fa-check"></i>               |  <i class="fa fa-times"></i><sup>3</sup>  |
|  vault-auth                      |  <i class="fa fa-check"></i>               |  <i class="fa fa-check"></i>              |

<sup>1</sup> Only used with Dev Portal

<sup>2</sup> request-transformer now has feature parity with
  request-transformer-advanced. request-transformer-advanced remains only for
  compatibility with existing configurations.

<sup>3</sup> Only used with Vitals
