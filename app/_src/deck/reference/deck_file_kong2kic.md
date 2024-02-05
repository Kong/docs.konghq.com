---
title: deck file kong2kic
source_url: https://github.com/Kong/deck/tree/main/cmd/file_kong2kic.go
content_type: reference
---

Convert decK state files to Kong Ingress Controller kubernetes manifests.

The `kong2kic` subcommand transforms Kong's configuration files, written in the deck format, into Kubernetes manifests suitable for the Kong Ingress Controller. This tool serves as a bridge for deploying API configurations from deck files directly to a Kubernetes cluster running Kong Ingress Controller, facilitating  integration into the final stages of an APIOps pipeline. Essentially, `kong2kic` translates the desired API configurations into a format that `kubectl` can deploy, ensuring that the API's intended state is accurately reflected in the Kubernetes environment.

`kong2kic` integrates API management within kubernetes environments, offering support for both Gateway API and Ingress API standards.
Currently supports the HTTP/HTTPS protocol.

The following table details how Kong configuration entities will be mapped to Kubernetes manifests:

| decK entity                                                  | K8s entity                                                        |
|--------------------------------------------------------------|-------------------------------------------------------------------|
| Service                                                      | Service with annotations and KongIngress for upstream section     |
| Route                                                        | Ingress (Ingress API) or HTTPRoute (Gateway API) with annotations |
| Global Plugin                                                | KongClusterPlugin                                                 |
| Plugin                                                       | KongPlugin                                                        |
| Auth Plugins (key auth, hmac, jwt, basic, oauth2, acl, mtls) | KongPlugin and Secret with credentials section in KongConsumer    |
| Upstream                                                     | KongIngress                                                       |
| Consumer                                                     | KongConsumer                                                      |
| ConsumerGroup                                                | KongConsumerGroup                                                 |
| Certificate                                                  | kubernetes.io/tls Secret                                          |
| CA Certificate                                               | generic Secret                                                    |


Let's see an example of how the following decK state file is converted to Ingress API Kubernetes 
manifests and Gateway API Kubernetes manifests. 

{% navtabs %}
{% navtab decK state file %}

```yaml
services:
  - name: example-service
    url: http://example-api.com
    protocol: http
    host: example-api.com
    port: 80
    path: /v1
    retries: 5
    connect_timeout: 5000
    write_timeout: 60000
    read_timeout: 60000
    enabled: true
    plugins:
      - name: rate-limiting-advanced
        config:
          limit:
          - 5
          window_size:
          - 30
          identifier: consumer
          sync_rate: -1
          namespace: example_namespace
          strategy: local
          hide_client_headers: false
    routes:
      - name: example-route
        methods:
          - GET
          - POST
        hosts:
          - example.com
          - another-example.com
          - yet-another-example.com
        paths:
          - ~/v1/example/?$
          - /v1/another-example
          - /v1/yet-another-example
        protocols:
          - http
          - https
        headers:
          x-my-header:
            - ~*foos?bar$
          x-another-header:
            - first-header-value
            - second-header-value
        regex_priority: 1
        strip_path: false
        preserve_host: true
        https_redirect_status_code: 302
        snis:
          - example.com
        sources:
          - ip: 192.168.0.1
        plugins:
          - name: cors
            config:
              origins:
                - example.com
              methods:
                - GET
                - POST
              headers:
                - Authorization
              exposed_headers:
                - X-My-Header
              max_age: 3600
              credentials: true
          - name: basic-auth
            config:
              hide_credentials: false
consumers:
  - username: example-user
    custom_id: "1234567890"
    basicauth_credentials:
      - username: my_basic_user
        password: my_basic_password
        tags:
          - internal
    plugins:
      - name: rate-limiting-advanced
        config:
          limit:
          - 5
          window_size:
          - 30
          identifier: consumer
          sync_rate: -1
          namespace: example_namespace
          strategy: local
          hide_client_headers: false
consumer_groups:
  - name: example-consumer-group
    consumers:
      - username: example-user
    plugins:
      - name: rate-limiting-advanced
        config:
          limit:
          - 5
          window_size:
          - 30
          identifier: consumer
          sync_rate: -1
          namespace: example_namespace
          strategy: local
          hide_client_headers: false
          window_type: sliding
          retry_after_jitter_max:
          - 0
```

{% endnavtab %}
{% navtab Convert to Ingress API %}

```yaml
apiVersion: configuration.konghq.com/v1
config:
  hide_client_headers: false
  identifier: consumer
  limit:
  - 5
  namespace: example_namespace
  strategy: local
  sync_rate: -1
  window_size:
  - 30
kind: KongPlugin
metadata:
  annotations:
    kubernetes.io/ingress.class: kong
  creationTimestamp: null
  name: example-service-rate-limiting-advanced
plugin: rate-limiting-advanced
status: {}
---
apiVersion: configuration.konghq.com/v1
config:
  credentials: true
  exposed_headers:
  - X-My-Header
  headers:
  - Authorization
  max_age: 3600
  methods:
  - GET
  - POST
  origins:
  - example.com
kind: KongPlugin
metadata:
  annotations:
    kubernetes.io/ingress.class: kong
  creationTimestamp: null
  name: example-service-example-route-cors
plugin: cors
status: {}
---
apiVersion: configuration.konghq.com/v1
config:
  hide_credentials: false
kind: KongPlugin
metadata:
  annotations:
    kubernetes.io/ingress.class: kong
  creationTimestamp: null
  name: example-service-example-route-basic-auth
plugin: basic-auth
status: {}
---
apiVersion: configuration.konghq.com/v1
config:
  hide_client_headers: false
  identifier: consumer
  limit:
  - 5
  namespace: example_namespace
  strategy: local
  sync_rate: -1
  window_size:
  - 30
kind: KongPlugin
metadata:
  annotations:
    kubernetes.io/ingress.class: kong
  creationTimestamp: null
  name: example-user-rate-limiting-advanced
plugin: rate-limiting-advanced
status: {}
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    konghq.com/headers.x-another-header: first-header-value,second-header-value
    konghq.com/headers.x-my-header: ~*foos?bar$
    konghq.com/https-redirect-status-code: "302"
    konghq.com/methods: GET,POST
    konghq.com/plugins: example-service-example-route-cors,example-service-example-route-basic-auth
    konghq.com/preserve-host: "true"
    konghq.com/protocols: http,https
    konghq.com/regex-priority: "1"
    konghq.com/snis: example.com
    konghq.com/strip-path: "false"
  creationTimestamp: null
  name: example-service-example-route
spec:
  ingressClassName: kong
  rules:
  - host: example.com
    http:
      paths:
      - backend:
          service:
            name: example-service
            port:
              number: 80
        path: /~/v1/example/?$
        pathType: ImplementationSpecific
      - backend:
          service:
            name: example-service
            port:
              number: 80
        path: /v1/another-example
        pathType: ImplementationSpecific
      - backend:
          service:
            name: example-service
            port:
              number: 80
        path: /v1/yet-another-example
        pathType: ImplementationSpecific
  - host: another-example.com
    http:
      paths:
      - backend:
          service:
            name: example-service
            port:
              number: 80
        path: /~/v1/example/?$
        pathType: ImplementationSpecific
      - backend:
          service:
            name: example-service
            port:
              number: 80
        path: /v1/another-example
        pathType: ImplementationSpecific
      - backend:
          service:
            name: example-service
            port:
              number: 80
        path: /v1/yet-another-example
        pathType: ImplementationSpecific
  - host: yet-another-example.com
    http:
      paths:
      - backend:
          service:
            name: example-service
            port:
              number: 80
        path: /~/v1/example/?$
        pathType: ImplementationSpecific
      - backend:
          service:
            name: example-service
            port:
              number: 80
        path: /v1/another-example
        pathType: ImplementationSpecific
      - backend:
          service:
            name: example-service
            port:
              number: 80
        path: /v1/yet-another-example
        pathType: ImplementationSpecific
status:
  loadBalancer: {}
---
apiVersion: v1
kind: Service
metadata:
  annotations:
    konghq.com/connect-timeout: "5000"
    konghq.com/path: /v1
    konghq.com/plugins: example-service-rate-limiting-advanced
    konghq.com/protocol: http
    konghq.com/read-timeout: "60000"
    konghq.com/retries: "5"
    konghq.com/write-timeout: "60000"
  creationTimestamp: null
  name: example-service
spec:
  ports:
  - port: 80
    protocol: TCP
    targetPort: 80
  selector:
    app: example-service
status:
  loadBalancer: {}
---
apiVersion: v1
kind: Secret
metadata:
  annotations:
    kubernetes.io/ingress.class: kong
  creationTimestamp: null
  name: basic-auth-example-user
stringData:
  kongCredType: basic-auth
  password: my_basic_password
  username: my_basic_user
---
apiVersion: configuration.konghq.com/v1
consumerGroups:
- example-consumer-group
credentials:
- basic-auth-example-user
custom_id: "1234567890"
kind: KongConsumer
metadata:
  annotations:
    konghq.com/plugins: example-user-rate-limiting-advanced
    kubernetes.io/ingress.class: kong
  creationTimestamp: null
  name: example-user
status: {}
username: example-user
---
apiVersion: configuration.konghq.com/v1beta1
kind: KongConsumerGroup
metadata:
  annotations:
    kubernetes.io/ingress.class: kong
  creationTimestamp: null
  name: example-consumer-group
status: {}
---
```

{% endnavtab %}
{% navtab Convert to Gateway API %}

````yaml
apiVersion: configuration.konghq.com/v1
config:
  hide_client_headers: false
  identifier: consumer
  limit:
  - 5
  namespace: example_namespace
  strategy: local
  sync_rate: -1
  window_size:
  - 30
kind: KongPlugin
metadata:
  annotations:
    kubernetes.io/ingress.class: kong
  creationTimestamp: null
  name: example-service-rate-limiting-advanced
plugin: rate-limiting-advanced
status: {}
---
apiVersion: configuration.konghq.com/v1
config:
  credentials: true
  exposed_headers:
  - X-My-Header
  headers:
  - Authorization
  max_age: 3600
  methods:
  - GET
  - POST
  origins:
  - example.com
kind: KongPlugin
metadata:
  annotations:
    kubernetes.io/ingress.class: kong
  creationTimestamp: null
  name: example-service-example-route-cors
plugin: cors
status: {}
---
apiVersion: configuration.konghq.com/v1
config:
  hide_credentials: false
kind: KongPlugin
metadata:
  annotations:
    kubernetes.io/ingress.class: kong
  creationTimestamp: null
  name: example-service-example-route-basic-auth
plugin: basic-auth
status: {}
---
apiVersion: configuration.konghq.com/v1
config:
  hide_client_headers: false
  identifier: consumer
  limit:
  - 5
  namespace: example_namespace
  strategy: local
  sync_rate: -1
  window_size:
  - 30
kind: KongPlugin
metadata:
  annotations:
    kubernetes.io/ingress.class: kong
  creationTimestamp: null
  name: example-user-rate-limiting-advanced
plugin: rate-limiting-advanced
status: {}
---
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  annotations:
    konghq.com/https-redirect-status-code: "302"
    konghq.com/preserve-host: "true"
    konghq.com/regex-priority: "1"
    konghq.com/snis: example.com
    konghq.com/strip-path: "false"
  creationTimestamp: null
  name: example-service-example-route
spec:
  hostnames:
  - example.com
  - another-example.com
  - yet-another-example.com
  parentRefs:
  - name: kong
  rules:
  - backendRefs:
    - name: example-service
      port: 80
    filters:
    - extensionRef:
        group: configuration.konghq.com
        kind: KongPlugin
        name: example-service-example-route-cors
      type: ExtensionRef
    - extensionRef:
        group: configuration.konghq.com
        kind: KongPlugin
        name: example-service-example-route-basic-auth
      type: ExtensionRef
    matches:
    - headers:
      - name: x-another-header
        type: Exact
        value: first-header-value,second-header-value
      - name: x-my-header
        type: RegularExpression
        value: foos?bar$
      method: GET
      path:
        type: RegularExpression
        value: /v1/example/?$
  - backendRefs:
    - name: example-service
      port: 80
    filters:
    - extensionRef:
        group: configuration.konghq.com
        kind: KongPlugin
        name: example-service-example-route-cors
      type: ExtensionRef
    - extensionRef:
        group: configuration.konghq.com
        kind: KongPlugin
        name: example-service-example-route-basic-auth
      type: ExtensionRef
    matches:
    - headers:
      - name: x-another-header
        type: Exact
        value: first-header-value,second-header-value
      - name: x-my-header
        type: RegularExpression
        value: foos?bar$
      method: POST
      path:
        type: RegularExpression
        value: /v1/example/?$
  - backendRefs:
    - name: example-service
      port: 80
    filters:
    - extensionRef:
        group: configuration.konghq.com
        kind: KongPlugin
        name: example-service-example-route-cors
      type: ExtensionRef
    - extensionRef:
        group: configuration.konghq.com
        kind: KongPlugin
        name: example-service-example-route-basic-auth
      type: ExtensionRef
    matches:
    - headers:
      - name: x-another-header
        type: Exact
        value: first-header-value,second-header-value
      - name: x-my-header
        type: RegularExpression
        value: foos?bar$
      method: GET
      path:
        type: PathPrefix
        value: /v1/another-example
  - backendRefs:
    - name: example-service
      port: 80
    filters:
    - extensionRef:
        group: configuration.konghq.com
        kind: KongPlugin
        name: example-service-example-route-cors
      type: ExtensionRef
    - extensionRef:
        group: configuration.konghq.com
        kind: KongPlugin
        name: example-service-example-route-basic-auth
      type: ExtensionRef
    matches:
    - headers:
      - name: x-another-header
        type: Exact
        value: first-header-value,second-header-value
      - name: x-my-header
        type: RegularExpression
        value: foos?bar$
      method: POST
      path:
        type: PathPrefix
        value: /v1/another-example
  - backendRefs:
    - name: example-service
      port: 80
    filters:
    - extensionRef:
        group: configuration.konghq.com
        kind: KongPlugin
        name: example-service-example-route-cors
      type: ExtensionRef
    - extensionRef:
        group: configuration.konghq.com
        kind: KongPlugin
        name: example-service-example-route-basic-auth
      type: ExtensionRef
    matches:
    - headers:
      - name: x-another-header
        type: Exact
        value: first-header-value,second-header-value
      - name: x-my-header
        type: RegularExpression
        value: foos?bar$
      method: GET
      path:
        type: PathPrefix
        value: /v1/yet-another-example
  - backendRefs:
    - name: example-service
      port: 80
    filters:
    - extensionRef:
        group: configuration.konghq.com
        kind: KongPlugin
        name: example-service-example-route-cors
      type: ExtensionRef
    - extensionRef:
        group: configuration.konghq.com
        kind: KongPlugin
        name: example-service-example-route-basic-auth
      type: ExtensionRef
    matches:
    - headers:
      - name: x-another-header
        type: Exact
        value: first-header-value,second-header-value
      - name: x-my-header
        type: RegularExpression
        value: foos?bar$
      method: POST
      path:
        type: PathPrefix
        value: /v1/yet-another-example
status:
  parents: null
---
apiVersion: v1
kind: Service
metadata:
  annotations:
    konghq.com/connect-timeout: "5000"
    konghq.com/path: /v1
    konghq.com/plugins: example-service-rate-limiting-advanced
    konghq.com/protocol: http
    konghq.com/read-timeout: "60000"
    konghq.com/retries: "5"
    konghq.com/write-timeout: "60000"
  creationTimestamp: null
  name: example-service
spec:
  ports:
  - port: 80
    protocol: TCP
    targetPort: 80
  selector:
    app: example-service
status:
  loadBalancer: {}
---
apiVersion: v1
kind: Secret
metadata:
  annotations:
    kubernetes.io/ingress.class: kong
  creationTimestamp: null
  name: basic-auth-example-user
stringData:
  kongCredType: basic-auth
  password: my_basic_password
  username: my_basic_user
---
apiVersion: configuration.konghq.com/v1
consumerGroups:
- example-consumer-group
credentials:
- basic-auth-example-user
custom_id: "1234567890"
kind: KongConsumer
metadata:
  annotations:
    konghq.com/plugins: example-user-rate-limiting-advanced
    kubernetes.io/ingress.class: kong
  creationTimestamp: null
  name: example-user
status: {}
username: example-user
---
apiVersion: configuration.konghq.com/v1beta1
kind: KongConsumerGroup
metadata:
  annotations:
    kubernetes.io/ingress.class: kong
  creationTimestamp: null
  name: example-consumer-group
status: {}
---
````

{% endnavtab %}
{% endnavtabs %}

## Syntax

```
deck file kong2kic [command-specific flags] [global flags]
```

## Examples

```
# Transform kong configuration file into kong ingress controller 
# manifests using the Ingress API (default) and output
# in yaml format (default)
deck file kong2kic -s kong-config.yaml -o ingress-config.yaml

# transform kong configuration file into kong ingress controller 
# manifests using the Gateway API and output in json format
deck file kong2kic -s kong-config.yaml -a gateway -f json -o ingress-config.yaml

# transform kong configuration file into kong ingress controller 
# manifests using the Gateway API and output in json format.
# Use "apiVersion: gateway.networking.k8s.io/v1beta1" for HTTPRoute
# objects in case of deploying against Kong Ingress Controller
# versions earlier than 3.0.
deck file kong2kic -s kong-config.yaml -a gateway -–v1beta1 -f json -o gateway-config.yaml

# transform openapi configuration into kong configuration file
# and then into kubernetes ingress controller manifests to  
# finally apply them via kubectl in the kong namespace
deck file openapi2kong -s petstore-openapi.json | deck file kong2kic -s - | kubectl apply -f - -n kong

# transform openapi configuration into kong configuration file
# and then into kubernetes ingress controller manifests with an
# ingressClassName: kong-private.
# Finally apply them via kubectl in the kong namespace
deck file openapi2kong -s petstore-openapi.json | deck file kong2kic -s - --class-name kong-private | kubectl apply -f - -n kong

```

## Flags

`-a`, `--api`
:  Transform into Ingress API manifests or Gateway API manifests: `ingress` or `gateway` (default `"ingress"`).

`-f`, `--format`
:  Output format: `yaml` or `json`. (Default: `"yaml"`)

`-h`, `--help`
:  Help for kong2kic.

`-o`, `--output-file`
:  Output file to write to. Use `-` to write to stdout. (Default: `"-"`)

`-s`, `--state`
:  decK state file to process. Use `-` to read from stdin. (Default: `"-"`)

`--style`
:  Only for Ingress API. Generate manifests with annotations in Service objects	and Ingress objects (versions of
{{site.kic_product_name}} 2.8 and higher), or use only KongIngress objects without annotations
(versions of {{site.kic_product_name}} 2.7 or older): `annotation` or `crd`. (default `"annotation"`).

`--class-name`
: String to use for "kubernetes.io/ingress.class" ObjectMeta.Annotations and for "parentRefs.name" in the case of HTTPRoute.
Useful when using multiple instances of {{site.kic_product_name}} in the same cluster, for example one to process
Internet traffic and the other to process intranet traffic. (default `"kong"`)

`--v1beta1`
: Only for Gateway API. Setting this flag will use "apiVersion: gateway.networking.k8s.io/v1beta1" 
in Gateway API manifests. Otherwise, "apiVersion: gateway.konghq.com/v1" is used.
{{site.kic_product_name}} versions earlier than 3.0 only support v1beta1.

## Global flags

{% include_cached /md/deck-global-flags.md release=page.release %}

## See also

{% include /md/deck-reference-links.md file_links='true' %}


