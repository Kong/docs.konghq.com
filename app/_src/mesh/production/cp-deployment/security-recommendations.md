---
title: Security Recommendations
---

{{site.mesh_product_name}} is designed to be secure by default. However, there are additional steps you can take to further secure your deployment.
For a strongly secure and high-availability deployment checkout [Mesh in Konnect](/konnect/mesh-manager/).

## Control Plane

### Access Control

For usability, {{site.mesh_product_name}} control plane API is open by default.
To restrict access to entities and features of the control plane, you can configure [access control policies](/mesh/{{page.release}}/features/rbac/). 

### KDS Authentication

In multi-zone deployments, you can enable [KDS authentication](/mesh/{{page.release}}/features/kds-auth/) to secure the communication between the global and zone control planes.

### CORS

By default CORS setup in {{site.mesh_product_name}} is allowing any origin.
You can configure it by setting the [control-plane config](/mesh/{{page.release}}/documentation/configuration): `KUMA_API_SERVER_CORS_ALLOWED_DOMAINS` to a list of domains that are allowed to access the control plane API.
