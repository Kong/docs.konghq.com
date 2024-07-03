---
title: Configure Auth0 IdP for Dev Portal
content_type: how-to
---

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
