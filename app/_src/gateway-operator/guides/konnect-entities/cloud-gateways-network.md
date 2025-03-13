---
title: Cloud Gateways Networks
---

In this guide you'll learn how to use the `KonnectCloudGatewayNetwork` custom resource to
manage {{site.konnect_product_name}} Dedicated Cloud Gateways Networks natively from your Kubernetes cluster.

{% include md/kgo/konnect-entities-prerequisites.md disable_accordian=false version=page.version release=page.release
with-control-plane=false %}

## Provider Account

In order to mange Cloud Gateway networks you need to have a Cloud Gateway Provider Account associated with your {{site.konnect_product_name}} account.

To create one, please contact your Kong Account Manager.

If you already have one, you can use the [{{site.konnect_short_name }}'s `/cloud-gateways/provider-accounts` API][provider_account_list_api]
to get the `id` of the provider account.

```bash
curl -s -H 'Content-Type: application/json' -H "Authorization: Bearer ${KONNECT_TOKEN}" -XGET https://global.api.konghq.com/v2/cloud-gateways/provider-accounts | jq
```

[provider_account_list_api]: /konnect/api/cloud-gateways/latest/#/operations/list-provider-accounts

This should return a list of provider accounts, you can use the `id` of the account you want to use to create a Cloud Gateway Network.

```
{
  "data": [
    {
      "id": "11111111-1111-1111-1111-111111111111",
      "provider": "aws",
      "provider_account_id": "001111111111",
      "created_at": "2023-07-06T18:40:12.172Z",
      "updated_at": "2023-07-06T18:40:12.172Z"
    }
  ],
  "meta": {
    "page": {
      "total": 1,
      "size": 100,
      "number": 1
    }
  }
}
```

## Create a Cloud Gateway Network

Creating the `KonnectCloudGatewayNetwork` object in your Kubernetes cluster will provision a new {{site.konnect_short_name }} Dedicated Cloud Gateway Network.

You can refer to the [`KonnectCloudGatewayNetwork` CRD API](/gateway-operator/{{ page.release }}/reference/custom-resources/#konnectcloudgatewaynetwork)
for all the available fields.

To create a `KonnectCloudGatewayNetwork` object you can use the following YAML manifest:

```bash
echo '
kind: KonnectCloudGatewayNetwork
apiVersion: konnect.konghq.com/v1alpha1
metadata:
  name: konnect-network-1
  namespace: default
spec:
  name: network1
  cloud_gateway_provider_account_id: "001111111111"
  availability_zones:
  - us-west-1
  cidr_block: "10.0.0.1/24"
  region: us-west
  konnect:
    authRef:
      name: konnect-api-auth
' | kubectl apply -f -
```

After creating the network object you can check the status of the network by running:

```bash
kubectl get konnectcloudgatewaynetworks.konnect.konghq.com konnect-network-1 -o=jsonpath='{.status}' | yq -p json
```

Which should return the status of the network:

```yaml
conditions:
  - lastTransitionTime: "2025-03-13T09:16:49Z"
    message: KonnectAPIAuthConfiguration reference default/konnect-api-auth is resolved
    observedGeneration: 3
    reason: ResolvedRef
    status: "True"
    type: APIAuthResolvedRef
  - lastTransitionTime: "2025-03-13T09:16:49Z"
    message: referenced KonnectAPIAuthConfiguration default/konnect-api-auth is valid
    observedGeneration: 3
    reason: Valid
    status: "True"
    type: APIAuthValid
  - lastTransitionTime: "2025-03-13T09:18:05Z"
    message: ""
    observedGeneration: 3
    reason: Programmed
    status: "True"
    type: Programmed
id: 1111111-111111111111-11111111111111111
organizationID: 222222222-22222222-2222222222222222222
serverURL: https://global.api.konghq.com
state: initializing
```

Since creating a network can take some time, you can monitor the status of the network by checking the `state` field.
