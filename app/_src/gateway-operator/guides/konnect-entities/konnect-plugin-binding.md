---
title: Managing Plugin Bindings by CRD
---

In this guide you'll learn how to use the `KongPluginBinding` to bind plugins to {{site.konnect_short_name }} entities
from within your Kubernetes cluster.

{% include md/kgo/konnect-entities-prerequisites.md disable_accordian=false version=page.version release=page.release
with-control-plane=true %}

## Introduction of `KongPluginBinding` CRD

The `KongPluginBinding` is the CRD used to manage the binding relationship between plugins and attached {{site.konnect_short_name}} 
entities, including services, routes, consumers, and consumer groups, or a supported combination of these entities.
{% if_version gte:1.5.x %} It can also be used to bind a plugin globally to a control plane when `spec.scope` is set to `GlobalInControlPlane`. {% endif_version %} 
Each `KongPluginBinding` represents a single plugin instance on {{ site.konnect_short_name }}.

This CRD has the following fields:
* `spec.pluginRef`: Refers to a `KongPlugin` object which contains the plugin name and configuration of the plugin.
* `spec.targets`: Refers to the entity or combination of entities that the plugin is attached to.{% if_version gte:1.5.x %} At least one target has to be specified when `spec.scope` is `OnlyTargets` (default). {% endif_version %}
* `spec.controlPlaneRef`: Refers to the {{site.konnect_product_name}} control plane this `KongPluginBinding` is associated with.

You can refer to the CR [API](/gateway-operator/{{ page.release }}/reference/custom-resources/#kongpluginbinding) to see all the available fields.

## Using an unmanaged `KongPluginBinding`

You can directly create a `KongPluginBinding` to bind your plugin to a Konnect entity. Assume that you have an existing and programmed `KonnectGatewayControlPlane` with the name `cp` in the `default` namespace.

First, create a service and a plugin by `KongService` and `KongPlugin` CRD:

```shell
echo '
kind: KongService
apiVersion: configuration.konghq.com/v1alpha1
metadata:
  namespace: default
  name: service-example
spec:
  host: example.com
  controlPlaneRef:
    type: konnectNamespacedRef
    konnectNamespacedRef:
      name: cp
' | kubectl apply -f -
```

Then, create a `KongPlugin`:

```shell
echo '
kind: KongPlugin
apiVersion: configuration.konghq.com/v1
metadata:
  namespace: default
  name: rate-limiting-minute-10
plugin: rate-limiting
config:
  policy: local
  minute: 10
' | kubectl apply -f -
```

And you can create a `KongPluginBinding` to bind them together.

```shell
echo '
kind: KongPluginBinding
apiVersion: configuration.konghq.com/v1alpha1
metadata:
  namespace: default
  name: binding-service-example-rate-limiting
spec:
  pluginRef:
    kind: KongPlugin
    name: rate-limiting-minute-10
  targets:
    serviceRef:
      group: configuration.konghq.com
      kind: KongService
      name: service-example
  controlPlaneRef:
    type: konnectNamespacedRef
    konnectNamespacedRef:
      name: cp
' | kubectl apply -f -
```

Then the plugin will be successfully attached to the service in {{ site.konnect_short_name }}.

### Attaching plugins to multiple entities

{{ site.kgo_product_name }} also supports attaching plugins to a combination of entities by `KongPluginBinding`.
Supported combinations include:

* `Service` and `Route`
* `Service` and `Consumer`
* `Service` and `ConsumerGroup`
* `Service`, `Route`, and `Consumer`
* `Service`, `Route`, and `ConsumerGroup`
* `Consumer` and `ConsumerGroup`

For example, we can configure a `rate-limiting` plugin to a service and a consumer like this:

Create a service:

```shell
echo '
kind: KongService
apiVersion: configuration.konghq.com/v1alpha1
metadata:
  namespace: default
  name: service-plugin-binding-combination
spec:
  host: example.com
  controlPlaneRef:
    type: konnectNamespacedRef
    konnectNamespacedRef:
      name: cp
' | kubectl apply -f -
```

Create a consumer:

```shell
echo '
kind: KongConsumer
apiVersion: configuration.konghq.com/v1
metadata:
  namespace: default
  name: consumer-plugin-binding-combination
username: consumer-test
spec:
  controlPlaneRef:
    type: konnectNamespacedRef
    konnectNamespacedRef:
      name: cp
' | kubectl apply -f -
```

Create a plugin:

```shell
echo '
kind: KongPlugin
apiVersion: configuration.konghq.com/v1
metadata:
  namespace: default
  name: rate-limiting-minute-10
plugin: rate-limiting
config:
  policy: local
  minute: 10
' | kubectl apply -f -
```

Then, you can create a `KongPluginBinding` including both references to the `KongService` and the `KongCosumer` to attach the plugin to the service and the consumer:

```shell
echo '
kind: KongPluginBinding
apiVersion: configuration.konghq.com/v1alpha1
metadata:
  namespace: default
  name: binding-combination-service-consumer
spec:
  pluginRef:
    kind: KongPlugin
    name: rate-limiting-minute-10
  targets:
    serviceRef:
      group: configuration.konghq.com
      kind: KongService
      name: service-plugin-binding-combination
    consumerRef:
      name: consumer-plugin-binding-combination
  controlPlaneRef:
    type: konnectNamespacedRef
    konnectNamespacedRef:
      name: cp
' | kubectl apply -f -
```

{% if_version gte:1.5.x %}
### Attaching plugins globally to a control plane

You can also attach a plugin globally to a control plane by setting the `spec.scope` field to `GlobalInControlPlane` in the `KongPluginBinding` CRD.

Create a `KongPluginBinding` to attach a plugin globally to a control plane like this:

```shell
echo '
kind: KongPluginBinding
apiVersion: configuration.konghq.com/v1alpha1
metadata:
  namespace: default
  name: binding-global-rate-limiting
spec:
  # This indicates that the plugin is attached globally to the control plane and allows leaving targets empty.
  scope: GlobalInControlPlane
  pluginRef:
    kind: KongPlugin
    name: rate-limiting-minute-10
  controlPlaneRef:
    type: konnectNamespacedRef
    konnectNamespacedRef:
      name: cp
' | kubectl apply -f -
```

Having the `KongPluginBinding` created, the plugin will be attached globally to the control plane in {{ site.konnect_short_name }}.
{% endif_version %}

## Using annotations to bind plugins to other entities

{:.note}
> **NOTE:** This approach is considered legacy and using `KongPluginBinding` CRD is recommended instead.
> Users can expect that `konghq.com/plugins` annotation support will be removed at some point in the future.

You can also use the `konghq.com/plugins` annotation to attach plugins to other entities like it's done in {{ site.kic_product_name }}.
The {{ site.kgo_product_name }} will create `KongPluginBinding` resources for the annotations and configure them in {{ site.konnect_short_name }}.

In the example above, you can create a `KongPlugin` and a `KongService` like this:

```shell
echo '
kind: KongPlugin
apiVersion: configuration.konghq.com/v1
metadata:
  namespace: default
  name: rate-limiting-minute-10
plugin: rate-limiting
config:
  policy: local
  minute: 10
' | kubectl apply -f - 
```

```shell
echo '
kind: KongService
apiVersion: configuration.konghq.com/v1alpha1
metadata:
  namespace: default
  name: service-example
  annotations:
    konghq.com/plugins: rate-limiting-minute-10
spec:
  host: example.com
  controlPlaneRef:
    type: konnectNamespacedRef
    konnectNamespacedRef:
      name: cp
' | kubectl apply -f -
```

At this point you can see the plugin is attached to the service in {{ site.konnect_short_name }}.

You can also check the `KongPluginBinding` resource by running.

```shell
kubectl get kongpluginbinding
```

You can see the created `KongPluginBinding` like this:

```shell
NAME                            PLUGIN-KIND   PLUGIN-NAME                  PROGRAMMED
rate-limiting-minute-10-a0z1x   KongPlugin    rate-limiting-minute-10      True
```

### Attaching plugins to multiple entities

{:.note}
> **NOTE:** Binding plugins with this approach has limited observability and can yield unexpected results
> when multiple different resources are attached to the same plugin
> (e.g. a service already has a plugin attached to it and we're annotating consumer with the same plugin).
> Users are advised to use `KongPluginBinding` CRD instead for better control and auditability.

Similar to those introduced above, you can also attach a plugin to multiple entities by configuring annotations of attached entities.
If a plugin appears in the `konghq.com/plugins` annotation of multiple entities, a `KongPluginBinding` will be created for the binding relationship between the plugin and the combination of these entities.
Taking the example above where a plugin is attached to a service and a consumer:

```shell
echo '
kind: KongPlugin
apiVersion: configuration.konghq.com/v1
metadata:
  namespace: default
  name: rate-limiting-minute-10
plugin: rate-limiting
config:
  policy: local
  minute: 10
' | kubectl apply -f -
```

```shell
echo '
kind: KongService
apiVersion: configuration.konghq.com/v1alpha1
metadata:
  namespace: default
  name: service-plugin-binding-combination
  annotations:
    konghq.com/plugins: rate-limiting-minute-10
spec:
  host: example.com
  controlPlaneRef:
    type: konnectNamespacedRef
    konnectNamespacedRef:
      name: cp
' | kubectl apply -f -
```

```shell
echo '
kind: KongConsumer
apiVersion: configuration.konghq.com/v1
metadata:
  namespace: default
  name: consumer-plugin-binding-combination
  annotations:
    konghq.com/plugins: rate-limiting-minute-10
username: consumer-test
spec:
  controlPlaneRef:
    type: konnectNamespacedRef
    konnectNamespacedRef:
      name: cp
' | kubectl apply -f -
```

A `KongPluginBinding` with both `serviceRef` and `consumerRef` in its `spec.targets` will be created like:

```yaml
apiVersion: configuration.konghq.com/v1alpha1
kind: KongPluginBinding
metadata:
  creationTimestamp: "2024-10-14T07:14:05Z"
  generateName: rate-limiting-minute-10-
  name: rate-limiting-minute-10-xyz98
  namespace: default
  ownerReferences:
  - apiVersion: configuration.konghq.com/v1
    blockOwnerDeletion: true
    kind: KongPlugin
    name: rate-limiting-minute-10
    uid: 01234567-89ab-cdef-fdec-ba9876543210
spec:
  controlPlaneRef:
    konnectNamespacedRef:
      name: test1
      namespace: default
    type: konnectNamespacedRef
  pluginRef:
    kind: KongPlugin
    name: rate-limiting-minute-10
  targets:
    consumerRef:
      name: consumer-plugin-binding-combination
    serviceRef:
      group: configuration.konghq.com
      kind: KongService
      name: service-plugin-binding-combination
```
