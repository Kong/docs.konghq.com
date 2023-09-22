---
title: Social Identity Login
content_type: how-to
---

Users have the option to register for and sign in to Konnect accounts using social credentials from Google, GitHub and Microsoft. 

## Account Linking

It is possible to login with one or more social identities such as Google and Github. Upon login with subsequent credentials, users are asked to link accounts such that multiple social identities are associated to the same Konnect accounts. If the user does not choose to “Link Accounts”, each account will behave as its own independent credentials and be associated with its own organizations. Organizations will only be associated with one primary account. It is not currently possible to re-link accounts. Konnect recommends “Linking Accounts” when using multiple social identities.

## Disable Social Login (Enterprise Only)

The social login functionality is part of the “Built-In” authentication scheme found in the Organization > Auth Settings menu. The only way to disable social login is to enable OIDC single sign on and disable the built-in authentication scheme. This will also disable basic auth logins and delegate user management to the identity provider.