---
title: Dev Portal Workspaces
book: portal
chapter: 7
---

## Working with Workspaces

With the addition of Workspace support in 0.34, the Kong Dev Portal now supports
running multiple instances of the Dev Portal - one for each Workspace. When a 
Workspace is created, that Workspaces Dev Portal will automatically appear on 
the "Dev Portals Overivew Page"

![Dev Portals Overview Page](https://konghq.com/wp-content/uploads/2018/11/devportals-overview.png)

Note that Kong Admins will only be able to see the cards for Dev Portals to 
which they have permissions to edit. 


## Enabling a Workspace's Dev Portal

When a new Workspace is created other than `default`, that Workspace's Dev 
Portal will remain `off` until it is manually enabled. 

If the Kong Dev Portal feature is enabled, the Dev Portal in a Workspace can be 
enabled by navigating to `Settings` page in the `Kong Manager` and toggling the 
Dev Portal Switch. Or by sending the following cURL request:

```
curl -X PATCH http://localhost:8001/workspace/<WORKSPACE_NAME> \
 --data "config.portal=on"
```

**Note: If you cannot see the Settings or Overview pages, the Kong Dev Portal 
may not be enabled in the Kong configuration file. See [Getting Started] 

## Accessing a Workspace's Dev Portal

When a Dev Portal is enabled, its URL will be automatically configured using 
the `portal_gui_protocol` and `portal_gui_host` variables in the Kong 
configuration file and the name of the Workspace.

Example: `http://localhost:8003/example-workspace`

If `portal_gui_use_subdomains` is set to `on` the Workspace name
will be used as a subdomain. 

Example: `http://example-workspace.localhost:8003`


## Overriding settings

When first enabled, a Workspace's Dev Portal config will be empty, and the Dev 
Portal will fall back on the default values provided in the Kong Configuration 
file. The Workspaced Dev Portal's settings can be manually set by navigating to 
the `Settings` page in the `Kong Manager` or by submitting a cURL request 
directly to the Dev Portal's configuration table. More information on these 
settings can be found in 
[Getting Started](/enterprise/{{page.kong_version}}/developer-portal/configuration/getting-started) and in the 
[Dev Portal Property Reference](/enterprise/{{page.kong_version}}/property-reference/#dev-portal)


## Files

When a Workspace's Dev Portal is enabled, a copy of the `default Dev Portals` 
files will be made and inserted into the new Dev Portal. This allows for the 
easy transferrence of a customized Dev Portal theme and allows `default` 
to act as a 'master template' -- however the Dev Portal will not continue to 
sync changes from the default Dev Portal after it is first enabled. 


## Developer Access

Kong Admin and Developer access is not synced between Dev Portals. If a Kong 
Admin or Developer would like access to multiple Dev Portals, they must sign up 
for each Dev Portal individually. 

However, credentials between Dev Portals must be **unique** including the email
address. This means that a Developer or Kong Admin **cannot** sign up for more
than one Dev Portal with the same email address.


