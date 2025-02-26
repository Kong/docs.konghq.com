---
title: Publishing
---

Publishing an API makes it available to one or more Dev Portals, and with the appropriate [Security Settings](settings/security) and [Access and Approvals](../access-and-approvals/), can publish security to the appropriate audience.

Be sure you have [created APIs](../apis) before attempting to publish to your Dev Portals

## Publish an API to Dev Portals

There are two methods for publishing an API, for your convenience:
* Click on your Dev Portal, and select **Published APIs**. Click **Publish**
* Click on **APIs**, and select the API you want to publish. Click **Publish**

In both cases, you'll see the same dialog. 
* Select the portal you want to publish to
* The Authentication Strategy will be set to the default in Settings/Security for that portal. You can change this Authentication Strategy if desired. This will determine how Developers will generate credentials to call the API.
* Visibility determines if Developers need to register to view the API. 

### Access control scenarios

Visibility, Authentication strategies, and User authentication can be independently configured to maximize fleixbility in how you publish your API to a given Developer audience.

{:.note}
> *Visibility of [Pages](customization/custom-pages) and [Menus](customization/customization.md) are configured independently from APIs, maximizing your flexibility.

{:.note}
> *In order for credential generation to properly restrict access to your API with Authentication Strategies, a Konnect Gateway Service must be [linked to your API](../apis/gateway-service-link). Gateway version 3.6+ supported. * 

#### Viewable by anyone, no self-service credentials
Anyone can view the API's specs and documentation, but cannot generate credentials/API keys. No Developer registration is required.
  * Visibility: Public
  * Authentication strategy: Disabled
  * User authentication: Disabled in [Seucrity settings](settings/security)

#### Viewable by anyone, self-service credentials
Anyone can view the API's specs and documentation, but must sign up for a Developer account and create an Application to generate credentials/API keys.
  * Visibility: Public
  * Authentication strategy: `key-auth` (or any other appropriate Authentication strategy)
  * User authentication: Enabled in [Security settings](settings/security)
  * RBAC: Disabled, if you don't need to manage fine grained access with Teams, configured in [Security settings](settings/security)

#### Viewable by anyone, self-service credentials with RBAC
Anyone can view the API's specs and documentation, but must sign up for a Developer account and create an Application to generate credentials/API keys. Konnect Admin must assign Developer to a Team to provide specfic role-based access.
  * Visibility: Public
  * Authentication strategy: `key-auth` (or any other appropriate Authentication strategy)
  * User authentication: Enabled in [Security settings](settings/security)
  * RBAC: Enabled (allows for [Teams](../access-and-approvals/teams) assignments for Developers, grants credentials with the API Consumer role)  in [Security settings](settings/security)

#### Signup required to view API specs and/or documentation
All users must sign up for a Developer account in order to view APIs. Optionally, they can create an Application to generate credentials/API keys with RBAC.
  * Visibility: Private
  * Authentication strategy: `key-auth` (or any other appropriate Authentication strategy)
  * User authentication: Enabled in [Security settings](settings/security)
  * RBAC(optional): Enabled (allows for [Teams](../access-and-approvals/teams) assignments for Developers, grants credentials with the API Consumer role)  in [Security settings](settings/security)
