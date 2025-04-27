---
title: Limiting namespaces watched by ControlPlane
---

{{site.kgo_product_name}}'s `ControlPlane` watches all namespaces by default.
This is a convenient out of the box experience but might not fit all production environments,
specifically those with multiple teams sharing the same cluster or in multitenant environments.

To limit the namespaces watched by `ControlPlane`, you can set the `watchNamespaces` field in the `ControlPlane`'s `spec`.

## ControlPlane's watchNamespaces field

The `spec.watchNamespaces.type` accepts 3 values to control this behavior:

- `all`: default, as the name implies, watch resources in all namespaces
- `own`: makes the `ControlPlane` only watch resources in its own namespace
- `list`: makes the `ControlPlane` watch resources in its own namespace and the provided list of namespaces
  Using "list" also adds ControlPlane's own namespace to the list of watched namespaces
  because that's that KIC does.
  The reason for this is the publish service (`DataPlane`'s `Service` exposed by {{site.base_gateway}})
  by default would exist in the same namespace as `ControlPlane`.

> Note: Please mark that this setting in `ControlPlane` will set the `CONTROLLER_WATCH_NAMESPACE`
> environment variable in managed {{ site.kic_product_name }} so setting this via
> `podTemplateSpec` will override this.

## Specify a list of namespaces to watch

`all` and `own` types are self-explanatory and do not require any further changes
or additional resources.

The `list` type requires 2 additional steps:

- you must specify the namespaces to watch in the `spec.watchNamespaces.list` field.

    ```yaml
    spec:
      watchNamespaces:
        type: list
        list:
        - namespace-a
        - namespace-b
    ```

- you must create a `WatchNamespaceGrant` resource in each of the specified namespaces.
  This resource grants the `ControlPlane` the permission to watch resources in said namespace.
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

For more information on the `WatchNamespaceGrant` CRD please consult the [CRD reference](/gateway-operator/{{ page.release }}/reference/custom-resources#watchnamespacegrant).
