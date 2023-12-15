---
title: Configure your Custom IdP for Dynamic Client Registration
breadcrumb: Custom
content_type: explanation
description: Learn how to configure your custom IdP for Dynamic Client Registration in Konnect.
---

{{site.konnect_short_name}} Dev Portal supports a variety of the most widely adopted identity provider (IdP) for [Dynamic Client Registration (DCR)](/konnect/dev-portal/applications/dynamic-client-registration/):

* Auth0
* Azure
* Curity
* Okta

If your third-party IdP is not on this list, you can still use your IdP with {{site.konnect_short_name}} by using Kong’s open source HTTP DCR bridge. This HTTP DCR bridge acts as a proxy and translation layer between your IdP and DCR applications in the Dev Portal. This bridge allows you to enable a DCR integration between the Dev Portal and your third-party IdP or IdP that isn't exposed to the internet. This integration can act as either a translation layer to bridge to your network <!--either translation layer or....???-->.

{% mermaid %}
sequenceDiagram
    actor Developer
    participant Konnect Dev Portal
    participant Translation layer
    participant Common domain cookie
    Developer->>Konnect Dev Portal: Create application
    Konnect Dev Portal->>Translation layer: Create application
    Translation layer->>Common domain cookie: POST fidm.oidc.createRP
    Common domain cookie--)Translation layer: 200 OK and credentials
    Translation layer->>Konnect Dev Portal: Create app (with credentials from CDC)
    Konnect Dev Portal->>Developer: Show credentials
{% endmermaid %}

> _**Figure 1:** This diagram shows how Kong's HTTP DCR bridge generates credentials from an IdP when a developer creates and application. First, a developer tries to create an application in {{site.konnect_short_name}} Dev Portal. This triggers Dev Portal to pass the information to the translation layer, which then sends a `POST fidm.oidc.createRP` request to the common domain cookie (CDC). Once the CDC receives the request, it sends a `200` status code in return, if successful, as well as credentials for the developer. The translation layer then creates the app with the credentials from the CDC, and then the Dev Portal shows the credentials to the developer._

## Configure custom DCR using the {{site.konnect_short_name}} Dev Portal DCR Handler

To use this HTTP DCR bridge, you must integrate the [{{site.konnect_short_name}} Dev Portal DCR Handler spec](https://github.com/Kong/konnect-portal-dcr-handler/blob/main/openapi/openapi.yaml)<!--integrate with what? replace this link with a link to the spec in our docs-->. Kong provides an example reference implementation in the [{{site.konnect_short_name}} Dev Portal DCR Handler repository](https://github.com/Kong/konnect-portal-dcr-handler). This is an example bridge implementation and is not meant to be deployed in production. We encourage you to use this implementation as a guide to create your own implementation. 

Any operation that does not return a `2xx` status code is considered failing and won't continue the process of trying to create an application in your {{site.konnect_short_name}} portal.
