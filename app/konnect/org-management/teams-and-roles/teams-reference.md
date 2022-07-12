---
title: Teams Reference
no_version: true
content_type: reference
---

All new and existing organizations in {{site.konnect_short_name}} have predefined default teams.
The default teams can't be modified or deleted.

Keywords:
* **Fully manage**: Create, read, update, and delete
* **Partially manage**: Depends on the team

| Team                | Description  |
|---------------------|--------------|
| Organization Admin  | Users can fully manage all objects, users, and roles in the organization. |
| Portal Admin        | Users can fully manage all Dev Portal content, which includes {{site.konnect_short_name}} service pages and supporting content, as well as Dev Portal configuration and connections. |
| Portal Viewer       | Users can view Dev Portal configuration in {{site.konnect_short_name}}, including all developers and applications registered through the Dev Portal. |
| Runtime Admin       | Users can configure runtimes for the organization and fully manage related global configurations: Gateway services, routes, plugins, upstreams, SNIs, and certificates.
| Service Admin       | Users can fully manage services and versions, manage application registration, publish services to the Dev Portal, and manage global configuration for consumers and plugins.|  
| Service Developer   | Users can view {{site.konnect_short_name}} services, and fully manage versions of existing services and their Dev Portal specs. |
| Service Page Editor | Users can partially manage (read, update) the documentation and specs for services and versions, publish services to the Dev Portal, and enable or disable application registration for service. |

To set up a custom team, see [Manage Teams and Roles](/konnect/org-management/teams-and-roles).
