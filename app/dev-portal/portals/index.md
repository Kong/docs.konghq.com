---
title: Create a Dev Portal
---

The {{site.konnect_short_name}} Dev Portal is a customizable website for developers to locate, access, and consume API services.

### Common use cases:
* Internal Dev Portal
  * [Create a portal](#create-dev-portal) with Private visibility / Auth enabled.
  * Publish [all internal APIs](../apis/index), secured to internal use only. 
  * [Create Pages](customization/portal-editor) to document API standards, training and guidance for the developers at your organization to accelerate and standardize API development and consumption.
  * Secure portal via [IdP integration](settings/security#identity-providers), to ensure only organizational members have access, and segment access by Teams.
* Partner Dev Portal 
  * [Create a portal](#create-dev-portal) with Private visibility / Auth enabled. Auth enabling the portal will provide Developers self-service API key provisioning.
  * If publicly available Pages and API specs are preferred, only requiring login for Developers in order to create Applications / provision API keys, [change default visibility of the portal to Public](settings/security#default-visibility).
  * [Configure RBAC defaults](settings/security#role-based-access-control) to restrict access to view a selection of APIs, as well as determine [which APIs can provide self-service API keys](../apis/index).
  * [Publish a selection of available APIs](../apis/index) and related documentation suited to your network of partners. 
  * Create a branded experience, and document benefits of your partner APIs with [Portal Editor and custom CSS](customization/portal-editor#custom-css). 
  * Create usage guide [Pages](customization/portal-editor) to provide context on how to enable use cases across multiple APIs.
* Public Dev Portal 
  * [Create a new Dev Portal](#create-dev-portal) with Public visibility and no auth.
  * [Publish a selection of available APIs](../apis/index) suited to any developer.
  * Craft [highly customized pages](customization/portal-editor) for landing pages, guides, etc, and [customize CSS and optimize SEO](customization).


## Create Dev Portal

The only required choices are "Private" or "Public", and provide a name for the Dev Portal. Optionally, you can specify the first API specification to publish. 

During portal creation, "Private" and "Public" change a variety of settings to streamline your onboarding. They can all be changed later in [Settings/Security](settings/security).

### Private
* Enables User Authentication
* Default Page visibility: Private
* Default API visibility: Private

### Public
* Disables User Authentication
* Default Page visibility: Private
* Default API visibility: Private

After clicking Next, your Dev Portal will be created, and you'll be presented with basic options to customize the look and feel. These settings can be changed later in Portal Editor in the [Appearance](customization/appearance) tab.

## Next steps

### Configure developer self-service

* [Configure Application Registration for an API](../app-reg/)
<!-- Before GA
* [Dynamic Client Registration Overview](/konnect/dev-portal/applications/dynamic-client-registration/): Dynamic Client Registration (DCR) within Konnect Dev Portal allows applications created in the portal to automatically create a linked application in a third-party Identity Provider (IdP).
-->

### Customize

* [Change settings](settings/general)
* [Change security](settings/security)
* [Customize the experience](customization)
* [Configure a custom domain]{custom-domains}

### Publish API specs and documentation

* [Publish APIs](../apis/)
* [Add and publish API documentation](../apis/docs)

### Configure audit logs
* [Audit logs](audit-logs): Keep track of Dev Portal authentication, authorization, and access logs in a SIEM provider
