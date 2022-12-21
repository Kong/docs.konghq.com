---
title: Traffic Route
---

{% tip %}
Traffic Route is an outbound policy. Dataplanes whose configuration is modified are in the `sources` matcher.
{% endtip %}

This policy lets you configure routing rules for the traffic in the mesh. It supports weighted routing and can be used to implement versioning across services or to support deployment strategies such as blue/green or canary.

Note the following:

- The configuration must specify the data plane proxies for the routing rules.
- The `spec.destinations` field supports only `kuma.io/service`.
- All available tags are supported for `spec.conf`.
- This is an outbound connection policy. Make sure that your data plane proxy configuration [includes the appropriate tags](/docs/{{ page.version }}/policies/how-kuma-chooses-the-right-policy-to-apply/#outbound-connection-policy). 

Kuma also supports [locality aware load balancing](/docs/{{ page.version }}/policies/locality-aware).

### Default TrafficRoute

The control plane creates a default `TrafficRoute` every time a new `Mesh` is created. The default `TrafficRoute` enables the traffic between all the services in the mesh. 

{% tabs default-traffic-route useUrlFragment=false %}
{% tab default-traffic-route Kubernetes %}
```yaml
apiVersion: kuma.io/v1alpha1
kind: TrafficRoute
mesh: default
metadata:
  name: route-all-default
spec:
  sources:
    - match:
        kuma.io/service: '*'
  destinations:
    - match:
        kuma.io/service: '*'
  conf:
    loadBalancer:
      roundRobin: {}
    destination:
      kuma.io/service: '*'
```
{% endtab %}

{% tab default-traffic-route Universal %}
```yaml
type: TrafficRoute
name: route-all-default
mesh: default
sources:
  - match:
      kuma.io/service: '*'
destinations:
  - match:
      kuma.io/service: '*'
conf:
  loadBalancer:
    roundRobin: {}
  destination:
    kuma.io/service: '*'
```
{% endtab %}
{% endtabs %}

## Usage

Here is a full example of `TrafficRoute` policy

{% tabs usage useUrlFragment=false %}
{% tab usage Kubernetes %}
```yaml
apiVersion: kuma.io/v1alpha1
kind: TrafficRoute
mesh: default
metadata:
  name: full-example
spec:
  sources:
    - match:
        kuma.io/service: backend_default_svc_80
  destinations:
    - match:
        kuma.io/service: redis_default_svc_6379
  conf:
    http:
    - match:
        method: # one of either "prefix", "exact" or "regex" is allowed
          exact: GET
          regex: "^POST|PUT$"
        path: # one of either "prefix", "exact" or "regex" is allowed
          prefix: /users
          exact: /users/user-1
          regex: "^users$"
        headers:
          some-header: # one of either "prefix", "exact" or "regex" will be allowed
            exact: some-value
            prefix: some-
            regex: "^users$"
      modify: # optional section
        path: # one of "rewritePrefix" or "regex" is allowed
          rewritePrefix: /not-users # rewrites previously matched prefix
          regex: # (example to change the path from "/service/foo/v1/api" to "/v1/api/instance/foo")
            pattern: "^/service/([^/]+)(/.*)$"
            substitution: '\2/instance/\1'
        host: # one of "value" or "fromPath" is allowed
          value: "XYZ"
          fromPath: # (example to extract "envoyproxy.io" host header from "/envoyproxy.io/some/path" path)
            pattern: "^/(.+)/.+$"
            substitution: '\1'
        requestHeaders:
          add:
            - name: x-custom-header
              value: xyz
              append: true # if true then if there is x-custom-header already, it will append xyz to the value 
          remove:
            - name: x-something
        responseHeaders:
          add:
            - name: x-custom-header
              value: xyz
              append: true
          remove:
            - name: x-something
      destination: # one of "destination", "split" is allowed
        kuma.io/service: redis_default_svc_6379
      split:
        - weight: 100
          destination:
            kuma.io/service: redis_default_svc_6379
    destination: # one of "destination", "split" is allowed
      kuma.io/service: redis_default_svc_6379
    split:
      - weight: 100
        destination:
          kuma.io/service: redis_default_svc_6379
    loadBalancer: # one of "roundRobin", "leastRequest", "ringHash", "random", "maglev" is allowed    
      roundRobin: {}
      leastRequest:
        choiceCount: 8
      ringHash:
        hashFunction: "MURMUR_HASH_2"
        minRingSize: 64
        maxRingSize: 1024
      random: {}
      maglev: {}
```
{% endtab %}

{% tab usage Universal %}
```yaml
type: TrafficRoute
name: full-example
mesh: default
sources:
  - match:
      kuma.io/service: backend
destinations:
  - match:
      kuma.io/service: redis
conf:
  http:
    - match:
        method: # one of either "prefix", "exact" or "regex" is allowed
          exact: GET
          regex: "^POST|PUT$"
        path: # one of either "prefix", "exact" or "regex" is allowed
          prefix: /users
          exact: /users/user-1
          regex: "^users$"
        headers:
          some-header: # one of either "prefix", "exact" or "regex" will be allowed
            exact: some-value
            prefix: some-
            regex: "^users$"
      modify: # optional section
        path: # one of "rewritePrefix" or "regex" is allowed
          rewritePrefix: /not-users # rewrites previously matched prefix
          regex: # (example to change the path from "/service/foo/v1/api" to "/v1/api/instance/foo")
            pattern: "^/service/([^/]+)(/.*)$"
            substitution: '\2/instance/\1'
        host: # one of "value" or "fromPath" is allowed
          value: "XYZ"
          fromPath: # (example to extract "envoyproxy.io" host header from "/envoyproxy.io/some/path" path)
            pattern: "^/(.+)/.+$"
            substitution: '\1'
        requestHeaders:
          add:
            - name: x-custom-header
              value: xyz
              append: true # if true then if there is x-custom-header already, it will append xyz to the value 
          remove:
            - name: x-something
        responseHeaders:
          add:
            - name: x-custom-header
              value: xyz
              append: true
          remove:
            - name: x-something
      destination: # one of "destination", "split" is allowed
        kuma.io/service: redis
      split:
        - weight: 100
          destination:
            kuma.io/service: redis
  destination: # one of "destination", "split" is allowed
    kuma.io/service: redis
  split:
    - weight: 100
      destination:
        kuma.io/service: redis
  loadBalancer: # one of "roundRobin", "leastRequest", "ringHash", "random", "maglev" is allowed    
    roundRobin: {}
    leastRequest:
      choiceCount: 8
    ringHash:
      hashFunction: "MURMUR_HASH_2"
      minRingSize: 64
      maxRingSize: 1024
    random: {}
    maglev: {}
```
{% endtab %}
{% endtabs %}

Kuma utilizes positive weights in the `TrafficRoute` policy and not percentages, therefore Kuma does not check if the total adds up to 100. If we want to stop sending traffic to a destination service we change the `weight` for that service to 0.

### L4 Traffic Split

We can use `TrafficRoute` to split a TCP traffic between services with different tags implementing A/B testing or canary deployments.

Here is an example of a `TrafficRoute` that splits the traffic over the two different versions of the application.
90% of the connections from `backend_default_svc_80` service will be initiated to `redis_default_svc_6379` with tag `version: 1.0`
and 10% of the connections will be initiated to `version: 2.0`  

{% tabs l4-traffic-split useUrlFragment=false %}
{% tab l4-traffic-split Kubernetes %}
```yaml
apiVersion: kuma.io/v1alpha1
kind: TrafficRoute
mesh: default
metadata:
  name: split-traffic
spec:
  sources:
    - match:
        kuma.io/service: backend_default_svc_80
  destinations:
    - match:
        kuma.io/service: redis_default_svc_6379
  conf:
    split:
      - weight: 90
        destination:
          kuma.io/service: redis_default_svc_6379
          version: '1.0'
      - weight: 10
        destination:
          kuma.io/service: redis_default_svc_6379
          version: '2.0'
```
{% endtab %}

{% tab l4-traffic-split Universal %}
```yaml
type: TrafficRoute
name: split-traffic
mesh: default
sources:
  - match:
      kuma.io/service: backend
destinations:
  - match:
      kuma.io/service: redis
conf:
  split:
    - weight: 90
      destination:
        kuma.io/service: redis
        version: '1.0'
    - weight: 10
      destination:
        kuma.io/service: redis
        version: '2.0'
```
{% endtab %}
{% endtabs %}

### L4 Traffic Rerouting

We can use `TrafficRoute` to fully reroute a TCP traffic to different version of a service or even completely different service.

Here is an example of a `TrafficRoute` that redirects the traffic to `another-redis_default_svc_6379` when `backend_default_svc_80` is trying to consume `redis_default_svc_6379`.  

{% tabs l4-traffic-rerouting useUrlFragment=false %}
{% tab l4-traffic-rerouting Kubernetes %}
```yaml
apiVersion: kuma.io/v1alpha1
kind: TrafficRoute
mesh: default
metadata:
  name: reroute-traffic
spec:
  sources:
    - match:
        kuma.io/service: backend_default_svc_80
  destinations:
    - match:
        kuma.io/service: redis_default_svc_6379
  conf:
    destination:
      kuma.io/service: another-redis_default_svc_6379
```
{% endtab %}

{% tab l4-traffic-rerouting Universal %}
```yaml
type: TrafficRoute
name: reroute-traffic
mesh: default
sources:
  - match:
      kuma.io/service: backend_default_svc_80
destinations:
  - match:
      kuma.io/service: redis_default_svc_6379
conf:
  destination:
    kuma.io/service: another-redis_default_svc_6379
```
{% endtab %}
{% endtabs %}

### L7 Traffic Split

We can use `TrafficRoute` to split an HTTP traffic between services with different tags implementing A/B testing or canary deployments.

Here is an example of a `TrafficRoute` that splits the traffic from `frontend_default_svc_80` to `backend_default_svc_80` between versions,
but only on endpoints starting with `/api`. All other endpoints will go to `version: 1.0` 

{% tabs l7-traffic-split useUrlFragment=false %}
{% tab l7-traffic-split Kubernetes %}
```yaml
apiVersion: kuma.io/v1alpha1
kind: TrafficRoute
mesh: default
metadata:
  name: api-split
spec:
  sources:
    - match:
        kuma.io/service: frontend_default_svc_80
  destinations:
    - match:
        kuma.io/service: backend_default_svc_80
  conf:
    http:
    - match:
        path:
          prefix: "/api"
      split:
      - weight: 90
        destination:
          kuma.io/service: backend_default_svc_80
          version: '1.0'
      - weight: 10
        destination:
          kuma.io/service: backend_default_svc_80
          version: '2.0'
    destination: # default rule is applied when endpoint does not match any rules in http section
      kuma.io/service: backend_default_svc_80
      version: '1.0'
```
{% endtab %}

{% tab l7-traffic-split Universal %}
```yaml
type: TrafficRoute
name: api-split
mesh: default
sources:
  - match:
      kuma.io/service: frontend_default_svc_80
destinations:
  - match:
      kuma.io/service: backend_default_svc_80
conf:
  http:
    - match:
        path:
          prefix: "/api"
      split:
        - weight: 90
          destination:
            kuma.io/service: backend_default_svc_80
            version: '1.0'
        - weight: 10
          destination:
            kuma.io/service: backend_default_svc_80
            version: '2.0'
  destination: # default rule is applied when endpoint does not match any rules in http section
    kuma.io/service: backend_default_svc_80
    version: '1.0'
```
{% endtab %}
{% endtabs %}

{% tip %}
In order to use L7 Traffic Split, we need to [mark the destination service with `kuma.io/protocol: http`](/docs/{{ page.version }}/policies/protocol-support-in-kuma).
{% endtip %}

### L7 Traffic Modification

We can use `TrafficRoute` to modify outgoing requests, by setting new path or changing request and response headers.

Here is an example of a `TrafficRoute` that adds `x-custom-header` with value `xyz` when `frontend_default_svc_80` tries to consume `backend_default_svc_80`.

{% tabs l7-traffic-modification useUrlFragment=false %}
{% tab l7-traffic-modification Kubernetes %}
```yaml
apiVersion: kuma.io/v1alpha1
kind: TrafficRoute
mesh: default
metadata:
  name: add-header
spec:
  sources:
    - match:
        kuma.io/service: frontend_default_svc_80
  destinations:
    - match:
        kuma.io/service: backend_default_svc_80
  conf:
    http:
    - match:
        path:
          prefix: "/"
      modify:
        requestHeader:
          add:
            - name: x-custom-header
              value: xyz
      destination:
        kuma.io/service: backend_default_svc_80
    destination:
      kuma.io/service: backend_default_svc_80
```
{% endtab %}

{% tab l7-traffic-modification Universal %}
```yaml
type: TrafficRoute
name: add-header
mesh: default
sources:
  - match:
      kuma.io/service: frontend_default_svc_80
destinations:
  - match:
      kuma.io/service: backend_default_svc_80
conf:
  http:
    - match:
        path:
          prefix: "/"
      modify:
        requestHeader:
          add:
            - name: x-custom-header
              value: xyz
      destination:
        kuma.io/service: backend_default_svc_80
  destination:
    kuma.io/service: backend_default_svc_80
```
{% endtab %}
{% endtabs %}

{% tip %}
In order to use L7 Traffic Modification, we need to [mark the destination service with `kuma.io/protocol: http`](/docs/{{ page.version }}/policies/protocol-support-in-kuma).
{% endtip %}

### L7 Traffic Rerouting

We can use `TrafficRoute` to modify outgoing requests, by setting new path or changing request and response headers.

Here is an example of a `TrafficRoute` that redirect traffic to `offers_default_svc_80` when `frontend_default_svc_80` is trying to consume `backend_default_svc_80` on `/offers` endpoint.
{% tabs l7-traffic-rerouting useUrlFragment=false %}
{% tab l7-traffic-rerouting Kubernetes %}
```yaml
apiVersion: kuma.io/v1alpha1
kind: TrafficRoute
mesh: default
metadata:
  name: http-reroute
spec:
  sources:
    - match:
        kuma.io/service: frontend_default_svc_80
  destinations:
    - match:
        kuma.io/service: backend_default_svc_80
  conf:
    http:
    - match:
        path:
          prefix: "/offers"
      destination:
        kuma.io/service: offers_default_svc_80
    destination:
      kuma.io/service: backend_default_svc_80
```
{% endtab %}

{% tab l7-traffic-rerouting Universal %}
```yaml
type: TrafficRoute
name: http-reroute
mesh: default
sources:
  - match:
      kuma.io/service: frontend_default_svc_80
destinations:
  - match:
      kuma.io/service: backend_default_svc_80
conf:
  http:
    - match:
        path:
          prefix: "/offers"
      destination:
        kuma.io/service: offers_default_svc_80
  destination:
    kuma.io/service: backend_default_svc_80
```
{% endtab %}
{% endtabs %}

{% tip %}
In order to use L7 Traffic Rerouting, we need to [mark the destination service with `kuma.io/protocol: http`](/docs/{{ page.version }}/policies/protocol-support-in-kuma).
{% endtip %}

### Load balancer types

There are different load balancing algorithms that can be used to determine how traffic is routed to the destinations. By default `TrafficRoute` uses the `roundRobin` load balancer, but more options are available:

* `roundRobin` is a simple algorithm in which each available upstream host is selected in round robin order.

  Example:

  ```yaml
  loadBalancer:
    roundRobin: {}
  ```

* `leastRequest` uses different algorithms depending on whether the hosts have the same or different weights. It has a single configuration field `choiceCount`, which denotes the number of random healthy hosts from which the host with the fewer active requests will be chosen.

  Example:

  ```yaml
  loadBalancer:
    leastRequest:
      choiceCount: 8
  ```

* `ringHash` implements consistent hashing to the upstream hosts. It has the following fields:
  * `hashFunction` the hash function used to hash the hosts onto the ketama ring. Can be `XX_HASH` or `MURMUR_HASH_2`.
  * `minRingSize` minimum hash ring size.
  * `maxRingSize` maximum hash ring size.

  Example:

  ```yaml
  loadBalancer:
    ringHash:
      hashFunction: "MURMUR_HASH_2"
      minRingSize: 64
      maxRingSize: 1024
  ```

* `random` selects a random available host.

  Example:

  ```yaml
  loadBalancer:
    random: {}
  ```

* `maglev` implements consistent hashing to upstream hosts

  Example:

  ```yaml
  loadBalancer:
    maglev: {}
  ```
