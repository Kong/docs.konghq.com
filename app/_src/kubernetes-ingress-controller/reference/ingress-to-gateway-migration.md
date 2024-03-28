---
title: Migrating Ingress to Gateway
type: reference
purpose: |
  Which ingress annotations are migrated to Gateway API features?
---

As the name states, the {{site.kic_product_name}} is an ingress controller.
Right from the early stage of the Gateway API development, the {{site.kic_product_name}}
supports the Gateway API as well, as an alternative to the ingress resources.
Since the Gateway API graduation, happened in late 2023, the {{site.kic_product_name}}
promoted the Gateway API as the preferred way of configuring the {{site.base_gateway}}
in Kubernetes.

## The IngressToGateway tool

Kong contributed to the kubernetes-sigs project [`ingress2gateway`](https://github.com/kubernetes-sigs/ingress2gateway)
by creating a Kong provider able to convert ingress resources into Gateway resources.
The `ingress2Gateway` tool provides a unique `print` command that gets ingress resources
and displays the Gateway API equivalent. The output of such an operation can be either
directly applied to the cluster, or into a file, to have a new set of yaml files
containing the converted configuration.

## Supported Ingress features and annotations

Here is a list of all the ingress features, along with the Gateway API
equivalent support.

{{ site.kic_product_name }} provides an extensive set of [annotations](/kubernetes-ingress-controller/latest/reference/annotations).
This is the list of the features supported by the Ingress2Gateway's Kong provider.
Such a list is improved over time.

| Annotation name | Conversion |
|-----------------|-------------------------|
| REQUIRED [`kubernetes.io/ingress.class`](#kubernetesioingressclass) | `gateway.spec.gatewayClassName` |
| [`konghq.com/methods`](#konghqcommethods) | `httpRoute.spec.rules[*].matches[*].method` |
| [`konghq.com/headers.*`](#konghqcomheaders) | `httpRoute.spec.rules[*].matches[*].headers` |
| [`konghq.com/plugins`](#konghqcomplugins) | `httpRoute.spec.rules[*].matches[*].headers` |

## Features

### kubernetes.io/ingress.class

> [Annotation description](/kubernetes-ingress-controller/latest/reference/annotations/#kubernetesioingressclass)

If configured on an Ingress resource, this value is used as the `gatewayClassName`
set on the corresponding generated Gateway.

### konghq.com/methods

> [Annotation description](/kubernetes-ingress-controller/latest/reference/annotations/#konghqcommethods)

If configured on an Ingress resource, this value is used to set the `HTTPRoute` method
matching configuration. Since many methods can be set as a comma-separated list,
each method creates a match copy. All the matches belonging to the same
`HTTPRoute` rule are put in OR.

### konghq.com/headers.*

> [Annotation description](/kubernetes-ingress-controller/latest/reference/annotations/#konghqcomheaders)

If configured on an Ingress resource, this value sets the `HTTPRoute` header
matching configuration. Only exact matching is supported. Because many values can
be set for the same header name as a comma-separated list, each header value is used
to create a match copy. All the matches belonging to the same `HTTPRoute` rule
are put in OR.

### konghq.com/plugins

> [Annotation description](/kubernetes-ingress-controller/latest/reference/annotations/#konghqcomplugins)

If configured on an Ingress resource, this value attaches plugins
to routes. Plugin references are converted into `HTTPRoute` `ExtensionRef` filters.
Each plugin is converted into a different reference to a [`KongPlugin`](/kubernetes-ingress-controller/latest/reference/custom-resources/#kongplugin)
or [`KongClusterPlugin`](/kubernetes-ingress-controller/latest/reference/custom-resources/#kongclusterplugin).
