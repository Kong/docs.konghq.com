---
title: Use OPA to validate JWT tokens
content-type: tutorial
description: Validate JWT tokens using an OPA policy in Kong Mesh.
---

A common problem companies face is how to determine that a user is who they say they are when logging in, and how to ensure only authorized users have access to certain applications and enforce security policies over API requests and for upstream services. {{site.mesh_product_name}} uses a [MeshOPA (beta)](/mesh/{{page.kong_version}}/features/meshopa/) policy to authorize JWT tokens by using [Envoy's External authorization filter](https://www.envoyproxy.io/docs/envoy/latest/intro/arch_overview/security/ext_authz_filter.html) with [OPA](https://www.openpolicyagent.org/docs/latest/envoy-introduction/). Keep in mind that OPA doesn't handle authentication, it only handles authorization.

In this tutorial, you are a security engineer at your company. The company has created a new application that employees can log in to, but it's an internal application, so they don't want the public to be able to access it. Your company already uses an IdP for authentication, so you figure you can use the JWT token presented by the IdP to authorize employees to use the internal application. You are already using {{site.mesh_product_name}} to proxy services, so you decide to use the [MeshOPA (beta)](/mesh/{{page.kong_version}}/features/meshopa/) policy to authorize JWT tokens because <!--what are the advantages of this over other options?-->.

<!--Use case ideas:
* apply security policies for upstream services 
* EnvoyFilter can be configured to include Envoy’s External Authorization filter to delegate authorization decisions to OPA. 
* Envoy’s External authorization filter can be used with OPA as an authorization service to enforce security policies over API requests received by Envoy. The tutorial also covers examples of authoring custom policies over the HTTP request body.-->


{diagram that explains how the tech works}

## Prerequisites

* install example app:
    ```bash
    kubectl apply -f https://bit.ly/demokuma
    ```
    why? what does this contain? maybe not since we want this to apply to a bunch of use cases?

## instructions



