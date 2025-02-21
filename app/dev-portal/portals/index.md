---
title: Create a Dev Portal
---

The {{site.konnect_short_name}} Dev Portal is a customizable website for developers to locate, access, and consume API services.

### Common use cases:
* Internal Dev Portal
  * [Create a portal](#create-dev-portal) with Private visibility / Auth enabled.
  * Publish [all internal APIs](apis/index), secured to internal use only. 
  * [Create Pages](portals/customization/portal-editor) to document API standards, training and guidance for the developers at your organization to accelerate and standardize API development and consumption.
  * Secure portal via [IdP integration](portals/settings-security#identity-providers), to ensure only organizational members have access, and segment access by Teams.
* Partner Dev Portal 
  * [Create a portal](#create-dev-portal) with Private visibility / Auth enabled. Auth enabling the portal will provide Developers self-service API key provisioning.
  * If publicly available Pages and API specs are preferred, only requiring login for Developers in order to create Applications / provision API keys, [change default visibility of the portal to Public](portals/settings-security#default-visibility).
  * [Configure RBAC defaults](portals/settings-security#role-based-access-control) to restrict access to view a selection of APIs, as well as determine [which APIs can provide self-service API keys](apis/index).
  * [Publish a selection of available APIs](apis/index) and related documentation suited to your network of partners. 
  * Create a branded experience, and document benefits of your partner APIs with [Portal Editor and custom CSS](portals/customization/portal-editor#custom-css). 
  * Create usage guide [Pages](portals/customization/portal-editor) to provide context on how to enable use cases across multiple APIs.
* Public Dev Portal 
  * [Create a new Dev Portal](#create-dev-portal) with Public visibility and no auth.
  * [Publish a selection of available APIs](apis/index) suited to any developer.
  * Craft [highly customized pages](portals/customization/portal-editor) for landing pages, guides, etc, and [customize CSS and optimize SEO](portals/customization).


## Create Dev Portal

<!--TODO: onboarding flow-->

## Next steps

### Configure developer self-service

* [Configure Application Registration for an API](/konnect/dev-portal/app-reg/)
<!-- Before GA
* [Dynamic Client Registration Overview](/konnect/dev-portal/applications/dynamic-client-registration/): Dynamic Client Registration (DCR) within Konnect Dev Portal allows applications created in the portal to automatically create a linked application in a third-party Identity Provider (IdP).
-->

### Configure Dev Portal customization

* [Change Konnect Dev Portal settings](/portals/settings)
* [Change Konnect Dev Portal security](/portals/settings-security)
* [Customize the Konnect Dev Portal](portals/customization)

### Publish APIs to Dev Portals

* [Publish APIs to a Dev Portal](apis/)
* [Add and publish API documentation](portals/apis/docs)

### Configure audit logs for Dev Portal
* [Dev Portal audit logs](/konnect/dev-portal/audit-logging/): Keep track of Dev Portal authentication, authorization, and access logs in a SIEM provider
