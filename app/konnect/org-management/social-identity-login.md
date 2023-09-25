---
title: Social Identity Login
content_type: how-to
---

Users have the option to register for and sign in to {{site.konnect_short_name}} accounts using social identity from the following providers:
- Google
- GitHub 
- Microsoft

## Account Linking

You can login with one or more social identity such as Google and Github. When you login with a different identity, you're asked to link accounts so your social identities are associated to the same {{site.konnect_short_name}} accounts. 

We recommend linking accounts when using multiple social identities. If you choose not to link, each account will behave as its own independent identity and be associated with its own organizations. Organizations will only be associated with one social identity. It is not currently possible to relink accounts. 

## Disable Social Login
{:.badge .enterprise}

The social login functionality is part of the “Built-In” authentication scheme found in the [**Organization**](https://cloud.konghq.com/organization/) > [**Auth Settings**](https://cloud.konghq.com/global/organization/auth-settings) menu. The only way to disable social login is to enable OIDC single sign on and disable the built-in authentication scheme. This will also disable basic auth logins and delegate user management to the identity provider.
