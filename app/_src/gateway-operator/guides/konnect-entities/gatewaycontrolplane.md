---
title: Gateway Control Plane
---

In this guide you'll learn how to use the `KonnectGatewayControlPlane` custom resource to
manage [Konnect Gateway Control
Planes](/konnect/gateway-manager/#control-planes) natively from your Kubernetes cluster.

{% include md/kgo/konnect-entities-prerequisites.md disable_accordian=false version=page.version release=page.release %}

## Create a self-managed hybrid gateway control plane

Creating the `KonnectGatewayControlPlane` object in your Kubernetes cluster will provision a {{site.konnect_short_name}} Gateway
control plane in your [Gateway Manager](/konnect/gateway-manager). The `KonnectGatewayControlPlane` CR
[API](/gateway-operator/{{ page.release }}/reference/custom-resources/#konnectgatewaycontrolplane) allows you to
explicitly set a type of the Gateway control plane, but if you don't specify it, the default type is
a [Self-Managed Hybrid
Gateway Control Plane](/konnect/gateway-manager/#kong-gateway-control-planes).

You can create one by applying the following YAML manifest:

```yaml
echo '
kind: KonnectGatewayControlPlane
apiVersion: konnect.konghq.com/v1alpha1
metadata:
  name: gateway-control-plane
  namespace: default
spec:
  name: gateway-control-plane # Name used to identify the Gateway Control Plane in Konnect
  konnect:
    authRef:
      name: konnect-api-auth # Reference to the KonnectAPIAuthConfiguration object
  ' | kubectl apply -f -
```

You can see the status of the Gateway control plane by running:

```shell
kubectl get konnectgatewaycontrolplanes.konnect.konghq.com gateway-control-plane
```

If the Gateway control plane is successfully created, you should see the following output:

```shell
NAME                    PROGRAMMED   ID                                     ORGID
gateway-control-plane   True         <konnect-control-plane-id>             <your-konnect-org-id>
```

## Create a control plane group

Gateway Manager allows you to group multiple Gateway control planes. You can create
a [Control Plane Group](/konnect/gateway-manager/#control-plane-groups) by setting the `cluster_type`
field in the `spec` section of the `KonnectGatewayControlPlane` object to `CLUSTER_TYPE_CONTROL_PLANE_GROUP`.

```yaml
echo '
kind: KonnectGatewayControlPlane
apiVersion: konnect.konghq.com/v1alpha1
metadata:
  name: control-plane-group
  namespace: default
spec:
  name: control-plane-group # Name used to identify the Gateway Control Plane in Konnect
  cluster_type: CLUSTER_TYPE_CONTROL_PLANE_GROUP # Type of the Gateway Control Plane
  konnect:
    authRef:
      name: konnect-api-auth # Reference to the KonnectAPIAuthConfiguration object
  ' | kubectl apply -f -
```

You can see the status of the Gateway Control Plane by running:

```shell
kubectl get konnectgatewaycontrolplane control-plane-group
```

If the Control Plane Group is successfully created, you should see the following output:

```shell
NAME                    PROGRAMMED   ID                                     ORGID
control-plane-group     True         <konnect-control-plane-id>             <your-konnect-org-id>
```

### Add a gateway control plane to a control plane group

To assign Gateway control planes to a control plane group, you need to specify the `members` field in the `spec` section of the `KonnectGatewayControlPlane` object.

```yaml
echo '
kind: KonnectGatewayControlPlane
apiVersion: konnect.konghq.com/v1alpha1
metadata:
  name: control-plane-group
  namespace: default
spec:
  name: control-plane-group # Name used to identify the Gateway Control Plane in Konnect
  cluster_type: CLUSTER_TYPE_CONTROL_PLANE_GROUP # Type of the Gateway Control Plane
  members:
    - name: gateway-control-plane # Reference to the KonnectGatewayControlPlane object
  konnect:
    authRef:
      name: konnect-api-auth # Reference to the KonnectAPIAuthConfiguration object
  ' | kubectl apply -f -
```

You can check in your Gateway Manager to see if the Gateway control plane was successfully added to the control plane group.

## Create a Kubernetes ingress controller control plane

To create a [Kubernetes Ingress Controller Control Plane](/konnect/gateway-manager/kic/), you need to specify the
`cluster_type` field in the `spec` section of
the `KonnectGatewayControlPlane` object.

```yaml
echo '
kind: KonnectGatewayControlPlane
apiVersion: konnect.konghq.com/v1alpha1
metadata:
  name: kic-control-plane
  namespace: default
spec:
  name: kic-control-plane # Name used to identify the Gateway Control Plane in Konnect
  cluster_type: CLUSTER_TYPE_K8S_INGRESS_CONTROLLER # Type of the Gateway Control Plane
  konnect:
    authRef:
      name: konnect-api-auth # Reference to the KonnectAPIAuthConfiguration object
  ' | kubectl apply -f -
```

You can see the status of the Gateway control plane by running:

```shell
kubectl get konnectgatewaycontrolplane kic-control-plane
```

If the control plane is successfully created, you should see the following output:

```shell
NAME                    PROGRAMMED   ID                                     ORGID
kic-control-plane       True         <konnect-control-plane-id>             <your-konnect-org-id>
```

{% if_version gte:1.6.x %}

## Refer to existing Konnect gateway control plane

You can refer to an existing {{site.konnect_short_name}} Gateway control plane by creating the `KonnectGatewayControlPlane` object with `Mirror` source in your Kubernetes cluster. This operation will mirror the {{site.konnect_short_name}} Gateway
control plane from your [Gateway Manager](/konnect/gateway-manager). You must provide the {{site.konnect_short_name}} ID of the 
{{site.konnect_short_name}} Gateway control plane in the `mirror.konnect.id` field.

> Note: the mirrored control planes are in read-only in Kubernetes, which means that no update or deletion
  can be enforced on the remote Konnect entities through such resource.

You can create one by applying the following YAML manifest:

```yaml
echo '
kind: KonnectGatewayControlPlane
apiVersion: konnect.konghq.com/v1alpha1
metadata:
  name: gateway-control-plane
  namespace: default
spec:
  source: Mirror
  mirror:
    konnect:
      id: <YOUR-KONNECT-ID>
  konnect:
    authRef:
      name: konnect-api-auth # Reference to the KonnectAPIAuthConfiguration object
  ' | kubectl apply -f -
```

You can see the status of the Gateway control plane by running:

```shell
kubectl get konnectgatewaycontrolplanes.konnect.konghq.com gateway-control-plane
```

If the Gateway control plane is successfully mirrored, you should see the following output:

```shell
NAME                    PROGRAMMED   ID                                     ORGID
gateway-control-plane   True         <konnect-control-plane-id>             <your-konnect-org-id>
```
{% endif_version %}
