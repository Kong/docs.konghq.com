---
title: Configure your Custom IdP for Dynamic Client Registration
breadcrumb: Custom
content_type: how-to
description: Learn how to configure your custom IdP for Dynamic Client Registration in Konnect.
---

{{site.konnect_short_name}} Dev Portal supports a variety of the most widely adopted identity provider (IdP) for [Dynamic Client Registration (DCR)](/konnect/dev-portal/applications/dynamic-client-registration/):

* Auth0
* Azure
* Curity
* Okta

If your third-party IdP is not on this list, you can still use your IdP with {{site.konnect_short_name}} by using a custom HTTP DCR bridge. This HTTP DCR bridge acts as a proxy and translation layer between your IdP and DCR applications in the Dev Portal. When a developer creates a DCR application in the Dev Portal, {{site.konnect_short_name}} calls your HTTP DCR bridge which can translate the application data into a suitable format for your third-party IdP. 

{% mermaid %}
sequenceDiagram
    actor Developer
    participant Konnect Dev Portal
    participant HTTP DCR Bridge
    participant IdP
    Developer->>Konnect Dev Portal: Create application
    Konnect Dev Portal->>HTTP DCR Bridge: POST Create application
    HTTP DCR Bridge->>IdP: POST Create application
    IdP--)HTTP DCR Bridge: 200 OK and credentials
    HTTP DCR Bridge->>Konnect Dev Portal: Create application response (with credentials from IdP)
    Konnect Dev Portal->>Developer: Show credentials
{% endmermaid %}

> _**Figure 1:** This diagram shows how an HTTP DCR bridge creates an application in an IdP when a developer creates an application in the Dev Portal. First, a developer tries to create an application in {{site.konnect_short_name}} Dev Portal. This triggers Dev Portal to pass the information to the HTTP DCR Bridge, which then sends a `POST create application` request to the IdP. Once the IdP receives the request, it sends a `200` status code in return, if successful, as well as credentials for the developer's application. These credentials are then shown to the developer in the Dev Portal._

## Configure custom DCR using the {{site.konnect_short_name}} Dev Portal DCR Handler

To use an unsupported IdP with DCR, you must implement an API that conforms to the [{{site.konnect_short_name}} Dev Portal DCR Handler spec](https://github.com/Kong/konnect-portal-dcr-handler/blob/main/openapi/openapi.yaml). Kong provides an example reference implementation in the [{{site.konnect_short_name}} Dev Portal DCR Handler repository](https://github.com/Kong/konnect-portal-dcr-handler). This is an example HTTP DCR bridge implementation and is not meant to be deployed in production. We encourage you to use this implementation as a guide to create your own implementation. 

Any request that does not return a `2xx` status code is considered failing and won't continue the process of trying to create an application in your {{site.konnect_short_name}} Dev Portal.
