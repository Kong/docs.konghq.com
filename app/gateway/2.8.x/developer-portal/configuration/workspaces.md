---
title: Running Multiple Dev Portals with Workspaces
badge: enterprise
---

Kong supports running multiple instances of the Dev Portal with the use of
[**Workspaces**](/gateway/{{page.kong_version}}/admin-api/workspaces/reference). This allows each Workspace to enable
and maintain separate Dev Portals (complete with separate files, settings, and
authorization) from within a single instance of Kong.

## Manage Multiple Dev Portals within Kong Manager

A snapshot of every Dev Portal within an instance of Kong can be viewed via
the Kong Manager's **Dev Portals** top navigation tab.

This page details:

- Whether a Dev Portal in a given Workspace is enabled or disabled
- A link to set up the Dev Portal if it is not enabled
- A link to each Dev Portal's homepage
- A link to each Dev Portal's individual overview page within Kong Manager
- Whether or not each Dev Portal is authenticated (indicated by a lock icon
in the upper right corner of each card)

## Enable a Workspace's Dev Portal

As with the **default** Workspace, when an additional Workspace is created, 
its associated Dev Portal is `disabled` until it's manually enabled.

This can be done from the Kong Manager by clicking the **Set up Dev Portal**
button located on the **Dev Portals** Overview page, or by navigating directly
to a Workspace's **Dev Portal Settings** page via the sidebar and toggling the
`Dev Portal Switch`, or by sending the following cURL request:

```bash
curl -X PATCH http://localhost:8001/workspaces/<WORKSPACE_NAME> \
 --data "config.portal=true"
```

On initialization, Kong will populate the new Dev Portal with the [**Default Settings**](/gateway/{{page.kong_version}}/reference/configuration/#dev-portal) defined in Kong's configuration file.

>*Note* A Workspace can only enable a Dev Portal if the Dev Portal feature has been enabled in Kong's configuration.


## Define the Dev Portal's URL structure

The URL of each Dev Portal is automatically configured on initialization and
is determined by four properties:

1. The `portal_gui_protocol` property
2. The `portal_gui_host` property
3. Whether the `portal_gui_use_subdomains` property is enabled or disabled
4. The `name` of the Workspace

Example URL with subdomains disabled: `http://localhost:8003/example-workspace`

Example URL with subdomains enabled: `http://example-workspace.localhost:8003`

The first three properties are controlled by Kong's configuration file and
cannot be edited via the Kong Manager.

## Override Default Settings

On initialization, the Dev Portal will be configured using the [**Default Portal Settings**](/gateway/{{page.kong_version}}/reference/configuration/#dev-portal) defined in Kong's configuration file.

{:.note}
> **Note**: You can only enable a Dev Portal for a Workspace if the
Dev Portal feature has been [enabled for Kong Gateway](/gateway/{{page.kong_version}}/developer-portal/enable-dev-portal).

These settings can be manually overridden in the Dev Portals **Settings** tab
in the Kong Manager or by patching the setting directly.

## Workspace Files

On initialization of a Workspace's Dev Portal, a copy of the **default** Dev Portal files will be made and inserted into the new Dev Portal. This allows for the easy transference of a customized Dev Portal theme and allows **default** to act as a 'master template' -- however, the Dev Portal will not continue to sync changes from the **default** Dev Portal after it is first enabled.

## Developer Access

Access is not synced between Dev Portals. If an Admin or Developer wants access to multiple Dev Portals, they must sign up for each Dev Portal individually.
