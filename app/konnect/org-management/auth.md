---
title: Authentication and Authorization
no_version: true
---

Authentication options in {{site.konnect_saas}}:

* Native: Basic auth

  This is the default option in Konnect. You don't have to do anything to set it
  up.

* External auth:
[Single-sign on (SSO) through Okta identity provider (IdP) integration](/konnect/org-management/okta-idp)
<span class="badge enterprise"></span>

    As an alternative to {{site.konnect_saas}}’s native authentication, you can set
    up single sign-on (SSO) access to {{site.konnect_short_name}} through
    [Okta](https://developer.okta.com/docs/guides/) with
    [OpenID Connect](https://developer.okta.com/docs/concepts/oauth-openid/#openid-connect).


Authorization options depend on your authenticator:

* Native auth: Set up Konnect [user and role permissions](/konnect/org-management/users-and-roles)
* External auth (Okta): [Map Okta roles to Konnect roles](/konnect/org-management/okta-idp/#map-roles-to-groups)
