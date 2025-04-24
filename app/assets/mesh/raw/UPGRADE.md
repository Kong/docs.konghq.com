This document guides you through the process of upgrading Kong Mesh.

First, check if a section named `Upgrade to x.y.z` exists,
with `x.y.z` being the version you are planning to upgrade to.

Make sure to also check the upgrade notes for the matching version of [Kuma](https://kuma.io/docs/latest/production/upgrades-tuning/upgrades).

## Upgrade to `2.11.x`

### Reduce the permissions of the `ClusterRole` by moving cert-manager permissions to a `Role`

During installation, we create a `ClusterRole` with permissions for Kong Mesh resources and cert-manager. We’ve identified that cluster-scoped access to cert-manager is not necessary, so we’ve moved those permissions to a separate `Role`, bound by a `RoleBinding` in the system namespace only. This change should not affect your deployment.

## Upgrade to `2.10.x`

### CP tokens are removed

Control Plane Tokens were deprecated in 2.0.x.
They are now removed and only zone tokens are supported to auth to zonal control-planes to global.
To generate and use zone tokens checkout the dedicated [docs](https://docs.konghq.com/mesh/latest/features/kds-auth/).

## Upgrade to `2.7.x`

### RBAC

A new access type: `VIEW_CONTROL_PLANE_METADATA` has been added to the RBAC configuration which restricts access to `/config`.
If you want to leave the access to `/config` unrestricted, you need to add `VIEW_CONTROL_PLANE_METADATA` to the rules of your `admin` `AccessRole`.

### ECS

The configuration for AWS IAM data plane authentication has changed slightly
because of the removal of configuration options
`KUMA_DP_SERVER_AUTH_*` and `dpServer.auth.*` (see Kuma `UPGRADE.md`).

Instead of control plane configuration like:

```
            - Name: KUMA_DP_SERVER_AUTH_TYPE
              Value: aws-iam
            - Name: KUMA_DP_SERVER_AUTH_USE_TOKEN_PATH
              Value: "true"
```

you'll need:

```
            - Name: KUMA_DP_SERVER_AUTHN_DP_PROXY_TYPE
              Value: aws-iam
            - Name: KUMA_DP_SERVER_AUTHN_ZONE_PROXY_TYPE
              Value: aws-iam
            - Name: KUMA_DP_SERVER_AUTHN_ENABLE_RELOADABLE_TOKENS
              Value: "true"

```

See [Kong/kong-mesh-ecs#40](https://github.com/Kong/kong-mesh-ecs/pull/40) for an example.

## Upgrade to `2.0.x`

Control Plane Tokens are deprecated. It will be removed in a future release.
You can use the Zone Token instead to authenticate any zonal control plane.
