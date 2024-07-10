---
title: Configure SSO for Dev Portal
content_type: how-to
---

You can configure single sign-on (SSO) for {{site.konnect_short_name}} Dev Portal with OIDC. This allows developers to log in to Dev Portals by using their SSO credentials. 

<!--Do developers get auto approved in Dev Portal then?-->

<!-- would we recommend SSO instead of adding developers and teams from IdPs if we don't want to map team? Or would we maybe recommend both (one to create/map devs and the other to let them log in to Dev Portal)-->

<!-- should we add a note that this SSO is different than the one for Konnect? As in, if they want to use SSO for logging in to Konnect, they still need to configure that separately?-->

## Configure an application and group claims in your IdP
{% navtabs %}
{% navtab Azure %}

### Create an application in Azure

1. In [Azure](https://portal.azure.com/), navigate to **App registrations**. 

1. Click **New registration** to register a new application:

1. Name the application.

1. Select **Accounts in this organizational directory only** for the **Supported account type**. 

1. Select **Web** and enter the Dev Portal [Redirect URI](/konnect/dev-portal/access/). 
    
1. Save the application ID for later.


### Configure an application in Azure

1. Click **New client secret**, enter a description, select an expiration value, and click **Add**.
    
    * Save the secret value for configuring {{site.konnect_short_name}}.


1. Click **Overview** in the sidebar, then click the **Endpoints** tab.

1. Copy the **OpenID Connect metadata document** URL and open it in your browser:

1.  Your browser will display a large JSON blob object. In the object, find and save the `issuer` value.
    
    The `issuer` value will be used as the provider URL when configuring SSO in {{site.konnect_short_name}}.

## Configure group claims in Azure

1. On your new application page in Azure, click **Token configuration** in the sidebar.

1. Click **Add groups claim** and do the following:
    1. Select each checkbox in the **Select group types to include in Access, ID, and SAML tokens** section. 
    1. Select **Group ID** for each section in **Customize token properties by type**.
    1. Click **Add**. 

    ![Group claim](/assets/images/products/konnect/dev-portal/azure-group-claim.png)

1. Click **Add optional claim**, select **ID** as the token type, and **email** as the claim.

1. Click **Add**.

## Configure SSO in {{site.konnect_short_name}}

From the [{{site.konnect_short_name}} portal identity page](https://cloud.konghq.com/portal/portal-settings#identity), click **Configure provider** for **OIDC**, and enter the values from Azure.

This table maps the {{site.konnect_short_name}} values to the corresponding Azure values. 

| {{site.konnect_short_name}} value      | Azure value |
| ----------- | ----------- |
| Provider URL      | The value stored in the `issuer` variable. |
| Client ID   | Your Azure application ID.        |
| Client Secret | Azure client secret.|

You can test your configuration by navigating to the Dev Portal and using your Azure credentials to log in. 

{% endnavtab %}
{% navtab Okta %}
## Create an application in Okta
## Configure the application in Okta
## Set up claims in Okta
## 
## Configure SSO in {{site.konnect_short_name}}
{% endnavtab %}
{% navtab Auth0 %}
Kong offers OIDC support to allow Single-Sign-on for {{site.konnect_short_name}} and the Dev Portal. This guide shows you how to configure Auth0 for Dev Portal SSO.

## Create an application in Auth0

1. Login to [Auth0](https://auth0.com/), and navigate to the management dashboard for your Auth0 tenant.

1. Navigate to the **Applications > Applications** page to and click "Create Application" create a new application.

    * Name the application, making it easy to reference as the app that manages your Konnect Dev Portal SSO integration.
    * Select **Machine To Machine** as the **Application Type**.
    * Select **Auth0 Management API** as the Authorized API.
    * Authorize the application for at least one Permission to continue, e.g. `read:client_grants`. Note: this permission can be revoked later if desired, but is required to create the application.

1. Submit the form to create the application.

## Configure the Auth0 application

1. Locate your portal's callback URL in the Konnect Identity Provider Configuration Settings page. It will have the form `https://<your_portal_domain>/login`
1. Navigate to the **Settings** tab and enter the value of your portal's callback URL into each of the following fields:

    * **Application Login URI**
    * **Allowed Callback URLs**

1. Scroll down to the **Advanced Settings** and open the **Grant Types** tab.

    * Check the box for **Authorization Code** and click **Save Changes**

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

## Configure SSO in {{site.konnect_short_name}}

From the [{{site.konnect_short_name}} portal identity page](https://cloud.konghq.com/portal/portal-settings#identity), click **Configure provider** for **OIDC**, and enter the values from your Auth0 application.

This table maps the {{site.konnect_short_name}} values to the corresponding Auth0 application values. 

| {{site.konnect_short_name}} value      | Auth0 application value |
| ----------- | ----------- |
| Provider URL      | Your Auth0 tenant's **Domain** with a leading `https://` and trailing slash `/`, e.g., `https://<your-tenant>.<region>.auth0.com/` |
| Client ID   | Your Auth0 application's **Client ID** value.        |
| Client Secret | Your Auth0 application's **Client Secret** value.|

## Add Users to Your Auth0 tenant

1. Ensure that any users that need to use the Dev Portal SSO have been added to the **User Management > Users** section of your Auth0 tenant


You can test your configuration by navigating to the Dev Portal and using your Auth0 user credentials to log in.
{% endnavtab %}
{% endnavtabs %}