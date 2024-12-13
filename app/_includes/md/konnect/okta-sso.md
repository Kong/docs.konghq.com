<!-- used in the Dev Portal Okta SSO how to and the Org Okta SSO how to -->
## Prerequisites
{% if include.desc == "Dev Portal" %}
* Ensure that any users that need to use the Dev Portal SSO are added to Okta
{% endif %}
{% if include.desc == "Konnect Org" %}
* Ensure that any users that need to use {{site.konnect_short_name}} SSO are added to Okta
{% endif %}
* To set up Okta single sign-on (SSO) for {{site.konnect_short_name}}, you need access to an Okta admin account and a {{site.konnect_short_name}} admin account, which you will access concurrently.
* Optionally, if you want to use team mappings, you must configure Okta to include group attributes.

## Configure an application and group claims in Okta

{% navtabs %}
{% navtab OIDC %}
1. Create a [new OIDC application in Okta](https://help.okta.com/oie/en-us/content/topics/apps/apps_app_integration_wizard_oidc.htm) to manage {{site.konnect_saas}} account integration. Configure the following settings:
    * **Application Type**: Web Application
    * **Grant type**: Authorization Code
    {% if include.desc == "Konnect Org" %}
    * **Sign-in redirect URIs**: `https://cloud.konghq.com/login` (This is a placeholder value that you'll replace later)
    * **Sign-out redirect URIs**: `https://cloud.konghq.com/login` (This is a placeholder value that you'll replace later)
    {% endif %}
    {% if include.desc == "Dev Portal" %}
    * **Sign-in redirect URIs**: `https://{portalId}.{region}.portal.konghq.com/login` (This is a placeholder value that you'll replace later)
    * **Sign-out redirect URIs**: `https://{portalId}.{region}.portal.konghq.com/login` (This is a placeholder value that you'll replace later)
    {% endif %}
    * **Controlled access**: Select a group assignment option

    Leave this page open. You'll need the connection details here to configure your {{site.konnect_saas}} account.

{% if include.desc == "Dev Portal" %}
1. Optional: If you want to use group claims for Konnect [developer team mappings](/konnect/dev-portal/access-and-approval/add-teams/), click the **Sign On** tab in Okta for your application to [configure a `groups` claim](https://developer.okta.com/docs/guides/customize-tokens-groups-claim/main/#add-a-groups-claim-for-the-org-authorization-server) and configure the following fields:

    | Field | Value |
    | ---|--- |
    | Group claims type | Filter |
    | Group claims filter | `groups`, select **Matches regex** from the drop-down, then enter `.*` in the field.
{% endif %}

    This claim tells Okta to reference a subset of Okta groups.
    In this case, the wildcard (`.*`) value tells Okta to make all groups available for team mapping.

    {:.important}
    > If the authorization server is pulling in additional groups from
    third-party applications (for example, Google groups), the `groups` claim
    cannot find them. An Okta administrator needs to duplicate those groups and
    re-create them directly in Okta. They can do this by exporting the group in
    question in CSV format, then importing the CSV file to populate the new group.

1. [Add users to the Okta application](https://help.okta.com/en-us/content/topics/users-groups-profiles/usgp-assign-apps.htm).

{% endnavtab %}
{% navtab SAML %}

1. Create a [new SAML 2.0 application in Okta](https://help.okta.com/en-us/content/topics/apps/apps_app_integration_wizard_saml.htm?cshid=ext_Apps_App_Integration_Wizard-saml) to manage {{site.konnect_saas}} account integration. Configure the following placeholder settings:
    {% if include.desc == "Konnect Org" %}
    * **Single Sign-On URL**: `https://global.api.konghq.com/v2/authenticate/login_path/saml/acs`
    {% endif %}
    {% if include.desc == "Dev Portal" %}
    * **Single Sign-On URL**: `https://{portalId}.{region}.portal.konghq.com/v2/authenticate/login_path/saml/acs`
    {% endif %}
    * **Audience URI (SP Entity ID)**: `https://cloud.konghq.com/sp/SP_ID`

1. Optional: To include additional user attributes beyond authentication, add the following three attributes in the **Attribute Statements**:
 
    | Name       | Name format  | Value          |
    |------------|--------------|----------------|
    | `firstName`  | Unspecified  | user.firstName |
    | `lastName`   | Unspecified  | user.lastName  |
    | `email`      | Unspecified  | user.email     |

{% if include.desc == "Dev Portal" %}
1. Optional: If you want to use group claims for Konnect [developer team mappings](/konnect/dev-portal/access-and-approval/add-teams/), [configure a groups attribute claim](https://developer.okta.com/docs/guides/customize-tokens-groups-claim/main/#add-a-groups-claim-for-a-custom-authorization-server) and fill in the following fields:

    | Name    | Name format  | Filter          | Filter Value |
    |---------|--------------|-----------------|--------------|
    | groups  | Unspecified  | Matches regex   | .*           |
{% endif %}

1. [Add users to the Okta application](https://help.okta.com/en-us/content/topics/users-groups-profiles/usgp-assign-apps.htm).

1. [Generate a signing certificate](https://help.okta.com/en-us/content/topics/apps/manage-signing-certificates.htm) to use in {{site.konnect_short_name}}.

{% endnavtab %}
{% endnavtabs %}

## Set up {{site.konnect_short_name}}

### Provide Okta connection details
{% navtabs %}
{% navtab OIDC %}
{% if include.desc == "Konnect Org" %}
1. In [{{site.konnect_saas}}](https://cloud.konghq.com/login), click {% konnect_icon organizations %} **Organization** > **Settings**, and then click the **Authentication Scheme** tab.
{% endif %}
{% if include.desc == "Dev Portal" %}
1. In a separate browser tab, open [{{site.konnect_short_name}} Dev Portal](https://cloud.konghq.com/portals/), click the Dev Portal you want to configure SSO for, click **Settings** in the sidebar and then click the **Identity** tab.
{% endif %}

1. Click **Configure** for OIDC.

1. In Okta, update the placeholder **Single Sign-On URL** and **Audience URI (SP Entity ID)** values that you set in the previous section with the {% if include.desc == "Dev Portal" %}Dev Portal callback URL{% endif %}{% if include.desc == "Konnect Org" %}{{site.konnect_short_name}} login URI{% endif %}.

1. In Okta, locate your issuer URI in your authorization server settings. It should look like the following: `https://{yourOktaOrg}.okta.com/oauth2/default`

1. Paste the issuer URI from Okta in the **Provider URL** field in {{site.konnect_short_name}}.

1. In Okta, copy your client ID and client secret from your {{site.konnect_short_name}} application. 

1. Paste the **Client ID** and **Client Secret** from your Okta
application into {{site.konnect_saas}}.

    See the [Okta developer documentation](https://developer.okta.com/docs/guides/find-your-app-credentials/findcreds/)
    to learn more about client credentials in Okta.
{% if include.desc == "Konnect Org" %}
1. In the **Organization Login Path** box, enter a unique string that will be used in the URL your users use to log in. For example: `examplepath`.

    Requirements:
    * The path must be unique *across all {{site.konnect_short_name}} organizations*.
    If your desired path is already taken, you must to choose another one.
    * The path can be any alphanumeric string.
    * The path does not require a slash (`/`).
{% endif %}
{% if include.desc == "Dev Portal" %}
1. Optional: [Map existing developer teams from Okta groups to {{site.konnect_short_name}} Dev Portal teams](/konnect/dev-portal/access-and-approval/add-teams/).
{% endif %}
1. After clicking **Save**, close the configuration dialog and from the OIDC context menu, click **Enable OIDC**.
{% endnavtab %}
{% navtab SAML %}
{% if include.desc == "Konnect Org" %}
1. In [{{site.konnect_saas}}](https://cloud.konghq.com/login), click {% konnect_icon organizations %} **Organization** > **Settings**, and then click the **Authentication Scheme** tab.
{% endif %}
{% if include.desc == "Dev Portal" %}
1. In a separate browser tab, open [{{site.konnect_short_name}} Dev Portal](https://cloud.konghq.com/portals/), click the Dev Portal you want to configure SSO for, click **Settings** in the sidebar and then click the **Identity** tab.
{% endif %}
1. Click **Configure** for SAML.

1. In Okta, go to **Sign On** page in the Okta application created in the previous step and copy the **IDP Metadata URL** under the Settings section. It should look like: `https://<your-okta-domain>.okta.com/app/exkgzjkl0kUZB06Ky5d7/sso/saml/metadata`
{% if include.desc == "Konnect Org" %}
1. In the **Login Path** box, enter a unique string that will be used in the URL your users use to log in. For example: `examplepath`.

   Requirements:
    * The path must be unique *across all {{site.konnect_short_name}} organizations*.
      If your desired path is already taken, you must choose another one.
    * The path can be any alphanumeric string.
    * The path does not require a slash (`/`).
{% endif %}
1. Click **Save**.
1. Copy the **Single Sign-On URL** and **Audience URI** that display after you configured SAML SSO.
1. In Okta, update the placeholder **Single Sign-On URL** and **Audience URI (SP Entity ID)** values that you set in the previous section with the Single sign-on URL and Audience URI that display in the SAML config in {% if include.desc == "Dev Portal" %}Dev Portal{% endif %}{% if include.desc == "Konnect Org" %}{{site.konnect_short_name}}{% endif %}.
{% if include.desc == "Dev Portal" %}
1. Optional: [Map existing developer teams from Okta groups to {{site.konnect_short_name}} Dev Portal teams](/konnect/dev-portal/access-and-approval/add-teams/).
{% endif %}
1. In {{site.konnect_short_name}}, close the configuration dialog and click **Enable SAML** from the context menu.

{% endnavtab %}
{% endnavtabs %}
{% if include.desc == "Konnect Org" %}
### (Optional) Map {{site.konnect_short_name}} teams to Okta groups

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

1. [Configure a custom authorization server](https://help.okta.com/en-us/content/topics/security/api-config-auth-server.htm). 
    
    {:.important}
    > **Important:** Using the Okta API to set up group claims with a custom authorization server is an additional paid Okta feature. Alternatively, you can use the org authorization server and [create a group](https://help.okta.com/en-us/content/topics/users-groups-profiles/usgp-assign-group-people.htm), [enable group push](https://help.okta.com/en-us/content/topics/users-groups-profiles/usgp-enable-group-push.htm), and [add a group claim to the org authorization server](https://developer.okta.com/docs/guides/customize-tokens-groups-claim/main/#add-a-groups-claim-for-the-org-authorization-server) instead.
1. [Navigate to the Token Preview tab](https://help.okta.com/en-us/content/topics/security/api-config-test.htm) of your authorization server and configure the following:
    * **OAuth/OIDC client**: Enter the client name you previously created for your Okta application
    * **Grant Type**: Authorization Code
    * **User**: Select an Okta user that is assigned to the Konnect application to test the claim with
    * **Scope**: `openid`, `email`, `profile`

    In the generated Preview Token preview, ensure that the `groups` value is present. From the list of groups in the preview, identify groups that you want to use in Konnect. Take note of these groups.
1. Refer to the [token preview](#test-claims-and-find-groups-for-mapping)
in Okta to locate the Okta groups you want to map.

    You can also locate a list of all existing groups by going to
    **Directory > Groups** in Okta. However, not all of these
    groups may be accessible by the `groups` claim. See the
    [claims](#set-up-claims-in-okta) setup step for details.

1. In {{site.konnect_saas}}, go to {% konnect_icon organizations %} **Organization** > **Settings**, click the **Team Mappings** tab and do at least one of the following:

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
{% endif %}

## Test and apply the configuration

{:.important}
> **Important:** Keep built-in authentication enabled while you are testing IdP authentication. Only disable built-in authentication after successfully testing IdP authentication.

{% if include.desc == "Dev Portal" %}
1. Test the SSO configuration by navigating to the callback URL for your Dev Portal. For example: `https://{portalId}.{region}.portal.konghq.com/login`. 
    
    You will see the Okta sign in window if your configuration is set up correctly.
1. Using an account that belongs to one of the groups you just mapped, log
in with your Okta credentials. 
    
    If a group-to-team mapping exists, the user is automatically provisioned with a {{site.konnect_saas}} Dev Portal developer account with the relevant team membership.
1. In [{{site.konnect_short_name}} Dev Portal](https://cloud.konghq.com/portals/), click the Dev Portal you configured SSO for and click **Developers** in the sidebar.
    
    You should see a list of users in this org, including a new entry for the user you used to log in.
{% endif %}
{% if include.desc == "Konnect Org" %}
Test the SSO configuration by navigating to the login URI based on the organization login path you set earlier. For example: `https://cloud.konghq.com/login/examplepath`, where `examplepath` is the unique login path string set in the previous steps.
{% endif %}

You can now manage your organization's user permissions entirely from the IdP application.

## (Optional) Enable {{site.konnect_saas}}{% if include.desc == "Dev Portal" %} Dev Portal{% endif %} as a dashboard app in Okta

If you want your users to have easy access to {{site.konnect_saas}}{% if include.desc == "Dev Portal" %} Dev Portal{% endif %} alongside their other apps, you can add it to your Okta dashboard.

In Okta, navigate to the General Settings of your application and configure the following settings:

| Okta setting | Value |
|--------------|-------|
| Grant type | Implicit (hybrid) |
| Login Initiated by | Either Okta or App |
| Application Visibility | Display application icon to users |
| Initiate login URI | Enter your organization's login URI. {% if include.desc == "Dev Portal" %}You can find the URI in {{site.konnect_saas}} by going to your Dev Portal, clicking **Settings**, clicking the **Identity** tab, and then clicking **Configure provider** next to your authentication method.{% endif %}{% if include.desc == "Konnect Org" %}You can find the URI in {{site.konnect_saas}} by going to **Settings** > **Identity Management**.{% endif %}|