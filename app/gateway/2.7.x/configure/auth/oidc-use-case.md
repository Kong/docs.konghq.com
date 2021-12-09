---
title: OpenID Connect
badge: enterprise
---

## What does OpenID Connect do?

OpenID Connect provides a way to form a *federation* with *identity providers*. Identity providers are third parties that store account credentials. If the identity provider authenticates a user, the application trusts that provider and allows access to the user. The *identity provider* bears some responsibility for protecting the user’s credentials and ensuring authenticity, so applications no longer need to on their own.

Besides delegating responsibility to an identity provider, OpenID Connect also makes single sign-on possible without storing any credentials on a user’s local machine.

Finally, enterprises may want to manage access control for many applications from one central system of record. For example, they may want employees to be able to access many different applications using their email address and password. They may want to also change access (e.g. if an employee separates or changes roles) from one central point. OpenID Connect addresses this challenge by providing a way for many different applications to authenticate users through the same third-party identity provider.

## What does Kong’s OpenID Connect plugin do?

Just as OpenID Connect enables developers to offload authentication to another party, Kong enables developers to separate entire processes from their applications. Rather than needing to hand write the code for OpenID Connect *within* a service, developers can place Kong in front of the service and have Kong handle authentication. This separation allows developers to focus on the business logic within their application. It also allows them to easily swap out services while preserving authentication at the front door, and to effortlessly spread the same authentication to *new* services.

Kong users may prefer OpenID Connect to other authentication types, such as Key Auth and Basic Auth, because they will not need to manage the database storing passwords. Instead, they can offload the task to a trusted identity provider of their choice.

While the OpenID Connect Plugin can suit many different use cases and extends to other Plugins such as JWT (JSON Web Token) and 0Auth 2.0, the most common use case is the Authorization Code flow.

## References
See our series of integration guides to configure the OIDC plugin for your
identity provider:

  - [Auth0](/gateway/{{page.kong_version}}/configure/auth/oidc-auth0)
  - [Amazon AWS Cognito](/gateway/{{page.kong_version}}/configure/auth/oidc-cognito/)
  - [Curity](/gateway/{{page.kong_version}}/configure/auth/oidc-curity/)
  - [Google](/gateway/{{page.kong_version}}/configure/auth/oidc-google/)
  - [Microsoft Azure Active Directory (Azure AD)](/gateway/{{page.kong_version}}/configure/auth/oidc-azuread)
  - [Okta](/gateway/{{page.kong_version}}/configure/auth/oidc-okta)

  For a full list of tested providers and all available configuration options,
  see the [OpenID Connect plugin reference](/hub/kong-inc/openid-connect).
