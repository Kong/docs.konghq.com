---
title: Rate Limit
---

{% tip %}
Rate Limit is an inbound policy. Dataplanes whose configuration is modified are in the `destinations` matcher.
{% endtip %}

The `RateLimit` policy leverages
Envoy's [local rate limiting](https://www.envoyproxy.io/docs/envoy/latest/configuration/http/http_filters/local_rate_limit_filter)
to allow for per-instance service request limiting. All HTTP/HTTP2 based requests are supported.

You can configure how many requests are allowed in a specified time period, and how the service responds when the limit is reached.

The policy is applied per service instance. This means that if a service `backend` has 3 instances rate limited to 100 requests per second, the overall service is rate limited to 300 requests per second.

When rate limiting to an [ExternalService](/docs/{{ page.version }}/policies/external-services), the policy is applied per sending service instance.`
## Usage

{% tabs usage useUrlFragment=false %}
{% tab usage Kubernetes %}

```yaml
apiVersion: kuma.io/v1alpha1
kind: RateLimit
mesh: default
metadata:
  name: rate-limit-all-to-backend
spec:
  sources:
    - match:
        kuma.io/service: "*"
  destinations:
    - match:
        kuma.io/service: backend_default_svc_80
  conf:
    http:
      requests: 5
      interval: 10s
      onRateLimit:
        status: 423
        headers:
          - key: "x-kuma-rate-limited"
            value: "true"
            append: true
```

Apply the configuration with `kubectl apply -f [..]`.
{% endtab %}

{% tab usage Universal %}

```yaml
type: RateLimit
mesh: default
name: rate-limit-all-to-backend
sources:
  - match:
      kuma.io/service: "*"
destinations:
  - match:
      kuma.io/service: backend
conf:
  http:
    requests: 5
    interval: 10s
    onRateLimit:
      status: 423
      headers:
        - key: "x-kuma-rate-limited"
          value: "true"
          append: true
```

Apply the configuration with `kumactl apply -f [..]` or with the [HTTP API](/docs/{{ page.version }}/documentation/http-api).
{% endtab %}
{% endtabs %}

### Configuration fields

The `conf` section of the `RateLimit` resource provides the following configuration options:

- **`http`** -
    - **`requests`** - the number of requests to limit
    - **`interval`** - the interval for which `requests` will be limited
    - **`onRateLimit`** (optional) - actions to take on RateLimit event
        - **`status`**  (optional) - the status code to return, defaults to `429`
        - **`headers`** - list of headers which should be added to every rate limited response:
            - **`key`** - the name of the header
            - **`value`** - the value of the header
            - **`append`** (optional) - should the value of the provided header be appended to already existing
              headers (if present)

### Matching sources

This policy is applied on the destination data plane proxy and generates a set of matching rules for the originating
service. These matching rules are ordered from the most specific one, to the more generic ones. Given the
following `RateLimit` resources:

```yaml
apiVersion: kuma.io/v1alpha1
kind: RateLimit
mesh: default
metadata:
  name: rate-limit-all-to-backend
spec:
  sources:
    - match:
        kuma.io/service: "*"
  destinations:
    - match:
        kuma.io/service: backend_default_svc_80
  conf:
    http:
      requests: 5
      interval: 10s
---
apiVersion: kuma.io/v1alpha1
kind: RateLimit
mesh: default
metadata:
  name: rate-limit-frontend
spec:
  sources:
    - match:
        kuma.io/service: "frontend_default_svc_80"
  destinations:
    - match:
        kuma.io/service: backend_default_svc_80
  conf:
    http:
      requests: 10
      interval: 10s
---
apiVersion: kuma.io/v1alpha1
kind: RateLimit
mesh: default
metadata:
  name: rate-limit-frontend-zone-eu
spec:
  sources:
    - match:
        kuma.io/service: "frontend_default_svc_80"
        kuma.io/zone:    "eu"
  destinations:
    - match:
        kuma.io/service: backend_default_svc_80
  conf:
    http:
      requests: 20
      interval: 10s
```

The service `backend` is configured with the following rate limiting hierarchy:
 - `rate-limit-frontend-zone-eu`
 - `rate-limit-frontend`
 - `rate-limit-all-to-backend`


## Matching destinations

`RateLimit`, when applied to a dataplane proxy bound Kuma service, is an [Inbound Connection Policy](/docs/{{ page.version }}/policies/how-kuma-chooses-the-right-policy-to-apply#outbound-connection-policy).

When applied to an [ExternalService](/docs/{{ page.version }}/policies/external-services), `RateLimit` is an [Outbound Connection Policy](/docs/{{ page.version }}/policies/how-kuma-chooses-the-right-policy-to-apply/#outbound-connection-policy). In this case, the only supported value for `destinations.match` is `kuma.io/service`.

## Builtin Gateway support

Kuma Gateway supports the `RateLimit` connection policy.
Rate limits are configured on each Envoy route by selecting the best Rate Limit policy that matches the source and destination.
