---
title: Linking Static Clients (Self-Managed OIDC)
breadcrumb: Linking Static Clients
content_type: explanation
---

OpenID Connect (OIDC) can be used in two main ways with the Dev Portal:

- **Self-Managed OIDC (Static Clients):** Developers bring their own pre-registered application from the Identity Provider (IdP) and manually link the client ID to their Portal application.
- **Dynamic Client Registration (DCR):** The Dev Portal automatically creates and manages applications in the IdP as developers need them.

This page describes the self-managed (static client) approach.

## How Self-Managed OIDC Works

In this model, each developer:

1. Registers their application directly in the IdP (such as Okta, Auth0, Azure, etc.).
2. Obtains a client ID (and secret, if applicable) from the IdP.
3. Enters the client ID into the Dev Portal when creating or linking their application.

The Dev Portal then uses this client ID to authenticate API requests via OIDC.

**Note:** The Dev Portal does not create or manage IdP applications in this model. All application management is manual and handled by the developer or IdP admin.

## When to Use Self-Managed OIDC

- You want developers to have full control over their IdP applications.
- Your IdP does not support DCR, or you do not want to enable it.
- You require manual review or approval of all IdP applications.

## Workflow

1. Developer registers an application in the IdP.
2. Developer copies the client ID (and secret, if needed).
3. Developer creates or links an application in the Dev Portal, providing the client ID.
4. The Dev Portal uses the provided client ID for OIDC authentication.

## Comparison: Self-Managed OIDC vs. DCR

| Feature                | Self-Managed OIDC (Static) | DCR OIDC (Dynamic)         |
|------------------------|----------------------------|----------------------------|
| App creation in IdP    | Manual by developer        | Automated by Dev Portal    |
| Client ID management   | Manual                     | Automated                  |
| Use case               | Full developer control     | Streamlined onboarding     |
| IdP support required   | Any OIDC IdP               | IdP must support DCR       |

For details on DCR, see [Dynamic Client Registration](/dev-portal/app-reg/auth-strategies/oidc/dynamic-client-registration/).
