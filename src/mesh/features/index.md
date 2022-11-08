---
title: Enterprise Features
content_type: explanation
---

{{site.mesh_product_name}} builds on top of Kuma with the following Enterprise features:

## mTLS policy backends

{{site.mesh_product_name}} supports the following additional backends for the
[mTLS policy](/mesh/{{page.kong_version}}/policies/mutual-tls/):
* [HashiCorp Vault CA](/mesh/{{page.kong_version}}/features/vault)
* [Amazon Certificate Manager Private CA](/mesh/{{page.kong_version}}/features/acmpca)
* [Kubernetes cert-manager CA](/mesh/{{page.kong_version}}/features/cert-manager)

## Open Policy Agent (OPA) support

You can use [OPA with {{site.mesh_product_name}}](/mesh/{{page.kong_version}}/features/opa)
to provide access control for your services.

The agent is included in the data plane proxy sidecar.

## Multi-zone authentication

To add to the security of your deployments, {{site.mesh_product_name}} provides
[authentication of zone control planes](/mesh/{{page.kong_version}}/features/kds-auth)
to the global control plane.

Authentication is based on the Zone Token, which is also used to authenticate the zone proxy.

##  FIPS 140-2 support

{{site.mesh_product_name}} provides built-in support for the Federal Information Processing Standard (FIPS-2).
See [FIPS Support](/mesh/{{page.kong_version}}/features/fips-support) for more information.

##  Certificate Authority rotation

{{site.mesh_product_name}} lets you provide secure communication between applications with mTLS.
You can change the mTLS backend with [Certificate Authority rotation](/mesh/{{page.kong_version}}/features/ca-rotation),
to support a scenario such as migrating from the builtin CA to a Vault CA.

## Role-Based Access Control (RBAC)

[Role-Based Access Control (RBAC)](/mesh/{{page.kong_version}}/features/rbac) in {{site.mesh_product_name}}
lets you restrict access to resources and actions to specified users or groups based on user roles.
Apply targeted security policies, implement granular traffic control, and much more.

## Red Hat Universal Base Images

{{site.mesh_product_name}} provides images based on the [Red Hat Universal Base Image (UBI)](https://developers.redhat.com/products/rhel/ubi).

{{site.mesh_product_name}} UBI images are distributed with all standard images, but with the `ubi-` prefix.
See the [UBI documentation](/mesh/{{page.kong_version}}/features/ubi-images) for more information.

## Windows Support

You can [install {{site.mesh_product_name}} on Windows](/mesh/{{page.kong_version}}/installation/windows).
