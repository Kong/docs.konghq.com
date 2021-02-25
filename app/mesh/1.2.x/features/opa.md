---
title: Kong Mesh - OPAPolicy Support
---

## OPAPolicy plugin

[Open Policy Agent (OPA)](https://www.openpolicyagent.org/) is a way to control access to a various components of your infrastructure.
OPA can also be used to control the access to a service, which is the case that Kong Mesh integration covers.

Usually, OPA agent is deployed as a sidecar next to your application, but Kong Mesh embeds OPA agent into data plane proxy sidecar removing the burden of operations.

When `OPAPolicy` is applied, Kong Mesh control plane does two things
1) It configures embedded OPA agent with a selected policy
2) It configures Envoy to use [External Authorization](https://www.envoyproxy.io/docs/envoy/latest/api-v2/config/filter/http/ext_authz/v2/ext_authz.proto) pointing to a local embedded OPA agent.

## Usage

To apply an OPA policy, we first need to select a group of dataplanes on which the policy will be applied using `selectors` section.
Then, in the `conf` section we need to provide a list of OPA policies. Policies are defined using [Rego language](https://www.openpolicyagent.org/docs/latest/policy-language/).

### Inline

**Kubernetes**

```yaml
apiVersion: kuma.io/v1alpha1
kind: OPAPolicy
mesh: default
metadata:
  name: opa-1
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
```

**Universal**

```yaml
type: OPAPolicy
mesh: default
name: opa-1
selectors:
- match:
    kuma.io/service: '*'
conf:
  policies:
    - inlineString: |
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
```

### Secret

Policy can contain sensitive data, so we can use a [Secret](https://kuma.io/docs/1.0.7/documentation/secrets/#universal) as a source of the policy.

{% navtabs %}
{% navtab Kubernetes %}

First define a secret with a policy encoded as Base64.

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: opa-policy
  namespace: kong-mesh-system
  labels:
    kuma.io/mesh: default
data:
  value: cGFja2FnZSBlbnZveS5hdXRoegoKaW1wb3J0IGlucHV0LmF0dHJpYnV0ZXMucmVxdWVzdC5odHRwIGFzIGh0dHBfcmVxdWVzdAoKZGVmYXVsdCBhbGxvdyA9IGZhbHNlCgp0b2tlbiA9IHsidmFsaWQiOiB2YWxpZCwgInBheWxvYWQiOiBwYXlsb2FkfSB7CiAgICBbXywgZW5jb2RlZF0gOj0gc3BsaXQoaHR0cF9yZXF1ZXN0LmhlYWRlcnMuYXV0aG9yaXphdGlvbiwgIiAiKQogICAgW3ZhbGlkLCBfLCBwYXlsb2FkXSA6PSBpby5qd3QuZGVjb2RlX3ZlcmlmeShlbmNvZGVkLCB7InNlY3JldCI6ICJzZWNyZXQifSkKfQoKYWxsb3cgewogICAgaXNfdG9rZW5fdmFsaWQKICAgIGFjdGlvbl9hbGxvd2VkCn0KCmlzX3Rva2VuX3ZhbGlkIHsKICB0b2tlbi52YWxpZAogIG5vdyA6PSB0aW1lLm5vd19ucygpIC8gMTAwMDAwMDAwMAogIHRva2VuLnBheWxvYWQubmJmIDw9IG5vdwogIG5vdyA8IHRva2VuLnBheWxvYWQuZXhwCn0KCmFjdGlvbl9hbGxvd2VkIHsKICBodHRwX3JlcXVlc3QubWV0aG9kID09ICJHRVQiCiAgdG9rZW4ucGF5bG9hZC5yb2xlID09ICJhZG1pbiIKfQoK
type: system.kuma.io/secret
```

Then refer to it in `OPAPolicy`

```yaml
apiVersion: kuma.io/v1alpha1
kind: OPAPolicy
mesh: default
metadata:
  name: opa-1
spec:
  selectors:
  - match:
      kuma.io/service: '*'
  conf:
    policies:
      - secret: opa-policy
```

{% endnavtab %}
{% navtab Universal %}

First define a secret with a policy encoded as Base64.

```yaml
type: Secret
name: sample-secret
mesh: default
data: cGFja2FnZSBlbnZveS5hdXRoegoKaW1wb3J0IGlucHV0LmF0dHJpYnV0ZXMucmVxdWVzdC5odHRwIGFzIGh0dHBfcmVxdWVzdAoKZGVmYXVsdCBhbGxvdyA9IGZhbHNlCgp0b2tlbiA9IHsidmFsaWQiOiB2YWxpZCwgInBheWxvYWQiOiBwYXlsb2FkfSB7CiAgICBbXywgZW5jb2RlZF0gOj0gc3BsaXQoaHR0cF9yZXF1ZXN0LmhlYWRlcnMuYXV0aG9yaXphdGlvbiwgIiAiKQogICAgW3ZhbGlkLCBfLCBwYXlsb2FkXSA6PSBpby5qd3QuZGVjb2RlX3ZlcmlmeShlbmNvZGVkLCB7InNlY3JldCI6ICJzZWNyZXQifSkKfQoKYWxsb3cgewogICAgaXNfdG9rZW5fdmFsaWQKICAgIGFjdGlvbl9hbGxvd2VkCn0KCmlzX3Rva2VuX3ZhbGlkIHsKICB0b2tlbi52YWxpZAogIG5vdyA6PSB0aW1lLm5vd19ucygpIC8gMTAwMDAwMDAwMAogIHRva2VuLnBheWxvYWQubmJmIDw9IG5vdwogIG5vdyA8IHRva2VuLnBheWxvYWQuZXhwCn0KCmFjdGlvbl9hbGxvd2VkIHsKICBodHRwX3JlcXVlc3QubWV0aG9kID09ICJHRVQiCiAgdG9rZW4ucGF5bG9hZC5yb2xlID09ICJhZG1pbiIKfQoK
```

Then refer to it in `OPAPolicy`

```yaml
type: OPAPolicy
mesh: default
name: opa-1
selectors:
- match:
    kuma.io/service: '*'
conf:
  policies:
    - secret: opa-policy
```
{% endnavtab %}
{% endnavtabs %}

## OPA Configuration

OPA has a default configuration tuned for Kong Mesh, but you can still control the behavior of OPA itself for your need.

### Universal

Kuma DP `run` command exposes set of parameters

```
--opa-addr string                Address on which OPA API server will listen (default "localhost:8181")
--opa-config-path string         Path to a file which OPA will use to load initial configuration
--opa-diagnostic-addr string     Address on which OPA will expose diagnostics server (default "0.0.0.0:8282")
--opa-enabled                    If true, Kuma DP will start embedded Open Policy Agent (default true)
--opa-ext-authz-addr string      Address on which OPA will expose Envoy's External Authz service. Envoy will use this address to authorize requests (default "localhost:9191")
--opa-set strings                Overrides for the OPA configuration that are applied on top of config file (equivalent of --set in standalone OPA) (default [plugins.envoy_ext_authz_grpc.query=data.envoy.authz.allow])
```

or equivalent environment variables
```
KMESH_OPA_ADDR
KMESH_OPA_CONFIG_PATH
KMESH_OPA_DIAGNOSTIC_ADDR
KMESH_OPA_ENABLED
KMESH_OPA_EXT_AUTHZ_ADDR
KMESH_OPA_CONFIG_OVERRIDES
```

### Kubernetes

There are two ways how we can parametrize

1. Override variables whenever Kuma DP is injected.

#### kumactl

Deploy Kong Mesh CP. Edit `kong-mesh-control-plane-config` config map

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: kong-mesh-control-plane-config
  namespace: kong-mesh-system
data:
  config.yaml: |
    runtime:
      kubernetes:
        injector:
          sidecarContainer:
            envVars:
              KMESH_OPA_ENABLED: "false"
              KMESH_OPA_ADDR: ":8888"
              KMESH_OPA_CONFIG_OVERRIDES: "config1:x,config2:y"
```

#### HELM

Override HELM value in `Values.yaml`

```yaml
kuma:
  controlPlane:
    config: |
      runtime:
        kubernetes:
          injector:
            sidecarContainer:
              envVars:
                KMESH_OPA_ENABLED: "false"
                KMESH_OPA_ADDR: ":8888"
                KMESH_OPA_CONFIG_OVERRIDES: "config1:x,config2:y"
```

2. Override config for individual Kuma DP

Place annotation on the Pod

```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: example-app
  namespace: kuma-example
spec:
  ...
  template:
    metadata:
      ...
      annotations:
        # indicate to Kuma that this Pod doesn't need a sidecar
        kuma.io/sidecar-env-vars: "KMESH_OPA_ENABLED=false;KMESH_OPA_ADDR=:8888;KMESH_OPA_CONFIG_OVERRIDES=config1:x,config2:y"
```

### Support for external Management API servers

OPAPolicy does not require `conf` section, therefore we can

1. Apply OPAPolicy that configures Envoy with External Authorization filter, but won't configure OPA itself

```yaml
type: OPAPolicy
mesh: default
name: opa-1
selectors:
- match:
    kuma.io/service: '*'
```

2. Provide custom OPA configuration (for example via file or set of parameters)

```
$ cat /tmp/example-bootstrap.yaml
services:
  - name: acmecorp
    url: https://example.com/control-plane-api/v1
    credentials:
      bearer:
        token: "bGFza2RqZmxha3NkamZsa2Fqc2Rsa2ZqYWtsc2RqZmtramRmYWxkc2tm"
discovery:
  name: example
  resource: /configuration/example/discovery.tar.gz
  service: acmecorp
  signing:
    keyid: my_global_key
    scope: read
```

```
--opa-config-path /tmp/example-bootstrap.yaml
```