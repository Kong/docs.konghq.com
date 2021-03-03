---
title: Kong Mesh - OPA Policy Integration
---

## OPA policy plugin

Kong Mesh integrates the [Open Policy Agent (OPA)](https://www.openpolicyagent.org/) to provide access control for your services.

The agent is included in the data plane proxy sidecar, instead of the more common deployment as a separate sidecar.

When `OPAPolicy` is applied, the control plane configures:

- the embedded policy agent, with the specified policy
- Envoy, to use [External Authorization](https://www.envoyproxy.io/docs/envoy/latest/api-v2/config/filter/http/ext_authz/v2/ext_authz.proto) that points to the embedded policy agent

## Usage

To apply a policy with OPA: 

- Specify the group of data plane proxies to apply the policy to with the `selectors` property.
- Provide the list of policies with the `conf` property. Policies are defined in the [Rego language](https://www.openpolicyagent.org/docs/latest/policy-language/).

### Inline

{% navtabs %}
{% navtab Kubernetes %}

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

{% endnavtab %}
{% navtab Universal %}

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

{% endnavtab %}
{% endnavtabs %}

### With Secrets

Encoding the policy in a [Secret](https://kuma.io/docs/1.0.7/documentation/secrets/#universal) provides some security for policies that contain sensitive data.

{% navtabs %}
{% navtab Kubernetes %}

1.  Define a Secret with a policy that's Base64-encoded:

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

1.  Pass the Secret to `OPAPolicy`:

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

1.  Define a Secret with a policy that's Base64-encoded:

    ```yaml
    type: Secret
    name: sample-secret
    mesh: default
    data: cGFja2FnZSBlbnZveS5hdXRoegoKaW1wb3J0IGlucHV0LmF0dHJpYnV0ZXMucmVxdWVzdC5odHRwIGFzIGh0dHBfcmVxdWVzdAoKZGVmYXVsdCBhbGxvdyA9IGZhbHNlCgp0b2tlbiA9IHsidmFsaWQiOiB2YWxpZCwgInBheWxvYWQiOiBwYXlsb2FkfSB7CiAgICBbXywgZW5jb2RlZF0gOj0gc3BsaXQoaHR0cF9yZXF1ZXN0LmhlYWRlcnMuYXV0aG9yaXphdGlvbiwgIiAiKQogICAgW3ZhbGlkLCBfLCBwYXlsb2FkXSA6PSBpby5qd3QuZGVjb2RlX3ZlcmlmeShlbmNvZGVkLCB7InNlY3JldCI6ICJzZWNyZXQifSkKfQoKYWxsb3cgewogICAgaXNfdG9rZW5fdmFsaWQKICAgIGFjdGlvbl9hbGxvd2VkCn0KCmlzX3Rva2VuX3ZhbGlkIHsKICB0b2tlbi52YWxpZAogIG5vdyA6PSB0aW1lLm5vd19ucygpIC8gMTAwMDAwMDAwMAogIHRva2VuLnBheWxvYWQubmJmIDw9IG5vdwogIG5vdyA8IHRva2VuLnBheWxvYWQuZXhwCn0KCmFjdGlvbl9hbGxvd2VkIHsKICBodHRwX3JlcXVlc3QubWV0aG9kID09ICJHRVQiCiAgdG9rZW4ucGF5bG9hZC5yb2xlID09ICJhZG1pbiIKfQoK
    ```

1.  Pass the Secret to `OPAPolicy`:

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

## Configuration

Kong Mesh defines a default configuration for OPA, but you can adjust the configuration to meet your environment's requirements.

The following environment variables are available:

| Variable                   | Type      | What it configures     | Default value {:width=25%:}   |
| -------------------------- | --------- | --------------------------------------| ------------------- |
| KMESH_OPA_ADDR             | string    | Address OPA API server listens on     | `localhost:8181`    |
| KMESH_OPA_CONFIG_PATH      | string    | Path to file of initial config        | N/A                 |
| KMESH_OPA_DIAGNOSTIC_ADDR  | string    | Address of OPA diagnostics server     | `0.0.0.0:8282`      |
| KMESH_OPA_ENABLED          | bool      | Whether `kuma-dp` starts embedded OPA | true                |
| KMESH_OPA_EXT_AUTHZ_ADDR   | string    | Address of Envoy External AuthZ service | `localhost:9191`  |
| KMESH_OPA_CONFIG_OVERRIDES | strings   | Overrides for OPA configuration, in addition to config file(*) | [plugins.envoy_ext_authz_grpc. query=data.envoy.authz.allow] |

{% navtabs %}
{% navtab Kubernetes %}

You can customize the agent in either of the following ways:

- Override variables in the data plane proxy config: 
{% navtabs %}
{% navtab kumactl %}

When you deploy the Mesh control plane, edit the `kong-mesh-control-plane-config` ConfigMap:

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

{% endnavtab %}
{% navtab Helm %}

Override the Helm value in `values.yaml`

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

{% endnavtab %}
{% endnavtabs %}
{% endnavtab %}
{% navtab Universal %}

The `run` command on the data plane proxy accepts the following equivalent parameters if you prefer not to set environment variables:


```
--opa-addr 
--opa-config-path 
--opa-diagnostic-addr 
--opa-enabled                    
--opa-ext-authz-addr 
--opa-set strings 
```

{% endnavtab %}
{% endnavtabs %}

- Override the config for individual data plane proxies by placing the appropriate annotations on the Pod:

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

## Support for external API management servers

OPAPolicy does not require the `conf` section, so you can apply `OPAPolicy` to configure Envoy with External AuthZ only. This approach does not configure the policy agent itself:

```yaml
type: OPAPolicy
mesh: default
name: opa-1
selectors:
- match:
    kuma.io/service: '*'
```

You can also provide a custom OPA configuration with either a config file or an explicit set of parameters.

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
--opa-config-path /tmp/example-bootstrap.yaml
```
