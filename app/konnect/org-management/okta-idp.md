---
title: Set Up SSO with Okta
badge: enterprise
---


As an alternative to {{site.konnect_saas}}’s native authentication, you can set up single sign-on (SSO) access to {{site.konnect_short_name}} through Okta using OpenID Connect or SAML. These authentication methods allow your users to log in to {{site.konnect_saas}} using their Okta credentials without needing a separate login. 

You cannot mix authenticators in {{site.konnect_saas}}. With Okta authentication enabled, all non-admin {{site.konnect_short_name}} users will log in through Okta. Only the {{site.konnect_short_name}} org owner can continue to log in with {{site.konnect_short_name}}'s native authentication.

This topic covers configuring Okta. For generic instructions on configuring SAML or OIDC for use with other identity providers, see the [generic SSO guide](/konnect/org-management/sso/).

{% include_cached /md/konnect/okta-sso.md desc='Konnect Org' %}

## Set up {{site.konnect_short_name}}

### Provide Okta connection details
{% navtabs %}
{% navtab OIDC %}
1. In another separate browser tab, log in to [{{site.konnect_saas}}](https://cloud.konghq.com).
1. Click {% konnect_icon organizations %} **Organization** > **Settings**, then **Authentication Schemes**.
1. Click **Configure provider** for **OIDC**.

1. In Okta, locate your issuer URI.
    1. Go to **Security** > **API**.
    1. Copy the issuer URI for your authorization server. It should look
    something like this:

        ```
        https://example.okta.com/oauth2/default
        ```
        Where `default` is the name or ID of the authorization server.

        {:.note}
        > Note: Do not use the issuer URI from your application's settings. That
        URI is incomplete: `https://example.okta.com`.

1. Paste the issuer URI from Okta in the **Issuer URI** box in {{site.konnect_short_name}}.

1. In Okta, copy your client ID and client secret by going to **Applications > Applications** and selecting your {{site.konnect_short_name}} application. 

1. Paste the **Client ID** and **Client Secret** from your Okta
application into {{site.konnect_saas}}.

    See the [Okta developer documentation](https://developer.okta.com/docs/guides/find-your-app-credentials/findcreds/)
    to learn more about client credentials in Okta.

1. In the **Organization Login Path** box, enter a unique string. For example: `examplepath`.

    {{site.konnect_short_name}} uses this string to generate a custom login
    URL for your organization.

    Requirements:
    * The path must be unique *across all {{site.konnect_short_name}} organizations*.
    If your desired path is already taken, you must to choose another one.
    * The path can be any alphanumeric string.
    * The path does not require a slash (`/`).

1. Click **Save**.
1. From the list of authentication providers, open the context menu and **Enable OIDC**.
{% endnavtab %}
{% navtab SAML %}
1. In another separate browser tab, log in to [{{site.konnect_saas}}](https://cloud.konghq.com).
1. Click {% konnect_icon organizations %} **Organization** > **Settings**, then **Authentication Schemes**.
1. Click **Configure provider** for **SAML**.

1. In Okta, locate your Metadata :
    1. Go to **Sign On** page in the Okta application created in the previous step.
    2. Copy the **IDP Metadata URL** under the Settings section. It should look like:

             https://<your-okta-domain>.okta.com/app/exkgzjkl0kUZB06Ky5d7/sso/saml/metadata

1. In the **Login Path** box, enter a unique string. For example: `examplepath`.

   {{site.konnect_short_name}} uses this string to generate a custom login
   URL for your organization.

   Requirements:
    * The path must be unique *across all {{site.konnect_short_name}} organizations*.
      If your desired path is already taken, you must choose another one.
    * The path can be any alphanumeric string.
    * The path does not require a slash (`/`).


1. Click **Save**.
1. From the list of authentication providers, open the context menu and **Enable SAML**.
1. Close the configuration dialog and click **Enable** on your SAML provider.
1. In Okta update the placeholder **Single Sign-On URL** and **Audience URI (SP Entity ID)** that you set in the previous section.
1. Close the configuration dialog and click **Enable** on your SAML provider.

{% endnavtab %}
{% endnavtabs %}

### Map {{site.konnect_short_name}} teams to Okta groups


By mapping Okta groups to [{{site.konnect_short_name}} teams](/konnect/org-management/teams-and-roles/),
you can manage a user's {{site.konnect_short_name}} team membership directly through
Okta group membership.

After mapping is set up:
* Okta users belonging to the mapped groups can log in to {{site.konnect_short_name}}.
* When a user logs into {{site.konnect_short_name}} with their Okta account
for the first time,
{{site.konnect_short_name}} automatically provisions an account with the
relevant roles.
* If your org already has non-admin {{site.konnect_short_name}} users before
mapping, on their next
login they will be mapped to the teams defined by their Okta group membership.
* An organization admin can view all registered users in
{{site.konnect_short_name}},
but cannot edit their team membership from the {{site.konnect_short_name}} side. To
manage automatically-created users, adjust user permissions through Okta, or
adjust the team mapping.

Any changes to the mapped Okta groups on the Okta side are reflected in
{{site.konnect_saas}}. For example:
* Removing a user from a group in Okta also deactivates their
{{site.konnect_short_name}} account.
* Moving a user from one group to another changes their team in {{site.konnect_short_name}}
to align with the new group-to-team mapping.

1. Refer to the [token preview](#test-claims-and-find-groups-for-mapping)
in Okta to locate the Okta groups you want to map.

    You can also locate a list of all existing groups by going to
    **Directory > Groups** in Okta. However, not all of these
    groups may be accessible by the `groups` claim. See the
    [claims](#set-up-claims-in-okta) setup step for details.

1. In {{site.konnect_saas}}, go to {% konnect_icon organizations %} **Organization > Auth Settings > Team Mappings** and do at least one of the following:

    * To manage user and team memberships in {{site.konnect_short_name}} from the Organization settings, select the **Konnect Mapping Enabled** checkbox.
    * To assign team memberships by the IdP during SSO login via group claims mapped to {{site.konnect_short_name}} teams, select the **IdP Mapping Enabled** checkbox and enter your Okta groups in the relevant fields.

    Each {{site.konnect_short_name}} team can be mapped to **one** Okta group.

    For example, if you have a `service_admin` group in Okta, you might map it
    to the `Service Admin` team in {{site.konnect_short_name}}. You can hover
    over the info (`i`) icon beside each field to learn more about the team, or
    see the [teams reference](/konnect/org-management/teams-and-roles/teams-reference/)
    for more information.

    You must have at least one group mapped to save configuration changes.

1. Click **Save**.

## Test and apply the configuration {#test-the-integration}

{:.important}
> **Important:** Keep built-in authentication enabled while you are testing Okta authentication. Only disable built-in authentication after successfully testing Okta authentication.

You can test the Okta configuration by navigating to the login URI based on the Organization Login Path you set earlier. For example: `cloud.konghq.com/login/examplepath`. You will see the Okta sign in window if your configuration is set up correctly.

You can now manage your organization's user permissions entirely from the Okta
application.

## Log in through Okta to test the integration
1. Copy your {{site.konnect_short_name}} organization's login URI.

1. Paste the URI into a browser address bar. An Okta login page should appear.

1. Using an account that belongs to one of the groups you just mapped
(for example, an account belonging to the `service_admin` group in Okta), log
in with your Okta credentials.

    If a group-to-team mapping exists, the user is automatically provisioned with
    a {{site.konnect_saas}} account with the relevant team membership.

1. In the left menu, select **Organization**.

    You should see a list of users in this org, including a new entry for the
    previous user and the team that they were assigned to.

{:.note}
> **Note**:  If you need to find your login path, go to **My Account**, locate the Login Path, and append it to `cloud.konghq.com/login/`.

## (Optional) Enable {{site.konnect_saas}} as a dashboard app in Okta

If you want your users to have easy access to {{site.konnect_saas}} alongside their other apps,
you can add it to your Okta dashboard.

1. Log in to your [Okta admin account](https://okta.com/login/).
1. Click **Applications > Applications**, then select your {{site.konnect_saas}} Okta application.
1. On **General** tab, click **Edit** for the **General Settings** pane.
1. In the **Application** section, click the **Implicit (hybrid)** checkbox for the **Grant type**.
1. In the **Login** section:
    1. In the **Login Initiated by** menu, select **Either Okta or App**.
    1. For the **Application Visibility**, click the **Display application icon to users** checkbox.
    1. In the **Initiate login URI** box, enter your organization's login URI. You can
    find the URI in {{site.konnect_saas}} by going to
    **Settings** > **Identity Management**.
1. Click **Save**.

## Okta reference docs
* [Build an Okta SSO integration](https://developer.okta.com/docs/guides/build-sso-integration/openidconnect/overview/)
* [Create claims in Okta](https://developer.okta.com/docs/guides/customize-authz-server/create-claims/)
* [Groups claim](https://developer.okta.com/docs/guides/customize-tokens-groups-claim/add-groups-claim-custom-as/)
* [Custom claims](https://developer.okta.com/docs/guides/customize-tokens-returned-from-okta/add-custom-claim/) 
