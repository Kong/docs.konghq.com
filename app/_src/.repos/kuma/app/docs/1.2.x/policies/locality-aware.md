---
title: Locality Aware Load Balancing
---

A [multi-zone deployment](/docs/{{ page.version }}/documentation/deployments/) can enable locality aware load balancing in a particular [Mesh](/docs/{{ page.version }}/policies/mesh/) to ensure optimal service backend routing. This feature relies on the following service tags to make decisions of selecting the destination service endpoint:

 * `kuma.io/region` - optional, denotes a wider region composed of several zones.
 * `kuma.io/zone` - automatically generate in every multi-zone deployment.
 * `kuma.io/subzone` - optional, denotes service grouping within a particular zone.

## Enabling the Locality Aware Load Balancing

A particular `Mesh` that spans several regions, zones or subzones, may choose to enable locality aware load balancing as follows:

{% tabs load-balancing useUrlFragment=false %}
{% tab load-balancing Kubernetes %}
```yaml
apiVersion: kuma.io/v1alpha1
kind: Mesh
metadata:
  name: default
spec:
  routing:
    localityAwareLoadBalancing: true
```

We will apply the configuration with `kubectl apply -f [..]`.
{% endtab %}

{% tab load-balancing Universal %}
```yaml
type: Mesh
name: default
routing:
  localityAwareLoadBalancing: true
```

We will apply the configuration with `kumactl apply -f [..]` or via the [HTTP API](/docs/{{ page.version }}/documentation/http-api).
{% endtab %}
{% endtabs %}
