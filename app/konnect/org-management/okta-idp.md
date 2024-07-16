---
title: Set Up SSO with Okta
badge: enterprise
---

As an alternative to {{site.konnect_saas}}’s native authentication, you can set
up single sign-on (SSO) access to {{site.konnect_short_name}} through
[Okta](https://developer.okta.com/docs/guides/) with
[OpenID Connect](https://developer.okta.com/docs/concepts/oauth-openid/#openid-connect).
This authentication method allows your users to log in to {{site.konnect_saas}}
using their Okta credentials, without needing a separate login.


## Prerequisites and overview of steps

To set up Okta single sign-on (SSO) for {{site.konnect_short_name}}, you need
access to an Okta admin account and a
[{{site.konnect_short_name}} admin account](/konnect/org-management/teams-and-roles),
which you will access concurrently.

Optionally, if you want to use team mappings, you must configure Okta to include group claims in the ID token. 

Here are the steps you need to complete, in both Okta and
{{site.konnect_short_name}}.
First, complete the following in Okta:
* [Set up an Okta application](#prepare-the-okta-application)
* (Optional) If using group claims for team mapping, [set up claims in Okta](#optional-set-up-claims-in-okta).

Then, you can set up {{site.konnect_short_name}} to talk to the Okta application:
* [Set up Okta IDP in {{site.konnect_short_name}}](#set-up-konnect), referring
back to Okta for details
* [Map {{site.konnect_short_name}} teams to Okta groups](#map-teams-to-groups)
* [Test and publish config](#test-the-integration)

## Set up Okta

### Prepare the Okta application

Create a new application in Okta to manage {{site.konnect_saas}} account integration.

1. Sign in to your [Okta admin account](https://okta.com/login/).
1. In the sidebar, click **Applications > Applications**, then click **Create App Integration**.
1. Select the application type:

    1. For the **Sign-in method**, select **OIDC - OpenID Connect**.
    1. For the **Application Type**, select **Web Application**.
    1. Click **Next**.

1. Configure the application:
    1. In the **App integration name** box, enter a unique name for your application.
    1. For the **Grant type**, ensure the **Authorization Code** checkbox is selected.
    1. For both the **Sign-in redirect URIs** and
    **Sign-out redirect URIs** boxes, enter: `https://cloud.konghq.com/login`
    1. In the **Assignments** pane, for **Controlled access**, choose your
    preferred access level for this application. This preferred access level sets the permissions for
    Okta admins.

1. Click **Save**.

    Leave this page open. You'll need the connection details here to configure your {{site.konnect_saas}} account.

### (Optional) Set up claims in Okta

If you are intending to use group claims for Konnect team mappings, follow this guide to set them up. Otherwise, skip to [Add a user to your application](#add-a-user-to-your-application).

The connection between {{site.konnect_short_name}} and Okta uses OpenID Connect tokens. To have Okta send the correct information to your {{site.konnect_short_name}} org, set up claims to extract that information.

1. Open your Okta account in a new browser tab.

1. In the sidebar, select **Security > API**.

1. Select the authorization server that you want to configure.

1. Click the **Claims** tab to configure the `groups` claim.

1. Click **ID**, then click **Add Claim**.

1. Configure a `groups` claim by filling in the following fields:

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
    
1. Click **Create**.

If you have problems setting up these claims, refer to the Okta documentation
for troubleshooting:
* [Adding a `groups` claim](https://developer.okta.com/docs/guides/customize-tokens-groups-claim/add-groups-claim-custom-as/)
* [Adding a custom claim](https://developer.okta.com/docs/guides/customize-tokens-returned-from-okta/add-custom-claim/)

### Add a user to your application

1. In the sidebar of your Okta account, click **Applications > Applications**.

1. Select your {{site.konnect_short_name}} application.

1. Click the **Assignments** tab.

1. Click **Assign > Assign to People**, and then click **Assign** next to the name of the users you want to add.

1. Optional: In the dialog, enter additional information about the user.

1. Click **Save and Go Back**.

1. Click **Done**.

### Test claims and find groups for mapping

1. In the sidebar of your Okta account, click **Security > API**.

1. Select the authorization server that you want to configure.

1. Click the **Token Preview** tab.

1. Enter your client in the **OAuth/OIDC client** box. This is the name you created previously for your Okta application.

1. In the **Grant Type** menu, select **Authorization Code**.

1. In the **User** menu, select an Okta user that is assigned to the {{site.konnect_short_name}} application to test the claim with.

1. In the **Scope** box, enter `openid`, `email`, and `profile`.

1. Click **Preview Token**.

1. In the generated preview, ensure that the `groups`
value is present.

1. From the list of groups in the preview, identify groups that you want to use in
{{site.konnect_short_name}}. Take note of these groups.

## Set up {{site.konnect_short_name}}

### Provide Okta connection details
1. In another separate browser tab, log in to [{{site.konnect_saas}}](https://cloud.konghq.com).
1. Click {% konnect_icon organizations %} **Organization**, and then **Auth Settings**.
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

### Map {{site.konnect_short_name}} teams to Okta groups {#map-teams-to-groups}

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

    If you ever need to find the path again, you can always find it under
    {% konnect_icon organizations %} **Organization > Auth Settings**, then copy the **Organization Login URI**
     and append it to `cloud.konghq.com/login/`.

1. Paste the URI into a browser address bar. An Okta login page should appear.

1. Using an account that belongs to one of the groups you just mapped
(for example, an account belonging to the `service_admin` group in Okta), log
in with your Okta credentials.

    If a group-to-team mapping exists, the user is automatically provisioned with
    a {{site.konnect_saas}} account with the relevant team membership.

1. In the left menu, select **Organization**.

    You should see a list of users in this org, including a new entry for the
    previous user and the team that they were assigned to.

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
