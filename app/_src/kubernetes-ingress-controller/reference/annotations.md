---
title: Annotations
type: reference
purpose: |
  What annotatations are available and what do they do?
---

The {{site.kic_product_name}} supports these annotations on various
resources.

## Ingress resource

Following annotations are supported on Ingress resources:

| Annotation name                                                                      | Description                                                                                                     |
|--------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------|
| REQUIRED [`kubernetes.io/ingress.class`](#kubernetesioingressclass)                  | Restrict the Ingress rules that Kong should satisfy                                                             |
| [`konghq.com/plugins`](#konghqcomplugins)                                            | Run plugins for specific Ingress                                                                                |
| [`konghq.com/protocols`](#konghqcomprotocols)                                        | Set protocols to handle for each Ingress resource                                                               |
| [`konghq.com/preserve-host`](#konghqcompreserve-host)                                | Pass the `host` header as is to the upstream service                                                            |
| [`konghq.com/strip-path`](#konghqcomstrip-path)                                      | Strip the path defined in Ingress resource and then forward the request to the upstream service                 |
| [`ingress.kubernetes.io/force-ssl-redirect`](#ingresskubernetesioforce-ssl-redirect) | Force non-SSL requests to be redirected to SSL.                                                                 |
| [`konghq.com/https-redirect-status-code`](#konghqcomhttps-redirect-status-code)      | Set the HTTPS redirect status code to use when an HTTP request is received                                      |
| [`konghq.com/regex-priority`](#konghqcomregex-priority)                              | Set the route's regex priority                                                                                  |
| [`konghq.com/regex-prefix`](#konghqcomregex-prefix)                                  | Prefix of path to annotate that the path is a regex match, other than default `/~`                              |
| [`konghq.com/methods`](#konghqcommethods)                                            | Set methods matched by this Ingress                                                                             |
| [`konghq.com/snis`](#konghqcomsnis)                                                  | Set SNI criteria for routes created from this Ingress                                                           |
| [`konghq.com/request-buffering`](#konghqcomrequest-buffering)                        | Set request buffering on routes created from this Ingress                                                       |
| [`konghq.com/response-buffering`](#konghqcomresponse-buffering)                      | Set response buffering on routes created from this Ingress                                                      |
| [`konghq.com/host-aliases`](#konghqcomhostaliases)                                   | Additional hosts for routes created from this Ingress's rules                                                   |
| [`konghq.com/override`](#konghqcomoverride)                                          | (Deprecated, replace with per-setting annotations) Control other routing attributes with a KongIngress resource |
| [`konghq.com/path-handling`](#konghqcompathhandling)                                 | Set the path handling algorithm                                                                                 |
| [`konghq.com/headers.*`](#konghqcomheaders)                                          | Set header values required to match rules in this Ingress, default separator for multiple values is `,`         |
{% if_version gte:3.2.x %}
| [`konghq.com/headers-separator`](#konghqcomheaders-separator)                        | Separator for header values, other than default `,`                                                             |
{% endif_version %}
| [`konghq.com/rewrite`](#konghqcomrewrite)                                            | Rewrite the path of a URL |
| [`konghq.com/tags`](#konghqcomtags)                                                  | Assign custom tags to Kong entities generated out of this Ingress |

`kubernetes.io/ingress.class` is required, and its value should match
the value of the `--ingress-class` controller argument (`kong` by default).

## Service resource

These annotations are supported on Service resources.

| Annotation name                                                                  | Description                                                                                                                            |
|----------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------|
| [`konghq.com/plugins`](#konghqcomplugins)                                        | Run plugins for a specific Service                                                                                                     |
| [`konghq.com/protocol`](#konghqcomprotocol)                                      | Set protocol Kong should use to talk to a Kubernetes service                                                                           |
| [`konghq.com/path`](#konghqcompath)                                              | HTTP Path that is always prepended to each request that is forwarded to a Kubernetes service                                           |
| [`konghq.com/client-cert`](#konghqcomclient-cert)                                | Client certificate and key pair Kong should use to authenticate itself to a specific Kubernetes service                                |
| [`konghq.com/host-header`](#konghqcomhost-header)                                | Set the value sent in the `Host` header when proxying requests upstream                                                                |
| [`ingress.kubernetes.io/service-upstream`](#ingresskubernetesioservice-upstream) | Offload load-balancing to kube-proxy or sidecar                                                                                        |
| [`konghq.com/override`](#konghqcomoverride)                                      | (Deprecated for non-upstream fields, replace with per-setting annotations) Control load balancing behavior with a KongIngress resource |
| [`konghq.com/upstream-policy`](#konghqcomupstream-policy)                        | Override Kong Upstream configuration with KongUpstreamPolicy resource                                                                  |
| [`konghq.com/connect-timeout`](#konghqcomconnecttimeout)                         | Set the timeout for completing a TCP connection                                                                                        |
| [`konghq.com/read-timeout`](#konghqcomreadtimeout)                               | Set the timeout for receiving an HTTP response after sending a request                                                                 |
| [`konghq.com/write-timeout`](#konghqcomwritetimeout)                             | Set the timeout for writing data                                                                                                       |
| [`konghq.com/retries`](#konghqcomretries)                                        | Set the number of times to retry requests that failed                                                                                  |
| [`konghq.com/tags`](#konghqcomtags)                                              | Assign custom tags to Kong entities generated out of this Service                                                                      |
{% if_version gte:3.4.x %}
| [`konghq.com/tls-verify`](#konghqcomtls-verify)                                   | Enable or disable verification of the upstream service's TLS certificates                                                              |
| [`konghq.com/tls-verify-depth`](#konghqcomtls-verify-depth)                        | Set the maximal depth of a certificate chain when verifying the upstream service's TLS certificates                                    |
| [`konghq.com/ca-certificates`](#konghqcomca-certificates)                         | Assign CA certificates to be used for the upstream service's TLS certificates verification                                             |
{% endif_version %}

## KongConsumer resource

These annotations are supported on KongConsumer resources.

| Annotation name                                                     | Description                                                            |
|---------------------------------------------------------------------|------------------------------------------------------------------------|
| REQUIRED [`kubernetes.io/ingress.class`](#kubernetesioingressclass) | Restrict the KongConsumers that a controller should satisfy            |
| [`konghq.com/plugins`](#konghqcomplugins)                           | Run plugins for a specific consumer                                    |
| [`konghq.com/tags`](#konghqcomtags)                                 | Assign custom tags to Kong entities generated out of this KongConsumer |

`kubernetes.io/ingress.class` is normally required, and its value should match
the value of the `--ingress-class` controller argument (`kong` by default).

Setting the `--process-classless-kong-consumer` controller flag removes that requirement.
when it is enabled, the controller processes KongConsumers with no
`kubernetes.io/ingress.class` annotation. Recommended best practice is to set
the annotation and leave this flag disabled; the flag is primarily intended for
older configurations, as controller versions prior to 0.10 processed classless
KongConsumer resources by default.

## Annotations

### kubernetes.io/ingress.class

{:.note}
> Kubernetes versions after 1.18 introduced the new `ingressClassName`
field to the Ingress spec and
[deprecated the `kubernetes.io/ingress.class` annotation](https://kubernetes.io/docs/concepts/services-networking/ingress/#deprecated-annotation).
Ingress resources should now use the `ingressClassName` field.
Kong resources (KongConsumer, TCPIngress, etc.)
still use the `kubernetes.io/ingress.class` annotation.

If you have multiple Ingress controllers in a single cluster,
you can pick one by specifying the `ingress.class` annotation.
Here is an example to create an Ingress with an annotation:

```yaml
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  name: test-1
  annotations:
    kubernetes.io/ingress.class: "gce"
spec:
  rules:
  - host: example.com
    http:
      paths:
      - path: /test1
        backend:
          serviceName: echo
          servicePort: 80
```

This targets the GCE controller, forcing the {{site.kic_product_name}} to ignore it.

On the other hand, an annotation such as this, targets the {{site.kic_product_name}}, forcing the GCE controller to ignore it.

```yaml
metadata:
  name: test-1
  annotations:
    kubernetes.io/ingress.class: "kong"
```

With the `ingressClassName` field instead of the annotation:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: test-1
spec:
  ingressClassName: kong
  rules:
  - host: example.com
    http:
      paths:
      - path: /test1
        backend:
          serviceName: echo
          servicePort: 80
```

The following resources _require_ this annotation by default:

- Ingress
- KongConsumer
- TCPIngress
- UDPIngress
- KongClusterPlugin
- Secret resources with the `ca-cert` label

The ingress class used by the {{site.kic_product_name}} to filter Ingress
resources can be changed using the `CONTROLLER_INGRESS_CLASS`
environment variable.

```yaml
spec:
  template:
     spec:
       containers:
         - name: kong-ingress-internal-controller
           env:
           - name: CONTROLLER_INGRESS_CLASS
             value: kong-internal
```

#### Multiple unrelated {{site.kic_product_name}}s {#multiple-unrelated-controllers}

In some deployments, you might use multiple {{site.kic_product_name}}s
in the same Kubernetes cluster. For example, one which serves public traffic, and one which serves "internal" traffic.
For such deployments, ensure that in addition to different
`ingress-class`, the `--election-id` is also different.

In such deployments, `kubernetes.io/ingress.class` annotation can be used on the
following custom resources as well:

- KongPlugin: To configure (global) plugins only in one of the Kong clusters.
- KongConsumer: To create different consumers in different Kong clusters.

### konghq.com/plugins

> Available since controller 0.8

Kong's power comes from its plugin architecture, where plugins can modify
the request and response or impose certain policies on the requests as they
are proxied to your service.

With the {{site.kic_product_name}}, plugins can be configured by creating
KongPlugin Custom Resources and then associating them with an Ingress, Service,
HTTPRoute, KongConsumer, KongConsumerGroup or a combination of those.

This is an example of how to use the annotation:

```yaml
konghq.com/plugins: high-rate-limit, docs-site-cors
```

Here, `high-rate-limit` and `docs-site-cors`
are the names of the KongPlugin resources which
should be to be applied to the Ingress rules defined in the
Ingress resource on which the annotation is being applied.

This annotation can also be applied to a Service resource in Kubernetes, which
will result in the plugin being executed at Service-level in Kong,
meaning the plugin will be
executed for every request that is proxied, no matter which Route it came from.

This annotation can also be applied to a KongConsumer resource,
which results in plugin being executed whenever the specific consumer
is accessing any of the defined APIs.

Finally, this annotation can also be applied on a combination of the
following resources:
- **Ingress and KongConsumer**
  If an Ingress resource and a KongConsumer resource share a plugin in the
  `konghq.com/plugins` annotation then the plugin will be created for the
  combination of those to resources in Kong.
- **Service and KongConsumer**
  Same as the above case, if you would like to give a specific consumer or
  client of your service some special treatment, you can do so by applying
  the same annotation to both of the resources.

### konghq.com/path

> Available since controller 0.8

This annotation can be used on a Service resource only.
This annotation can be used to prepend an HTTP path of a request,
before the request is forwarded.

For example, if the annotation `konghq.com/path: "/baz"` is applied to a
Kubernetes Service `billings`, then any request that is routed to the
`billings` service will be prepended with `/baz` HTTP path. If the
request contains `/foo/something` as the path, then the service will
receive an HTTP request with path set as `/baz/foo/something`.

### konghq.com/strip-path

> Available since controller 0.8

This annotation can be applied to an Ingress resource and can take two values:
- `"true"`: If set to true, the part of the path specified in the Ingress rule
  will be stripped out before the request is sent to the service.
  For example, if the Ingress rule has a path of `/foo` and the HTTP request
  that matches the Ingress rule has the path `/foo/bar/something`, then
  the request sent to the Kubernetes service will have the path
  `/bar/something`.
- `"false"`: If set to false, no path manipulation is performed.

All other values are ignored.
Please note the quotes (`"`) around the boolean value.

Sample usage:

```yaml
konghq.com/strip-path: "true"
```

### konghq.com/preserve-host

> Available since controller 0.8

This annotation can be applied to an Ingress resource and can take two values:
- `"true"`: If set to true, the `host` header of the request will be sent
  as is to the Service in Kubernetes.
- `"false"`: If set to false, the `host` header of the request is not preserved.

> **Note**: The quotes (`"`) around the boolean value is required.

Sample usage:

```yaml
konghq.com/preserve-host: "true"
```

### ingress.kubernetes.io/force-ssl-redirect

> Available since controller 0.10

This annotation is used to enforce requests to be redirected to SSL protocol
(HTTPS or GRPCS). The default status code for requests that need to be 
redirected is 302. This code can be configured by annotation `konghq.com/https-redirect-status-code`[#konghqcomhttps-redirect-status-code].


### konghq.com/https-redirect-status-code

> Available since controller 0.8

By default, Kong sends HTTP Status Code 426 for requests
that need to be redirected to HTTPS.
This can be changed using this annotations.
Acceptable values are:
- 301
- 302
- 307
- 308
- 426

Any other value will be ignored.

Sample usage:

```yaml
konghq.com/https-redirect-status-code: "301"
```

Please note the quotes (`"`) around the integer value.

### konghq.com/regex-priority

> Available since controller 0.9

Sets the `regex_priority` setting to this value on the Kong route associated
with the Ingress resource. This controls the [matching evaluation
order](/gateway/latest/reference/proxy/#evaluation-order) for regex-based
routes. It accepts any integer value. Routes are evaluated in order of highest
priority to lowest.

Sample usage:

```yaml
konghq.com/regex-priority: "10"
```

>**Note**: the quotes (`"`) around the integer value is required.

### konghq.com/methods

> Available since controller 0.9

Sets the `methods` setting on the Kong route associated with the Ingress
resource. This controls which request methods will match the route. Any
uppercase alpha ASCII string is accepted, though most users will use only
[standard methods](https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods).

Sample usage:

```yaml
konghq.com/methods: "GET,POST"
```

### konghq.com/snis

> Available since controller 1.1

Sets the `snis` match criteria on the Kong route associated with this Ingress.
When using route-attached plugins that execute during the certificate
phase (for example, [Mutual TLS Authentication](/hub/kong-inc/mtls-auth/)),
the `snis` annotation allows route matching based on the server name
indication information sent in a client's TLS handshake.

Sample usage:

```yaml
konghq.com/snis: "foo.example.com, bar.example.com"
```

### konghq.com/request-buffering

> Available since controller 1.2

Enables or disables request buffering on the Kong route associated with this
Ingress.

Sample usage:

```yaml
konghq.com/request-buffering: "false"
```

### konghq.com/response-buffering

> Available since controller 1.2

Enables or disables response buffering on the Kong route associated with this
Ingress.

Sample usage:

```yaml
konghq.com/response-buffering: "false"
```

### konghq.com/host-aliases

> Available since controller 1.3

Set additional hosts for routes created from rules on this Ingress.

Sample usage:

```yaml
konghq.com/host-aliases: "example.com,example.net"
```

This annotation applies to all rules equally. An Ingress like this:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: example-ingress
  annotations:
    konghq.com/host-aliases: "example.com,example.net"
spec:
  rules:
  - host: "foo.example"
    http:
      paths:
      - pathType: Prefix
        path: "/bar"
        backend:
          service:
            name: service1
            port:
              number: 80
  - host: "bar.example"
    http:
      paths:
      - pathType: Prefix
        path: "/bar"
        backend:
          service:
            name: service2
            port:
              number: 80
```

Results in two routes:

```
{"hosts":["foo.example", "example.com", "example.net"], "paths":["/foo"]}
{"hosts":["bar.example", "example.com", "example.net"], "paths":["/bar"]}
```

{:.important}
> To avoid creating overlapping routes, don't reuse the same path in multiple rules.

### konghq.com/protocol

> Available since controller 0.8

This annotation can be set on a Kubernetes Service resource and indicates
the protocol that should be used by Kong to communicate with the service.
In other words, the protocol is used for communication between a
[Kong Service](/gateway/api/admin-ee/latest/#/Services/list-service/) and
a Kubernetes Service, internally in the Kubernetes cluster.

Accepted values are:
- `http`
- `https`
- `grpc`
- `grpcs`
- `tcp`
- `tls`

### konghq.com/protocols

> Available since controller 0.8

This annotation sets the list of acceptable protocols for the all the rules
defined in the Ingress resource.
The protocols are used for communication between the
Kong and the external client/user of the Service.

You usually want to set this annotation for the following two use-cases:
- You want to redirect HTTP traffic to HTTPS, in which case you will use
  `konghq.com/protocols: "https"`
- You want to define gRPC routing, in which case you should use
  `konghq.com/protocols: "grpc,grpcs"`

### konghq.com/client-cert

> Available since controller 0.8

This annotation sets the certificate and key-pair Kong should use to
authenticate itself against the upstream service, if the upstream service
is performing mutual-TLS (mTLS) authentication.

The value of this annotation should be the name of the Kubernetes TLS Secret
resource which contains the TLS cert and key pair.

Under the hood, the controller creates a Certificate in Kong and then
sets the
[`service.client_certificate`](/gateway/api/admin-ee/latest/#/Services/list-service/)
for the service.

### konghq.com/host-header

> Available since controller 0.9

Sets the `host_header` setting on the Kong upstream created to represent a
Kubernetes Service. By default, Kong upstreams set `Host` to the hostname or IP
address of an individual target (the Pod IP for controller-managed
configuration). This annotation overrides the default behavior and sends
the annotation value as the `Host` header value.

If `konghq.com/preserve-host: true` is present on an Ingress (or
`route.preserve_host: true` is present in a linked KongIngress), it will take
precedence over this annotation, and requests to the application will use the
hostname in the Ingress rule.

Sample usage:

```yaml
konghq.com/host-header: "test.example.com"
```

### ingress.kubernetes.io/service-upstream

> Available since controller 0.6

By default, the {{site.kic_product_name}} distributes traffic amongst all the
Pods of a Kubernetes Service by forwarding the requests directly to
Pod IP addresses. One can choose the load-balancing strategy to use
by specifying a KongIngress resource.

However, in some use-cases, the load-balancing should be left up
to `kube-proxy`, or a sidecar component in the case of Service Mesh deployments.

Setting this annotation to a Service resource in Kubernetes will configure
the {{site.kic_product_name}} to directly forward
the traffic outbound for this Service
to the IP address of the service (usually the ClusterIP).

`kube-proxy` can then decide how it wants to handle the request and route the
traffic accordingly. If a sidecar intercepts the traffic from the controller,
it can also route traffic as it sees fit in this case.

Following is an example snippet you can use to configure this annotation
on a Service resource in Kubernetes, (please note the quotes around `true`):

```yaml
annotations:
  ingress.kubernetes.io/service-upstream: "true"
```

### konghq.com/regex-prefix

> Available since controller 2.7

Sets the prefix of regex matched path to be some string other than `/~`. In
Kong 3.0 and later, paths with regex match must start with `~`, so in
ingresses, `/~` prefix used by default to annotate that the path is using
regex match. If the annotation is set, paths with the specified prefix is
considered as paths with regex match and will be translated to `~` started
path in Kong. For example, if an ingress has annotation
`konghq.com/regex-prefix: "/@"`, paths started with `/@` are considered as
paths using regex match. See: [upgrade-to-kong-3x](/kubernetes-ingress-controller/2.12.x/guides/upgrade-kong-3x/)

### konghq.com/path-handling

> Available since controller 2.8

Sets the [path handling algorithm](/gateway/latest/admin-api/#path-handling-algorithms),
which controls how {{site.base_gateway}} combines the service and route `path`
fields (the Service's [path annotation](#konghqcompath) value and Ingress
rule's `path` field) are combined into the path sent upstream.

### konghq.com/headers.*

> Available since controller 2.8

Sets header values that are required for requests to match rules in an Ingress.

Unlike most annotations, `konghq.com/headers.*` includes part of the
configuration in the annotation name. The string after the `.` in the
annotation name is the header, and the value is a CSV of allowed header values.

For example, setting `konghq.com/headers.x-routing: alpha,bravo` will only
match requests that include an `x-routing` header whose value is either `alpha`
or `bravo`.

{% if_version gte:3.2.x %}
### konghq.com/headers-separator

> Available since controller 3.2

Sets the separator for the `konghq.com/headers.*` annotation to be something
other than default `,`. This is useful when the header values themselves contain
commas. For example, setting `konghq.com/headers-separator: ";"` will allow
header values to be separated by `;` instead of `,`.
{% endif_version %}

### konghq.com/connect-timeout

> Available since controller 2.8

Sets the connect timeout, in milliseconds. For example, setting this annotation
to `60000` will instruct the proxy to wait up to 60 seconds to complete the
initial TCP connection to the upstream service.

### konghq.com/read-timeout

> Available since controller 2.8

Sets the read timeout, in milliseconds. For example, setting this annotation
to `60000` will instruct the proxy to wait up to 60 seconds after sending a
request before timing out and returning a 504 response to the client.

### konghq.com/write-timeout

> Available since controller 2.8

Sets the write timeout, in milliseconds. For example, setting this annotation
to `60000` will instruct the proxy to wait up to 60 seconds without writing
data before closing a kept-alive connection.

### konghq.com/retries

> Available since controller 2.8

Sets the max retries on a request. For example, setting this annotation to `3`
will re-send the request up to three times if it encounters a failure, such as
a timeout.

### konghq.com/tags

> Available since controller 2.9

This annotation can be used to assign custom tags to Kong entities generated out of a
resource the annotation is applied to. The value of the annotation is a comma-separated
list of tags. For example, setting this annotation to `tag1,tag2` will assign the tags
`tag1` and `tag2` to the Kong entity.

### konghq.com/rewrite

> Available since controller 2.12

Rewrite a URL path. This annotation is a shorthand method of applying a
[request-transformer plugin](/hub/kong-inc/request-transformer/)
with [a `replace.uri` action](/hub/kong-inc/request-transformer/configuration/#config-replace).
It cannot be combined with a `konghq.com/plugins` annotation that applies a
request-transformer plugin as such.

The annotation can rebuild URLs using segments captured from a regular
expression path. A `$n` in the annotation path represents the nth capture group
in the Ingress rule path, starting from 1. For example, combining an Ingress
rule with path `/~/v(.*)/(.*)` and a `konghq.com/rewrite:
/api/$1/foo/svc_$2` would send an upstream request to `/api/2/foo/svc_pricing` upstream
when an inbound request is made to `/v2/pricing` (the `/~` prefix instructs Kong to treat
the path as a regular expression, and isn't used in the actual request).

Annotations apply at the Ingress level and not modify individual rules. As
such, this annotation should only be used on Ingresses with a single rule, or
on Ingresses whose rules paths _all_ match the rewrite pattern.

Note that this annotation overrides `strip_path` and Service `path`
annotations. The value of the `konghq.com/rewrite` annotation will be the
_entire_ path sent upstream. You must include path segments you would normally
place in a Service `konghq.com/path` annotation at the start of your
`konghq.com/rewrite` annotation.

### konghq.com/upstream-policy

> Available since controller 3.0

This annotation can be used to attach `KongUpstreamPolicy` resources to `Services`. 
The value of the annotation is the name of the `KongUpstreamPolicy` object in the 
same namespace as the `Service`. Please refer to the 
[KongUpstreamPolicy reference](/kubernetes-ingress-controller/{{page.release}}/reference/custom-resources/#kongupstreampolicy) 
for details on how to configure the `KongUpstreamPolicy` resource. 

{% if_version gte:3.4.x %}

### konghq.com/tls-verify

> Available since controller 3.4

This annotation can be used to enable or disable verification of the upstream service's TLS certificates.
The value of the annotation should be either `true` or `false`. By default, the verification is disabled.

See [TLS verification of Upstream Service](/kubernetes-ingress-controller/{{page.release}}/guides/security/verify-upstream-tls)
guide for more information.

### konghq.com/tls-verify-depth

> Available since controller 3.4

This annotation can be used to set the maximal depth of a certificate chain when verifying the upstream service's TLS
certificates.
The value of the annotation should be an integer. If not set, a system default value is used.

See [TLS verification of Upstream Service](/kubernetes-ingress-controller/{{page.release}}/guides/security/verify-upstream-tls)
guide for more information.

### konghq.com/ca-certificates-secret

> Available since controller 3.4

This annotation can be used to assign CA certificates to be used for the upstream service's TLS certificates verification.
The value of the annotation should be a comma-separated list of `Secret`s containing CA certificates.

### konghq.com/ca-certificates-configmap

> Available since controller 3.4

This annotation can be used to assign CA certificates to be used for the upstream service's TLS certificates verification.
The value of the annotation should be a comma-separated list of `ConfigMap`s containing CA certificates.

{% include /md/kic/ca-certificates-note.md %}

See [TLS verification of Upstream Service](/kubernetes-ingress-controller/{{page.release}}/guides/security/verify-upstream-tls)
guide for more information.

{% endif_version %}
