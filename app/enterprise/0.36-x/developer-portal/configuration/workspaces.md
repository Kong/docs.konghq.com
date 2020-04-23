---
title: Running Multiple Dev Portals with Workspaces
---

### Introduction

Kong supports running multiple instances of the Dev Portal with the use of
[**Workspaces**](/enterprise/{{page.kong_version}}/admin-api/workspaces/reference/). This allows each Workspace to enable
and maintain separate Dev Portals (complete with separate files, settings, and
authorization) from a within a single instance of Kong.

## Managing Multiple Dev Portals within Kong Manager

A snapshot of every Dev Portal within an instance of Kong can be viewed via
the Kong Manager's **Dev Portals** top navigation tab.

This overview page details:

- Whether a Dev Portal in a given Workspace is enabled or disabled
- A link to set up the Dev Portal if it is not enabled
- A link to each Dev Portal's homepage
- A link to each Dev Portal's individual overview page within Kong Manager
- Whether or not each Dev Portal is authenticated (indicated by a lock icon
in the upper right corner of each card)


## Enabling a Workspace's Dev Portal

When a Workspace other than **default** is created, that Workspace's Dev Portal
will remain `disabled` until it is manually enabled.

This can be done from the Kong Manager by clicking the **Set up Dev Portal**
button located on the **Dev Portals** Overview page, or by navigating directly
to a Workspace's **Dev Portal Settings** page via the sidebar and toggling the
`Dev Portal Switch`, or by sending the following cURL request:

```
curl -X PATCH http://localhost:8001/workspaces/<WORKSPACE_NAME> \
 --data "config.portal=true"
```

On initialization, Kong will populate the new Dev Portal with the [**Default Settings**](#defining-dev-portals-default-settings) defined in Kong's configuration file.

>*Note* A Workspace can only enable a Dev Portal if the Dev Portal feature has been enabled in Kong's configuration. See [Enabling the Dev Portal](/enterprise/{{page.kong_version}}/getting-started/enable-dev-portal/) for more information.


## Defining the Dev Portal's URL structure

The URL of each Dev Portal is automatically configured upon initialization and
is determined by four properties:

1. The `portal_gui_protocol` property
2. The `portal_gui_host` property
3. Whether the `portal_gui_use_subdomains` property is enabled or disabled
4. The `name` of the Workspace

Example URL with subdomains disabled: `http://localhost:8003/example-workspace`

Example URL with subdomains enabled: `http://example-workspace.localhost:8003`

The first three properties are controlled by Kong's configuration file and
cannot be edited via the Kong Manager.

## Overriding Default Settings

On initialization, the Dev Portal will be configured using the [**Default Portal Settings**](/enterprise/{{page.kong_version}}/developer-portal/configuration/workspaces/#overriding-default-settings) defined in Kong's configuration file.

These settings can be manually overridden in the Dev Portals **Settings** tab
in the Kong Manager or by patching the setting directly.

## Workspace Files

On initialization of a Workspace's Dev Portal a copy of the **default** Dev Portal files will be made and inserted into the new Dev Portal. This allows for the easy transference of a customized Dev Portal theme and allows **default** to act as a 'master template' -- however the Dev Portal will not continue to sync changes from the **default** Dev Portal after it is first enabled.

## Developer Access

Access is not synced between Dev Portals. If an Admin or Developer would like access to multiple Dev Portals, they must sign up for each Dev Portal individually.
