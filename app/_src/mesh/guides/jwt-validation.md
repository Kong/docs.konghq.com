---
title: Use OPA to validate JWT tokens
content-type: how-to
description: Validate JWT tokens using an OPA policy in Kong Mesh.
---

In this use case, you are ----

Use case ideas:
* apply security policies for upstream services 
* EnvoyFilter can be configured to include Envoy’s External Authorization filter to delegate authorization decisions to OPA. 
* Envoy’s External authorization filter can be used with OPA as an authorization service to enforce security policies over API requests received by Envoy. The tutorial also covers examples of authoring custom policies over the HTTP request body.


diagram that explains how the tech works

## Prerequisites

* install example app:
    ```bash
    kubectl apply -f https://bit.ly/demokuma
    ```
    why? what does this contain? maybe not since we want this to apply to a bunch of use cases?

## instructions



