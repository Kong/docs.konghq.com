---
title: Dev Portal Overview
content_type: explanation
---

The {{site.konnect_short_name}} Dev Portal is a customizable website for developers to locate, access, and consume API services. The Dev Portal enables developers to browse and search API documentation, test API endpoints, and manage their own credentials. {{site.konnect_short_name}} offers flexible deployment options to support both internal and external APIs that can be managed from {{site.konnect_short_name}}.

## Dev Portal use cases

You can use the following table to help you determine which Dev Portal configurations are best for your use case:

| You want to... | Then use... |
| -------------- | ----------- |
| Publish some APIs to an internal Dev Portal as well as an external Dev Portal. | [Multi-portal](/konnect/dev-portal/create-dev-portal/) |
| Allow developers to reuse your APIs in applications | [Enable app reg and Dev Portal](/konnect/dev-portal/applications/enable-app-reg/) |
| Only allow certain users to see your published APIs | [Manage dev teams with RBAC](/konnect/api/portal-auth/portal-rbac-guide/#main) |
| Self-host or visually customize your Dev Portal | [Self-hosted Dev Portal](/konnect/dev-portal/customization/self-hosted-portal/) |
| Publish documentation for your APIs | [Add and publish API product documentation](/konnect/dev-portal/publish-service/) |

## Dev Portal configuration options

The following diagram displays the different Dev Portal configuration options you have depending on if you're planning to configure a public or private Dev Portal, or both. 

{% mermaid %}
flowchart TD
    A[Create a Dev Portal] --> C{Public Dev Portal}
    A --> B{Private Dev Portal}
    B -->D[Manage developers] 
    D --> E(Third-party IdP)
    D --> F(Approve/deny)
    D --> G(RBAC)
    B --> H[Manage apps]
    H --> I(Enable app reg)
    H --> J(Approve/deny apps)
    H --> K(DCR)
    C --> L[Customize Dev Portal]
    B --> L
    L --> M(Self host with Netlify)
    L --> N(Self host)
    L --> O(Customize appearance)

    %% this section defines node interactions
    click A "/konnect/dev-portal/create-dev-portal/"
    click E "/konnect/dev-portal/access-and-approval/add-teams/"
    click F "/konnect/dev-portal/access-and-approval/manage-devs/"
    click G "/konnect/api/portal-auth/portal-rbac-guide/#main"
    click I "/konnect/dev-portal/applications/enable-app-reg/"
    click J "/konnect/dev-portal/access-and-approval/manage-app-reg-requests/"
    click K "/konnect/dev-portal/applications/dynamic-client-registration/"
    click M "/konnect/dev-portal/customization/netlify/"
    click N "/konnect/dev-portal/customization/self-hosted-portal/"
    click O "/konnect/dev-portal/customization/"
{% endmermaid %} 

## Developer self service

Dev Portals are created for developers to use. The Dev Portal removes the burden of credential management from the API creator, and empowers developers to manage aspects of the application development lifecycle on their own. 

Developers can interact with API product versions that have been exposed through API Products via applications. They can register and unregister applications, manage their own application API keys, and view analytics for their applications from the Dev Portal. 

For more information on this topic, we offer several pieces of documentation depending on your use case.

For {{site.konnect_short_name}} administrators:

* [Enabling and disabling application registration](/konnect/dev-portal/applications/enable-app-reg/) - This explains how to grant and revoke application registration access.
Manage developer access - This doc details to a {{site.konnect_short_name}} administrator all of the different options they have available to them to manage developer access to their Dev Portal. The Dev Portal offers administrators the ability to approve and reject requests for access to the Dev Portal.

* [Manage developer access](/konnect/dev-portal/access-and-approval/manage-devs/)- This doc details to a {{site.konnect_short_name}} administrator all of the different options they have available to them to manage developer access to their Dev Portal. The Dev Portal offers administrators the ability to approve and reject requests for access to the Dev Portal.

* [Manage application registration requests](/konnect/dev-portal/access-and-approval/manage-devs/) -  When developers want to create applications on your Dev Portal, they will have to create a request. Requests can be managed from within {{site.konnect_short_name}}. This document contains instructions on how to manage application requests. If you are interested in automatically allowing application requests automatically, read our guide on handling [auto approval](/konnect/dev-portal/access-and-approval/auto-approve-devs-apps/).

For developers:

* [Developer registration and account management](/konnect/dev-portal/dev-reg/) - This explains how to register for a Dev Portal as well as the registration process and different registration states, for developers who want to register for the platform. It also explains account management information.

* [Manage Applications](/konnect/dev-portal/applications/dev-apps/) - Managing application registration requests.

* [Generate credentials for an application](/konnect/dev-portal/applications/dev-gen-creds/) - This guide walks you through the process of generating and deleting API keys on the Dev Portal platform. 


