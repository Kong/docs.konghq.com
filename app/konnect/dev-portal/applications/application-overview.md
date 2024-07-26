---
title: Applications Overview
toc: true
content_type: explanation
---

The purpose of registering services to an application is to consume those services using application-level authentication. An application can register multiple services, provided they use the same authentication strategy. Grouping authentication enables direct access to multiple services. The application can host multiple credentials or API keys. For more information about application credentials, refer to [Generate Credentials for an Application](/konnect/dev-portal/applications/dev-gen-creds/).

In the {{site.konnect_short_name}} Dev Portal, an application's associated services are displayed on its details page. To view all applications linked to your account, select **My Apps** from the dropdown menu beneath your login email in the Dev Portal.

In [cloud.konghq.com](https://cloud.konghq.com), admins can access a list of the installed authentication plugins via the **Gateway Manager**. See [Enable Application Registration for a Service](/konnect/dev-portal/applications/enable-app-reg/) for more information about authentication flows.

Once a developer is [granted access](/konnect/dev-portal/access-and-approval/manage-devs/) to the {{site.konnect_short_name}} Dev Portal, they can create, edit, and delete applications. These modifications are all managed on the **My Apps** page. **My Apps** allows you to view all of your registered applications. Clicking on individual applications from this page opens a detailed overview of an application.

You can perform the following actions from an application's details page:

- [Edit](#edit-an-application) the name, reference ID, and description of an application.
- [Generate or delete credentials](/konnect/dev-portal/applications/dev-gen-creds/).
- View a catalog of services that can be [registered with the application](/konnect/dev-portal/applications/dev-apps), if no services are registered yet.
- View the status of an application registration to an API product.
- Open the analytics dashboard and view metrics about an application.

## Application authentication considerations

### App registration minimum versions

App registration is supported using the `konnect-application-auth` plugin, available as of {{site.base_gateway}} 3.0.x. 
For compatibility with app registration features, ensure all Gateway nodes in relevant control planes are using the following minimum versions:

| Feature    | {{site.base_gateway}} version |
| -------- | ------- |
| App registration with a single auth strategy  | 3.0.x    |
| App registration with different auth strategies across multiple Dev Portals | 3.6.x     |

{:.note}
> **Note:** {{site.konnect_saas}} organizations created before July 2024 include a legacy mode control plane by default, which uses a different app registration setup. This includes the `acl`, `key-auth`, and `openid-connect` plugins and the `consumers` entity. These control planes are compatible with all {{site.konnect_saas}} supported versions {{site.base_gateway}}, including 2.x.

### Differences between control plane groups

The `konnect-application-auth` plugin manages access control and API key authentication for app registration and replaces the need for the `acl` and `key-auth` plugins. It is used in every non-`default` control plane group. 

In the `default` control plane group, applications are linked to {{site.base_gateway}} consumers and use the `acl` plugin to control access between an application’s consumers and an API product version. For all other control planes, applications are not linked to {{site.base_gateway}} consumers.

### Disabling app registration or removing application authentication

Disabling application registration ensures Dev Portal developers can no longer request new registrations for the API product version. Existing registrations are not affected. You can disable application registration from the API product version settings.

Removing an authentication strategy from a product version removes the plugins that were initially applied when adding the auth strategy to the version. This opens the API traffic directly to any upstream if there are no other plugins to control request traffic. You can remove an authentication strategy from the API product version settings.

### Known limitations

The internal `konnect-application-auth` plugin only supports {{site.base_gateway}} 3.0 or later. If you need to use a version of {{site.base_gateway}} before 3.0, you must create your API product version that is linked to a Gateway service in the `default` group, which still supports consumer mapping with the `acl` plugin.

The `konnect-application-auth` plugin does not connect applications to {{site.base_gateway}} consumers. Therefore, any applications created through the app registration process in any non-default control plane group won't support rate limiting plugins. This will be addressed in a future release.

If you don't use any rate limiting plugins, we recommend upgrading your data plane nodes to {{site.base_gateway}} version 3.0 or later to ensure future compatibility with the `konnect-application-auth` plugin, which has a built-in replacement for the `acl` plugin.

{:.note}
> **Note:**  Although it can be renamed, the [`default` control plane group](/konnect/gateway-manager/control-plane-groups/) will always be the first and oldest control plane group in each geo.

## More information

* [How to create, edit and delete applications](/konnect/dev-portal/applications/dev-apps/)
* [How to enable and disable app registration](/konnect/dev-portal/applications/enable-app-reg/)
* [How to register or unregister an application for a Service](/konnect/dev-portal/applications/dev-apps/)
* [How to generate credentials for an application](/konnect/dev-portal/applications/dev-gen-creds/)
