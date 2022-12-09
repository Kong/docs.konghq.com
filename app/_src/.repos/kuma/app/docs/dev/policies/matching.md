---
title: Policy matching
---

Policy matching refers to using `targetRef` fields to specify which resources
a given policy affects. Every `targetRef` refers to a policy by `kind`.
For example, `Mesh` or `MeshService`. A `targetRef` may also refer to a `name`
and additional fields depending on the `kind`.

## `targetRef` levels

The top level `spec.targetRef` field defines which set of proxies a policy affects.
In particular, it defines which proxies have their Envoy configuration modified.

Some policies also support further narrowing.

The `spec.to.targetRef` field defines rules that applies to outgoing traffic of proxies selected by `spec.targetRef`.
The `spec.from.targetRef` field defines rules that applies to incoming traffic of proxies selected by `spec.targetRef`.

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
It defines the scope of this policy as applying
to traffic either from or to `web-frontend` services.

The `spec.to.targetRef` section enables logging for any traffic to `web-backend`.
The `spec.from.targetRef` section enables logging for any traffic from _any service_ in the `Mesh`.

## Target resources

Not every policy supports `to` and `from` levels. Additionally, not every resource can
appear at every supported level. The specified top level resource can also affect which
resources can appear in `to` or `from`.

In this example:

```yaml
apiVersion: kuma.io/v1alpha1
kind: SomePolicyType
---
spec:
  targetRef: # top level
    kind: Mesh | MeshSubset | MeshService | MeshServiceSubset
    # ...
  to:
    - targetRef: # "to"
        kind: Mesh
      # ...
  from:
    - targetRef: # "from"
        kind: MeshService
      # ...
```

- top level can be one of `Mesh`, `MeshSubset`, `MeshService`, `MeshServiceSubset`
- to level can only be `Mesh`
- from level can only be `MeshService`

The following table indicates which entity types (`Mesh`, `MeshSubset`, `MeshService`, `MeshServiceSubset`) a policy supports
and where they can appear.

| `targetRef.kind`    | top level | to  | from |
| ------------------- | --------- | --- | ---- |
| `Mesh`              | ✅        | ✅  | ❌   |
| `MeshSubset`        | ✅        | ❌  | ❌   |
| `MeshService`       | ✅        | ❌  | ✅   |
| `MeshServiceSubset` | ✅        | ❌  | ❌   |
