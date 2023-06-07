---
title: Kong Ingress Controller and Ingress Class
---

## Introduction

The {{site.kic_product_name}} uses ingress classes to filter Kubernetes Ingress
objects and other resources before converting them into Kong configuration.
This allows it to coexist with other ingress controllers and/or other
deployments of the {{site.kic_product_name}} in the same cluster: a
{{site.kic_product_name}} will only process configuration marked for its use.

## Configuring the controller ingress class

The `--ingress-class` flag (or `CONTROLLER_INGRESS_CLASS` environment variable)
specify the ingress class expected by the {{site.kic_product_name}}. By default,
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

Because they create Kong configuration indenpendent of any other resources,
directly-translated resources require an ingress class, and their class must
match the class configured for the controller. Referenced resources do not
require a class, but must be referenced by a directly-translated resource
that matches the controller.

### Adding class information to resources

Most resources use a [kubernetes.io/ingress-class annotation][class-annotation]
to indicate their class. There are several exceptions:

- v1 Ingress resources have a dedicated `class` field.
- Knative Services [use the class specifed][knative-class] by the
  `ingress.class` key of the Knative installation's `config-network` ConfigMap.
  You can optionally [override this on a per-Service basis][knative-override]
  by adding a `networking.knative.dev/ingress.class` annotation to the Service.

### Enabling support for classless resources

Specifying a class is optional for some resources. Although specifying a class
is recommended, you can instruct the controller to process resources without a
class annotation using flags:

- `--process-classless-ingress-v1beta1` instructs the controller to translate
  v1beta1 Ingress resources with no class annotation.
- `--process-classless-kong-consumer` instructs the controller to translate
  KongConsumer resources with no class annotation.

These flags are primarily intended for compatibility with older configuration
({{site.kic_product_name}} before 0.10 had less strict class
requirements, and it was common to omit class annotations). If you are creating
new configuration and do not have older configuration without class
annotations, recommended best practice is to add class information to Ingress
and KongConsumer resources and not set the above flags. Doing so avoids
accidentally creating duplicate configuration in other ingress controller
instances.

These flags do not _ignore_ `ingress.class` annotations: they allow resources
with no such annotation, but will not allow resource that have a non-matching
`ingress.class` annotation.

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

## Legacy behavior

This overview covers behavior in {{site.kic_product_name}} version 0.10.0 onward.
Earlier versions had a special case for the default class and a bug affecting
custom classes:

- When using the default `kong` class, the controller would always process
  classless resources in addition to `kong`-class resources. When using a
  non-default controller class, the controller would only process resources
  with that class, not classless resources. Although this was by design, it was
  a source of user confusion.
- When using a custom controller class, some resources that should not have
  required a class (because they were referenced by other resources)
  effectively did require a class: while these resources were loaded initially,
  the controller would not track updates to them unless they had a class
  annotation.

In versions 0.10.0+ you must instruct the controller to load classless
resources, which is allowed (but not recommended) for either the default or
custom classes. Resources referenced by another resource are always loaded and
updated correctly regardless of which class you set on the controller; you do
not need to add class annotations to these resources when using a custom class.

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
apiVersion: extensions/v1beta1
metadata:
  name: ktonezhnaet
  annotations:
    kubernetes.io/ingress.class: "kong"
    konghq.com/plugins: "key-auth-example"
spec:
  rules:
  - http:
      paths:
      - path: /vsemznakom
        backend:
          serviceName: httpbin
          servicePort: 80

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

[class-annotation]: /kubernetes-ingress-controller/{{page.kong_version}}/references/annotations/#kubernetesioingressclass
[knative-class]: /kubernetes-ingress-controller/{{page.kong_version}}/guides/using-kong-with-knative/#ingress-class
[knative-override]: https://knative.dev/docs/serving/services/ingress-class/
