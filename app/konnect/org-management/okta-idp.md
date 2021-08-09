---
title: Set Up Okta IdP Authentication
no_version: true
badge: enterprise
---

As an alternative to Konnect Cloud’s native basic authentication, you can set up
org access through Okta. This way, your users can log in to Konnect Cloud
using their Okta credentials, and without needing a separate login.

You can't mix authenticators in Konnect Cloud. With Okta IdP
authentication enabled, all non-admin Konnect users will subsequently log in
through Okta. Only Konnect admins can continue to log in with basic
authentication.

> This feature is only available with Kong Konnect Enterprise.

## Prerequisites
* [**Organization Admin**](/konnect/reference/org-management/#role-definitions)
permissions in Konnect Cloud
* [Okta developer account](https://developer.okta.com/)

## Set up Okta IdP Auth

### Prepare the Okta application

Create a new application in Okta to manage Konnect Cloud account integration.

1. Sign in to your [Okta developer account](https://developer.okta.com/).
1. Click **Applications**, then **Create Integration**.
1. Select the application type:
    1. Under **Sign-on method**, select **OIDC - OpenID Connect**.
    1. Under **Application Type**, select **Web Application**.
1. Click **Next**.Configure the application:
    1. Create a unique name for your application.
    1. Under **Grant Type**, select **Authorization Code**.
    1. In both the **Sign-in redirect URIs** and
**Sign-out redirect URIs** fields, enter `https://{YOUR_KONNECT_APP_DOMAIN}/login`.

      Replace `{YOUR_KONNECT_APP_DOMAIN}` with your own domain.
1. Save your settings to generate connection details.

    Leave this page open. You'll need the details here to configure your Konnect
    Cloud account.

### Set the default IdP for Konnect Cloud

1. In a separate browser tab, log in to Konnect Cloud.
1. Open **Settings**, then **Identity Management**.
1. Select **Okta**.
1. Copy and paste the **Client ID** and **Client Secret** from your Okta
application into Konnect Cloud.
1. Create the **Issuer URL**:
    1. Copy the **Okta domain** from your Okta application.
    1. Paste it into the **Issuer** field in Konnect using the following format:

        `https://{OKTA_DOMAIN}/oauth2/default`
1. Save your changes.
1. Copy the generated login URL.

    This is your organization's login URL. Provide this URL to users to let them
    log in to Konnect with Okta.

1. Paste the URL into a browser window.
This should load an Okta application login screen.
1. Log in with your Okta credentials.

### Enable Konnect Cloud as a dashboard app in Okta

If you want your users to have easy access to Konnect Cloud, you can add it to
your Okta dashboard.

1. Sign in to your [Okta developer account](https://developer.okta.com/).
1. Click **Applications**, then open your Konnect Cloud Okta application.
1. Scroll to **General Settings** and click **Edit** to configure the following:
    1. **Grant Type**: Select the **Implicit (Hybrid)** checkbox.
    1. **Login Initiated by**: Select **Either Okta or App** from the dropdown.
    1. **Aplication visibility**: Select **Display application icon to users**.
    1. **Initiate login URI**: Paste your organization's login URL.
        You can find this URL in Konnect Cloud under **Settings** >
        **Identity Management**.
