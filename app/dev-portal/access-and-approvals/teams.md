---
title: Developer Teams
---

Teams are provided to define [Role-based access control (RBAC)](/konnect/dev-portal/portals/settings/security.md#role-cased-access-control). When User Autentication and RBAC are enabled, only logged in Developers assigned to a team will be able to view or generate credentials / API keys for the APIs in that Team.

## Create a Team

* **Name** (required): displayed in the list of teams, and when assigning a Developer to a Team.
* **Description** (optional): displayed in lists of teams.

## Add APIs/Roles

From the **APIs** tab, click **Add**. Select one of the previously created APIs, and select an appropriate Role.

### Roles

* **API Viewer**: Developer in this Team can view this API, but **can't** generate credentials / API keys.
* **API Consumer**: Developers in this Team can both view this API **and** generate credentials / API keys.

## Add a Developer to a Team

In the list of Teams, click the three dots menu on the right side, and select **Add Developer**. Select the approriate Developer(s) from the list, and click Save.

{:.note}
> Developers can also be added to a team from the list of [Developers](/konnect/dev-portal/access-and-approvals/developers).