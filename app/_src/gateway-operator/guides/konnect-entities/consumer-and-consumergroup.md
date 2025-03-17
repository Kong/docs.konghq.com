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

Consumers can have credentials associated with them.
In order to define credentials you can use the dedicated CRDs{% if_version gte: 1.5.x %} or define credentials in Secrets and link them using `KongConsumer` `credentials` field{% endif_version %}.

### Using CRDs

{{ site.kgo_product_name }} supports the following credential types, please refer to each type's documentation link to learn all the available fields for each credential type:

- [KongCredentialBasicAuth](/gateway-operator/{{ page.release }}/reference/custom-resources/#kongcredentialbasicauth)
- [KongCredentialAPIKey](/gateway-operator/{{ page.release }}/reference/custom-resources/#kongcredentialapikey)
- [KongCredentialACL](/gateway-operator/{{ page.release }}/reference/custom-resources/#kongcredentialacl)
- [KongCredentialJWT](/gateway-operator/{{ page.release }}/reference/custom-resources/#kongcredentialjwt)
- [KongCredentialHMAC](/gateway-operator/{{ page.release }}/reference/custom-resources/#kongcredentialhmac)

For example, you can create a `KongCredentialBasicAuth` associated with the `consumer` `KongConsumer` by applying the
following YAML manifest:

```bash
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

{% if_version gte: 1.5.x %}
### Using Secrets

To use Secrets as consumer credential definitions, you can create a Secret with the credentials and link it to the `KongConsumer` object using the `credentials` field:

```bash
echo '
kind: KongConsumer
apiVersion: configuration.konghq.com/v1
metadata:
  name: consumer1
  namespace: default
username: consumer1
spec:
  controlPlaneRef:
    type: konnectNamespacedRef
    konnectNamespacedRef:
      name: cp
credentials:
- consumer1-basic-auth1
---
kind: Secret
apiVersion: v1
metadata:
  name: consumer1-basic-auth1
  namespace: default
  labels:
    konghq.com/credential: basic-auth
stringData:
  username: username
  password: pass
  ' | kubectl apply -f -
```

This manifest should yield a consumer with a basic auth credential associated with it in {{ site.konnect_short_name }}.

We can check the validity of the credential secret reference by looking at the `CredentialSecretRefsValid` `KongConsumer` condition:

```bash
kubectl get kongconsumer consumer1 -o=jsonpath='{.status.conditions[?(@.type=="CredentialSecretRefsValid")]}' | jq
```

Should give the following output:

```yaml
{
  "lastTransitionTime": "2025-03-12T15:36:46Z",
  "message": "",
  "observedGeneration": 1,
  "reason": "Valid",
  "status": "True",
  "type": "CredentialSecretRefsValid"
}
```

#### Credential Secret Requirements

Please note that `Secret`s used as credentials have to meet certain requirements:

- each `Secret` has to be labeled using the `konghq.com/credential` label with the credential type as the value:
  - basic auth credentials should have it set to `basic-auth`
  - API key credentials should have it set to `key-auth`
  - HMAC credentials should have it set to `hmac-auth`
  - JWT credentials should have it set to `jwt`
  - ACL credentials should have it set to `acl`

- additionally each `Secret` has to contain the following fields:
  - basic auth credentials:
    - `username`: the username
    - `password`: the password
  - API key credentials:
    - `key`: the API key
  - HMAC credentials:
    - `username`: the username
    - `secret`: the secret
  - JWT credentials
    - `key`: the key
    - `algorithm`: the algorithm (please consult the [JWT plugin reference](/hub/kong-inc/jwt/#create-a-jwt-credential) for the supported algorithms)
    - `rsa_public_key`: the RSA public key (if the `algorithm` is requires it)
  - ACL credentials
    - `group`: the group
{% endif_version %}

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
