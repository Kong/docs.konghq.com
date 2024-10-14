---
title: Managing Plugin Bindings by CRD
---

The `KongPluginBinding` is the CRD used to manage binding relationship between plugins and attached Konnect entities, including services, routes, consumers and consumer groups, or supported comblination of these entities.

### Introduction of `KongPluginBinding` CRD

A `KongPluginBinding` resource describes a binding relationship of a plugin and an attached entity or a combination of possible entities. It has two parts for describing the binding in its specification: `spec.pluginRef` to refer to a `KongPlugin` resource which contains the plugin name and configuration of the plugin, and `spec.targets` to refer to the entity or combination of entities that the plugin attached to. The `spec.controlPlaneRef` refers to the Konnect ControlPlane this KongPluginBinding is associated with.

### Using an Unmannaged `KongPluginBinding`

You can directly create a `KongPluginBinding` to bind your plugin to a Konnect entity. Assume that you have an existing and programmed `KonnectGatewayControlPlane` with name `cp` in `default` namespace.

First, Create a service and a plugin by `KongService` and `KongPlugin` CRD:

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

And we can create a `KongPluginBinding` to bind them together.

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

### Using Annotations to Bind Plugins to Other Entities

We can also use the `konghq.com/plugins` annotation to attach plugins to other entities like what we used in {{ site.kic_product_name }}. The {{ site.kgo_product_name }} will create `KongPluginBinding` resources for the annotations and configure them in {{ site.konnect_short_name }}.

For the example above, we can create a `KongPlugin` and a `KongService` like this:

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
rate-limiting-minute-10-r4xvt   KongPlugin    rate-limiting-minute-10      True
```
