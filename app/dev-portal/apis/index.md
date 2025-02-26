---
title: APIs
---

An API is the interface that you publish to your end customer. Developers register [applications](../access-and-approvals/applications) for use with specific APIs.

As an API Producer, you [publish an OpenAPI specification](../portals/publishing) and additional documentation to help users get started with your API.

{:.note}
> If you previously used API Products you may be wondering where the "API Product" concept has gone. API Product will not be used in the Beta Dev Portal, and will not affect your existing API Products, which will only be supported on older Dev Portals.

{:.note}
<!-- TODO: composition once we commit to deliver
In the future you will be able to define an API as a subset of the endpoints available within a Service, or compose an API using multiple Services.
-->

## From Zero to API

Publishing an API is a multi-step process:

1. Create a new API, including [the API version](versioning).
2. Upload an OpenAPI specification for the API and/or additional markdown documentation for your API (either API spec or docs must be provided to generate documentation)
3. Link your API to a [Gateway Service](gateway-service-link)
4. [Publish your API to a Portal](../portals/publishing)

Your API is now published in the Portal that you selected. If [User Authentication](../portals/settings/settings/security#user-authentication--role-based-access-control-rbac) is enabled, Developers can register to create applications, generate credentials and use the API in a self-service manner. 

If you have RBAC enabled, you will need to add an approved Developer to a [Team](../access-and-approvals/teams) in order to provide access.