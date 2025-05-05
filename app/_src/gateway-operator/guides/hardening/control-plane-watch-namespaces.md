---
title: Limiting namespaces watched by ControlPlane
---

By default, {{ site.kgo_product_name }}'s `ControlPlane` watches all namespaces.
This provides a convenient out-of-the-box experience but may not suit all production environments, especially those where multiple teams share the same cluster or in multitenant setups.

To limit the namespaces watched by `ControlPlane`, you can set the `watchNamespaces` field in the `ControlPlane`'s `spec`.

## ControlPlane's watchNamespaces field

The `spec.watchNamespaces.type` field accepts three values to control this behavior:

- `all` (default): Watches resources in all namespaces.
- `own`: Watches resources only in the `ControlPlane`'s own namespace.
- `list`: Watches resources in the `ControlPlane`'s own namespace and in the specified list of additional namespaces.
  When using `list`, the `ControlPlane`'s own namespace is automatically added to the list of watched namespaces, because this behavior is required by {{ site.kic_product_name }}.  
  By default, the publish service (the `Service` for the `DataPlane`, exposed by {{ site.base_gateway }}) is created in the same namespace as the `ControlPlane`.

> **Note:** Setting this field in `ControlPlane` will configure the `CONTROLLER_WATCH_NAMESPACE` environment variable in the managed {{ site.kic_product_name }}.
> If you manually set the `CONTROLLER_WATCH_NAMESPACE` environment variable through `podTemplateSpec`, it will **override** this configuration.

## Specify a list of namespaces to watch

`all` and `own` types are self-explanatory and do not require any further changes
or additional resources.

The `list` type requires 2 additional steps:

- You must specify the namespaces to watch in the `spec.watchNamespaces.list` field.


    ```yaml
    spec:
      watchNamespaces:
        type: list
        list:
        - namespace-a
        - namespace-b
    ```

- You must create a `WatchNamespaceGrant` resource in each of the specified namespaces.
  This resource grants the `ControlPlane` permission to watch resources in the specified namespace.  
  It can be defined as:

    ```yaml
    apiVersion: gateway-operator.konghq.com/v1alpha1
    kind: WatchNamespaceGrant
    metadata:
      name: watch-namespace-grant
      namespace: namespace-a
    spec:
      from:
      - group: gateway-operator.konghq.com
        kind: ControlPlane
        namespace: control-plane-namespace
    ```

For more information on the `WatchNamespaceGrant` CRD, check [CRD reference](/gateway-operator/{{ page.release }}/reference/custom-resources#watchnamespacegrant).
