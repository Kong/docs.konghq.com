---
title: Teams Reference
content_type: reference
---

All new and existing organizations in {{site.konnect_short_name}} have predefined default teams. All predefined roles and teams automatically get access to all [geographic regions](/konnect/geo) in your {{site.konnect_short_name}} instance.
The default teams can't be modified or deleted.

Keywords:
* **Fully manage**: Create, read, update, and delete
* **Partially manage**: Depends on the team

| Team                           | Description  |
|--------------------------------|--------------|
| Analytics Admin                | Users can fully manage all Analytics content, which includes creating, editing, and deleting reports, as well as viewing the analytics summary. |
| Analytics Viewer               | Users can view the Analytics summary and report data.|
| Organization Admin             | Users can fully manage all entities and configuration in the organization. |
| Organization Admin (Read Only) | Users can view all entities and configuration in the organization. |
| Portal Admin                   | Users can fully manage all Dev Portal content, which includes {{site.konnect_short_name}} service pages and supporting content, as well as Dev Portal configuration and service connections. <br> To manage app registration requests, members must also be assigned to the Admin or Maintainer roles for the corresponding services.|
| Data Plane Node Admin                  | Users can configure data plane nodes for the organization. They can also manage global configuration of the following entities: Gateway services, routes, plugins, upstreams, SNIs, and certificates.
| API Product Admin                  | Users can create and manage API products, including publishing API product versions to Dev Portal and enabling application registration.|  
| API Product Developer              | Users can create and manage versions of API products. |

To set up a custom team, see [Manage Teams and Roles](/konnect/org-management/teams-and-roles/).
