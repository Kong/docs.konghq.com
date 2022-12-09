---
title: Traffic Route
---

This policy allows us to configure routing rules for L4 traffic running in our [Mesh](/docs/{{ page.version }}/policies/mesh). This policy provides support for weighted routing and can be used to implement versioning across our services as well as deployment strategies like blue/green and canary.

`TrafficRoute` must select the data plane proxies to route the connection between them.

Kuma also supports [locality aware load balancing](/docs/{{ page.version }}/policies/locality-aware).

### Default TrafficRoute

The control plane creates a default `TrafficRoute` every time the new `Mesh` is created. The default `TrafficRoute` enables the traffic between all the services in the mesh. 

{% tabs default useUrlFragment=false %}
{% tab default Kubernetes %}
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
    split:
      - weight: 100
        destination:
          kuma.io/service: '*'
```
{% endtab %}

{% tab default Universal %}
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
  split:
    - weight: 100
      destination:
        kuma.io/service: '*'
```
{% endtab %}
{% endtabs %}

## Usage

By default when a service makes a request to another service, Kuma will round robin the request across every data plane proxy belogning to the destination service. It is possible to change this behavior by using this policy, for example:

{% tabs usage useUrlFragment=false %}
{% tab usage Kubernetes %}
```yaml
apiVersion: kuma.io/v1alpha1
kind: TrafficRoute
mesh: default
metadata:
  name: route-example
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

We will apply the configuration with `kubectl apply -f [..]`.
{% endtab %}

{% tab usage Universal %}
```yaml
type: TrafficRoute
name: route-example
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

We will apply the configuration with `kumactl apply -f [..]` or via the [HTTP API](/docs/{{ page.version }}/documentation/http-api).
{% endtab %}
{% endtabs %}

In this example the `TrafficRoute` policy assigns a positive weight of `90` to the version `1.0` of the `redis` service and a positive weight of `10` to the version `2.0` of the `redis` service. 

{% tip %}
Note that routing can be applied not just on the automatically provisioned `service` Kuma tag, but on any other tag that we may want to add to our data plane proxies (like `version` in the example above).
{% endtip %}

Kuma utilizes positive weights in the `TrafficRoute` policy and not percentages, therefore Kuma does not check if the total adds up to 100. If we want to stop sending traffic to a destination service we change the `weight` for that service to 0.

## Load balancer types

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

## Matching

`TrafficRoute` is an [Outbound Connection Policy](/docs/{{ page.version }}/policies/how-kuma-chooses-the-right-policy-to-apply/#outbound-connection-policy).
You can only use `kuma.io/service` in the `destinations` section. However, you can use all the tags in `conf.split.destination`.
