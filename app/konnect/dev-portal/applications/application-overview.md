---
title: Application Overview
no_version: true
toc: true
---

Applications consume Services in {{site.konnect_short_name}} via Application-level authentication. Developers, or the persona that logs into the {{site.konnect_short_name}} Dev Portal, use Applications they create in the Dev Portal.

Admins [enable application registration](/konnect/dev-portal/applications/enable-app-reg/) through [konnect.konghq.com](https://konnect.konghq.com) so that Developers can associate Services with Applications.

For a Developer to be able to manage Applications, they must be [granted access by an admin](/konnect/dev-portal/access-and-approval/manage-devs/) to the {{site.konnect_short_name}} Dev Portal. For more information about registering for a {{site.konnect_short_name}} Dev Portal as a Developer, see [Developer Registration](/konnect/dev-portal/access-and-approval/dev-reg/).

## Applications and Services

Multiple Services can be registered to a single Application. In the {{site.konnect_short_name}} Dev Portal, Services registered to an Application will be listed in the Application detail page, available through **My Apps** in the top-right corner dropdown menu beneath the Developer's login email.

The purpose of registering Services to an Application is to consume those Services using the Application-level authentication. Grouping authentication enables direct access to multiple Services.

As an example, the Application can represent a mobile banking app and the Services registered to the Application can be a billing API, a users API, and a legal agreements API.

## Application authentication

Generate Application credentials through the {{site.konnect_short_name}} Dev Portal in the Application detail page. The Application can have multiple credentials, or API keys. For more information about Application Credentials, refer to [Generate Credentials for an Application](/konnect/dev-portal/applications/dev-gen-creds/).

In [konnect.konghq.com](https://konnect.konghq.com), admins can access a list of the installed authentication plugins via **Shared Config**. See [Enable Application Registration for a Service](/konnect/dev-portal/applications/enable-app-reg/) for more information about authentication flows.

## Konnect-managed plugins

When you enable application registration on a Service,
{{site.konnect_saas}} enables two plugins automatically:
[ACL](/hub/kong-inc/acl), and one of [Key Authentication](/hub/kong-inc/key-auth)
or [OIDC](/hub/kong-inc/openid-connect). These plugins run in the background to
support application registration for the Service and are managed by
{{site.konnect_saas}}.

To disable or delete a plugin that was enabled by app registration,
you must disable app registration itself. You can't use the toggle in the
Plugins pane on a Service version, as the toggle is unavailable for
{{site.konnect_short_name}}-managed plugins.

![Konnect Enable App Registration with OIDC](/assets/images/docs/konnect/konnect-enable-app-reg-oidc-toggle.png)

If using a [declarative configuration](/konnect/getting-started/declarative-config)
file to manage your Service, these plugins appear in the file. **Do not**
delete or edit them through declarative configuration, as it will break your Service.

To help differentiate the application registration plugins,
{{site.konnect_short_name}} automatically adds two metadata tags:
`konnect-managed-plugin` and `konnect-app-registration`.

For example, if you enable application registration from the
{{site.konnect_short_name}} GUI and run `deck konnect dump`, you should see
an entry like this for the ACL plugin:

```yaml
plugins:
- name: acl
  config:
    allow:
    - 0003237b-7e77-4ec4-8dd0-b1b587305c28
    deny: null
    hide_groups_header: false
  enabled: true
  protocols:
  - grpc
  - grpcs
  - http
  - https
  tags:
  - konnect-managed-plugin
  - konnect-app-registration
  ```
