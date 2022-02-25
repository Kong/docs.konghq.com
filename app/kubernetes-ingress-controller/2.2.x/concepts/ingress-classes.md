---
title: Kubernetes Ingress Controller and Ingress Class
---

## Introduction

The {{site.kic_product_name}} uses ingress classes to filter Kubernetes Ingress
objects and other resources before converting them into Kong configuration.
This allows it to coexist with other ingress controllers and/or other
deployments of the {{site.kic_product_name}} in the same cluster: a
{{site.kic_product_name}} will only process configuration marked for its use.

## Configuring the controller ingress class

The `--ingress-class` flag (or `CONTROLLER_INGRESS_CLASS` environment variable)
specifies the ingress class expected by the {{site.kic_product_name}}. By default,
it expects the `kong` class.

## Loading resources by class

The {{site.kic_product_name}} translates a variety of Kubernetes resources into
Kong configuration. Broadly speaking, we can separate these resources into two
categories:

- Resources that the controller translates directly into Kong configuration.
- Resources referenced by some other resource, where the other resource is
  directly translated into Kong configuration.

For example, an Ingress is translated directly into a Kong route, and a
KongConsumer is translated directly into a
[Kong consumer](/gateway/latest/admin-api/#consumer-object). A Secret containing
an authentication plugin credential is _not_ translated directly: it is only
translated into Kong configuration if a KongConsumer resource references it.

Because they create Kong configuration independent of any other resources,
directly-translated resources require an ingress class, and their class must
match the class configured for the controller. Referenced resources do not
require a class, but must be referenced by a directly translated resource
that matches the controller.

### Adding class information to resources

Most resources use a [kubernetes.io/ingress-class annotation][class-annotation]
to indicate their class. There are several exceptions:

- v1 Ingress resources have a [dedicated `ingressClassName` field][ingress-class-name].
- Knative Services [use the class specifed][knative-class] by the
  `ingress.class` key of the Knative installation's `config-network` ConfigMap.
  You can optionally [override this on a per-Service basis][knative-override]
  by adding a `networking.knative.dev/ingress.class` annotation to the Service.

## When to use a custom class

Using the default `kong` class is fine for simpler deployments, where only one
{{site.kic_product_name}} instance is running in a cluster. Changing the class is
typical when:

- You install multiple Kong environments in one Kubernetes cluster to handle
  different types of ingress traffic, e.g. when using separate Kong instances
  to handle traffic on internal and external load balancers, or deploying
  different types of non-production environments in a single test cluster.
- You install multiple controller instances alongside a single Kong cluster to
  separate configuration into different Kong workspaces (using the
  `--kong-workspace` flag) or to restrict which Kubernetes namespaces any one
  controller instance has access to.

## Examples

Typical configurations will include a mix of resources that have class
information and resources that are referenced by them. For example, consider
the following configuration for authenticating a request, using a KongConsumer,
credential Secret, Ingress, and KongPlugin (a Service is implied, but not
shown):

```yaml
apiVersion: configuration.konghq.com/v1
kind: KongConsumer
metadata:
  name: dyadya-styopa
  annotations:
    kubernetes.io/ingress.class: "kong"
username: styopa
credentials:
- styopa-key

---

kind: Secret
apiVersion: v1
stringData:
  key: bylkogdatomoryakom
  kongCredType: key-auth
metadata:
  name: styopa-key

---

kind: Ingress
apiVersion: networking.k8s.io/v1
metadata:
  name: ktonezhnaet
  annotations:
    konghq.com/plugins: "key-auth-example"
spec:
  ingressClassName: kong
  rules:
  - http:
      paths:
      - path: /vsemznakom
        pathType: ImplementationSpecific
        backend:
          service:
            name: httpbin
            port:
              number: 80

---

apiVersion: configuration.konghq.com/v1
kind: KongPlugin
metadata:
  name: key-auth-example
plugin: key-auth
```

The KongConsumer and Ingress resources both have class annotations, as they are
resources that the controller uses as a basis for building Kong configuration.
The Secret and KongPlugin _do not_ have class annotations, as they are
referenced by other resources that do.

[class-annotation]:/kubernetes-ingress-controller/{{page.kong_version}}/references/annotations/#kubernetesioingressclass
[knative-class]:/kubernetes-ingress-controller/{{page.kong_version}}/guides/using-kong-with-knative/#ingress-class
[knative-override]:https://knative.tips/networking/ingress-override/
[ingress-class-name]:https://kubernetes.io/docs/concepts/services-networking/ingress/#deprecated-annotation
