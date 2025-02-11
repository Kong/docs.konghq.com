---
title: Workspaces
---

decK is workspace-aware, meaning it can interact with multiple workspaces.

{:.note}
> Workspaces are a {{ site.ee_product_name }} concept, and are not applicable to {{ site.konnect_short_name }}.

## Manage one workspace at a time

To manage the configuration of a specific workspace, use the `--workspace` flag with [`sync`](/deck/gateway/sync/), [`diff`](/deck/gateway/diff/), [`dump`](/deck/gateway/dump/), or [`reset`](/deck/gateway/reset/).

For example, to export the configuration of the workspace `my-workspace`:

```sh
deck gateway dump --workspace my-workspace
```

If you don't specify a `--workspace` flag, decK uses the `default` workspace.

To set a workspace directly in the state file, use the `_workspace` parameter. For example:

```yaml
_format_version: "3.0"
_workspace: default
services:
  - name: example_service
```

{:.note}
> **Note:** decK can't delete workspaces. If you use `--workspace` or
`--all-workspaces` with `deck gateway reset`, decK deletes the entire configuration inside the workspace, but not the workspace itself.

## Manage multiple workspaces

You can manage the configurations of all workspaces in {{site.ee_product_name}} with the `--all-workspaces` flag:

```sh
deck gateway dump --all-workspaces
```

This creates one configuration file per workspace.

{:.important}
> Be careful when using the `--all-workspaces` flag to avoid overwriting the wrong workspace. We recommend using the singular `--workspace` flag in most situations.

However, since a `workspace` is an isolated unit of configuration, decK doesn't allow the deployment of multiple workspaces at a time. Therefore, each workspace configuration file must be deployed individually:

```sh
deck gateway sync workspace1.yaml --workspace workspace1
```

```sh
deck gateway sync workspace2.yaml --workspace workspace2
```
