---
title: Configure SSO for Dev Portal
content_type: how-to
---

You can configure single sign-on (SSO) for {{site.konnect_short_name}} Dev Portal with OIDC. This allows developers to log in to Dev Portals by using their SSO credentials. 

Developers do get auto-approved by Konnect when using SSO. This is because we outsource the approval process to the IDP instance when using SSO. Meaning it is possible to restrict who can sign up via the IDP rather than through Konnect.

SSO and IDP team mappings must come from the same IDP instance.

{:.note}
> **Note:** This SSO is different than the one for Konnect. If they want to use SSO for logging in to Konnect, they still need to configure that separately. Also could be good to note that each Dev Portal has a separate SSO configuration. They can use the same IDP for multiple portals or different IDPs per portal.

## Prerequisites

* Ensure that any users that need to use the Dev Portal SSO have been added to the **User Management > Users** section of your IdP tenant
* An application for {{site.konnect_short_name}} configured in your IdP. You can use other IdPs than the ones listed below as long as they follow the OIDC standard for SSO.
    * [Okta](https://help.okta.com/en-us/content/topics/apps/apps_app_integration_wizard.htm)
    * [Azure AD](https://learn.microsoft.com/graph/toolkit/get-started/add-aad-app-registration)
    * [Auth0](https://auth0.com/docs/get-started/auth0-overview/create-applications)


## Configure an application and group claims in your IdP
{% navtabs %}
{% navtab Azure %}

1. In [Azure](https://portal.azure.com/), [create an application](https://learn.microsoft.com/en-us/entra/identity-platform/quickstart-register-app?tabs=certificate) for {{site.konnect_short_name}}. 

1. Enter the Dev Portal [Redirect URI](/konnect/dev-portal/access/) for the **Redirect URI**. 

1. [Create a client secret](https://learn.microsoft.com/en-us/entra/identity-platform/quickstart-register-app?tabs=client-secret) and save the secret value to configure {{site.konnect_short_name}}.

1. [Use the OIDC well-known discovery endpoint](https://learn.microsoft.com/en-us/azure/active-directory-b2c/secure-api-management?tabs=app-reg-ga#get-a-token-issuer-endpoint) to find and save the `issuer` value. 
    The `issuer` value will be used as the provider URL when configuring SSO in {{site.konnect_short_name}}.

1. [Add a group claim](https://learn.microsoft.com/en-us/entra/identity-platform/optional-claims?tabs=appui#configure-groups-optional-claims). Enable all the group types settings and select **Group ID** for each setting in the token properties type.

1. [Configure an optional claim](https://learn.microsoft.com/en-us/entra/identity-platform/optional-claims?tabs=appui#configure-optional-claims-in-your-application) with **ID** as the token type and **email** as the claim.

{% endnavtab %}
{% navtab Okta %}

1. Create a [new OIDC application in Okta](https://help.okta.com/oie/en-us/content/topics/apps/apps_app_integration_wizard_oidc.htm) to manage {{site.konnect_saas}} account integration. Configure the following settings:
    * **Application Type**: Web Application
    * **Grant type**: Authorization Code
    * **Sign-in redirect URIs**: `https://cloud.konghq.com/login`
    * **Sign-out redirect URIs**: `https://cloud.konghq.com/login`

    Leave this page open. You'll need the connection details here to configure your {{site.konnect_saas}} account.

1. (Optional) If you want to use group claims for Konnect [developer team mappings](/konnect/dev-portal/access-and-approval/add-teams/), click the **Claims** tab in Okta to [configure a `groups` claim](https://developer.okta.com/docs/guides/customize-tokens-groups-claim/main/#add-a-groups-claim-for-a-custom-authorization-server) and fill in the following fields:

    Field | Value
    ---|---
    Name | `groups`
    Include in token type | ID token, Always
    Value type | Groups
    Filter | Select **Matches regex** from the drop-down, then enter `.*` in the field.
    Include in | Choose **The following scopes** and select `openid`, `email`, and `profile`. 

    This claim tells Okta to reference a subset of Okta groups.
    In this case, the wildcard (`.*`) value tells Okta to make all groups
    available for team mapping.

    {:.important}
    > If the authorization server is pulling in additional groups from
    third-party applications (for example, Google groups), the `groups` claim
    cannot find them. An Okta administrator needs to duplicate those groups and
    re-create them directly in Okta. They can do this by exporting the group in
    question in CSV format, then importing the CSV file to populate the new group.

1. [Add users to the application](https://help.okta.com/en-us/content/topics/users-groups-profiles/usgp-assign-apps.htm).

1. [Test ID token claims](https://developer.okta.com/docs/guides/customize-authz-server/main/#create-claims) and find groups for mapping. Configure the following claims settings:
    * **OAuth/OIDC client**: Enter the client name you previously created for your Okta application
    * **Grant Type**: Authorization Code
    * **User**: Select an Okta user that is assigned to the {{site.konnect_short_name}} application to test the claim with
    * **Scope**: `openid`, `email`, `profile`

    In the generated **Preview Token** preview, ensure that the `groups` value is present. From the list of groups in the preview, identify groups that you want to use in {{site.konnect_short_name}}. Take note of these groups.

{% endnavtab %}
{% navtab Auth0 %}
Kong offers OIDC support to allow Single-Sign-on for {{site.konnect_short_name}} and the Dev Portal. This guide shows you how to configure Auth0 for Dev Portal SSO.

1. [Create an application in Auth0](https://auth0.com/docs/get-started/auth0-overview/create-applications/machine-to-machine-apps) and configure the following settings:
    * **Application Type**: Machine to Machine Applications
    * **Authorized API**: Auth0 Management API
    * **Permissions**: Authorize the application for at least one permission, for example: `read:client_grants`. 
    This permission can be revoked later if desired, but one permission is required to create the application.

1. [Configure the Auth0 application settings](https://auth0.com/docs/get-started/applications/application-settings):
    * **Application Login URI**: `https://cloud.konghq.com/login`
    * **Allowed Callback URLs**: `https://cloud.konghq.com/login`
    * **Grant Types**: Authorization Code

## Configure Login Action in Auth0

   {:.note}
   > **Important:** This section is required due to the Auth0 API implementation not being inline with the OIDC standard for the value of the `updated_at` token claim.
1. Navigate to the **Actions > Flows** section in Auth0

1. Select the **Login** flow

1. Add an action using the button in the corner of the interactive Login Flow diagram

    * Choose **Build from scratch** when selecting the action type
    * Name the action something like `konnect_transform_updated_at_integer`

1. Replace the new action's default code with the following snippet, making it compatible with Konnect's OIDC integration:

```js
exports.onExecutePostLogin = async (event, api) => {
  if (event.authorization) {
    // This transforms the ISO 8601 Timestamp string into the seconds integer representation that is expected for the OIDC standard,
    // allowing the Konnect SSO validation to accept the format of the `updated_at` property when parsing the token claim.
    api.idToken.setCustomClaim('updated_at', Math.floor(new Date(event.user.updated_at).getTime()/1000))
  }
};
```

1. Deploy the newly created action

1. In the Login Flow diagram, select the **Custom** tab and drag the newly deployed action between the Start and Complete steps in the diagram.

1. Click **Apply** to save the changes
{% endnavtab %}
{% endnavtabs %}

## Configure SSO in {{site.konnect_short_name}}

From the [{{site.konnect_short_name}} portal identity page](https://cloud.konghq.com/portal/portal-settings#identity), click **Configure provider** for **OIDC**, and enter the values from your IdP application.

This table maps the {{site.konnect_short_name}} values to the corresponding IdP values:

| {{site.konnect_short_name}} value      | Azure value | Okta value | Auth0 value |
| ----------- | ----------- | ----------- | ----------- |
| Provider URL      | The value stored in the `issuer` variable. | The issuer URI for the authorization server. It should look something like this: `https://example.okta.com/oauth2/default` | Your Auth0 tenant's **Domain** with a leading `https://` and trailing slash `/`, e.g., `https://<your-tenant>.<region>.auth0.com/` |
| Client ID   | Your Azure application ID.        | The **Client ID** in your Okta application. | Your Auth0 application's **Client ID** value. |
| Client Secret | Azure client secret.| The **Client Secret** in your Okta application. | Your Auth0 application's **Client Secret** value. |

You can test your configuration by navigating to the Dev Portal and using your IdP credentials to log in. 