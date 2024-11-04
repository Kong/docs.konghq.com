<!-- used in the Dev Portal Okta SSO how to and the Org Okta SSO how to -->
## Prerequisites

* Ensure that any users that need to use the Dev Portal SSO have been added to your IdP tenant
* To set up Okta single sign-on (SSO) for {{site.konnect_short_name}}, you need access to an Okta admin account and a {{site.konnect_short_name}} admin account, which you will access concurrently.

Optionally, if you want to use team mappings, you must configure Okta to include group attributes.

## Configure an application and group claims in Okta

{% navtabs %}
{% navtab OIDC %}
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

1. [Add users to the Okta application](https://help.okta.com/en-us/content/topics/users-groups-profiles/usgp-assign-apps.htm).

1. Test ID token claims and find groups for mapping. Configure the following claims settings:
    * **OAuth/OIDC client**: Enter the client name you previously created for your Okta application
    * **Grant Type**: Authorization Code
    * **User**: Select an Okta user that is assigned to the {{site.konnect_short_name}} application to test the claim with
    * **Scope**: `openid`, `email`, `profile`

    In the generated **Preview Token** preview, ensure that the `groups` value is present. From the list of groups in the preview, identify groups that you want to use in {{site.konnect_short_name}}. Take note of these groups.

{% endnavtab %}
{% navtab SAML %}

1. Create a [new SAML 2.0 application in Okta](https://help.okta.com/en-us/content/topics/apps/apps_app_integration_wizard_saml.htm?cshid=ext_Apps_App_Integration_Wizard-saml) to manage {{site.konnect_saas}} account integration. Configure the following placeholder settings:
    * **Single Sign-On URL**: `https://global.api.konghq.com/v2/authenticate/login_path/saml/acs`
    * **Audience URI (SP Entity ID)**: `https://cloud.konghq.com/sp/SP_ID`

1. Optional: In the **Attribute Statements**, add the following three attributes:
 
       | Name       | Name format  | Value          |
       |------------|--------------|----------------|
       | `firstName`  | Unspecified  | user.firstName |
       | `lastName`   | Unspecified  | user.lastName  |
       | `email`      | Unspecified  | user.email     |

1. Optional: If you want to use group claims for Konnect [developer team mappings](/konnect/dev-portal/access-and-approval/add-teams/), click the **Claims** tab in Okta to [configure a `groups` claim](https://developer.okta.com/docs/guides/customize-tokens-groups-claim/main/#add-a-groups-claim-for-a-custom-authorization-server) and fill in the following fields:

       | Name    | Name format  | Filter          | Filter Value |
       |---------|--------------|-----------------|--------------|
       | groups  | Unspecified  | Matches regex   | .*           |
    
1. Select **I'm an Okta customer adding an internal app**.

1. [Add users to the Okta application](https://help.okta.com/en-us/content/topics/users-groups-profiles/usgp-assign-apps.htm).

1. [Generate a signing certificate](https://help.okta.com/en-us/content/topics/apps/manage-signing-certificates.htm) to use in {{site.konnect_short_name}}.

{% endnavtab %}
{% endnavtabs %}