---
title: Mapping IdP Developer Teams to Konnect Developer Portal
content_type: how-to
---

A common scenario in Konnect Dev Portal is the ability to import existing developer Teams from your IDP, and mapping their permissions in Konnect.

In this guide, we'll show you how to enable OIDC Team Mapping with Okta. Note: You can use this functionality on any IDP.

## Prerequisites
* An IDP configured in Konnect (OIDC or DCR) for [application registration](konnect/dev-portal/applications/enable-app-reg/)
* A team created in your IDP
* SSO enabled on your Developer Portal (ensure the login URI is properly set to your Konnect Developer Portal)

Note: In order to use OIDC Team Mappings, you must enable RBAC to have the ability to create Teams (you can disable RBAC afterwards if you don't want to use it).

## Map developer teams 

In this scenario, you want to map the permissions (scopes, claims, etc) from your group of developers in Okta, to your organization's team in Konnect.

In Okta:

1. Use an existing team or create a new team of developers in Okta called "Authorized Delivery Partners". These are developers that have permissions to consume the APIs for Authorized Delivery Partners. Add yourself as a test developer to this team.

In Konnect:

1. Enable RBAC in Developer Portal Settings in order to be able to create Teams
2. Create a team called "Konnect Authorized Delivery Partners"
3. In the Portal Settings Team Mappings, select IdP Mapping Enabled, paste the name of your team in Okta next to the Konnect Team name, and select save.
4. If there are any API Products you want to assign to your Team, navigate to the team you created earlier and add those products now

In your Developer Portal:

1. Log into your Developer Portal as the test developer using SSO
2. If you have any API Products assigned to your team in Konnect, you should see them here

In Konnect:
1. In Konnect you should now see your test developer populated in the "Konnect Authorized Delivery Partners" team.
2. Every time a developer in your team signs into the Developer Portal, they will get populated as a new developer under that team in Konnect


### Summary

Now that you've completed the steps in this scenario, you've mapped your developer team from Okta to Konnect, as well as all of their associated properties and permissions. Now, instead of manually copying over every single team of developers from your IDP to Konnect, you can import them automatically.

