---
title: Key and Key Set 
---

In this guide you'll learn how to use the `KongKey` and `KongKeySet` custom resources to
manage {{site.konnect_product_name}} [keys](/konnect/gateway-manager/configuration/#keys)
and key sets natively from your Kubernetes cluster.

{% include md/kgo/konnect-entities-prerequisites.md disable_accordian=false version=page.version release=page.release
with-control-plane=true %}

## Create a Key

Creating the `KongKey` object in your Kubernetes cluster will provision a {{site.konnect_product_name}} key in
your [Gateway Manager](/konnect/gateway-manager).
You can refer to the CR [API](/gateway-operator/{{ page.release }}/reference/custom-resources/#kongkey)
to see all the available fields.

Your `KongKey` must be associated with a `KonnectGatewayControlPlane` object that you've created in your cluster.
It will make it part of the Gateway control plane's configuration.

`KongKey` supports two types of keys: JWK and PEM. You can create a PEM `KongKey` by providing `spec.pem.private_key`
and `spec.pem.public_key` fields. For JWK keys, you should provide `spec.jwk` field with the JWK key string
representation.

For this example, we will create a PEM `KongKey` by applying the following YAML manifest:

```yaml
echo '
kind: KongKey
apiVersion: configuration.konghq.com/v1alpha1
metadata:
  name: key
  namespace: default
spec:
  controlPlaneRef:
    type: konnectNamespacedRef # This indicates that an in cluster reference is used
    konnectNamespacedRef:
      name: gateway-control-plane # Reference to the KonnectGatewayControlPlane object
  kid: key-id
  name: key
  pem:
    private_key: | # Sample private key in PEM format, replace with your own
      -----BEGIN PRIVATE KEY-----
      MIIBVQIBADANBgkqhkiG9w0BAQEFAASCAT8wggE7AgEAAkEA4f5Ur6EzZKsfu0ct
      QCmmbCkUohHp6lAgGGmVmQpj5Xrx5jrjGWWdDAF1ADFPh/XMC58iZFaX33UpGOUn
      tuWbJQIDAQABAkEAxqXvvL2+1iNRbiY/kWHLBtIJb/i9G5i4zZypwe+PJduIPRlH
      4bFHih8sHtYt5rEs4RnT0SJnZN1HKhJcisVLdQIhAPKboGS0dTprmMLrAXQh15p7
      xz4XUbZrNqPct+hqa5JXAiEA7nfrjPYm2UXKRzvFo9Zbd9K/Y3M0Xas9LsXdRaO8
      6OMCIAhkX8D8CQ4TSL59WJiGzyl13KeGMPppbQNwECCHBd+TAiB8dDOHprORsz2l
      PYmhPu8PsvpVkbtjo0nUDkmz3Ydq1wIhAIMCsZQ7A3H/kN88aYsqKeGg9c++yqIP
      /9xIOKHsjlB4
      -----END PRIVATE KEY-----
    public_key: | # Sample public key in PEM format, replace with your own
      -----BEGIN PUBLIC KEY-----
      MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBAOH+VK+hM2SrH7tHLUAppmwpFKIR6epQ
      IBhplZkKY+V68eY64xllnQwBdQAxT4f1zAufImRWl991KRjlJ7blmyUCAwEAAQ==
      -----END PUBLIC KEY-----
  ' | kubectl apply -f -
```

{% include md/kgo/check-condition.md name='key' kind='KongKey' %}

At this point, you should see the key in the Gateway Manager UI.

## Create a Key Set

Creating the `KongKeySet` object in your Kubernetes cluster will provision a {{site.konnect_product_name}} key set in
your [Gateway Manager](/konnect/gateway-manager). You can refer to the CR [API](/gateway-operator/{{ page.release
}}/reference/custom-resources/#kongkeyset)
to see all the available fields.

Your `KongKeySet` must be associated with a `KonnectGatewayControlPlane` object that you've created in your cluster.

To create a `KongKeySet`, you can apply the following YAML manifest:

```yaml
echo '
kind: KongKeySet
apiVersion: configuration.konghq.com/v1alpha1
metadata:
  name: key-set
  namespace: default
spec:
  controlPlaneRef:
    type: konnectNamespacedRef # This indicates that an in cluster reference is used
    konnectNamespacedRef:
      name: gateway-control-plane # KonnectGatewayControlPlane reference
  name: key-set
  ' | kubectl apply -f -
```

{% include md/kgo/check-condition.md name='key-set' kind='KongKeySet' %}

At this point, you should see the key set in the Gateway Manager UI.

### Associate the Key with the Key Set

A single `KongKey` can be associated with only one `KongKeySet`. To associate a `KongKey` with a `KongKeySet`, you need
to update the `KongKey` object with the `keySetRef` field. You can do this by applying the following YAML manifest:

```yaml
echo '
kind: KongKey
apiVersion: configuration.konghq.com/v1alpha1
metadata:
  name: key
  namespace: default
spec:
  controlPlaneRef:
    type: konnectNamespacedRef # This indicates that an in cluster reference is used
    konnectNamespacedRef:
      name: gateway-control-plane # KonnectGatewayControlPlane reference
  kid: key-id
  name: key
  pem:
    private_key: | # Sample private key in PEM format, replace with your own
      -----BEGIN PRIVATE KEY-----
      MIIBVQIBADANBgkqhkiG9w0BAQEFAASCAT8wggE7AgEAAkEA4f5Ur6EzZKsfu0ct
      QCmmbCkUohHp6lAgGGmVmQpj5Xrx5jrjGWWdDAF1ADFPh/XMC58iZFaX33UpGOUn
      tuWbJQIDAQABAkEAxqXvvL2+1iNRbiY/kWHLBtIJb/i9G5i4zZypwe+PJduIPRlH
      4bFHih8sHtYt5rEs4RnT0SJnZN1HKhJcisVLdQIhAPKboGS0dTprmMLrAXQh15p7
      xz4XUbZrNqPct+hqa5JXAiEA7nfrjPYm2UXKRzvFo9Zbd9K/Y3M0Xas9LsXdRaO8
      6OMCIAhkX8D8CQ4TSL59WJiGzyl13KeGMPppbQNwECCHBd+TAiB8dDOHprORsz2l
      PYmhPu8PsvpVkbtjo0nUDkmz3Ydq1wIhAIMCsZQ7A3H/kN88aYsqKeGg9c++yqIP
      /9xIOKHsjlB4
      -----END PRIVATE KEY-----
    public_key: | # Sample public key in PEM format, replace with your own
      -----BEGIN PUBLIC KEY-----
      MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBAOH+VK+hM2SrH7tHLUAppmwpFKIR6epQ
      IBhplZkKY+V68eY64xllnQwBdQAxT4f1zAufImRWl991KRjlJ7blmyUCAwEAAQ==
      -----END PUBLIC KEY-----
  keySetRef:
    type: namespacedRef
    namespacedRef:
      name: key-set # KongKeySet reference
  ' | kubectl apply -f -
```

You can verify the `KongKey` was successfully associated with the `KongKeySet` by checking its `KeySetRefValid`
condition.

```shell
kubectl get kongkey key -o=jsonpath='{.status.conditions}' | jq '.[] | select(.type == "KeySetRefValid")'
```

The output should look similar to this:

```console
{
  "observedGeneration": 2,
  "reason": "Valid",
  "status": "True",
  "type": "KeySetRefValid"
}
```

At this point, you should see the key associated with the key set in the Gateway Manager UI.
