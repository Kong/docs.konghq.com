---
title: Migrating Templates Between Workspaces
badge: enterprise
---

The template styling from your default Dev Portal doesn't automatically apply to new Dev Portals you create in other workspaces. However, with the [Portal CLI](/gateway/latest/developer-portal/helpers/cli/), you can move over templates in a few steps.

## Prerequisites

* Install [Portal CLI](/gateway/latest/developer-portal/helpers/cli/) and set up the [configuration](/gateway/latest/developer-portal/helpers/cli/#usage).

## Apply customization from default Dev Portal

To apply customizations from one Dev Portal to another, do the following:

1. From your Kong Manager, create a new Workspace and enable a new Dev Portal. In the rest of this document, the new Workspace name will be referred to as `{WORKSPACE_NAME}`.

2. Git clone `https://github.com/Kong/kong-portal-templates`.

3. CD into `kong-portal-templates`.

4. Run the command: `portal fetch default`.

5. Run the command: `cp workspaces/default workspaces/{WORKSPACE_NAME}`.

6. Run the command: `portal deploy {WORKSPACE_NAME}`.
