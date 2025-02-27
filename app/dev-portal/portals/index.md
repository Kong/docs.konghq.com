---
title: Create a Dev Portal
---

The Konnect Dev Portal is a customizable website for developers to locate, access, and consume API services.

### Get started

Your Dev Portal use case might dictate different security settings tailored to your audience. While this is not comprehensive of all possibilities, these are typical scenarios. Keep in mind it's quite common to have multiple Dev Portals, and your APIs are shared across them. 

#### Internal Dev Portal
  * [Create a portal](#create-dev-portal) with Private visibility / Auth enabled.
  * Publish [all internal APIs](/dev-portal/apis/index), secured to internal use only. 
  * [Create Pages](/dev-portal/portals/customization/portal-editor) to document API standards, training and guidance for the developers at your organization to accelerate and standardize API development and consumption.
  * Secure portal via [IdP integration](/dev-portal/portals/settings/security#identity-providers), to ensure only organizational members have access, and segment access by Teams.

#### Partner Dev Portal 
  * [Create a portal](#create-dev-portal) with Private visibility / Auth enabled. Auth enabling the portal will provide Developers self-service API key provisioning.
  * If publicly available Pages and API specs are preferred, only requiring login for Developers in order to create Applications / provision API keys, [change default visibility of the portal to Public](/dev-portal/portals/settings/security#default-visibility).
  * [Configure RBAC defaults](/dev-portal/portals/settings/security#role-based-access-control) to restrict access to view a selection of APIs, as well as determine [which APIs can provide self-service API keys](/dev-portal/portals/apis/index).
  * [Publish a selection of available APIs](/dev-portal/portals/apis/index) and related documentation suited to your network of partners. 
  * Create a branded experience, and document benefits of your partner APIs with [Portal Editor](/dev-portal/portals/customization/portal-editor). 
  * Create usage guide [Pages](/dev-portal/portals/customization/portal-editor) to provide context on how to enable use cases across multiple APIs.

#### Public Dev Portal 
  * [Create a new Dev Portal](#create-dev-portal) with Public visibility and no auth.
  * [Publish a selection of available APIs](/dev-portal/apis/index) suited to any developer.
  * Craft [highly customized pages](/dev-portal/portals/customization/portal-editor) for landing pages, guides, etc, and [customize header & footer menus and optimize SEO](/dev-portal/portals/customization).


## Create Dev Portal

The only required choices are "Private" or "Public", and provide a name for the Dev Portal. Optionally, you can specify the first API specification to publish. 

### Access control
During portal creation, "Private" and "Public" change a variety of settings to streamline your onboarding. They can all be changed later in [Settings/Security](/dev-portal/portals/settings/security).

#### Private
* Enables User Authentication
* Default Page visibility: Private
* Default API visibility: Private

#### Public
* Disables User Authentication
* Default Page visibility: Private
* Default API visibility: Private

### Upload your first API
Optionally, you can create and publish your first API by uploading an OpenAPI 3.x specification. If you are creating more than one Dev Portal, or previously uploaded APIs, you can also select from an existing API.

### Appearance
After clicking Next, your Dev Portal will be created, and you'll be presented with basic options to customize the look and feel. These settings can be changed later in Portal Editor in the [Appearance](/dev-portal/portals/customization/appearance) tab.

## Next steps

### Configure developer self-service

* [Configure Application Registration](/dev-portal/app-reg/)

<!-- Before GA
* [Dynamic Client Registration Overview](/dev-portal/applications/dynamic-client-registration/): Dynamic Client Registration (DCR) within Konnect Dev Portal allows applications created in the portal to automatically create a linked application in a third-party Identity Provider (IdP).
-->

### Customize

* [Change settings](/dev-portal/portals/settings/general)
* [Change security](/dev-portal/portals/settings/security)
* [Customize the experience](/dev-portal/portals/customization)
* [Configure a custom domain](/dev-portal/portals/custom-domains)

### Publish API specs and documentation

* [Publish APIs](/dev-portal/apis/)
* [Add and publish API documentation](/dev-portal/apis/docs)

### Configure audit logs
* [Audit logs](/dev-portal/portals/audit-logs): Keep track of Dev Portal authentication, authorization, and access logs in a SIEM provider
