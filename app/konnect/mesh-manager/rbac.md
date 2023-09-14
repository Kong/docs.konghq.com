---
title: Mesh Manager RBAC
content_type: reference
---

lksdlfkajldsjf

## Roles description

The following roles are available in {{site.konnect_short_name}} for Mesh Manager:

| Role                        | Description  |
|-----------------------------|--------------|
| Admin | Mesh operator is a part of infrastructure team responsible for Kong Mesh deployment. |
| Service owner | Service owner is a part of team responsible for given service. |
| Observability operator | We may also have an infrastructure team which is responsible for the logging/metrics/tracing systems in the organization. Currently, those features are configured on Mesh, TrafficLog and TrafficTrace objects. |
| Single Mesh operator | Kong Mesh lets us segment the deployment into many logical service meshes configured by Mesh object. We may want to give an access to one specific Mesh and all objects connected with this Mesh. |

## Roles key mapping

| Kong Mesh key                        | Konnect entity  | Description  |
|-----------------------------|--------------|--------------|
| `type` | `AccessRole` or `AccessRoleBinding` | RBAC method. |
| `name` | ? | Name for the  |
| `subjects.type` | ? | ? |
| `subjects.name` | ? | ? |
| `roles` | ? | ? |
| `rules.types` | ? | ? |
| `rules.names` | ? | ? |
| `rules.mesh` | ? | ? |
| `rules.access` | ? | ? |
| `rules.when.sources` | ? | ? |
| `rules.when.destinations` | ? | ? |
| `rules.when.selectors` | ? | ? |
| `rules.when.dpToken` | ? | ? |
