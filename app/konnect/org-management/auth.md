---
title: Authentication and Authorization
content_type: explanation
---

Secure your {{site.konnect_saas}} organization by setting up teams and roles,
or enable an external authenticator to manage
{{site.konnect_saas}} authentication and authorization from your own identity
provider.

## Native authentication through {{site.konnect_short_name}}

The default authentication option in {{site.konnect_saas}} is basic
authentication. You don't have to do anything special to set it up.

* Learn about [teams and roles](/konnect/org-management/teams-and-roles) in {{site.konnect_short_name}}
* [Manage teams and roles](/konnect/org-management/teams-and-roles/manage)
* [Invite users](/konnect/org-management/users) to join your
organization
* [Teams reference](/konnect/org-management/teams-and-roles/teams-reference)
* [Roles reference](/konnect/org-management/teams-and-roles/roles-reference)

## External authentication
{:.badge .enterprise}

{{site.konnect_saas}} supports single sign-on (SSO) access through
[Okta](https://developer.okta.com/docs/guides/) with
[OpenID Connect](https://developer.okta.com/docs/concepts/oauth-openid/#openid-connect).

* Set up [Okta integration](/konnect/org-management/okta-idp)
* View {{site.konnect_saas}} [teams and roles](/konnect/org-management/teams-and-roles)
* [Map Okta groups to {{site.konnect_short_name}} teams](/konnect/org-management/okta-idp/#map-roles-to-groups)

## Login session duration

A login session adheres to the following session duration limits:

* **Individual token duration:** 30 minutes
* **Refresh token duration:** 60 minutes
* **Overall session duration:** 12 hours

This means that a login session can last 12 hours at maximum, as long as the user is active every 60 minutes (for example, reloading a page or configuring something on a page).
After 12 hours, the user will have to log in again.

These limits also apply to sessions initiated through external IdPs.
Currently, session duration limits are not configurable.