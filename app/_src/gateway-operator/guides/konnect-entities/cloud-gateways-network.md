---
title: Cloud Gateways Networks
---

{% assign entity = "Network" %}
{% assign crd = "KonnectCloudGatewayNetwork" %}

In this guide you'll learn how to use the `{{ crd }}` custom resource to
manage {{site.konnect_product_name}} Dedicated Cloud Gateways Networks natively from your Kubernetes cluster.

{% include md/kgo/konnect-entities-prerequisites.md disable_accordian=false version=page.version release=page.release
with-control-plane=false %}

{% include md/kgo/konnect-cloud-gateways-provider-account.md entity='Network' %}

## Create a Cloud Gateway {{ entity }}

Creating the `{{ crd }}` object in your Kubernetes cluster will provision a new {{site.konnect_short_name }} Dedicated Cloud Gateway {{ entity }}.

You can refer to the [`{{ crd }}` CRD API](/gateway-operator/{{ page.release }}/reference/custom-resources/#konnectcloudgatewaynetwork)
for all the available fields.

To create a `{{ crd }}` object you can use the following YAML manifest:

```bash
echo '
kind: {{ crd }}
apiVersion: konnect.konghq.com/v1alpha1
metadata:
 name: konnect-network-1
 namespace: default
spec:
 name: network1
 cloud_gateway_provider_account_id: "001111111111"
 availability_zones:
 - euw1-az1
 - euw1-az2
 - euw1-az3
 cidr_block: "192.168.0.0/16"
 region: eu-west-1
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
