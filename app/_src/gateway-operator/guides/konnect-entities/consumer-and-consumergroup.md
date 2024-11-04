---
title: Consumer, Credentials and Consumer Group
---

In this guide you'll learn how to use the `KongConsumer` and `KongConsumerGroup` custom resources to
manage {{site.konnect_product_name}} [Consumers](/konnect/gateway-manager/configuration/#consumers)
and consumer groups natively from your Kubernetes cluster.

{% include md/kgo/konnect-entities-prerequisites.md disable_accordian=false version=page.version release=page.release
with-control-plane=true %}

## Create a consumer

Creating the `KongConsumer` object in your Kubernetes cluster will provision a {{site.konnect_product_name}} Consumer in
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
      name: gateway-control-plane # Reference to the KonnectGatewayControlPlane object
  ' | kubectl apply -f -
```

{% include md/kgo/check-condition.md name='consumer' kind='KongConsumer' %}

At this point, you should see the consumer in the Gateway Manager UI.

## Associate the consumer with credentials

Consumers can have credentials associated with them. You can create one of the supported credential types. Please refer
to the below custom resource's documentation links to learn all the available fields for each credential type.

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
    name: consumer # Reference to the KongConsumer object
  password: pass
  username: username
  ' | kubectl apply -f -
```

{% include md/kgo/check-condition.md name='basic-auth-cred' kind='KongCredentialBasicAuth' %}

At this point, you should see the credential in the consumer's credentials in the Gateway Manager UI.

## Create a consumer group

Creating the `KongConsumerGroup` object in your Kubernetes cluster will provision a {{site.konnect_product_name}} consumer group in
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
      name: gateway-control-plane # Reference to the KonnectGatewayControlPlane object
' | kubectl apply -f -
```

{% include md/kgo/check-condition.md name='consumer-group' kind='KongConsumerGroup' %}

At this point, you should see the consumer group in the Gateway Manager UI.

### Associate a consumer with a consumer group

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
  - consumer-group # Reference to the KongConsumerGroup object
spec:
  controlPlaneRef:
    type: konnectNamespacedRef
    konnectNamespacedRef:
      name: gateway-control-plane # Reference to the KonnectGatewayControlPlane object
  ' | kubectl apply -f -
```

You can verify the `KongConsumer`'s `consumerGroups` field was reconciled successfully by checking its `KongConsumerGroupRefsValid` condition.

{% include md/kgo/check-condition.md name='consumer' kind='KongConsumer' conditionType='KongConsumerGroupRefsValid' reason='Valid' disableDescription=true %}

At this point, you should see the `consumer` Consumer in the Consumer Group members in the Gateway Manager UI.
