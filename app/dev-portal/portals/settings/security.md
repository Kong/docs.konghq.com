---
title: Security Settings
---

Security settings allow for visibility and access control around Developers accessing your Dev Portal. 

{:.note}
> *To adjust security settings for Dev Portal admin/users, see [Konnect Organization settings](/konnect/org-management/auth/)*.

<!-- TODO: Settings screenshot -->

## Default Visibility

 When new APIs or Pages are created, the specified default Visibility will be used. When publishing these items, these defaults can be changed as well. 

 * Private: Registered and approved Developer must be logged into to view the asset
 * Public: Visible to anonymous users browsing the Dev Portal

{:.note}
> *Changing default Visibility does not retroactively change the visibility of existing APIs or Pages.*

<!--
### Konnect Dev Portal API
```
PATCH /portals/{portalId}
default_api_visibility: public|private
default_page_visibility: public|private
```
-->

## User Authentication

Enabling User Authentication will allow anonymous users browsing the portal to register for a Developer account. 

User Authentication must be enabled to configure any further settings related to Identity Providers, RBAC, Developer & Application registration, or specifying Application Auth Strategies. 

<!--
### Konnect Dev Portal API: 

```
PATCH /portals/{portalId}
authentication_enabled: true|false
```
-->

## Identity Providers

Identity Providers (IdP) manage authentication of Developers signing into the Dev Portal. 

Konnect’s Built-in authentication provider is used by default. This will generate API keys for Developers.

OIDC or SAML providers can be configured as an integrated IdP provider.

Learn more about configuring IdPs in [Enable Self-Service Developer & Application Registration](/dev-portal/portals/app-reg)

## Developer & Application Approvals

{:.note}
> An API must be linked to a Konnect Gateway Service (version 3.6+) to be able to restrict access to your API with Authentication Strategies.

Registration of Developer accounts and Application requires approval by portal admins by default. These approvals are managed in <Access and Approvals>.

### Auto approve developers
* Enabled: anyone can sign up for a Developer account without further approval process. 
* Disabled: portal admins will have to approve any new signup in [Access and Approvals](/dev-portal/access-and-approvals).

### Auto approve applications 
* Enabled: When any approved Developer creates an Application, it will be automatically approved. 
  * Once an application is approved, the Developer will be able to create an API Key. 
* Disable: dportal admins need to approve any new Applications in [Access and Approvals](/dev-portal/access-and-approvals) before a Developer can create API Keys.

<!--
### Konnect Dev Portal API: 

```
PATCH /portals/{portalId}
auto_approve_developers: true|false
auto_approve_applications: true|false
```
-->

## Role-Based Access Control

When RBAC is enabled for a Portal, the option to configure access policies for Developers on APIs will be available during publishing. Otherwise, any logged in Developer can see any published API that is set to `Visibility: public`.

<!--
### {site.konnect_short_name} Dev Portal API

```
PATCH /portals/{portalId}
rbac_enabled: true|false
```
-->

## Authentication Strategy / Creating API Keys

{:.note}
> An API must be linked to a Konnect Gateway Service (version 3.6+) to be able to restrict access to your API with Authentication Strategies.

Authentication strategies determine how [published APIs](/dev-portal/portals/publishing) will be authenticated, and how Developers will create API Keys. 

Authentication strategies automatically configure the Konnect Gateway service by enabling the Konnect Application Auth (KAA) plugin on that service (for APIs that are [linked](/dev-portal/apis/gateway-service-link) to a Gateway Service). The KAA plugin can only be configured from the associated Dev Portal.

### Default application authentication strategy 

Determines a default strategy to be applied to any API during publishing. Changing this default will not retroactively change any previously [published APIs](/dev-portal/portals/publishing).

*To create a new Application Authentication Strategy, see [Application Auth](/dev-portal/app-reg#authentication-strategies)*

{:.note}
> *Authentication strategy does not affect developers browsing the portal from viewing APIs. To change visibility, see [Default Visibility](#default-visibility) and [Role-based access control](#role-based-access-control).*

<!--
### Kong Dev Portal API 

```
PATCH /portals/{portalId}
Default_application_auth_strategy_id: null (none) or auth strategy uuid
```
-->

## User Authentication & Role-Based Access Control (RBAC)

Enabling User Authentication will allow anonymous users browsing the portal to register for a Developer account.  User Authentication must be enabled to configure any further settings related to Identity Providers, Developers registering, creating Applications or issuing API Keys. 

<!--
### Kong Dev Portal API

```
PATCH /portals/{portalId}
authentication_enabled: true|false
```
-->

## Identity Providers (IdP)

Identity Providers handle authentication of Developers signing into the Dev Portal. 
Konnect's Built-in authentication provider is used by default. OIDC or SAML providers can be configured as an integrated IdP provider.

*To setup security for Dev Portal admin/users, see [Konnect Organization settings](/konnect/org-management/auth/)*

## Developer/Application Approval

{:.note}
> An API must be linked to a Konnect Gateway Service (version 3.6+) to be able to restrict access to your API with Authentication Strategies.

### Auto approve developers

* Enabled: anyone can sign up for an account without further approval process. 
* Disabled: portal admins will have to approve any new signup in [Access and Approvals](/dev-portal//access-and-approvals).

### Auto approve applications

* Enabled: when any approved Developer creates an Application, it will be automatically approved. 
  * Once an application is approved, the Developer will be able to create an API Key. 
* Disabled: portal admins will have to approve any new Applications before a Developer can create API Keys in [Access and Approvals](/dev-portal/access-and-approvals).

<!--
### Konnect Dev Portal API: 

```
PATCH /portals/{portalId}
auto_approve_developers: true|false
auto_approve_applications: true|false
```
-->

## Role-Based Access Control

When RBAC is enabled for a Portal, the option to configure access policies for Developers on APIs will be available during [publishing](/dev-portal//portals/publishing). Otherwise, any logged in Developer can see any published API that is set to `Visibility: true`.

<!--
### {site.konnect_short_name} Dev Portal API: 

```
PATCH /portals/{portalId}
rbac_enabled: true|false
```
-->

## Authentication Strategy / Creating API Keys

{:.note}
> An API must be linked to a Konnect Gateway Service (version 3.6+) to be able to restrict access to your API with Authentication Strategies.

Authentication strategy determines how published APIs will be authenticated, and how Developers will create API Keys. Authentication strategies automatically configure the Konnect Gateway service by enabling the KAA Application Auth (KAA) plugin on that service. 

**Default application authentication strategy** determines a default strategy to be applied to any newly created API. Changing this default will not retroactively change any previously published APIs.
To create a new Application Authentication Strategy, navigate to **Application Auth**, more on this in [Enable Self-Service Developer & Application Registration](/dev-portal/app-reg).

{:.note}
> *Authentication strategy does not affect developers browsing the portal from viewing APIs (GA: Pages or Snippets). To change visibility, see [Default Visibility](#default-visibility) and [RBAC](#role-based-access-control).*

<!--
### {site.konnect_short_name} Dev Portal API: 

```
PATCH /portals/{portalId}
Default_application_auth_strategy_id: null (none) or auth strategy uuid
```
-->