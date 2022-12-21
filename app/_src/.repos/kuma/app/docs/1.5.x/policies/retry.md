---
title: Retry
---

This policy enables Kuma to know how to behave if there is a failed scenario (i.e. HTTP request) which could be retried.

## Usage

As usual, we can apply `sources` and `destinations` selectors to determine how retries will be performed across our data plane proxies.

The policy let you configure retry behaviour for `HTTP`, `GRPC` and `TCP` protocols.

### Example

{% tabs usage useUrlFragment=false %}
{% tab usage Kubernetes %}
```yaml
apiVersion: kuma.io/v1alpha1
kind: Retry
mesh: default
metadata:
  name: web-to-backend-retry-policy
spec:
  sources:
  - match:
      kuma.io/service: web_default_svc_80
  destinations:
  - match:
      kuma.io/service: backend_default_svc_80
  conf:
    http:
      numRetries: 5
      perTryTimeout: 200ms
      backOff:
        baseInterval: 20ms
        maxInterval: 1s
      retriableStatusCodes:
      - 500
      - 504
      retriableMethods:
      - GET
    grpc:
      numRetries: 5
      perTryTimeout: 200ms
      backOff:
        baseInterval: 20ms
        maxInterval: 1s
      retryOn:
      - cancelled
      - deadline_exceeded
      - internal
      - resource_exhausted
      - unavailable
    tcp:
      maxConnectAttempts: 3
```
We will apply the configuration with `kubectl apply -f [..]`.
{% endtab %}

{% tab usage Universal %}
```yaml
type: Retry
name: web-to-backend-retry-policy
mesh: default
sources:
- match:
    kuma.io/service: web
destinations:
- match:
    kuma.io/service: backend
conf:
  http:
    numRetries: 5
    perTryTimeout: 200ms
    backOff:
      baseInterval: 20ms
      maxInterval: 1s
    retriableStatusCodes:
    - 500
    - 504
    retriableMethods:
    - GET
    - DELETE
  grpc:
    numRetries: 5
    perTryTimeout: 200ms
    backOff:
      baseInterval: 20ms
      maxInterval: 1s
    retryOn:
    - cancelled
    - deadline_exceeded
    - internal
    - resource_exhausted
    - unavailable
  tcp:
    maxConnectAttempts: 3
```

We will apply the configuration with `kumactl apply -f [..]` or via the [HTTP API](/docs/{{ page.version }}/documentation/http-api).
{% endtab %}
{% endtabs %}


### HTTP

- **`numRetries`** (optional)

  Amount of attempts which will be made on failed (and retriable) requests

- **`perTryTimeout`** (optional)

  Amount of time after which retry attempt should timeout (i.e. all the values: `30000000ns`, `30ms`, `0.03s`, `0.0005m` are equivalent and can be used to express the same timeout value, equal to `30ms`)

- **`backOff`** (optional)

  Configuration of durations which will be used in exponential backoff strategy between retries

  - **`baseDuration`** (required)

    Base amount of time which should be taken between retries (i.e. `30ms`, `0.03s`, `0.0005m`)

  - **`maxInterval`** (optional)

    A maximal amount of time which will be taken between retries  (i.e. `1s`, `0.5m`)

- **`retriableStatusCodes`** (optional)

  A list of status codes which will cause the request to be retried. When this field will be provided it will overwrite the default behaviour of accepting as retriable codes: `502`, `503` and `504` and if they also should be considered as `retriable` you have to manually place them in the list

  For example to add a status code `418`:
  ```yaml
  retriableStatusCodes:
  - 418
  - 502
  - 503
  - 504
  ```

{% capture tooltip %}
{% tip %}
Note that if you won't provide `retriableStatusCodes`, the default behaviour of the policy is to retry:
- when server responds with one of status codes: `502`, `503` or `504`,
- when server won't respond at all (disconnect/reset/read timeout),
- when server resets the stream with a `REFUSED_STREAM` error code.
{% endtip %}
{% endcapture %}
{{ tooltip | indent }}

- **`retriableMethods`** (optional)

  A list of HTTP methods in which a request's method must be contained before that request can be retried. The default behavior is that all methods are retriable.


### GRPC

You can configure your GRPC Retry policy in similar fashion as the HTTP one with the only difference of the `retryOn` property which replace the `retriableStatusCodes` from the HTTP policy

- **`retryOn`** (optional)

  List of values which will cause retry.

  **Acceptable values**

  - `cancelled`
  - `deadline_exceeded`
  - `internal`
  - `resource_exhausted`
  - `unavailable`

{% capture tooltip %}
{% tip %}
Note that if `retryOn` is not defined or if it's empty, the policy will default to all values and is equivalent to:

```yaml
retryOn:
- cancelled
- deadline_exceeded
- internal
- resource_exhausted
- unavailable
```
{% endtip %}
{% endcapture %}
{{ tooltip | indent }}

### TCP

- **`maxConnectAmount`** (required)

  A maximal amount of TCP connection attempts which will be made before giving up

{% capture tooltip %}
{% tip %}
This policy will make attempt to retry the TCP connection which fail to be established and will be applied in the scenario when both, the dataplane, and the TCP service matched as a destination will be down.
{% endtip %}
{% endcapture %}
{{ tooltip | indent }}

## Matching

`Retry` is an [Outbound Connection Policy](/docs/{{ page.version }}/policies/how-kuma-chooses-the-right-policy-to-apply/#outbound-connection-policy).
The only supported value for `destinations.match` is `kuma.io/service`.

## Builtin Gateway support

Retries can be configured on each route by matching the `Retry` connection policy to the backend destination tags.
