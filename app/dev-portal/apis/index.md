---
title: APIs
---

An API is the interface that you publish to your end customer. Developers register [applications](../access-and-approvals/applications) for use with specific APIs.

As an API Producer, you [publish an OpenAPI specification](../portals/publishing) and additional documentation to help users get started with your API.

{:.note}
When linking an API to a Gateway Service, today it is a 1:1 mapping. 
<!-- TODO: composition once we commit to deliver
In the future you will be able to define an API as a subset of the endpoints available within a Service, or compose an API using multiple Services.
-->

## From Zero to API

Publishing an API is a multi-step process:

1. Create a new API, including [the API version](versioning).
2. Upload an OpenAPI specification for the API
3. (Optional) Add additional markdown documentation for your API
4. Link your API to a [Gateway Service](gateway-service-link)
5. [Publish your API to a Portal](portals/publishing)

Your API is now visible in the Portal that you selected, and developers can register to generate credentials and use the API in a self-service manner.