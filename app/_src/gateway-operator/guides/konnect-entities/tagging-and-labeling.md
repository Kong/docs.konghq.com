---
title: Tagging and Labeling
---

Tags and labels are a way to organize and categorize your resources. In this guide, you'll learn how to annotate your
Konnect entities managed by {{site.kgo_product_name}} with tags and labels (depending on particular entity's support for
those).

{% include md/kgo/konnect-entities-prerequisites.md disable_accordian=false version=page.version release=page.release %}

## Labeling

Labels are key-value pairs that you can attach to objects. As of now, the only Konnect entity that supports labeling is
the [KonnectGatewayControlPlane](/gateway-operator/guides/konnect-entities/gatewaycontrolplane). You can add labels to
the `KonnectGatewayControlPlane` object by specifying the `labels` field in the `spec` section.

```yaml
echo '
kind: KonnectGatewayControlPlane
apiVersion: konnect.konghq.com/v1alpha1
metadata:
  name: gateway-control-plane
  namespace: default
spec:
  labels: # Arbitrary key-value pairs
    environment: production
    team: devops
  name: gateway-control-plane
  konnect:
    authRef:
      name: konnect-api-auth # Reference to the KonnectAPIAuthConfiguration object
  ' | kubectl apply -f -
```

You can verify the Control Plane was reconciled successfully by checking its status.

```shell
kubectl get konnectgatewaycontrolplanes.konnect.konghq.com gateway-control-plane
```

The output should look similar to this:

```console
NAME                    PROGRAMMED   ID                                     ORGID
gateway-control-plane   True         <konnect-control-plane-id>             <your-konnect-ord-id>
```

At this point, labels should be visible in the Gateway Manager UI.

## Tagging

Tags are values that you can attach to objects. All the Konnect entities that can be attached to a
`KonnectGatewayControlPlane` object support tagging. You can add tags to those entities by specifying the `tags` field
in their `spec` section.

For example, to add tags to a `KongService` object, you can apply the following YAML manifest:

```yaml
echo '
kind: KongService
apiVersion: configuration.konghq.com/v1alpha1
metadata:
  name: service
  namespace: default
spec:
  tags: # Arbitrary list of strings
    - production
    - devops
  name: service
  host: example.com
  controlPlaneRef:
    type: konnectNamespacedRef
    konnectNamespacedRef:
      name: gateway-control-plane # Reference to the KonnectGatewayControlPlane object
  ' | kubectl apply -f -
```

You can verify the `KongService` was reconciled successfully by checking its `Programmed` condition.

```shell
kubectl get kongservice service -o=jsonpath='{.status.conditions}' | jq '.[] | select(.type == "Programmed")'
```

The output should look similar to this:

```console
{
  "observedGeneration": 1,
  "reason": "Programmed",
  "status": "True",
  "type": "Programmed"
}
```

At this point, tags should be visible in the Gateway Manager UI.
