---
title: Understanding TargetRef policies
---

## What is a policy?

A policy is a set of configuration that will be used to generate the proxy configuration.
{{ site.mesh_product_name }} combines policies with dataplane configuration to generate the Envoy configuration of a proxy.

## What do `targetRef` policies look like?

There are two parts in a policy:

1. The metadata
2. The spec

### Metadata

Metadata identifies the policies by its `name`, `type` and what `mesh` it is part of.

This is how it looks:

{% tabs metadata %}
{% tab metadata Universal %}

A policy metadata looks like:

```yaml
type: ExamplePolicy
name: my-policy-name
mesh: default
spec:
  ... # spec data specific to the policy kind
```

{% endtab %}
{% tab metadata Kubernetes %}

In Kubernetes all our policies are implemented as [custom resource definitions (CRD)](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/) in the group `kuma.io/v1alpha1`.

A policy metadata looks like:

```yaml
apiVersion: kuma.io/v1alpha1
kind: ExamplePolicy
metadata:
  name: my-policy-name
  namespace: {{site.default_namespace}}
spec:
  ... # spec data specific to the policy kind
```

By default the policy is created in the `default` mesh.
You can specify the mesh by using the `kuma.io/mesh` label.

For example:

```yaml
apiVersion: kuma.io/v1alpha1
kind: ExamplePolicy
metadata:
  name: my-policy-name
  namespace: {{site.default_namespace}}
  labels:
    kuma.io/mesh: "my-mesh"
spec:
  ... # spec data specific to the policy kind
```

{% warning %}
Policies are namespaced scope and currently the namespace must be the one the control-plane is running in `{{site.default_namespace}}` by default.
{% endwarning %}

{% endtab %}
{% endtabs %}

### Spec

The spec contains the actual configuration of the policy.

All specs have a **top level `targetRef`** which identifies which proxies this policy applies to.
In particular, it defines which proxies have their Envoy configuration modified.

Some policies also support further narrowing.

The `spec.to[].targetRef` field defines rules that applies to outgoing traffic of proxies selected by `spec.targetRef`.
The `spec.from[].targetRef` field defines rules that applies to incoming traffic of proxies selected by `spec.targetRef`.

The actual configuration is defined in a `default` map.

For example:

```yaml
type: ExamplePolicy
name: my-example
mesh: default
spec:
  targetRef:
    kind: Mesh
  to:
    - targetRef:
        kind: Mesh
      default: # Configuration that applies to outgoing traffic
        key: value
  from:
    - targetRef:
        kind: Mesh
      default: # Configuration that applies to incoming traffic
        key: value
```

Some policies are not directional and will not have `to` and `from`.
For example

```yaml
type: NonDirectionalPolicy
name: my-example
mesh: default
spec:
  targetRef:
    kind: Mesh
  default:
    key: value
```

{% tip %}
One of the benefits of `targetRef` policies is that the spec is always the same between Kubernetes and Universal.

This means that converting policies between Universal and Kubernetes only means rewriting the metadata.
{% endtip %}

#### Writing a `targetRef`

`targetRef` is a concept borrowed from [Kubernetes Gateway API](https://gateway-api.sigs.k8s.io/) its usage is fully defined in [MADR 005](https://github.com/kumahq/kuma/blob/master/docs/madr/decisions/005-policy-matching.md).
Its goal is to select subsets of proxies with maximum flexibility.

It looks like:

```yaml
targetRef:
  kind: Mesh | MeshSubset | MeshService | MeshServiceSubset | MeshGatewayRoute
  name: "my-name" # For kinds MeshService, MeshServiceSubset and MeshGatewayRoute a name can be defined
  tags:
    key: value # For kinds MeshServiceSubset and MeshSubset a list of matching tags can be used
```

Here's an explanation of each kinds and their scope:

- Mesh: applies to all proxies running in the mesh
- MeshSubset: same as Mesh but filters only proxies who have matching `targetRef.tags`
- MeshService: all proxies with a tag `kuma.io/service` equal to `targetRef.name`
- MeshServiceSubset: same as `MeshService` but further refine to proxies that have matching `targetRef.tags`
- MeshGatewayRoute: gateway using `MeshGatewayRoute` that have a name equal to `targetRef.name`

Consider the example below:

```yaml
apiVersion: kuma.io/v1alpha1
kind: MeshAccessLog
metadata:
  name: example
  namespace: {{site.default_namespace}}
  labels:
    kuma.io/mesh: default
spec:
  targetRef: # top level targetRef
    kind: MeshService
    name: web-frontend
  to:
    - targetRef: # to level targetRef
        kind: MeshService
        name: web-backend
      default:
        backends:
          - file:
              format:
                plain: '{"start_time": "%START_TIME%"}'
              path: "/tmp/logs.txt"
  from:
    - targetRef: # from level targetRef
        kind: Mesh
      default:
        backends:
          - file:
              format:
                plain: '{"start_time": "%START_TIME%"}'
              path: "/tmp/logs.txt"
```

Using `spec.targetRef`, this policy targets all proxies that implement the service `web-frontend`.
It defines the scope of this policy as applying to traffic either from or to `web-frontend` services.

The `spec.to.targetRef` section enables logging for any traffic going to `web-backend`.
The `spec.from.targetRef` section enables logging for any traffic coming from _any service_ in the `Mesh`.

### Target resources

Not every policy supports `to` and `from` levels. Additionally, not every resource can
appear at every supported level. The specified top level resource can also affect which
resources can appear in `to` or `from`.

To help users, each policy documentation includes a table indicating which `targetRef` kinds is supported at each level.

This table looks like:

| `targetRef.kind`    | top level | to  | from |
|---------------------| --------- | --- | ---- |
| `Mesh`              | ✅        | ✅  | ❌   |
| `MeshSubset`        | ✅        | ❌  | ❌   |
| `MeshService`       | ✅        | ❌  | ✅   |
| `MeshServiceSubset` | ✅        | ❌  | ❌   |
| `MeshGatewayRoute`  | ✅        | ❌  | ❌   |

Here it indicates that the top level can use any targetRef kinds. But in `targetRef.to` only kind `Mesh` can be used and in `targetRef.from` only kind `MeshService`.

### Merging configuration

It is necessary to define a policy for merging configuration,
because a proxy can be targeted by multiple `targetRef`'s.

We define a total order of policies:

- Mesh > MeshSubset > MeshService > MeshServiceSubset > MeshGatewayRoute (the more a `targetRef` is focused the higher priority it has)
- If levels are equal the lexicographic order of policy names is used

For `to` and `from` policies we concatenate the array for each matching policies.
We then build configuration by merging each level using [JSON patch merge](https://www.rfc-editor.org/rfc/rfc7386).

For example if I have 2 `default` ordered this way:

```yaml
default:
  conf: 1
  sub:
    array: [1, 2, 3]
    other: 50
    other-array: [3, 4, 5]
---
default:
  sub:
    array: []
    other: null
    other-array: [5, 6]
    extra: 2
```

The merge result is:
```yaml
default:
  conf: 1
  sub:
    array: []
    other-array: [5, 6]
    extra: 2
```

### Examples

#### Applying a global default

```yaml
type: ExamplePolicy
name: example
mesh: default
spec:
  targetRef:
    kind: Mesh
  to:
    - targetRef:
        kind: Mesh
      default:
        key: value
```

All traffic from any proxy (top level `targetRef`) going to any proxy (to `targetRef`) will have this policy applied with value `key=value`.

#### Recommending to users

```yaml
type: ExamplePolicy
name: example
mesh: default
spec:
  targetRef:
    kind: Mesh
  to:
    - targetRef:
        kind: MeshService
        name: my-service
      default:
        key: value
```

All traffic from any proxy (top level `targetRef`) going to the service "my-service" (to `targetRef`) will have this policy applied with value `key=value`.

This is useful when a service owner wants to suggest its clients as set of configuration.

#### Configuring all proxies of a team

```yaml
type: ExamplePolicy
name: example
mesh: default
spec:
  targetRef:
    kind: MeshSubset
    tags:
      team: "my-team"
  from:
    - targetRef:
        kind: Mesh
      default:
        key: value
```

All traffic from any proxies (from `targetRef`) going to any proxy that has the tag `team=my-team` (top level `targetRef`) will have this policy applied with value `key=value`.

This is a useful way to define coarse grain rules for example.

#### Configuring all proxies in a zone

```yaml
type: ExamplePolicy
name: example
mesh: default
spec:
  targetRef:
    kind: MeshSubset
    tags:
      kuma.io/zone: "east"
  default:
    key: value
```

All proxies in zone `east` (top level `targetRef`) will have this policy configured with `key=value`.

This can be very useful when observability stores are different for each zone for example.
