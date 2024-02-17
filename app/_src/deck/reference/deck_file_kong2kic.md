---
title: deck file kong2kic
source_url: https://github.com/Kong/deck/tree/main/cmd/file_kong2kic.go
content_type: reference
---


The `kong2kic` subcommand transforms Kong's configuration files, written in the deck format, into Kubernetes manifests suitable for the {{site.kic_product_name}}. This tool serves as a bridge for deploying API configurations from deck files directly to a Kubernetes cluster running {{site.kic_product_name}}, facilitating  integration into the final stages of an APIOps pipeline. Essentially, `kong2kic` translates the desired API configurations into a format that `kubectl` can deploy, ensuring that the API's intended state is accurately reflected in the Kubernetes environment.

`kong2kic` integrates API management within kubernetes environments, offering support for both Gateway API and Ingress API standards.
Currently supports the HTTP/HTTPS protocol.

The following table details how Kong configuration entities will be mapped to Kubernetes manifests:

| decK entity                                                  | K8s entity                                                        |
|--------------------------------------------------------------|-------------------------------------------------------------------|
| Service                                                      | Service with annotations and KongIngress for upstream section     |
| Route                                                        | Ingress (Ingress API) or HTTPRoute (Gateway API) with annotations |
| Global Plugin                                                | KongClusterPlugin                                                 |
| Plugin                                                       | KongPlugin                                                        |
| Auth Plugins <br>(`key-auth`, `hmac-auth`, `jwt`, `basic-auth`, `oauth2`, `acl`, `mtls-auth`) | KongPlugin and Secret with credentials section in KongConsumer    |
| Upstream                                                     | KongIngress or kongUpstreamPolicy                                 |
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
{% navtab Convert to Gateway API %}

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
  name: example-service-rate-limiting-advanced
plugin: rate-limiting-advanced
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
  name: example-service-example-route-cors
plugin: cors
---
apiVersion: configuration.konghq.com/v1
config:
  hide_credentials: false
kind: KongPlugin
metadata:
  annotations:
    kubernetes.io/ingress.class: kong
  name: example-service-example-route-basic-auth
plugin: basic-auth
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
  name: example-user-rate-limiting-advanced
plugin: rate-limiting-advanced
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
  name: example-service
spec:
  ports:
  - port: 80
    protocol: TCP
    targetPort: 80
  selector:
    app: example-service
---
apiVersion: v1
kind: Secret
metadata:
  annotations:
    kubernetes.io/ingress.class: kong
  labels:
    konghq.com/credential: basic-auth
  name: basic-auth-example-user
stringData:
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
  name: example-user
username: example-user
---
apiVersion: configuration.konghq.com/v1beta1
kind: KongConsumerGroup
metadata:
  annotations:
    kubernetes.io/ingress.class: kong
  name: example-consumer-group
---
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
  name: example-service-rate-limiting-advanced
plugin: rate-limiting-advanced
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
  name: example-service-example-route-cors
plugin: cors
---
apiVersion: configuration.konghq.com/v1
config:
  hide_credentials: false
kind: KongPlugin
metadata:
  annotations:
    kubernetes.io/ingress.class: kong
  name: example-service-example-route-basic-auth
plugin: basic-auth
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
  name: example-user-rate-limiting-advanced
plugin: rate-limiting-advanced
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
  name: example-service
spec:
  ports:
  - port: 80
    protocol: TCP
    targetPort: 80
  selector:
    app: example-service
---
apiVersion: v1
kind: Secret
metadata:
  annotations:
    kubernetes.io/ingress.class: kong
  labels:
    konghq.com/credential: basic-auth
  name: basic-auth-example-user
stringData:
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
  name: example-user
username: example-user
---
apiVersion: configuration.konghq.com/v1beta1
kind: KongConsumerGroup
metadata:
  annotations:
    kubernetes.io/ingress.class: kong
  name: example-consumer-group
---

```

{% endnavtab %}
{% endnavtabs %}

## Syntax

```
deck file kong2kic [command-specific flags] [global flags]
```

## Examples

```
# Transform kong configuration file into KIC v3.x
# manifests using the Gateway API (default) and output
# in yaml format (default)
deck file kong2kic -s kong-config.yaml -o gateway.yaml

# Transform kong configuration file into KIC v2.x
# manifests using the Ingress API and output
# in yaml format (default)
deck file kong2kic -s kong-config.yaml -o ingress.yaml --kicv2 --ingress

# transform openapi configuration into kong configuration file
# and then into KIC v3.x manifests using Gateway API and  
# finally apply them via kubectl in the kong namespace
deck file openapi2kong -s petstore-openapi.json | deck file kong2kic -s - | kubectl apply -f - -n kong

# transform openapi configuration into kong configuration file
# and then into KIC v3.x manifests with an
# ingressClassName: kong-private.
# Finally apply them via kubectl in the kong namespace
deck file openapi2kong -s petstore-openapi.json | deck file kong2kic -s - --class-name kong-private | kubectl apply -f - -n kong

```

## Flags

`-o`, `--output-file`
:  Output file to write to. Use `-` to write to stdout. (Default: `"-"`)

`-s`, `--state`
:  decK state file to process. Use `-` to read from stdin. (Default: `"-"`)

`--ingress`
: Use Kubernetes Ingress API manifests instead of Gateway API manifests.

`--kicv2`
:  Generate manifests compatible with KIC v2.x.

`--class-name`
: String to use for "kubernetes.io/ingress.class" ObjectMeta.Annotations and for "parentRefs.name" in the case of HTTPRoute.
Useful when using multiple instances of {{site.kic_product_name}} in the same cluster, for example one to process
Internet traffic and the other to process intranet traffic. (default `"kong"`)

`-f`, `--format`
:  Output format: `yaml` or `json`. (Default: `"yaml"`)

`-h`, `--help`
:  Help for kong2kic.

## Global flags

{% include_cached /md/deck-global-flags.md release=page.release %}

## See also

{% include /md/deck-reference-links.md file_links='true' %}


