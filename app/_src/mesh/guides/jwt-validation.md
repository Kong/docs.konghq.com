---
title: Use OPA to validate JWT tokens
content-type: tutorial
description: Validate JWT tokens using an OPA policy in Kong Mesh.
---

A companies commonly face the following security problems:
* How to determine that a user is who they say they are when logging in
* How to ensure that only authorized users have access to certain applications and enforce security policies over API requests and for upstream services. 

These problems can be solved by using a {{site.mesh_product_name}} [MeshOPA (beta)](/mesh/{{page.kong_version}}/features/meshopa/) policy to authorize JWT tokens by using [Envoy's External authorization filter](https://www.envoyproxy.io/docs/envoy/latest/intro/arch_overview/security/ext_authz_filter.html) with [OPA](https://www.openpolicyagent.org/docs/latest/envoy-introduction/). Keep in mind that OPA doesn't handle authentication, it only handles authorization.

This guide explains how to configure and deploy a MeshOPA policy that authorizes users based on if they have a valid JWT token. <!--what are the advantages of this over other options?-->.

{diagram that explains how the tech works}

## Prerequisites

* [Deploy {{site.mesh_product_name}}](/mesh/{{page.kong_version}}/production/deployment/) in either standalone or multi-zone mode.
* A valid JWT token stored securely?
* install example app?:
    ```bash
    kubectl apply -f https://bit.ly/demokuma
    ```
    why? what does this contain? maybe not since we want this to apply to a bunch of use cases?

## Use an OPA policy to validate JWT tokens

{% navtabs %}
{% navtab Kubernetes %}
1. Create the `require-jwt` OPA policy that enforces JWT validation when the `frontend` service makes a request to the `backend` service in the `kuma-demo` namespace:

```bash
echo "
apiVersion: kuma.io/v1alpha1
kind: OPAPolicy
mesh: default
metadata:
  name: require-jwt
  namespace: kuma-demo
spec:
  selectors:
  - match:
      kuma.io/service: '*'
  conf:
    policies:
      - inlineString: |
          package envoy.authz

          import input.attributes.request.http as http_request

          default allow = false

          token = {\"valid\": valid, \"payload\": payload} {
              [_, encoded] := split(http_request.headers.authorization, \" \")
              [valid, _, payload] := io.jwt.decode_verify(encoded, {\"secret\": \"secret\"})
          }

          allow {
              is_token_valid
              action_allowed
          }

          is_token_valid {
            token.valid
            now := time.now_ns() / 1000000000
            token.payload.nbf <= now
            now < token.payload.exp
          }

          action_allowed {
            http_request.method == \"GET\"
            token.payload.role == \"admin\"
          }
" | kubectl apply -f -
```
1. Export the token to a variable and make the request (somehow not manually, like how would this be done in real life):
{% endnavtab %}
{% navtab Universal %}
1. Create the `require-jwt` OPA policy that enforces JWT validation when the `frontend` service makes a request to the `backend` service in the `kuma-demo` namespace:

```bash
echo "
type: OPAPolicy
mesh: default
metadata:
  name: require-jwt
  namespace: kuma-demo
selectors:
- match:
    kuma.io/service: '*'
conf:
  agentConfig: # optional
    inlineString: | # one of: inlineString, secret
      decision_logs:
        console: true
  policies: # optional
    - inlineString: | # one of: inlineString, secret
        package envoy.authz

        import input.attributes.request.http as http_request

        default allow = false

        token = {"valid": valid, "payload": payload} {
            [_, encoded] := split(http_request.headers.authorization, " ")
            [valid, _, payload] := io.jwt.decode_verify(encoded, {"secret": "secret"})
        }

        allow {
            is_token_valid
            action_allowed
        }

        is_token_valid {
          token.valid
          now := time.now_ns() / 1000000000
          token.payload.nbf <= now
          now < token.payload.exp
        }

        action_allowed {
          http_request.method == "GET"
          token.payload.role == "admin"
        }
" | kumactl apply -f -
```
1. Export the token to a variable and make the request (somehow not manually, like how would this be done in real life):
{% endnavtab %}
{% endnavtabs %}

## Test the JWT validation configuration

verify that it won’t accept something without a JWT token

verify that it will accept something with the token and any modifiers (if they were configured)

troubleshooting if issues?

{% navtabs %}
{% navtab Kubernetes %}
```yaml
```
{% endnavtab %}
{% navtab Universal %}
```yaml
```
{% endnavtab %}
{% endnavtabs %}



