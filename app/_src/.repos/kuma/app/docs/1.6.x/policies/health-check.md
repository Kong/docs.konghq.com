---
title: Health Check
---

{% tip %}
Health Check is an outbound policy. Dataplanes whose configuration is modified are in the `sources` matcher.
{% endtip %}

This policy enables Kuma to keep track of the health of every data plane proxy, with the goal of minimizing the number of failed requests in case a data plane proxy is temporarily unhealthy.

By creating an `HealthCheck` resource we can instruct a data plane proxy to keep track of the health status for any other data plane proxy. When health-checks are properly configured, a data plane proxy will never send a request to another data plane proxy that is considered unhealthy. When an unhealthy proxy returns to a healthy state, Kuma will resume sending requests to it again.

This policy provides **active** checks. If you want to configure **passive** checks, please utilize the [Circuit Breaker](/docs/{{ page.version }}/policies/circuit-breaker) policy. Data plane proxies with **active** checks will explicitly send requests to other data plane proxies to determine if target proxies are healthy or not. This mode generates extra traffic to other proxies and services as described in the policy configuration.

## Usage

As usual, we can apply `sources` and `destinations` selectors to determine how health-checks will be performed across our data plane proxies.

The `HealthCheck` policy supports both L4/TCP (default) and L7/HTTP checks.

### Examples

{% tabs usage useUrlFragment=false %}
{% tab usage Kubernetes %}

```yaml
apiVersion: kuma.io/v1alpha1
kind: HealthCheck
mesh: default
metadata:
  name: web-to-backend-check
spec:
  sources:
  - match:
      kuma.io/service: web_default_svc_80
  destinations:
  - match:
      kuma.io/service: backend_default_svc_80
  conf:
    interval: 10s
    timeout: 2s
    unhealthyThreshold: 3
    healthyThreshold: 1
    initialJitter: 5s # optional
    intervalJitter: 6s # optional
    intervalJitterPercent: 10 # optional
    healthyPanicThreshold: 60 # optional, by default 50
    failTrafficOnPanic: true # optional, by default false
    noTrafficInterval: 10s # optional, by default 60s
    eventLogPath: "/tmp/health-check.log" # optional
    alwaysLogHealthCheckFailures: true # optional, by default false
    reuseConnection: false # optional, by default true
    tcp: # only one of tcp or http can be defined
      send: Zm9v
      receive:
      - YmFy
      - YmF6
    http:
      path: /health
      requestHeadersToAdd:
      - append: false
        header:
          key: Content-Type
          value: application/json
      - header:
          key: Accept
          value: application/json
      expectedStatuses: [200, 201]
```
We will apply the configuration with `kubectl apply -f [..]`.
{% endtab %}

{% tab usage Universal %}

```yaml
type: HealthCheck
name: web-to-backend-check
mesh: default
sources:
- match:
    kuma.io/service: web
destinations:
- match:
    kuma.io/service: backend
conf:
  interval: 10s
  timeout: 2s
  unhealthyThreshold: 3
  healthyThreshold: 1
  initialJitter: 5s # optional
  intervalJitter: 6s # optional
  intervalJitterPercent: 10 # optional
  healthyPanicThreshold: 60 # optional, by default 50
  failTrafficOnPanic: true # optional, by default false
  noTrafficInterval: 10s # optional, by default 60s
  eventLogPath: "/tmp/health-check.log" # optional
  alwaysLogHealthCheckFailures: true # optional, by default false
  reuseConnection: false # optional, by default true
  tcp: # only one of tcp or http can be defined
    send: Zm9v
    receive:
    - YmFy
    - YmF6
  http:
    path: /health
    requestHeadersToAdd:
    - append: false
      header:
        key: Content-Type
        value: application/json
    - header:
        key: Accept
        value: application/json
    expectedStatuses: [200, 201]
```
We will apply the configuration with `kumactl apply -f [..]` or via the [HTTP API](/docs/{{ page.version }}/reference/http-api).
{% endtab %}
{% endtabs %}

### HTTP

HTTP health checks are executed using HTTP 2

- **`path`** - HTTP path which will be requested during the health checks
- **`expectedStatuses`** (optional) - list of status codes which should be
  considered as a healthy during the checks
  - only statuses in the range `[100, 600)` are allowed
  - by default, when this property is not provided only responses with
    status code `200` are being considered healthy
- **`requestHeadersToAdd`** (optional) - list of headers which should be
  added to every health check request:
  - **`append`** (default, optional) - should the value of the provided
    header be appended to already existing headers (if present)
  - **`header`**:
    - **`key`** - the name of the header
    - **`value`** (optional) - the value of the header

### TCP

- **`send`** - Base64 encoded content of the message which should be
  sent during the health checks
- **`receive`** list of Base64 encoded blocks of strings which should be
  found in the returning message which should be considered as healthy
  - when checking the response, “fuzzy” matching is performed such that
    each block must be found, and in the order specified, but not
    necessarily contiguous;
  - if **`receive`** section won't be provided or will be empty, checks
    will be performed as "connect only" and will be marked as successful
    when TCP connection will be successfully established.

## Matching

`HealthCheck` is an [Outbound Connection Policy](/docs/{{ page.version }}/policies/how-kuma-chooses-the-right-policy-to-apply/#outbound-connection-policy).
The only supported value for `destinations.match` is `kuma.io/service`.
