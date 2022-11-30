---
title: Access Audit
---

Access Audit lets you track all actions that are executed in {{site.mesh_product_name}}.
It includes all the actions executed by both users and the control plane.

## How it works

{{site.mesh_product_name}} provides an extra resource that enables operators and teams to decide which resources should be audited.

### AccessAudit

`AccessAudit` defines which actions should be audited.
It is global-scoped, which means it is not bound to a mesh.

{% navtabs %}
{% navtab Universal %}
```yaml
type: AccessAudit
name: audit-1
rules:
- types: ["TrafficPermission", "TrafficRoute", "Mesh"] # list of types which should be audited. If empty, then default types are audited (see "Default types" below).
  mesh: default # Mesh within which access to resources is granted. It can only be used with the Mesh-scoped resources and Mesh itself. If empty, resources from all meshes will be audited.
  access: ["CREATE", "UPDATE", "DELETE"] # an action that is bound to a type.
  accessAll: true # an equivalent of specifying all possible accesses. Either access or access all can be specified.
```
{% endnavtab %}
{% navtab Kubernetes %}
```yaml
apiVersion: kuma.io/v1alpha1
kind: AccessAudit
metadata:
  name: role-1
spec:
  rules:
  - types: ["TrafficPermission", "TrafficRoute", "Mesh"] # list of types which should be audited. If empty, then all resources will be audited.
    mesh: default # Mesh within which access to resources is granted. It can only be used with the Mesh-scoped resources and Mesh itself. If empty, resources from all meshes will be audited.
    access: ["CREATE", "UPDATE", "DELETE"] # an action that is bound to a type.
    accessAll: true # an equivalent of specifying all possible accesses. Either access or access all can be specified.
```
{% endnavtab %}
{% endnavtabs %}

#### Default types

By default, when `types` are not specified all types are taken into account except the one defined in the static Kong Mesh CP config in `kmesh.access.audit.skipDefaultTypes`.
Right now, those are insight resources (`DataplaneInsight`, `ZoneIngressInsight`, `ZoneEgressInsight`, `ZoneInsight`, `ServiceInsight`, `MeshInsight`).
Those resources carry status information and are only managed by the control plane, not by a user.

#### Other actions

Aside `CREATE`, `UPDATE`, `DELETE`, `AccessAudit` lets you audit all actions that are controllable with RBAC:
* `GENERATE_DATAPLANE_TOKEN` (you can use `mesh` to audit only tokens generated for specific mesh)
* `GENERATE_USER_TOKEN`
* `GENERATE_ZONE_CP_TOKEN`
* `GENERATE_ZONE_TOKEN`
* `VIEW_CONFIG_DUMP`
* `VIEW_STATS`
* `VIEW_CLUSTERS`

## Backends

The backend is external storage that persists audit logs. Currently, there is one available backend which is a JSON file.

### JSON file

The JSON file is a backend that persists audit logs to a single file in JSON format.

#### Configuration

You can configure the file backend with the control plane config.
It can only be configured using YAML config, not environment variables.

```yaml
kmesh:
  access:
    audit:
      # Types that are skipped by default when `types` list in AccessAudit resource is empty
      skipDefaultTypes: ["DataplaneInsight", "ZoneIngressInsight", "ZoneEgressInsight", "ZoneInsight", "ServiceInsight", "MeshInsight"]
      backends:
      - type: file
        file:
          # Path to the file that will be filled with logs
          path: /tmp/audit.logs
          rotation:
            # If true, rotation is enabled.
            # Example: if we set path to /tmp/audit.log then after the file is rotated we will have /tmp/audit-2021-06-07T09-15-18.265.log
            enabled: true
            # Maximum number of the old log files to retain
            maxRetainedFiles: 10
            # Maximum size in megabytes of a log file before it gets rotated
            maxSizeMb: 100
            # Maximum number of days to retain old log files based on the timestamp encoded in their filename
            maxAgeDays: 30
```

#### Examples


Audit of the `TrafficPermission` update done by `john.doe@kuma.io`.

```json
{
  "date": "2022-09-21T09:31:42+02:00",
  "action": "UPDATE",
  "resource": {
    "name": "web-to-backend",
    "mesh": "default",
    "type": "TrafficPermission"
  },
  "user": {
    "name": "john.doe@kuma.io",
    "groups": [
      "team-a"
    ]
  }
}
```

Audit of the data plane token generation done by `john.doe@kuma.io`.

```json
{
  "date": "2022-09-21T09:31:42+02:00",
  "action": "GENERATE_DATAPLANE_TOKEN",
  "token": {
    "id": "0e120ec9-6b42-495d-9758-07b59fe86fb9",
    "expiresAt": "2022-09-22T09:31:42+02:00",
    "claims": {
      "mesh": "default",
      "tags": {
        "kuma.io/service": "backend"
      }
    }
  },
  "user": {
    "name": "john.doe@kuma.io",
    "groups": [
      "team-a"
    ]
  }
}
```

## Multi-zone

In a multi-zone setup, `AccessAudit` is not synchronized between the global control plane and the zone control plane.