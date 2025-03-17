---
title: Cloud Gateways Data Plane Group Configurations
---

{% assign entity = "Data Plane Group Configuration" %}
{% assign crd = "KonnectCloudGatewayDataPlaneGroupConfiguration" %}

In this guide you'll learn how to use the `{{ crd }}` custom resource to
manage {{site.konnect_product_name}} Dedicated Cloud Gateways {{ entity }}s natively from your Kubernetes cluster.

{% include md/kgo/konnect-entities-prerequisites.md disable_accordian=false version=page.version release=page.release
with-control-plane=true %}

{% include md/kgo/konnect-cloud-gateways-provider-account.md entity='Data Plane Group Configuration' %}

## Create a Cloud Gateway {{ entity }}

Creating the `{{ crd }}` object in your Kubernetes cluster will provision a new {{site.konnect_short_name }} Dedicated Cloud Gateway {{ entity }}.

You can refer to the [`{{ crd }}` CRD API](/gateway-operator/{{ page.release }}/reference/custom-resources/#konnectcloudgatewaynetwork)
for all the available fields.

To create a `{{ crd }}` object you can use the following YAML manifest:

```bash
echo '
apiVersion: konnect.konghq.com/v1alpha1
kind: {{ crd }}
metadata:
  name: konnect-cg-dpconf
spec:
  api_access: private+public
  version: "3.9"
  dataplane_groups:
    - provider: aws
      region: eu-central-1
      networkRef:
        type: konnectID
        konnectID: "111111111111111111111111111111111111"
      autoscale:
        type: static
        static:
          instance_type: small
          requested_instances: 2
      environment:
        - name: KONG_LOG_LEVEL
          value: debug
    - provider: aws
      region: ap-northeast-1
      networkRef:
        type: konnectID
        konnectID: "111111111111111111111111111111111111"
      autoscale:
        type: static
        static:
          instance_type: small
          requested_instances: 2
  controlPlaneRef:
    type: konnectNamespacedRef
    konnectNamespacedRef:
     name: konnect-api-auth
' | kubectl apply -f -
```

After creating the `{{ crd }}` you can check the status by running:

```bash
kubectl get {{ crd | downcase }}s.konnect.konghq.com konnect-cg-dpconf -o=jsonpath='{.status}' | yq -p json
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

Since creating a {{entity}} can take some time, you can monitor its status by checking the `dataplane_groups` field:

```bash
kubectl get konnectcloudgatewaydataplanegroupconfigurations.konnect.konghq.com eu-central-1 -o=jsonpath='{.status.dataplane_groups}'  | jq
```

Which should return the status of the provisioned {{ entity}}s:

```json
[
  {
    "cloud_gateway_network_id": "19cb7627-1111-1111-1111-111111111111",
    "egress_ip_addresses": [
      "18.111.11.111",
      "35.111.11.111",
      "18.111.11.111"
    ],
    "id": "a94bb897-1111-1111-1111-111111111111",
    "provider": "aws",
    "region": "eu-central-1",
    "state": "ready"
  }
]
```

> Note: Creating multiple {{ entity }}s will cause overwriting each others configurations.
> There can only exist one {{ entity }} per one Cloud Gateway which sets the configuration
> for all the Data Plane Groups.
