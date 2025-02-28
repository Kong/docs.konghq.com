---
title: Publishing
---

Publishing an API makes it available to one or more Dev Portals, and with the appropriate [Security Settings](/dev-portal/portals/settings/security) and [Access and Approvals](/dev-portal/access-and-approvals/), can publish security to the appropriate audience.

Be sure you have [created APIs](/dev-portal/apis) before attempting to publish to your Dev Portals

## Publish an API to Dev Portals

There are two methods for publishing an API, for your convenience:
* Click on your Dev Portal, and select **Published APIs**. Click **Publish**
* Click on **APIs**, and select the API you want to publish. Click **Publish**

In both cases, you'll see the same dialog. 

1. Select the **Dev Portal** you want to publish the API to.
2. Change the **Authentication Strategy** if desired. The **Authentication Strategy** will be set to the default in Settings/Security for that Dev Portal. This will determine how Developers will generate credentials to call the API.
3. Select the appropriate **Visibility**, it will also be set to the default in Settings/Security. Visibility determines if Developers need to register to view the API or generate credentials / API keys. 

## Change Published API

To change the **Visibility** or **Authentication Strategy)) of an API that has been published to one or more Dev Portals, 

1. Browse to a **Published API**.
2. Select the **Portals** tab to see where the API has been previously published.
3. On the three dots menu on the appropriate Dev Portal, select **Edit Publication**
4. Change **Visibility** and **Authentication Strategy** to the appropriate values
5. Click **Save**

### Access control scenarios

Visibility, Authentication strategies, and User authentication can be independently configured to maximize flexibility in how you publish your API to a given Developer audience.

{:.note}
> *Visibility of [Pages](/dev-portal/portals/customization/custom-pages) and [Menus](/dev-portal/portals/customization/customization.md) are configured independently from APIs, maximizing your flexibility.*

{:.note}
> *An API must be linked to a Konnect Gateway Service (version 3.6+) to be able to restrict access to your API with Authentication Strategies.*

#### Viewable by anyone, no self-service credentials
Anyone can view the API's specs and documentation, but cannot generate credentials/API keys. No Developer registration is required.
  * Visibility: Public
  * Authentication strategy: Disabled
  * User authentication: Disabled in [Security settings](/dev-portal/portals/settings/security)

#### Viewable by anyone, self-service credentials
Anyone can view the API's specs and documentation, but must sign up for a Developer account and create an Application to generate credentials/API keys.
  * Visibility: Public
  * Authentication strategy: `key-auth` (or any other appropriate Authentication strategy)
  * User authentication: Enabled in [Security settings](/dev-portal/portals/settings/security)
  * RBAC: Disabled, if you don't need to manage fine grained access with Teams, configured in [Security settings](/dev-portal/portals/settings/security)

#### Viewable by anyone, self-service credentials with RBAC
Anyone can view the API's specs and documentation, but must sign up for a Developer account and create an Application to generate credentials/API keys. Konnect Admin must assign Developer to a Team to provide specfic role-based access.
  * Visibility: Public
  * Authentication strategy: `key-auth` (or any other appropriate Authentication strategy)
  * User authentication: Enabled in [Security settings](/dev-portal/portals/settings/security)
  * RBAC: Enabled (allows for [Teams](/dev-portal/access-and-approvals/teams) assignments for Developers, grants credentials with the API Consumer role)  in [Security settings](/dev-portal/portals/settings/security)

#### Signup required to view API specs and/or documentation
All users must sign up for a Developer account in order to view APIs. Optionally, they can create an Application to generate credentials/API keys with RBAC.
  * Visibility: Private
  * Authentication strategy: `key-auth` (or any other appropriate Authentication strategy)
  * User authentication: Enabled in [Security settings](/dev-portal/portals/settings/security)
  * RBAC(optional): Enabled (allows for [Teams](/dev-portal/access-and-approvals/teams) assignments for Developers, grants credentials with the API Consumer role)  in [Security settings](/dev-portal/settings/security)
