---
title: Back up your configuration
---

decK can back up the configuration of your running {{ site.base_gateway }} using the `deck gateway dump` command.

See the reference for [Entities Managed by decK](/deck/{{page.release}}/reference/entities/) to find out which entity configurations can be backed up.

The exact command that you need to run changes if you're using workspaces (on-prem only) or not.

{:.note}
> The following commands will back up **all** of the configuration in to a single file. See [tags](/deck/gateway/tags/) to learn how to segment configuration.

## {{ site.konnect_short_name }}

decK can export one control plane at a time from {{ site.konnect_short_name }}. To choose which control plane is backed up, specify the `--konnect-control-plane-name` flag:

```bash
deck gateway dump -o $YOUR_CP_NAME.yaml --konnect-control-plane-name $YOUR_CP_NAME --konnect-token $KONNECT_TOKEN
```

## Single workspace

If you're using {{ site.ce_product_name }} or the default workspace in {{ site.ee_product_name }}, decK automatically identifies the workspace to back up:

```bash
deck gateway dump -o kong.yaml
```

To back up a different workspace, pass the `-w` flag:

```bash
deck gateway dump -w $WORKSPACE_NAME -o $WORKSPACE_NAME.yaml
```

## All workspaces

To back up all {{ site.ee_product_name }} workspaces, pass the `--all-workspaces` flag. 
This creates multiple files in the current directory. Each file is named the same as its workspace:

```bash
deck gateway dump --all-workspaces
```


