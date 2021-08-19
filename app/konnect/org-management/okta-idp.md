---
title: Set Up Okta IdP Authentication
no_version: true
badge: enterprise
---

As an alternative to {{site.konnect_saas}}’s native authentication, you can set up
access to {{site.konnect_short_name}} through Okta. This way, your users can log in to {{site.konnect_saas}}
using their Okta credentials, and without needing a separate login.

You can't mix authenticators in {{site.konnect_saas}}. With Okta IdP
authentication enabled, all non-admin {{site.konnect_short_name}} users will subsequently log in
through Okta. Only the {{site.konnect_short_name}} org owner can continue to log in with {{site.konnect_short_name}}'s
native authentication.

## Prerequisites
* [Organization Admin](/konnect/reference/org-management/#role-definitions)
permissions in {{site.konnect_saas}}
* Access to the Okta configuration for your organization

## Set up Okta IdP integration

### Prepare the Okta application

Create a new application in Okta to manage {{site.konnect_saas}} account integration.

1. Sign in to your [Okta admin account](https://admin.okta.com/).
1. From the left menu, select **Applications**, then **Create Integration**.
1. Select the application type:
    1. Under **Sign-on method**, select **OIDC - OpenID Connect**.
    1. Under **Application Type**, select **Web Application**.
1. Click **Next**. Configure the application:
    1. Create a unique name for your application.
    1. Under **Grant Type**, select **Authorization Code**.
    1. In both the **Sign-in redirect URIs** and
**Sign-out redirect URIs** fields, enter:

        <pre><code>https://<div contenteditable="true">{YOUR_KONNECT_APP_DOMAIN}</div>/login</code></pre>

        Replace `{YOUR_KONNECT_APP_DOMAIN}` with your own domain.
1. Save your settings to generate connection details.

    Leave this page open. You'll need the details here to configure your Konnect
    Cloud account.

### Set the default IdP for {{site.konnect_saas}}

1. In a separate browser tab, log in to [{{site.konnect_saas}}](https://konnect.konghq.com).
1. Open ![settings icon](/assets/images/icons/konnect/konnect-settings.svg){:.inline .no-image-expand}
**Settings**, then **Identity Management**.
1. Select **Okta**.
1. Copy and paste the **Client ID** and **Client Secret** from your Okta
application into {{site.konnect_saas}}.

    See the [Okta developer documentation](https://developer.okta.com/docs/guides/find-your-app-credentials/findcreds/)
    to learn more about client credentials in Okta.

1. Copy the **Okta domain** from your Okta application, then paste it into
the **Issuer URL** field in {{site.konnect_short_name}}.
1. Save your changes.
1. Copy the generated login URL.

    This is your organization's new login URL. Provide this URL to users to let them
    log in to {{site.konnect_short_name}} with Okta.

1. Paste the URL into a browser window.

    This should load an Okta application login screen.

1. Log in with your Okta credentials.

### (Optional) Enable Konnect Cloud as a dashboard app in Okta

If you want your users to have easy access to {{site.konnect_saas}} alongside their other apps,
you can add it to your Okta dashboard.

1. Sign in to your [Okta admin account](https://admin.okta.com/).
1. Click **Applications**, then open your {{site.konnect_saas}} Okta application.
1. Scroll to **General Settings** and click **Edit** to configure the following:

    Field | Value
    ---   | ---
    Grant Type | `Implicit (Hybrid)`
    Login Initiated by | `Either Okta or App`
    Application visibility | `Display application icon to users`
    Initiate login URI | Your organization's login URL. You can find this URL in {{site.konnect_saas}} under **Settings** > **Identity Management**.


## Set up claims in Okta
The connection between {{site.konnect_short_name}} and Okta uses OpenID Connect
tokens. Follow the Okta documentation instructions to add two ID token claims:
* A [`groups` claim](https://developer.okta.com/docs/guides/customize-tokens-groups-claim/add-groups-claim-custom-as/)
* A [custom claim](https://developer.okta.com/docs/guides/customize-tokens-returned-from-okta/add-custom-claim/) named
`user.login`

See the table below for fields in Okta and the values to fill in:

Name          | Value type | Value                     | Scopes   | Type
---           | ---        | ---                       | ---      | ---
`groups`      | Groups     | `groups: matches regex.*` | `openid` | `id`
`login_email` | Expression | `user.login`              | `openid` | `id`

## Next steps
Now that the Okta connection is enabled, you can
[map Okta groups to {{site.konnect_short_name}} roles](/konnect/org-management/okta-role-mapping)
to grant your {{site.konnect_short_name}} users any desired permissions.
