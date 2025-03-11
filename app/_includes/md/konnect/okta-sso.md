<!-- used in the Dev Portal Okta SSO how to and the Org Okta SSO how to -->
## Prerequisites
* An Okta account with administrator access to configure Applications and Authorization Server settings.
{{% if include.desc == "Dev Portal" %}}* A non-public {{site.konnect_saas}} Dev Portal created in your {{site.konnect_short_name}} organization.{{% endif %}}

## Configure an Okta Application

{% navtabs %}
{% navtab OIDC %}

1. From the Applications section of the Okta console, select _Create App Integration_ 
   and choose [OIDC - OpenID Connect](https://help.okta.com/oie/en-us/content/topics/apps/apps_app_integration_wizard_oidc.htm)
   with _Web Application_ for the _Application type_. Provide the following configuration details:
    * **Grant type**: Authorization Code
    {% if include.desc == "Konnect Org" %}* **Sign-in redirect URIs**: `https://cloud.konghq.com/login` 
    * **Sign-out redirect URIs**: `https://cloud.konghq.com/login` 
    {% endif %}
    {% if include.desc == "Dev Portal" %}
    Using the portal URL from the Dev Portal Overview page, provide the following configuration details substituting `<portal-url>` with your portal's URL:
    * **Sign-in redirect URIs**: `https://<portal-url>/login` 
    * **Sign-out redirect URIs**: `https://<portal-url>/login` 
    {% endif %}

1. **Optional**: If you want to map Okta group claims to {{site.konnect_short_name}}
{% if include.desc == "Konnect Org" %}Organization{% endif %}{% if include.desc == "Dev Portal" %}Dev Portal{% endif %} Teams, 
modify the [OpenID Connect ID Token claims](https://developer.okta.com/docs/guides/customize-tokens-groups-claim/main/#add-a-groups-claim-for-the-org-authorization-server) 
in the **Application->Sign On** section of the Okta configuration, setting the following values:

    * **Group claims type**: `Filter`
    * **Group claims filter**: Enter `groups` for the claim name and enter **Matches regex** as the filter type and `.*` for the filter value.

    This claim specifies which user's groups to include in the token, in this case the wildcard regex specifies that all groups will be included.

    {:.note}
    > If the authorization server is retrieving additional groups from
    third-party applications (for example, Google groups), the `groups` claim
    will not contain them. If it is desired to use these third-party groups, the Okta 
    administrator will need to duplicate them directly in Okta or use a [custom token](https://developer.okta.com/docs/guides/customize-tokens-groups-claim/main/)
    to include them in the `groups` claim.

1. [Assign desired groups and users to the new Okta application](https://help.okta.com/en-us/content/topics/users-groups-profiles/usgp-assign-apps.htm).

1. Locate the following values in the Okta console, which will be used later for the
{{site.konnect_short_name}} configuration.

    * **Client ID**: Located in your Application **General -> Client Credentials** settings.
    * **Client Secret**: Located in your Application **General -> Client Secrets** settings.
    * **Issuer URI** : The Issuer is typically found in the **Security -> API -> Authorization Servers** settings.
    It should look like the following: `https://<okta-org-id>.okta.com/oauth2/default`
{% endnavtab %}
<!-- END OIDC -->
{% navtab SAML %}

1. From the Applications section of the Okta console, select _Create App Integration_ 
   and choose [SAML 2.0](https://help.okta.com/en-us/content/topics/apps/apps_app_integration_wizard_saml.htm?cshid=ext_Apps_App_Integration_Wizard-saml). 
   Provide the following configuration details:
    * Give the application a name that signifies it is for {{site.konnect_short_name}} SAML SSO.
    {% if include.desc == "Konnect Org" %}
    * **Single Sign-On URL**: `https://global.api.konghq.com/v2/authenticate/login_path/saml/acs`
    {% endif %}
    {% if include.desc == "Dev Portal" %}
    Using the portal URL from the Dev Portal Overview page, provide the following configuration details:
    * **Single Sign-On URL**: `https://<portal-url>/v2/authenticate/login_path/saml/acs`
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

1. [Generate a signing certificate](https://help.okta.com/en-us/content/topics/apps/manage-signing-certificates.htm) to use in {{site.konnect_short_name}}.

1. [Assign desired groups and users to the new Okta application](https://help.okta.com/en-us/content/topics/users-groups-profiles/usgp-assign-apps.htm).

{% endnavtab %}
<!-- END SAML -->
{% endnavtabs %}

## Set up {{site.konnect_short_name}}

### Configure Okta connection details

{% navtabs %}
{% navtab OIDC %}
{% if include.desc == "Konnect Org" %}
1. In [{{site.konnect_short_name}}](https://cloud.konghq.com/login), 
navigate to {% konnect_icon organizations %} **Organization** -> **Settings** and then 
the **Authentication Scheme** tab.
{% endif %}
{% if include.desc == "Dev Portal" %}
1. Open your [{{site.konnect_short_name}} Dev Portal](https://cloud.konghq.com/portals/) overview, 
and select the Dev Portal you want to configure for SSO. Choose **Settings** in the sidebar 
and then the **Identity** tab.
{% endif %}

1. Select the **Configure** option for OIDC.

1. Insert your **Issuer URI**, **Client ID** and **Client Secret** in the OIDC configuration fields.

{% if include.desc == "Konnect Org" %}
1. In the **Organization Login Path** field, enter a value that uniquely identifies your organization. This
path value will be used by {{site.konnect_short_name}} to route users to the correct organization login page.

    Requirements:
    * The path must be unique *across all {{site.konnect_short_name}} organizations*.
    If your desired path is already taken, you will be prompted to enter another one.
    * The path can be any alphanumeric string.
    * The path does not require a slash (`/`).
{% endif %}

1. Under **Advanced Settings**, specify the *Scopes* {{site.konnect_short_name}} requests from Okta. 
The `openid` scope is required for OIDC authentication. The `profile` and `email` scopes are recommended so {{site.konnect_short_name}} 
obtains the user's name and email address in the token response.

1. In the **Claim Mappings** section, set the values of each field to their appropriate token response field name. Use the Okta Token Preview
feature to verify the response token field names will match what you enter in these mappings. The default values are as follows:

    * Name: `name`
    * Email: `email`
    * Groups: `groups` 

{% if include.desc == "Dev Portal" %}
1. Optional: [Map existing developer teams from Okta groups to {{site.konnect_short_name}} Dev Portal teams](/konnect/dev-portal/access-and-approval/add-teams/).
{% endif %}

1. **Save** the configuration and then select **Enable OIDC**.
{% endnavtab %}
<!-- END OIDC -->

{% navtab SAML %}
{% if include.desc == "Konnect Org" %}
1. In [{{site.konnect_saas}}](https://cloud.konghq.com/login), click {% konnect_icon organizations %} **Organization** > **Settings**, and then click the **Authentication Scheme** tab.
{% endif %}
{% if include.desc == "Dev Portal" %}
1. In a separate browser tab, open [{{site.konnect_short_name}} Dev Portal](https://cloud.konghq.com/portals/), click the Dev Portal you want to configure SSO for, click **Settings** in the sidebar and then click the **Identity** tab.
{% endif %}
1. Click **Configure** for SAML.

1. In Okta, go to **Sign On** page in the Okta application created in the previous step and copy the 
**IDP Metadata URL** under the Settings section. It should look like: `https://<okta-org-id>.okta.com/app/exkgzjkl0kUZB06Ky5d7/sso/saml/metadata`
{% if include.desc == "Konnect Org" %}
1. In the **Organization Login Path** field, enter a value that uniquely identifies your organization. This
path value will be used by {{site.konnect_short_name}} to route users to the correct organization login page.

    Requirements:
    * The path must be unique *across all {{site.konnect_short_name}} organizations*.
    If your desired path is already taken, you will be prompted to enter another one.
    * The path can be any alphanumeric string.
    * The path does not require a slash (`/`).
{% endif %}

1. **Save** this configuration, {{site.konnect_short_name}} will generate two new values. A **Single Sign-On URL**
and an **Audience URI**.

1. In the Okta console, update the previous placeholder **Single Sign-On URL** and **Audience URI (SP Entity ID)** 
with the new values generated by {{site.konnect_short_name}}.

{% if include.desc == "Dev Portal" %}
1. Optional: [Map existing developer teams from Okta groups to {{site.konnect_short_name}} Dev Portal teams](/konnect/dev-portal/access-and-approval/add-teams/).
{% endif %}
1. In {{site.konnect_short_name}}, close the configuration dialog and click **Enable SAML** from the context menu.

{% endnavtab %}
<!-- END SAML -->

{% endnavtabs %}

{% if include.desc == "Konnect Org" %}
### Okta users and mapping groups to {{site.konnect_short_name}} teams

While it is not required, it is **recommended to use {{site.konnect_short_name}}'s Okta group to 
team mapping** feature. If you choose not to use this feature then approving new users will require a 
two step process. First, the user will need to login to {{site.konnect_short_name}} with their Okta credentials. 
They will receive an access error but the new user will be visible to the {{site.konnect_short_name}} administrator.
The administrator can now map the user to a valid {{site.konnect_short_name}} team, which will give the user the required
access. The new user must now re-login to gain access. 

Preferably the IdP group to team mapping feature is used to streamline this process. Use the following to enable this feature:

1. In {{site.konnect_short_name}}, go to {% konnect_icon organizations %} **Organization** > **Settings**, 
click the **Team Mappings** and enable the IdP Mapping feature.

    Each {{site.konnect_short_name}} team can be mapped to **one** Okta group.

    For example, if you have a `service_admin` group in Okta, you might map it
    to the `Service Admin` team in {{site.konnect_short_name}}. You can hover
    over the info (`i`) icon beside each field to learn more about the team, or
    see the [teams reference](/konnect/org-management/teams-and-roles/teams-reference/)
    for more information.

    You must have at least one group mapped to save configuration changes.

1. Click **Save**.


After mapping is set up:
* Okta users belonging to the mapped groups can log in to {{site.konnect_short_name}}.
* When a user logs into {{site.konnect_short_name}} with their Okta account
for the first time, {{site.konnect_short_name}} automatically provisions an account with the
relevant roles.
* If your org already has non-admin {{site.konnect_short_name}} users before
mapping, on their next login they will be mapped to the teams defined by their Okta group membership.
* An organization admin can view all registered users in
{{site.konnect_short_name}}, but cannot edit their team membership from the {{site.konnect_short_name}} side. To
manage automatically-created users, adjust user permissions through Okta, or adjust the team mapping.

Any changes to the mapped Okta groups on the Okta side are reflected in
{{site.konnect_short_name}}. For example:
* Removing a user from a group in Okta also deactivates their
{{site.konnect_short_name}} account.
* Moving a user from one group to another changes their team in {{site.konnect_short_name}}
to align with the new group-to-team mapping.

{% endif %}

## Debug and test the configuration

The Okta console provides a [Token Preview feature](https://help.okta.com/en-us/content/topics/security/api-config-test.htm) which will be useful in 
verifying configuration values for these SSO configuration instructions. If you encounter issues configuring SSO with Okta, start by
checking the Token Preview for the Okta application you created.

{% if include.desc == "Dev Portal" %}
1. Test the SSO configuration by navigating to the portal URL for your Dev Portal. For example: `https://{portalId}.{region}.portal.konghq.com/login`. 
    
    You will see the Okta sign in window if your configuration is set up correctly.
1. Using an account that belongs to one of the groups you just mapped, log
in with your Okta credentials. 
    
    If a group-to-team mapping exists, the user is automatically provisioned with a {{site.konnect_saas}} Dev Portal developer account with the relevant team membership.
1. In [{{site.konnect_short_name}} Dev Portal](https://cloud.konghq.com/portals/), click the Dev Portal you configured SSO for and click **Developers** in the sidebar.
    
    You should see a list of users in this org, including a new entry for the user you used to log in.
{% endif %}
{% if include.desc == "Konnect Org" %}
Test the SSO configuration by navigating to the login URI based on the organization login path you set earlier. 
For example, if you successfully configured a login path of `examplepath`, navigate to `https://cloud.konghq.com/login/examplepath`.
Attempt to login with an Okta user assigned to your new application. If authorization is successful and the
team configuration is correct, the user should be able to access the {{site.konnect_short_name}} organization.
{% endif %}

## (Optional) Enable {{site.konnect_saas}}{% if include.desc == "Dev Portal" %} Dev Portal{% endif %} as a dashboard app in Okta

If you want your users to have easy access to {{site.konnect_saas}}
{% if include.desc == "Dev Portal" %} Dev Portal{% endif %} alongside their other apps, 
you can add it to your Okta dashboard.

In Okta, navigate to the General Settings of your application and configure the _application icon_ for users as needed.
