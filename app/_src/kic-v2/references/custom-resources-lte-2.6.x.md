---
title: Custom Resource Definitions
---

The Ingress Controller can configure Kong specific features
using several [Custom Resource Definitions(CRDs)][k8s-crd].

Following CRDs enables users to declaratively configure all aspects of Kong:

- [**KongPlugin**](#kongplugin): This resource corresponds to
  the [Plugin][kong-plugin] entity in Kong.
- [**KongIngress**](#kongingress): This resource provides fine-grained control
  over all aspects of proxy behaviour like routing, load-balancing,
  and health checking. It serves as an "extension" to the Ingress resources
  in Kubernetes.
- [**KongConsumer**](#kongconsumer):
  This resource maps to the [Consumer][kong-consumer] entity in Kong.
- [**TCPIngress**](#tcpingress):
  This resource can configure TCP-based routing in Kong for non-HTTP
  services running inside Kubernetes.
- [**UDPIngress**](#udpingress):
  This resource can configure UDP-based routing in Kong.
- [**KongCredential (Deprecated)**](#kongcredential-deprecated):
  This resource maps to
  a credential (key-auth, basic-auth, jwt, hmac-auth) that is associated with
  a specific KongConsumer.

## KongPlugin

This resource provides an API to configure plugins inside Kong using
Kubernetes-style resources.

Please see the [concept](/kubernetes-ingress-controller/{{page.release}}/concepts/custom-resources/#KongPlugin)
document for how the resource should be used.

The following snippet shows the properties available in KongPlugin resource:

```yaml
apiVersion: configuration.konghq.com/v1
kind: KongPlugin
metadata:
  name: <object name>
  namespace: <object namespace>
disabled: <boolean>  # optionally disable the plugin in Kong
config:              # configuration for the plugin
  key: value
configFrom:
  secretKeyRef:
     name: <Secret name>
     key: <Secret key>
plugin: <name-of-plugin> # like key-auth, rate-limiting etc
{% if_version gte:2.6.x -%}
ordering:
  before:
    <phase>:
    - <plugin>
    - <plugin>
  after:
    <phase>:
    - <plugin>
    - <plugin>
{% endif_version %}
```

- `config` contains a list of `key` and `value`
  required to configure the plugin.
  All configuration values specific to the type of plugin go in here.
  Please read the documentation of the plugin being configured to set values
  in here. For any plugin in Kong, anything that goes in the `config` JSON
  key in the Admin API request, goes into the  `config` YAML key in this resource.
  Please use a valid JSON to YAML convertor and place the content under the
  `config` key in the YAML above.
- `configFrom` contains a reference to a Secret and key, where the key contains
  a complete JSON or YAML configuration. This should be used when the plugin
  configuration contains sensitive information, such as AWS credentials in the
  Lambda plugin or the client secret in the OIDC plugin. Only one of `config`
  or `configFrom` may be used in a KongPlugin, not both at once.
- `plugin` field determines the name of the plugin in Kong.
  This field was introduced in {{site.kic_product_name}} 0.2.0.
{% if_version gte:2.6.x -%}
- `ordering` is only available on {{site.ee_product_name}}. `<phase>` is a
  request processing phase (for example, `access` or `body_filter`) and
  `<plugin>` is the name of the plugin that will run before or after the
  KongPlugin. For example, a KongPlugin with `plugin: rate-limiting` and
  `before.access: ["key-auth"]` will create a rate limiting plugin that limits
  requests _before_ they are authenticated.
{% endif_version %}

**Please note:** validation of the configuration fields is left to the user
by default. It is advised to setup and use the admission validating controller
to catch user errors.

The plugins can be associated with Ingress
or Service object in Kubernetes using `konghq.com/plugins` annotation.

### Examples

#### Applying a plugin to a service

Given the following plugin:

```yaml
apiVersion: configuration.konghq.com/v1
kind: KongPlugin
metadata:
  name: request-id
config:
  header_name: my-request-id
  echo_downstream: true
plugin: correlation-id
```

It can be applied to a service by annotating like:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: myapp-service
  labels:
     app: myapp-service
  annotations:
     konghq.com/plugins: request-id
spec:
  ports:
  - port: 80
    targetPort: 80
    protocol: TCP
    name: myapp-service
  selector:
    app: myapp-service
```

#### Applying a plugin to an ingress

The KongPlugin above can be applied to a specific ingress (route or routes):

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: demo-example-com
  annotations:
    konghq.com/plugins: request-id
spec:
  ingressClassName: kong
  rules:
  - host: example.com
    http:
      paths:
      - path: /bar
        pathType: ImplementationSpecific
        backend:
          service:
            name: echo
            port:
              number: 80
```

A plugin can also be applied to a specific KongConsumer by adding
`konghq.com/plugins` annotation to the KongConsumer resource.

Please follow the
[Using the KongPlugin resource](/kubernetes-ingress-controller/{{page.release}}/guides/using-kongplugin-resource)
guide for details on how to use this resource.

#### Applying a plugin with a secret configuration

The plugin above can be modified to store its configuration in a secret:

```yaml
apiVersion: configuration.konghq.com/v1
kind: KongPlugin
metadata:
  name: request-id
configFrom:
  secretKeyRef:
    name: plugin-conf-secret
    key: request-id
plugin: correlation-id
```

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: plugin-conf-secret
stringData:
  request-id: |
    header_name: my-request-id
    echo_downstream: true
type: Opaque
```

## KongClusterPlugin

A `KongClusterPlugin` is same as `KongPlugin` resource. The only differences
are that it is a Kubernetes cluster-level resource instead of a namespaced
resource, and can be applied as a global plugin using labels.

Please consult the [KongPlugin](#kongplugin) section for details.

*Example:*

KongClusterPlugin example:

```yaml
apiVersion: configuration.konghq.com/v1
kind: KongClusterPlugin
metadata:
  name: request-id
  annotations:
    kubernetes.io/ingress.class: <controller ingress class, "kong" by default>
  labels:
    global: "true"   # optional, if set, then the plugin will be executed
                     # for every request that Kong proxies
                     # please note the quotes around true
config:
  header_name: my-request-id
configFrom:
    secretKeyRef:
       name: <Secret name>
       key: <Secret key>
       namespace: <Secret namespace>
plugin: correlation-id
{% if_version gte:2.6.x -%}
ordering:
  before:
    <phase>:
    - <plugin>
    - <plugin>
  after:
    <phase>:
    - <plugin>
    - <plugin>
{% endif_version %}
```

As with KongPlugin, only one of `config` or `configFrom` can be used.

Setting the label `global` to `"true"` will apply the plugin globally in Kong,
meaning it will be executed for every request that is proxied via Kong.

## KongIngress

{:.note}
> **Note:** Many fields available on KongIngress are also available as
> [annotations](/kubernetes-ingress-controller/{{page.release}}/references/annotations/).
> You can add these annotations directly to Service and Ingress resources
> without creating a separate KongIngress resource. When an annotation is
> available, it is the preferred means of configuring that setting, and the
> annotation value will take precedence over a KongIngress value if both set
> the same setting.

Ingress resource spec in Kubernetes can define routing policies
based on HTTP Host header and paths.
While this is sufficient in most cases,
sometimes, users may want more control over routing at the Ingress level.
`KongIngress` serves as an "extension" to Ingress resource.
It is not meant as a replacement to the
`Ingress` resource in Kubernetes.

Please read the [concept](/kubernetes-ingress-controller/{{page.release}}/concepts/custom-resources/#kongingress)
document for why this resource exists and how it relates to the existing
Ingress resource.

Using `KongIngress`, all properties of [Upstream][kong-upstream],
[Service][kong-service], and
[Route][kong-route] entities in Kong related to an Ingress resource
can be modified.

Once a `KongIngress` resource is created, it needs to be associated with
an Ingress or Service resource using the following annotation:

```yaml
konghq.com/override: kong-ingress-resource-name
```

Specifically,

- To override any properties related to health-checking, load-balancing,
  or details specific to a service, add the annotation to the Kubernetes
  Service that is being exposed via the Ingress API.
- To override routing configuration (like protocol or method based routing),
  add the annotation to the Ingress resource.

Please follow the
[Using the KongIngress resource](/kubernetes-ingress-controller/{{page.release}}/guides/using-kongingress-resource)
guide for details on how to use this resource.

For reference, the following is a complete spec for KongIngress (for property documentation, see [Upstream](/gateway/api/admin-ee/latest/#/operations/list-upstream/), [Service](/gateway/api/admin-ee/latest/#/operations/list-service/) and [Route](/gateway/api/admin-ee/latest/#/operations/list-route) entities.

```yaml
apiVersion: configuration.konghq.com/v1
kind: KongIngress
metadata:
  name: configuration-demo
upstream:
  slots: 10000
  hash_on: none
  hash_fallback: none
  healthchecks:
    threshold: 25
    active:
      concurrency: 10
      healthy:
        http_statuses:
        - 200
        - 302
        interval: 0
        successes: 0
      http_path: "/"
      timeout: 1
      unhealthy:
        http_failures: 0
        http_statuses:
        - 429
        interval: 0
        tcp_failures: 0
        timeouts: 0
    passive:
      healthy:
        http_statuses:
        - 200
        successes: 0
      unhealthy:
        http_failures: 0
        http_statuses:
        - 429
        - 503
        tcp_failures: 0
        timeouts: 0
proxy:
  protocol: http
  path: /
  connect_timeout: 10000
  retries: 10
  read_timeout: 10000
  write_timeout: 10000
route:
  methods:
  - POST
  - GET
  regex_priority: 0
  strip_path: false
  preserve_host: true
  protocols:
  - http
  - https
```

## TCPIngress

The Ingress resource in Kubernetes is HTTP-only.
This custom resource is modeled similar to the Ingress resource but for
TCP and TLS SNI based routing purposes:

```yaml
apiVersion: configuration.konghq.com/v1beta1
kind: TCPIngress
metadata:
  name: <object name>
  namespace: <object namespace>
  annotations:
    kubernetes.io/ingress.class: <controller ingress class, "kong" by default>
spec:
  rules:
  - host: <SNI, optional>
    port: <port on which to expose this service, required>
    backend:
      serviceName: <name of the kubernetes service, required>
      servicePort: <port number to forward on the service, required>
```

If `host` is not specified, then port-based TCP routing is performed. Kong
doesn't care about the content of TCP stream in this case.

If `host` is specified, then Kong expects the TCP stream to be TLS-encrypted
and Kong will terminate the TLS session based on the SNI.
Also note that, the port in this case should be configured with `ssl` parameter
in Kong.

## UDPIngress

The `UDPIngress` API makes it possible to route traffic to your [UDP][udp] services
using Kong (e.g. DNS, Game Servers, e.t.c.).

```yaml
apiVersion: configuration.konghq.com/v1beta1
kind: UDPIngress
metadata:
  name: <object name>
  namespace: <object namespace>
  annotations:
    kubernetes.io/ingress.class: <controller ingress class, "kong" by default>
spec:
  rules:
  - port: <port on which to expose this service, required>
    backend:
      serviceName: <name of the kubernetes service, required>
      servicePort: <port number to forward on the service, required>
```

For each rule provided in the spec the Kong proxy environment must be updated to
listen to UDP on that port as well.

[udp]:https://datatracker.ietf.org/doc/html/rfc768

## KongConsumer

This custom resource configures a consumer in Kong:

The following snippet shows the field available in the resource:

```yaml
apiVersion: configuration.konghq.com/v1
kind: KongConsumer
metadata:
  name: <object name>
  namespace: <object namespace>
  annotations:
    kubernetes.io/ingress.class: <controller ingress class, "kong" by default>
username: <user name>
custom_id: <custom ID>
```

An example:

```yaml
apiVersion: configuration.konghq.com/v1
kind: KongConsumer
metadata:
  name: consumer-team-x
  annotations:
    kubernetes.io/ingress.class: kong
username: team-X
credentials:
  - secretRef1
  - secretRef2
```

When this resource is created, a corresponding consumer entity will be
created in Kong.

Consumers' `username` and `custom_id` values must be unique across the Kong
cluster. While KongConsumers exist in a specific Kubernetes namespace,
KongConsumers from all namespaces are combined into a single Kong
configuration, and no KongConsumers with the same `kubernetes.io/ingress.class`
may share the same `username` or `custom_id` value.

For help configuring credentials for the `KongConsumer` Please refer to the [using the Kong Consumer and Credential resource](/kubernetes-ingress-controller/{{page.release}}/guides/using-consumer-credential-resource/) guide.

[k8s-crd]: https://kubernetes.io/docs/tasks/access-kubernetes-api/extend-api-custom-resource-definitions/
[kong-consumer]: /gateway/api/admin-ee/latest/#/operations/list-consumer
[kong-plugin]: /gateway/api/admin-ee/latest/#/operations/list-service
[kong-upstream]: /gateway/api/admin-ee/latest/#/operations/list-service
[kong-service]: /gateway/api/admin-ee/latest/#/operations/list-service
[kong-route]: /gateway/api/admin-ee/latest/#/operations/list-service
