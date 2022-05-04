---
title: Enable and Disable Application Registration for a Service
no_version: true
toc: true
---

If your Develop[er Portal has application registration enabled, developers must
[register an application](/konnect/dev-portal/applications/dev-reg-app-service)
in order to access a Service. All versions of a service will share the same authentication plugin. If you add a new version to a Service, it will inherit the authentication plugin automatically. This guide will walk you through the two supported authentication plugins:
- [Key Authentication](#konnect-key-auth-flow)
- [OpenID Connect](#oidc-flow)
Once enabled, you can [disable application registration](#disable)
at any time.


{:.important}
> **Important:** Developers registered through app registration appear as
consumers on the
![icon](/assets/images/icons/konnect/konnect-shared-config.svg){:.inline .no-image-expand}
Shared Config page. Do not delete the ACLs associated with a consumer managed
by app registration.

## Prerequisites

- [**Organization Admin** or **Service Admin**](/konnect/org-management/teams-and-roles)
permissions.

- The Services have been created, versioned, and published to the
  {{site.konnect_short_name}} Dev Portal so that they appear in the Catalog.

- If you are using [OpenID Connect](#oidc-flow) for your authorization:

  - Set up your application, claims, and scopes in your OpenID identity provider as
    appropriate for your requirements. Refer to your IdP/OP documentation for instructions.

  - Be sure to edit the **Reference ID** field in the Dev Portal
    [Update Application](/konnect/dev-portal/applications/dev-apps#edit-my-app)
    dialog to match to your third-party OAuth2 claim.

## Enable App Registration with Key Authentication {#konnect-key-auth-flow}

1. From the {{site.konnect_short_name}} menu, click {% konnect_icon servicehub %}**ServiceHub** and select a
Service. Now, click the **Versions** button and select the desired version. 

2. From the **Actions** dropdown menu, select **Enable app registration**.

3. Select `key-auth` from the **Auth Type** list.
  >Optionally, click to enable [**Auto Approve**](#autoapprove-auth) for application registrations for the selected Service.

4. Click **Enable**.

    With app registration enabled, all versions of this service now include
    read-only entries for the `acl` and `key-auth` plugins.

### Enable Auto Approve {#autoapprove-auth}

If you enable Auto Approve, any developer application request will be automatically approved. Applications will not need to be [manually approve](/konnect/dev-portal/applications/manage-app-reg-requests/). You have the option to [enable Auto Approve portal-wide](/konnect/dev-portal/access-and-approval/auto-approve-devs-apps) using the Developer Portal settings. This action will override a Service specific Auto-Approve setting. 


## Enable App Registration with OpenID Connect {#oidc-flow}

1. From the {{site.konnect_short_name}} menu, click {% konnect_icon servicehub %} **ServiceHub** and select a
Service. Now, click the **Versions** button and select the desired version. 

2. From the **Actions** menu, click **Enable app registration**.

3. Select `openid-connect` (default) from the **Auth Type** list.

   Refer to the [configuration paramaters section](#openid-config-params) for information
   about each field.


4. Click **Enable**.

    With app registration enabled, all versions of this service now include
    read-only entries for the `acl` and `oidc` plugins.

###  OpenID Connect Configuration Parameters {#openid-config-params}

   | Form Parameter | Description                                                                       |
   |:---------------|:----------------------------------------------------------------------------------|
   | `Issuer` | The issuer URL from which the OpenID Connect configuration can be discovered. For example: `https://dev-1234567.okta.com/oauth2/default`. Required. |
   | `Scopes` | The scopes to be requested from your OP (OpenID Provider). Enter one or more scopes separated by spaces, such as `open_id` `myscope1`. Optional. |
   | `Consumer claims` |  Name of the claim that is used to find a consumer. Required. |
   | `Auth method` | The supported authentication method or methods you want to enable. This field should contain only the authentication methods that you need to use; otherwise, you unnecessarily widen the attack surface. Separate multiple entries with a comma. Available options: `password`, `client_credentials`, `authorization_code`, `bearer`, `introspection`, `kong_oauth2`, `refresh_token`, `session`. Required. |
   | `Hide Credentials` | Whether to show or hide the credential from the Upstream service. If enabled, the plugin strips the credential from the request (in the header, query string, or request body that contains the key) before proxying it. Default: disabled. Optional.|
   | `Auto Approve` | Automatically approve developer registration requests for an application. A Konnect admin does not need to [manually approve](/konnect/dev-portal/applications/manage-app-reg-requests/) application registration requests. Default: disabled. Optional. |

   For more background information about OpenID Connect plugin parameters, see
   [Important Configuration Parameters](/hub/kong-inc/openid-connect/#important-configuration-parameters).

## Disable App Registration for a Service {#disable}

You can disable app registration for a Service when an API
no longer requires authentication. If you want to disable Auto Approve at the
Service level, disable app registration and then enable it again with the Auto Approve
toggle set to disabled.

**Disable application registration from the Service Version page only**.
Do not attempt to disable application registration by deleting or disabling the
read-only application registration plugins (`acl` and `key-auth` or `openid-connect`).
Attempting to remove them manually will break your Service. See the
Application Overview section on
[{{site.konnect_short_name}}-managed plugins](/konnect/dev-portal/applications/application-overview/#konnect-managed-plugins)
for more information.

You can
[enable application registration](/konnect/dev-portal/applications/enable-app-reg)
again any time.

## Disable app registration

1. From the {{site.konnect_short_name}} menu, click **Services** and select a Service.

1. From the **Actions** menu, select **Disable app registration**.

1. Click **Disable**.

## Troubleshooting

If you encounter any of the errors below that can appear in the Enable App Registration dialog,
follow the recommended solution.

| Error Message | Solution |
|------------------------------|---------------------------------------------------------------------------------|
| No Service implementation in the Service package. | Create a Service implementation. See the [example](/konnect/configure/servicehub/manage-services/#implement-service-version) in the Quickstart Guide, and the [ServiceHub](/konnect/configure/servicehub/manage-services/#implement-service-version) documentation. |
| Schema violation, config.issuer: missing host in url (openid-connect)| Be sure to include the host in the Issuer URL of your identity provider. For example: `https://dev-1234567.okta.com/oauth2/default`. |