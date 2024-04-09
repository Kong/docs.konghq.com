This document guides you through the process of upgrading Kong Mesh.

First, check if a section named `Upgrade to x.y.z` exists,
with `x.y.z` being the version you are planning to upgrade to.

Make sure to also check the upgrade notes for the matching version of [Kuma](https://kuma.io/docs/latest/production/upgrades-tuning/upgrades).

## Upgrade to `2.7.x`

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
