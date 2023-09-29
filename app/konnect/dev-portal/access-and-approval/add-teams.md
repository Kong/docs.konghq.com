---
title: Add Developer Teams from Identity Providers
content_type: how-to
---

In the {{site.konnect_short_name}} Dev Portal, you can import existing developer teams from a third-party identity provider (IdP) and map their permissions to elements in {{site.konnect_short_name}}. This allows you to import developers automatically instead of manually copying over every single team of developers from your IdP to {{site.konnect_short_name}}.

This guide explains how to map the permissions, including scopes and claims, from your group of developers in your IdP to your organization's team in {{site.konnect_short_name}}. Although this guide uses Okta, Azure, and Auth0 as examples, you can use any IdP that conforms to OIDC standards. 

## Prerequisites
An IdP configured in Konnect (OIDC or DCR) for [application registration](/konnect/dev-portal/applications/enable-app-reg/).

## Create developer teams in your IdP

<!-- do these IdPs need the Kong callback URl added to them to be properly configured? Or is this just a one-way pull from the IdP to Konnect, so it doesn't need any information from Konnect?-->

{% navtabs %}
{% navtab Okta %}
In Okta, create a [new group of developers](https://help.okta.com/asa/en-us/content/topics/adv_server_access/docs/setup/create-a-group.htm) that you want to map to {{site.konnect_short_name}}. Be sure to configure the team settings and attributes as needed.
{% endnavtab %}
{% navtab Azure %}
In Azure, create a [new team of developers](https://learn.microsoft.com/azure/devops/organizations/settings/add-teams?view=azure-devops&tabs=preview-page) that you want to map to {{site.konnect_short_name}}.
{% endnavtab %}
{% navtab Auth0 %}
In Auth0, create a [new team of developers](https://auth0.com/docs/get-started/tenant-settings/auth0-teams) that you want to map to {{site.konnect_short_name}}.
{% endnavtab %}
{% endnavtabs %}

## Map IdP developer teams in {{site.konnect_short_name}}

1. In {% konnect_icon dev-portal %} [**Dev Portal**](https://cloud.konghq.com/portal), click **Settings**.

1. In the **General** setting tab, enable **Portal RBAC**.
    
    Enabling RBAC allows you to create teams in {{site.konnect_short_name}}. You can disable RBAC after you map teams from your IdP if you don't want to use it.

1. From the **Teams** settings in the side bar, click **New Team** and configure the team.

1. From the IdP team you just created, click the **Products** tab and click **Add Roles**. This allows you to assign API products and the role for the API product to members of your IdP team.

1. From **Settings** in the Dev Portal side bar, click the **Team Mappings** tab and then select **IdP Mapping Enabled**. 

1. Click **Configure OIDC provider** and configure the settings using the following mappings:
    * **Provider URL:** The value stored in the `issuer` variable for your IdP.
    * **Client ID:** The application ID for your IdP.
    * **Client Secret:** The client secret of your IdP.
    * **Scopes:** The scopes to be requested from the OpenID Provider.
    * **Claim Mappings - Name:** 
    * **Claim Mappings - Email:**
    * **Claim Mappings - Groups:**

1. Click the **Team Mappings** tab, and then select **IdP Mapping Enabled**.

1. Enter the exact name of your team from your IdP next to the name of the {{site.konnect_short_name}} team you want to map it to.

## Test developer team mappings

Now that you've configured the IdP team mappings in {{site.konnect_short_name}} for the Dev Portal, you can test the team mappings by logging in to the Dev Portal with a test account that is assigned to the team in your IdP.

1. Navigate to your Dev Portal URL and log in as a test developer that is assigned to the team in your IdP.
    You can find your Dev Portal URL in the Dev Portal settings in the **Portal Domain** tab.

1. If the mappings are correct, you should see any API products that you assigned to the team in {{site.konnect_short_name}}.

1. Once a developer in your IdP team signs into the Dev Portal, they will be populated as a new developer associated with that team in {{site.konnect_short_name}}. You can verify this by going to the Dev Portal teams settings in {{site.konnect_short_name}}. The test developer should be listed there as a developer associated with your team.

