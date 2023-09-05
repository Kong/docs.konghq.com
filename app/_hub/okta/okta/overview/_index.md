---
nav_title: Overview
---

[This integration guide](https://github.com/tom-smith-okta/okta-api-center/tree/master/gateways/kong){:target="_blank"}{:rel="noopener noreferrer"} describes how to integrate Okta's API Access Management (OAuth as a Service) with Kong API Gateway.

The integration described here is an authorization-tier integration; authentication will be happening outside of Kong. A web application will handle authentication vs. Okta, acquiring an access token, and sending that access token to Kong on behalf of the end-user.
