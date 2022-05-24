---
title: decK and Kong Gateway (Enterprise)
content-type: explanation
---

All features of decK work with both {{site.ce_product_name}} and {{site.ee_product_name}}.

For {{site.ee_product_name}}, decK provides a few additional features leveraging the
power of enterprise features.

## Compatibility

decK is compatible with {{site.ee_product_name}} 0.35 and above.

## Entities managed by decK

decK manages only the core proxy entities in {{site.ee_product_name}}. It doesn't
manage enterprise-only entities such as admins, RBAC permissions, RBAC roles,
or any entities related to Dev Portal.

## RBAC

You should have authentication and RBAC configured for Kong's Admin API.
Supply the RBAC token to decK so that decK can authenticate itself
against the Admin API.

Use the `--headers` flag to pass the RBAC token to decK. For example, you can pass the token as a string:

```sh
deck diff --headers "kong-admin-token:<your-token>"
```

However, passing the token directly is not secure and should only be used for testing. The command and all of its flags are logged to your shell's history file, potentially leaking the token.

For a more secure approach, you can store the token in a file and load the file as you execute the command. For example:

```sh
deck diff --headers "kong-admin-token:$(cat token.txt)"
```

You can also use the `DECK_HEADERS` environment variable to supply the same token with an environment variable.

It is advised that you do not use an RBAC token with super admin privileges
with decK, and always scope down the exact permissions you need to give
decK.

## Workspaces

decK is workspace-aware, meaning it can interact with multiple workspaces.

### Manage one workspace at a time

To manage the configuration of a specific workspace, use the `--workspace` flag with [`sync`](/deck/{{page.kong_version}}/reference/deck_sync),
[`diff`](/deck/{{page.kong_version}}/reference/deck_diff),
[`ping`](/deck/{{page.kong_version}}/reference/deck_ping),
[`dump`](/deck/{{page.kong_version}}/reference/deck_dump), or
[`reset`](/deck/{{page.kong_version}}/reference/deck_reset). For example, to
export the configuration of the workspace `my-workspace`:

```sh
deck dump --workspace my-workspace
```

If you do not specify a `--workspace` flag, decK uses the `default` workspace.

To set a workspace directly in the state file, use the `_workspace` parameter.
For example:

```yaml
_format_version: "1.1"
_workspace: default
services:
- name: example_service
```

{:.note}
> **Note:** decK cannot delete workspaces. If you use `--workspace` or
`--all-workspaces` with `deck reset`, decK deletes the entire configuration
inside the workspace, but not the workspace itself.

### Manage multiple workspaces

You can manage the configurations of all workspaces in {{site.ee_product_name}}
with the `--all-workspaces` flag:

```sh
deck dump --all-workspaces
```

This creates one configuration file per workspace.

{% if_version gte:1.11.x %}

However, since a `workspace` is an isolated unit of configuration, decK doesn't
allow the deployment of multiple workspaces at a time. Therefore, each
workspace configuration file must be deployed individually:

```sh
deck sync -s workspace1.yaml --workspace workspace1
```

```sh
deck sync -s workspace2.yaml --workspace workspace2
```

{% endif_version %}

{:.important}
> Be careful when using the `--all-workspaces` flag to avoid overwriting the wrong workspace. We
recommend using the singular `--workspace` flag in most situations.
