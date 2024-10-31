---
title: Managing Plugin Bindings by CRD
---

The `KongPluginBinding` is the CRD used to manage the binding relationship between plugins and attached Konnect entities, including services, routes, consumers, and consumer groups, or a supported combination of these entities.

### Introduction of `KongPluginBinding` CRD

A `KongPluginBinding` resource describes a binding relationship between a plugin and an attached entity or a combination of possible entities. It has two parts for the binding description in its specification: `spec.pluginRef` to refer to a `KongPlugin` resource which contains the plugin name and configuration of the plugin, and `spec.targets` to refer to the entity or combination of entities that the plugin attached to. The `spec.controlPlaneRef` refers to the {{site.konnect_product_name}} control plane this `KongPluginBinding` is associated with.

### Using an Unmanaged `KongPluginBinding`

You can directly create a `KongPluginBinding` to bind your plugin to a Konnect entity. Assume that you have an existing and programmed `KonnectGatewayControlPlane` with the name `cp` in the `default` namespace.

First, create a service and a plugin by `KongService` and `KongPlugin` CRD:

```bash
# Create a KongService for a service in Konnect
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

```bash
# Create a KongPlugin
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

```bash
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

#### Attaching plugins to multiple entities

{{ site.kgo_product_name }} also supports to attach plugins to combination of multiple entities by `KongPluginBinding`. Supported combinations includes: 
* `Service` and `Route`; 
* Service` and `Consumer`
* Service` and `ConsumerGroup`
* `Service`, `Route` and `Consumer`
* `Service`, `Route` and `ConsumerGroup` 
* `Consumer` and `ConsumerGroup`. 
For example, we can configure a `rate-limiting` plugin to a service and a consumer like this:

Create a service:

```bash
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

```bash
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

```bash
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

```bash
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

### Using annotations to bind plugins to other entities

You can also use the `konghq.com/plugins` annotation to attach plugins to other entities like what we used in {{ site.kic_product_name }}. The {{ site.kgo_product_name }} will create `KongPluginBinding` resources for the annotations and configure them in {{ site.konnect_short_name }}.

In the example above, you can create a `KongPlugin` and a `KongService` like this:

```bash
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

```bash
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

Then you can also see the plugin is attached to the service in {{ site.konnect_short_name }}. You can also check the `KongPluginBinding` resource by `kubectl get kongpluginbindings`. You can see the created `KongPluginBinding` like:

```
kubectl get kongpluginbinding
NAME                            PLUGIN-KIND   PLUGIN-NAME                  PROGRAMMED
rate-limiting-minute-10-a0z1x   KongPlugin    rate-limiting-minute-10      True
```

#### Attaching Plugins to Multiple Entities

Similar to those introduced above, you can also attach a plugin to multiple entities by configuring annotations of attached entities. If a plugin appears in the `konghq.com/plugins` annotation of multiple entities, a `KongPluginBinding` will be created for the binding relationship between the plugin and the combination of these entities. Taking the example above where a plugin is attached to a service and a consumer:

```bash
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

```bash
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

```bash
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