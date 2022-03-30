---
title: Set Up SSO with Okta
no_version: true
badge: enterprise
---

As an alternative to {{site.konnect_saas}}’s native authentication, you can set
up single sign-on (SSO) access to {{site.konnect_short_name}} through
[Okta](https://developer.okta.com/docs/guides/) with
[OpenID Connect](https://developer.okta.com/docs/concepts/oauth-openid/#openid-connect).
This authentication method allows your users to log in to {{site.konnect_saas}}
using their Okta credentials, without needing a separate login.

You can't mix authenticators in {{site.konnect_saas}}. With Okta
authentication enabled, all non-admin {{site.konnect_short_name}} users have to
log in through Okta. Only the {{site.konnect_short_name}} org
owner can continue to log in with {{site.konnect_short_name}}'s native
authentication.

{:.important}
> **Important:** Enabling SSO through Okta for a particular
{{site.konnect_short_name}} organization is **irreversible**. You cannot revert
to native {{site.konnect_short_name}} authentication after the switch has been
made.
> <br><br>
> Make sure that you are certain you want to switch, and are
ready to manage authentication and authorization through Okta for this
{{site.konnect_short_name}} organization.

## Prerequisites and overview of steps

To set up Okta single sign-on (SSO) for {{site.konnect_short_name}}, you need
access to an Okta admin account and a
[{{site.konnect_short_name}} admin account](/konnect/org-management/teams-and-roles),
which you will access concurrently.

Here are the steps you need to complete, in both Okta and
{{site.konnect_short_name}}.
First, complete the following in Okta:
* [Set up an Okta application](#prepare-the-okta-application)
* [Set up claims in Okta](#set-up-claims-in-okta)

Then, you can set up {{site.konnect_short_name}} to talk to the Okta application:
* [Set up Okta IDP in {{site.konnect_short_name}}](#set-up-konnect), referring
back to Okta for details
* [Map {{site.konnect_short_name}} teams to Okta groups](#map-teams-to-groups)
* [Test and publish config](#test-the-integration)

## Set up Okta

### Prepare the Okta application

Create a new application in Okta to manage {{site.konnect_saas}} account integration.

1. Sign in to your [Okta admin account](https://admin.okta.com/).
1. From the left menu, select **Applications**, then **Create App Integration**.
1. Select the application type:

    1. Under **Sign-in method**, select **OIDC - OpenID Connect**.
    1. Under **Application Type**, select **Web Application**.

1. Select **Next**. Configure the application:
    1. Create a unique name for your application.
    1. Under **Grant Type**, select **Authorization Code**.
    1. In both the **Sign-in redirect URIs** and
    **Sign-out redirect URIs** fields, enter: `https://cloud.konghq.com/login`
    1. In the Assigments section, for **Controlled access**, choose your
    preferred access level for this application. This preferred access level sets the permissions for
    Okta admins.

1. Save your settings to generate connection details.

    Leave this page open. You'll need the details here to configure your {{site.konnect_short_name}}
    Cloud account.

### Set up claims in Okta

The connection between {{site.konnect_short_name}} and Okta uses OpenID Connect
tokens. To have Okta send the correct information to your {{site.konnect_short_name}} org, set up
claims to extract that information.

1. Open your Okta account in a new browser tab.

1. From the left menu, select **Security > API**.

1. Select the Custom Authorization Server that you want to configure.

1. Go to the Claims tab.

    You need to configure two claims: `groups` and `login_email`.

1. In the **Claim type** menu, select **ID**, then select **Add Claim**.

1. Configure a `Groups` claim by filling in the following fields:

    Field | Value
    ---|---
    Name | `groups`
    Include in token type | ID token, Always
    Value type | Groups
    Filter | Select **Matches regex** from the dropdown, then enter `.*` in the field
    Include in | Choose **The following scopes** and select `openid`

    This claim tells Okta to reference a subset of Okta groups.
    In this case, the wildcard (`.*`) value tells Okta to make all groups
    available for team mapping.

    {:.important}
    > If the authorization server is pulling in additional groups from
    third-party applications (for example, Google groups), the `groups` claim
    cannot find them. An Okta administrator needs to duplicate those groups and
    re-create them directly in Okta. They can do this by exporting the group in
    question in CSV format, then importing the CSV file to populate the new group.

1. Select **Create** to save. Add another claim, this time for user login
information:

    Field | Value
    ---|---
    Name | `login_email`
    Include in token type | ID token, Always
    Value type | Expression
    Value | `user.login`
    Include in | Choose **The following scopes** and select `openid`

    This claim uses emails to map users to {{site.konnect_short_name}} login instances.

1. Select **Create** to save the second claim.

If you have problems setting up these claims, refer to the Okta documentation
for troubleshooting:
* [Adding a `groups` claim](https://developer.okta.com/docs/guides/customize-tokens-groups-claim/add-groups-claim-custom-as/)
* [Adding a custom claim](https://developer.okta.com/docs/guides/customize-tokens-returned-from-okta/add-custom-claim/)

### Test claims and find groups for mapping

1. Open the **Token Preview** tab.

2. Select your client, set **Grant Type** to Authorization Code, and choose an
Okta user to test the claim with.

3. Set the scope to `openid`, then select **Preview Token**.

4. In the generated preview, check to make sure that `groups` and `login_email`
values are present.

5. From the list of groups in the preview, identify groups that you want to use in
{{site.konnect_short_name}}. Take note of these groups.

## Set up Konnect

### Provide Okta connection details
1. In another separate browser tab, log in to [{{site.konnect_saas}}](https://cloud.konghq.com).
1. Open ![](/assets/images/icons/konnect/konnect-settings.svg){:.inline .no-image-expand}
**Settings**, then **Identity Management**.
1. Select **Okta**.

    Refer back to your Okta application to fill in the following fields.

1. Copy the **Issuer URI** from your Okta custom authorization server, then paste it into
the **Issuer URI** field in {{site.konnect_short_name}}. <!-- found in general settings in Okta app -->
1. Copy and paste the **Client ID** and **Client Secret** from your Okta
application into {{site.konnect_saas}}.

    See the [Okta developer documentation](https://developer.okta.com/docs/guides/find-your-app-credentials/findcreds/)
    to learn more about client credentials in Okta.

1. For the **Organization Login Path**, enter a unique string
(for example, `somepath`).

    {{site.konnect_short_name}} uses this string to generate a custom login
    URL for your organization.

    Requirements:
    * The path must be unique *across all {{site.konnect_short_name}} organizations*.
    If your desired path is already taken, you will need to choose another one.
    * The path can be any alphanumeric string.
    * The path does not require a slash (`/`).

### Map teams to groups

By mapping Okta groups to [{{site.konnect_short_name}} teams](/konnect/org-management/teams-and-roles),
you can manage a user's {{site.konnect_short_name}} team membership directly through
Okta group membership.

After mapping is set up:
* Okta users belonging to the mapped groups can log into {{site.konnect_short_name}}.
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

1. Referring to the [token preview](#test-claims-and-find-groups-for-mapping)
in Okta, locate the Okta groups you want to map.

    You can also locate a list of all existing groups by going to
    **Directory > Groups** in Okta. However, be aware that not all of these
    groups may be accessible by the `groups` claim. See the
    [claims](#set-up-claims-in-okta) setup step for details.

1. Enter your Okta groups in the relevant fields.

    Each {{site.konnect_short_name}} team can be mapped to **one** Okta group.

    For example, if you have a `service_admin` group in Okta, you might map it
    to the `Service Admin` team in {{site.konnect_short_name}}. You can hover
    over the info (`i`) icon beside each field to learn more about the team, or
    see the [teams reference](/konnect/org-management/teams-reference)
    for more information.

    You must have at least one group mapped to save configuration changes.

## Test and apply configuration

1. (Optional) Under **Logout Behavior**, enable Single Logout (SLO) by checking
the box.

    If this option is enabled, signing out from {{site.konnect_short_name}}
    also signs users out of their Okta session.

1. Select **Test Configuration** to make sure the configuration details are
valid.

    You must test configuration before saving. If you have filled out all
    required fields but the **Save** button remains greyed out, run the test
    first to enable saving.

    When you test the configuration, Konnect runs a connection check. If the
    connection test succeeds, the page reloads and prints the message
    `Configuration tested successfully`.

    Any subsequent changes to the configuration require a test before saving.

1. Save your changes, then confirm that you want to change your identity
provider to Okta.

    {:.warning}
    > **Warning:** This change is irreversible. Once you switch to Okta, you
    cannot revert to using native {{site.konnect_short_name}} authentication.

1. {{site.konnect_short_name}} generates a login URI based on the Organization
Login Path you set earlier. Copy this URI.

   You can now manage your org's user permissions entirely from the Okta
   application.

## Log in through Okta to test the integration
1. Copy your {{site.konnect_short_name}} organization's login URI.

    If you ever need to find the path again, you can always find it under
    ![](/assets/images/icons/konnect/konnect-settings.svg){:.inline .no-image-expand}
     **Settings > Identity Management**, then copy **Organization Login URI**
     from this page.

1. Paste the URI into a browser address bar. An Okta login page should appear.

1. Using an account that belongs to one of the groups you just mapped
(for example, an account belonging to the `service_admin` group in Okta), log
in with your Okta credentials.

    If a group-to-team mapping exists, the user is automatically provisioned with
    a {{site.konnect_saas}} account with the relevant team membership.

1. Log out of this account, and log back in with a {{site.konnect_short_name}}
admin account.

1. In the left menu, select **Organization**.

    You should see a list of users in this org, including a new entry for the
    previous user and the team that they were assigned.

## (Optional) Enable Konnect Cloud as a dashboard app in Okta

If you want your users to have easy access to {{site.konnect_saas}} alongside their other apps,
you can add it to your Okta dashboard.

1. Sign in to your [Okta admin account](https://admin.okta.com/).
1. Select **Applications**, then open your {{site.konnect_saas}} Okta application.
1. Scroll to **General Settings** and select **Edit**.
1. In the **Application** section, set **Grant type** to `Implicit (Hybrid)`.
1. In the **Login** section:
    1. Set **Login Initiated by** to `Either Okta or App`.
    1. Set **Application Visibility** to `Display application icon to users`
    1. Set **Initiate login URI** to your organization's login URI. You can
    find the URI in {{site.konnect_saas}} under
    **Settings** > **Identity Management**.
1. Select **Save**.

## Okta reference docs
* [Build an Okta SSO integration](https://developer.okta.com/docs/guides/build-sso-integration/openidconnect/overview/)
* [Create claims in Okta](https://developer.okta.com/docs/guides/customize-authz-server/create-claims/)
* [Groups claim](https://developer.okta.com/docs/guides/customize-tokens-groups-claim/add-groups-claim-custom-as/)
* [Custom claims](https://developer.okta.com/docs/guides/customize-tokens-returned-from-okta/add-custom-claim/)
