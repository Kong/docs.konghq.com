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

1. Clone the Kong Portal Templates repository:
 
    ```bash
    git clone https://github.com/Kong/kong-portal-templates
    ```

1. Move into `kong-portal-templates`:
   
   ```bash
   cd kong-portal-templates
   ```

1. Fetch the default workspace:
   
   ```bash
   portal fetch default
   ```

1. Copy the templates from the default workspace to another workspace:
   
    ```bash
    cp workspaces/default workspaces/{WORKSPACE_NAME}
    ```

1. Deploy the templates to the new workspace:
   
    ```bash
    portal deploy {WORKSPACE_NAME}
    ```
