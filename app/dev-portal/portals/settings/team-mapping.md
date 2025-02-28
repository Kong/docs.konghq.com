---
title: Add Developer Teams from Identity Providers
content_type: how-to
---

In the Konnect Dev Portal, you can map existing developer teams from a third-party identity provider (IdP) and their permissions to elements in Konnect. With teams mapped from an IdP, the developers and permissions are mapped automatically in Konnect so you don't have to manually copy over each team of developers.

This guide explains how to map the permissions, including scopes and claims, from your group of developers in your IdP to your organization's team in Konnect. Although this guide uses Okta, Azure Active Directory (AD), and Auth0 as examples, you can use any IdP that conforms to OIDC standards. 

## Prerequisites

* A test developer account in your IdP
* An application for Konnect configured in your IdP:
    * [Okta](https://help.okta.com/en-us/content/topics/apps/apps_app_integration_wizard.htm)
    * [Azure AD](https://learn.microsoft.com/graph/toolkit/get-started/add-aad-app-registration)
    * [Auth0](https://auth0.com/docs/get-started/auth0-overview/create-applications)

## Set up developer teams and group claims in your IdP

{% navtabs %}
{% navtab Okta %}
1. In Okta, [assign people to a group](https://help.okta.com/en-us/content/topics/users-groups-profiles/usgp-assign-group-people.htm), including your test developer account. Alternatively, you can use [group rules](https://help.okta.com/en-us/content/topics/users-groups-profiles/usgp-create-group-rules.htm) to automatically add people to a group.

1. Configure any other group settings and attributes as needed.

1. [Enable group push](https://help.okta.com/en-us/content/topics/users-groups-profiles/usgp-enable-group-push.htm) for **{{site.base_gateway}}** to push existing Okta groups and their memberships to Konnect.

1. [Add a groups claim for the org authorization server](https://developer.okta.com/docs/guides/customize-tokens-groups-claim/main/#add-a-groups-claim-for-the-org-authorization-server).
{% endnavtab %}
{% navtab Azure AD %}
1. In [Azure AD](https://portal.azure.com/), [create a new group](https://learn.microsoft.com/azure/active-directory/fundamentals/how-to-manage-groups#create-a-basic-group-and-add-members) that includes your test developer account.

1. [Configure a groups claim](https://learn.microsoft.com/azure/active-directory/develop/optional-claims#configure-groups-optional-claims).

{% endnavtab %}
{% navtab Auth0 %}
1. In Auth0, create a [new team of developers](https://auth0.com/docs/get-started/tenant-settings/auth0-teams) that you want to map to Konnect. Make sure to add your test developer account. 

1. [Configure a groups claim](https://auth0.com/docs/secure/tokens/json-web-tokens/create-custom-claims).
{% endnavtab %}
{% endnavtabs %}

## Map IdP developer teams in Konnect

1. In {% konnect_icon dev-portal %} [**Dev Portal**](https://cloud.konghq.com/portal), click **Settings**.

1. In the **General** setting tab, enable **Portal RBAC**.
    
    Enabling RBAC allows you to create teams in Konnect. You can disable RBAC after you map teams from your IdP if you don't want to use it.

1. From the **Teams** settings in the side bar, click **New Team** and configure the team.

2. From the IdP team you just created, click the **APIs** tab and click **Add Roles**. This allows you to assign APIs and the role for the APIs to members of your IdP team.

3. From **Settings** in the Dev Portal side bar, click the **Identity** tab and then click **Configure OIDC provider**.

4. Configure the IdP settings using the following mappings:
    * **Provider URL:** The value stored in the `issuer` variable from your application in your IdP.
    * **Client ID:** The application ID from your application in your IdP.
    * **Client Secret:** The client secret from your application in your IdP.
    * **Scopes:** The scopes to be requested from your application in your IdP.
    * **Claim Mappings - Name:** `name`
    * **Claim Mappings - Email:** `email`
    * **Claim Mappings - Groups:** `groups`

5. Click the **Team Mappings** tab, and then select **IdP Mapping Enabled**.

6. Enter the exact name of your team from your IdP next to the name of the Konnect team you want to map it to.

## Test developer team mappings

Now that you've configured the IdP team mappings in Konnect for the Dev Portal, you can test the team mappings by logging in to the Dev Portal with a test account that is assigned to the team in your IdP.

1. Navigate to your Dev Portal URL and log in as a test developer that is assigned to the team in your IdP.
    You can find your Dev Portal URL in the Dev Portal settings in the **Portal Domain** tab.

2. If the mappings are correct, you should see any APIs that you assigned to the team in Konnect.

Once a developer in your IdP team signs into the Dev Portal, they will be populated as a new developer associated with that team in Konnect. You can verify this by going to the Dev Portal teams settings in Konnect. The test developer should be listed there as a developer associated with your team.

