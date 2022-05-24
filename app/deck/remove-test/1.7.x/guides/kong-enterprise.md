---
title: decK and Kong Enterprise
---

All features of decK work with both {{site.ce_product_name}} and {{site.ee_product_name}}.

For {{site.ee_product_name}}, decK provides a few additional features leveraging the
power of enterprise features.

## Compatibility

decK is compatible with {{site.ee_product_name}} 0.35 and above.

## Entities managed by decK

decK manages only the core proxy entities in {{site.ee_product_name}}. It doesn't
manage enterprise-only entities such as admins, RBAC permissions, RBAC roles,
or any entities related to Developer Portal.

## RBAC

You should have authentication and RBAC configured for Kong's Admin API.
You can supply the RBAC token to decK so that decK can authenticate itself
against the Admin API:
- Use the `--headers` flag (example: `--headers "kong-admin-token:<your-token>"`).
  Please note that this is not a secure method. The entire command along with
  its flags will be logged to your shell's history file, potentially leaking
  the token. You can store the token in a file and load it as you execute the
  command, for example: `--headers "kong-admin-token:$(cat token.txt)"`
- Use the `DECK_HEADERS` environment variable to supply the same token, but via
  an environment variable.

It is advised that you do not use an RBAC token with super admin privileges
with decK, and always scope down the exact permissions you need to give
decK.

## Workspaces

decK is workspace-aware, meaning it can interact with multiple workspaces.

### Dump

To export the configuration of a specific workspace, use the `--workspace` flag:

```
deck dump --workspace my-workspace
```

If you do not specify a flag, the configuration of the `default` workspace will
be managed.

You can export the configurations of all workspaces in {{site.ee_product_name}} with
the `--all-workspaces` flag:

```
deck dump --all-workspaces
```

This creates one configuration file per workspace.

### Sync

`diff` and `sync` commands work with workspaces, and the workspace to sync
to is determined via the `_workspace` property inside the state file.

It is recommended to manage one workspace at a time and not clump
configurations of all the workspaces at the same time.

### Reset

Same as the `dump` command, you can use `--workspace` to reset configuration of a
specific workspace, or use `--all-workspaces` to reset configuration of all
workspaces in Kong.
Please note that decK doesn't delete the workspace itself but deletes the
entire configuration inside the workspace.
