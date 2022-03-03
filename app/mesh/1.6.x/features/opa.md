---
title: Kong Mesh - OPA Policy Integration
---

## OPA policy plugin

{{site.mesh_product_name}} integrates the [Open Policy Agent (OPA)](https://www.openpolicyagent.org/) to provide access control for your services.

The agent is included in the data plane proxy sidecar, instead of the more common deployment as a separate sidecar.

When `OPAPolicy` is applied, the control plane configures:

- the embedded policy agent, with the specified policy
- Envoy, to use [External Authorization](https://www.envoyproxy.io/docs/envoy/latest/api-v2/config/filter/http/ext_authz/v2/ext_authz.proto) that points to the embedded policy agent

## Usage

To apply a policy with OPA: 

- Specify the group of data plane proxies to apply the policy to with the `selectors` property.
- Provide the list of policies with the `conf` property. Policies are defined in the [Rego language](https://www.openpolicyagent.org/docs/latest/policy-language/).
- Optionally provide custom configuration for the policy agent.

You must also specify the HTTP protocol in your mesh configuration:

{% navtabs %}
{% navtab Kubernetes %}

Add the HTTP protocol annotation to the Kubernetes Service configuration, with the general syntax `<port>.service.kuma.io/protocol`.

Example:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: web
  namespace: kong-mesh-example
  annotations:
    8080.service.kuma.io/protocol: http # required for OPA support
spec:
  selector:
    app: web
  ports:
  - port: 8080
```

{% endnavtab %}
{% navtab Universal %}

Add the HTTP protocol tag to the `Dataplane` configuration.

Example:

```yaml
type: Dataplane
mesh: default
name: web
networking:
  address: 192.168.0.1 
  inbound:
  - port: 80
    servicePort: 8080
    tags:
      kuma.io/service: web
      kuma.io/protocol: http # required for OPA support
```

{% endnavtab %}
{% endnavtabs %}

For more information, see [the Kuma documentation about protocol support](https://kuma.io/docs/latest/policies/protocol-support-in-kuma/).

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
    agentConfig: # optional
      inlineString: | # one of: inlineString, secret
        decision_logs:
          console: true
    policies:
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
```

{% endnavtab %}
{% endnavtabs %}

### With Secrets

Encoding the policy in a [Secret](https://kuma.io/docs/latest/security/secrets/) provides some security for policies that contain sensitive data.

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

{{site.mesh_product_name}} defines a default configuration for OPA, but you can adjust the configuration to meet your environment's requirements.

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

## Configuring the authorization filter

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
    authConfig: # optional
        statusOnError: 413 # optional: defaults to 403.
        onAgentFailure: allow # optional: one of 'allow' or 'deny', defaults to 'deny' defines the behaviour when communication with the agent fails or the policy execution fails.
        requestBody: # optional
            maxSize: 1024 # the max number of bytes to send to the agent, if we exceed this, the request to the agent will have: `x-envoy-auth-partial-body: true`.
            sendRawBody: true # use when the body is not plaintext. The agent request will have `raw_body` instead of `body`
    agentConfig: # optional
      inlineString: | # one of: inlineString, secret
        decision_logs:
          console: true
    policies:
      - secret: opa-policy
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
    authConfig: # optional
        statusOnError: 413 # optional: defaults to 403. http statusCode to use when the connection to the agent failed.
        onAgentFailure: allow # optional: one of 'allow' or 'deny', defaults to 'deny'. defines the behaviour when communication with the agent fails or the policy execution fails.
        requestBody: # optional
            maxSize: 1024 # the maximum number of bytes to send to the agent, if we exceed this, the request to the agent will have: `x-envoy-auth-partial-body: true`.
            sendRawBody: true # use when the body is not plaintext. The agent request will have `raw_body` instead of `body`
  agentConfig: # optional
    inlineString: | # one of: inlineString, secret
      decision_logs:
        console: true
  policies: # optional
    - secret: opa-policy
```

{% endnavtab %}
{% endnavtabs %}

By default, the body will not be sent to the agent.
To send it, set `authConfig.requestBody.maxSize` to the maximum size of your body.
If the request body is larger than this parameter, it will be truncated and the header `x-envoy-auth-partial-body` will be set to `true`.

## Support for external API management servers

The `agentConfig` field lets you define a custom configuration that points to an external management server:

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
    agentConfig:
      inlineString: |
        services:
          acmecorp:
            url: https://example.com/control-plane-api/v1
            credentials:
              bearer:
                token: "bGFza2RqZmxha3NkamZsa2Fqc2Rsa2ZqYWtsc2RqZmtramRmYWxkc2tm"
        
        discovery:
          name: example
          resource: /configuration/example/discovery
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
  agentConfig:
    inlineString: | # one of: inlineString, secret
      services:
        acmecorp:
          url: https://example.com/control-plane-api/v1
          credentials:
            bearer:
              token: "bGFza2RqZmxha3NkamZsa2Fqc2Rsa2ZqYWtsc2RqZmtramRmYWxkc2tm"
      discovery:
        name: example
        resource: /configuration/example/discovery
```

{% endnavtab %}
{% endnavtabs %}

## Example

The following example shows how to deploy and test a sample OPA Policy on Kubernetes, using the kuma-demo application.

1.  Deploy the example application:

    ```
    kubectl apply -f https://bit.ly/demokuma
    ```

1.  Make a request from the frontend to the backend:

    ```
    $ kubectl exec -i -t $(kubectl get pod -l "app=kuma-demo-frontend" -o jsonpath='{.items[0].metadata.name}' -n kuma-demo) -n kuma-demo -- curl backend:3001 -v
    ```

    The output looks like:

    ```
    Defaulting container name to kuma-fe.
    Use 'kubectl describe pod/kuma-demo-app-6787b4f7f5-m428c -n kuma-demo' to see all of the containers in this pod.
    *   Trying 10.111.108.218:3001...
    * TCP_NODELAY set
    * Connected to backend (10.111.108.218) port 3001 (#0)
    > GET / HTTP/1.1
    > Host: backend:3001
    > User-Agent: curl/7.67.0
    > Accept: */*
    > 
    * Mark bundle as not supporting multiuse
    < HTTP/1.1 200 OK
    < x-powered-by: Express
    < cache-control: no-store, no-cache, must-revalidate, private
    < access-control-allow-origin: *
    < access-control-allow-methods: PUT, GET, POST, DELETE, OPTIONS
    < access-control-allow-headers: *
    < host: backend:3001
    < user-agent: curl/7.67.0
    < accept: */*
    < x-forwarded-proto: http
    < x-request-id: 1717af9c-2587-43b9-897f-f8061bba5ad4
    < content-length: 90
    < content-type: text/html; charset=utf-8
    < date: Tue, 16 Mar 2021 15:33:18 GMT
    < x-envoy-upstream-service-time: 1521
    < server: envoy
    < 
    * Connection #0 to host backend left intact
    Hello World! Marketplace with sales and reviews made with <3 by the OCTO team at Kong Inc.
    ```

1.  Apply an OPA Policy that requires a valid JWT token:

    ```
    echo " 
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

1.  Make an invalid request from the frontend to the backend:

    ```
    $ kubectl exec -i -t $(kubectl get pod -l "app=kuma-demo-frontend" -o jsonpath='{.items[0].metadata.name}' -n kuma-demo) -n kuma-demo -- curl backend:3001 -v
    ```
    The output looks like:

    ```
    Defaulting container name to kuma-fe.
    Use 'kubectl describe pod/kuma-demo-app-6787b4f7f5-bwvnb -n kuma-demo' to see all of the containers in this pod.
    *   Trying 10.105.146.164:3001...
    * TCP_NODELAY set
    * Connected to backend (10.105.146.164) port 3001 (#0)
    > GET / HTTP/1.1
    > Host: backend:3001
    > User-Agent: curl/7.67.0
    > Accept: */*
    >
    * Mark bundle as not supporting multiuse
    < HTTP/1.1 403 Forbidden
    < date: Tue, 09 Mar 2021 16:50:40 GMT
    < server: envoy
    < x-envoy-upstream-service-time: 2
    < content-length: 0
    <
    * Connection #0 to host backend left intact
    ```

    Note the `HTTP/1.1 403 Forbidden` message. The application doesn't allow a request without a valid token.

    The policy can take up to 30 seconds to propagate, so if this request succeeds the first time, wait and then try again.

1.  Make a valid request from the frontend to the backend:

    ```
    $ export ADMIN_TOKEN="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYWRtaW4iLCJzdWIiOiJZbTlpIiwibmJmIjoxNTE0ODUxMTM5LCJleHAiOjI1MjQ2MDgwMDB9.H0-42LYzoWyQ_4MXAcED30u6lA5JE087eECV2nxDfXo"
    $ kubectl exec -i -t $(kubectl get pod -l "app=kuma-demo-frontend" -o jsonpath='{.items[0].metadata.name}' -n kuma-demo) -n kuma-demo -- curl -H "Authorization: Bearer $ADMIN_TOKEN" backend:3001
    ```

    The output looks like:

    ```
    Defaulting container name to kuma-fe.
    Use 'kubectl describe pod/kuma-demo-app-6787b4f7f5-m428c -n kuma-demo' to see all of the containers in this pod.
    *   Trying 10.111.108.218:3001...
    * TCP_NODELAY set
    * Connected to backend (10.111.108.218) port 3001 (#0)
    > GET / HTTP/1.1
    > Host: backend:3001
    > User-Agent: curl/7.67.0
    > Accept: */*
    > 
    * Mark bundle as not supporting multiuse
    < HTTP/1.1 200 OK
    < x-powered-by: Express
    < cache-control: no-store, no-cache, must-revalidate, private
    < access-control-allow-origin: *
    < access-control-allow-methods: PUT, GET, POST, DELETE, OPTIONS
    < access-control-allow-headers: *
    < host: backend:3001
    < user-agent: curl/7.67.0
    < accept: */*
    < x-forwarded-proto: http
    < x-request-id: 8fd7b398-1ba2-4c2e-b229-5159d04d782e
    < content-length: 90
    < content-type: text/html; charset=utf-8
    < date: Tue, 16 Mar 2021 17:26:00 GMT
    < x-envoy-upstream-service-time: 261
    < server: envoy
    < 
    * Connection #0 to host backend left intact
    Hello World! Marketplace with sales and reviews made with <3 by the OCTO team at Kong Inc.
    ```

    The request is valid again because the token is signed with the `secret` private key, its payload includes the admin role, and it is not expired.
