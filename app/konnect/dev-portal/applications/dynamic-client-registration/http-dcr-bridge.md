---
title: Configuring your Custom IdP for Dynamic Client Registration
breadcrumb: Custom
content_type: how-to
---

## Configure a Custom IdP for Dynamic Client Registration

Konnect Dev Portal supports a variety of the most widely adopted identity providers for [Dynamic Client Registration] (https://docs.konghq.com/konnect/dev-portal/applications/dynamic-client-registration/). If your third party IdP is not on this list, you can still use your IdP with Konnect by using Kong’s open source HTTP DCR bridge. This HTTP DCR bridge acts as a proxy and translation layer between your IDP and DCR Applications made in Konnect Dev Portal. This bridge allows you to enable a Dynamic Client Registration integration between Konnect Dev Portal and your third party identity provider, or non-internet exposed IdP. This integration can act as either a translation layer to bridge to your network.

In order to use this bridge, you will need to integrate the [Konnect Portal DCR Handler spec] (https://github.com/Kong/konnect-portal-dcr-handler/blob/main/openapi/openapi.yaml). Any operation that does not return a 2XX status code will be considered as failing and will not continue the process of trying to create an application in your Konnect portal.

Konnect provides an example reference implementation in the [Konnect Portal DCR Handler repository] (https://github.com/Kong/konnect-portal-dcr-handler). Please note this is an example bridge implementation and is not meant to be deployed in production. We encourage you to use this implementation as a guide to create your own implementation.
