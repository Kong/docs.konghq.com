---
title: Consumer, Credentials and Consumer Group
---

In this guide you'll learn how to use the `KongConsumer` and `KongConsumerGroup` custom resources to
manage Konnect [Consumers](/konnect/gateway-manager/configuration/#consumers)
and Consumer Groups natively from your Kubernetes cluster.

{% include md/kgo/konnect-entities-prerequisites.md disable_accordian=false version=page.version release=page.release
with-control-plane=true %}

## Create a Consumer

Creating the `KongConsumer` object in your Kubernetes cluster will provision a Konnect Consumer in
your [Gateway Manager](/konnect/gateway-manager).
You can refer to the CR [API](/gateway-operator/{{ page.release }}/reference/custom-resources/#kongconsumer)
to see all the available fields.

Your `KongConsumer` must be associated with a `KonnectGatewayControlPlane` object that you've created in your cluster.
It will make it part of the Gateway Control Plane's configuration.

You can create a `KongConsumer` by applying the following YAML manifest:

```yaml
echo '
kind: KongConsumer
apiVersion: configuration.konghq.com/v1
metadata:
  name: consumer
  namespace: default
username: consumer
custom_id: 08433C12-2B81-4738-B61D-3AA2136F0212 # Optional
spec:
  controlPlaneRef:
    type: konnectNamespacedRef
    konnectNamespacedRef:
      name: gateway-control-plane # KonnectGatewayControlPlane reference
  ' | kubectl apply -f -
```

You can verify the `KongConsumer` was reconciled successfully by checking its `Programmed` condition.

```shell
kubectl get kongconsumer consumer -o=jsonpath='{.status.conditions}' | jq '.[] | select(.type == "Programmed")'
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

At this point, you should see the Consumer in the Gateway Manager UI.

## Associate the Consumer with Credentials

Consumers can have credentials associated with them. You can create one of the supported credential types. Please refer
to the below Custom Resource's documentation links to learn all the available fields for each credential type.

- [KongCredentialBasicAuth](/gateway-operator/{{ page.release }}/reference/custom-resources/#kongcredentialbasicauth)
- [KongCredentialKeyAuth](/gateway-operator/{{ page.release }}/reference/custom-resources/#kongcredentialkeyauth)
- [KongCredentialACL](/gateway-operator/{{ page.release }}/reference/custom-resources/#kongcredentialacl)
- [KongCredentialJWT](/gateway-operator/{{ page.release }}/reference/custom-resources/#kongcredentialjwt)
- [KongCredentialHMAC](/gateway-operator/{{ page.release }}/reference/custom-resources/#kongcredentialhmac)

For example, you can create a `KongCredentialBasicAuth` associated with the `consumer` `KongConsumer` by applying the
following YAML manifest:

```yaml
echo '
apiVersion: configuration.konghq.com/v1alpha1
kind: KongCredentialBasicAuth
metadata:
  name: basic-auth-cred
  namespace: default
spec:
  consumerRef:
    name: consumer
  password: pass
  username: username
  ' | kubectl apply -f -
```

You can verify the `KongCredentialBasicAuth` was reconciled successfully by checking its `Programmed` condition.

```shell
kubectl get kongcredentialbasicauth basic-auth-cred -o=jsonpath='{.status.conditions}' | jq '.[] | select(.type == "Programmed")'
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

At this point, you should see the Credential in the Consumer's Credentials in the Gateway Manager UI.

## Create a Consumer Group

Creating the `KongConsumerGroup` object in your Kubernetes cluster will provision a Konnect Consumer Group in
your [Gateway Manager](/konnect/gateway-manager). Please refer to the
`KongConsumerGroup` CR [API](/gateway-operator/{{ page.release }}/reference/custom-resources/#kongconsumergroup) to see
all the available fields.

You can create a `KongConsumerGroup` by applying the following YAML manifest:

```yaml
echo '
kind: KongConsumerGroup
apiVersion: configuration.konghq.com/v1beta1
metadata:
  name: consumer-group
  namespace: default
spec:
  name: consumer-group
  controlPlaneRef:
    type: konnectNamespacedRef
    konnectNamespacedRef:
      name: gateway-control-plane # KonnectGatewayControlPlane reference
' | kubectl apply -f -
```

You can verify the `KongConsumerGroup` was reconciled successfully by checking its `Programmed` condition.

```shell
kubectl get kongconsumergroup consumer-group -o=jsonpath='{.status.conditions}' | jq '.[] | select(.type == "Programmed")'
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

At this point, you should see the Consumer Group in the Gateway Manager UI.

### Associate a Consumer with a Consumer Group

You can associate a `KongConsumer` with a `KongConsumerGroup` by modifying the `KongConsumer` object and adding the
`consumerGroups` field. This field is a list of `KongConsumerGroup` names.

For example, you can associate the `consumer` `KongConsumer` with the `consumer-group` `KongConsumerGroup` by applying the
following YAML manifest:

```yaml
echo '
kind: KongConsumer
apiVersion: configuration.konghq.com/v1
metadata:
  name: consumer
  namespace: default
username: consumer
custom_id: 08433C12-2B81-4738-B61D-3AA2136F0212 # Optional
consumerGroups:
  - consumer-group # KongConsumerGroup reference
spec:
  controlPlaneRef:
    type: konnectNamespacedRef
    konnectNamespacedRef:
      name: gateway-control-plane # KonnectGatewayControlPlane reference
  ' | kubectl apply -f -
```

You can verify the `KongConsumer`'s `consumerGroups` field was reconciled successfully by checking its `KongConsumerGroupRefsValid` condition.

```shell
kubectl get kongconsumer consumer -o=jsonpath='{.status.conditions}' | jq '.[] | select(.type == "KongConsumerGroupRefsValid")'
```

The output should look similar to this:

```console
{
  "observedGeneration": 2,
  "reason": "Valid",
  "status": "True",
  "type": "KongConsumerGroupRefsValid"
}
```

At this point, you should see the `consumer` Consumer in the Consumer Group members in the Gateway Manager UI.
