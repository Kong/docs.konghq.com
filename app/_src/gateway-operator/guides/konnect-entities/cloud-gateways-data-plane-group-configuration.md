---
title: Cloud Gateways Data Plane Group Configurations
---

{% assign entity = "Data Plane Group Configuration" %}
{% assign crd = "KonnectCloudGatewayDataPlaneGroupConfiguration" %}

In this guide you'll learn how to use the `{{ crd }}` custom resource to
manage {{site.konnect_product_name}} Dedicated Cloud Gateways {{ entity }}s natively from your Kubernetes cluster.

{% include md/kgo/konnect-entities-prerequisites.md disable_accordian=false version=page.version release=page.release
with-control-plane=true control_plane_type="dcgw" create_network=true %}

## Create a Cloud Gateway {{ entity }}

Creating the `{{ crd }}` object in your Kubernetes cluster will provision a new {{site.konnect_short_name }} Dedicated Cloud Gateway {{ entity }}.

You can refer to the [`{{ crd }}` CRD API](/gateway-operator/{{ page.release }}/reference/custom-resources/#konnectcloudgatewaynetwork)
for all the available fields.

> Note: Creating multiple {{ entity }}s will cause overwriting each others configurations.
> There can only exist one {{ entity }} per one Cloud Gateway which sets the configuration
> for all the Data Plane Groups.

To create a `{{ crd }}` object you can use the following YAML manifest:

```bash
echo '
apiVersion: konnect.konghq.com/v1alpha1
kind: {{ crd }}
metadata:
  name: konnect-cg-dpconf
spec:
  api_access: private+public
  version: "{{ site.data.kong_latest_gateway.ee-version | split: "." | slice: 0,2 | join: "." }}"
  dataplane_groups:
    - provider: aws
      region: eu-west-1
      networkRef:
        type: namespacedRef
        namespacedRef:
         name: konnect-network-1
      autoscale:
        type: static
        static:
          instance_type: small
          requested_instances: 2
      environment:
        - name: KONG_LOG_LEVEL
          value: debug
  controlPlaneRef:
    type: konnectNamespacedRef
    konnectNamespacedRef:
     name: gateway-control-plane
' | kubectl apply -f -
```

After creating the `{{ crd }}` you can check the status by running:

```bash
kubectl get {{ crd | downcase }}s.konnect.konghq.com konnect-cg-dpconf -o=jsonpath='{.status}' | yq -p json
```

Which should return the status of the {{ entity }}:

```yaml
conditions:
  - lastTransitionTime: "2025-04-02T11:02:23Z"
    message: ""
    observedGeneration: 1
    reason: Programmed
    status: "True"
    type: Programmed
  - lastTransitionTime: "2025-04-02T10:31:15Z"
    message: Referenced ControlPlane <konnectNamespacedRef:gateway-control-plane> is programmed
    observedGeneration: 1
    reason: Valid
    status: "True"
    type: ControlPlaneRefValid
  - lastTransitionTime: "2025-04-02T10:31:15Z"
    message: KonnectAPIAuthConfiguration reference default/konnect-api-auth is resolved
    observedGeneration: 1
    reason: ResolvedRef
    status: "True"
    type: APIAuthResolvedRef
  - lastTransitionTime: "2025-04-02T10:31:15Z"
    message: referenced KonnectAPIAuthConfiguration default/konnect-api-auth is valid
    observedGeneration: 1
    reason: Valid
    status: "True"
    type: APIAuthValid
  - lastTransitionTime: "2025-04-02T11:02:22Z"
    message: Referenced KonnectCloudGatewayNetwork(s) are valid and programmed
    observedGeneration: 1
    reason: Valid
    status: "True"
    type: KonnectNetworkRefsValid
controlPlaneID: 22222222-2222-2222-2222-222222222222
dataplane_groups:
  - cloud_gateway_network_id: 19cb7627-1111-1111-1111-111111111111
    id: a94bb897-1111-1111-1111-111111111111
    provider: aws
    region: eu-west-1
    state: initializing
id: 35fe5b8b-1111-1111-1111-111111111111
organizationID: 8a6e97b1-b481-4fc2-8399-a59077076af6
serverURL: https://eu.api.konghq.tech
```

If one of the referenced networks is not ready yet, the status can look like this:

```yaml
conditions:
  - lastTransitionTime: "2025-04-02T10:31:15Z"
    message: Some conditions have status set to False
    observedGeneration: 1
    reason: ConditionWithStatusFalseExists
    status: "False"
    type: Programmed
  - lastTransitionTime: "2025-04-02T10:31:15Z"
    message: Referenced ControlPlane <konnectNamespacedRef:gateway-control-plane> is programmed
    observedGeneration: 1
    reason: Valid
    status: "True"
    type: ControlPlaneRefValid
  - lastTransitionTime: "2025-04-02T10:31:15Z"
    message: KonnectAPIAuthConfiguration reference default/konnect-api-auth is resolved
    observedGeneration: 1
    reason: ResolvedRef
    status: "True"
    type: APIAuthResolvedRef
  - lastTransitionTime: "2025-04-02T10:31:15Z"
    message: referenced KonnectAPIAuthConfiguration default/konnect-api-auth is valid
    observedGeneration: 1
    reason: Valid
    status: "True"
    type: APIAuthValid
  - lastTransitionTime: "2025-04-02T10:31:15Z"
    message: 'Referenced KonnectCloudGatewayNetwork default/konnect-network-1: is not ready yet, current state: initializing'
    observedGeneration: 1
    reason: Invalid
    status: "False"
    type: KonnectNetworkRefsValid
controlPlaneID: 22222222-2222-2222-2222-222222222222
```

It will change when the network provisioning is finished.

Since creating a {{entity}} can take some time, you can monitor its status by checking the `dataplane_groups` field.
{{ entity }}s receive this field when they are successfully provisioned in {{ site.konnect_short_name }}.

To check said status, you can run:

```bash
kubectl get {{ crd | downcase }}s.konnect.konghq.com eu-west-1 -o=jsonpath='{.status.dataplane_groups}' | yq -p json
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
    "region": "eu-west-1",
    "state": "ready"
  }
]
```
