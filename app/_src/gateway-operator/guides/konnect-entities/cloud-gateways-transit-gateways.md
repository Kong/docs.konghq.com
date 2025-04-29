---
title: Cloud Gateways Networks
---

{% assign entity = "TransitGateway" %}
{% assign crd = "KonnectCloudGatewayTransitGateway" %}

In this guide you'll learn how to use the `{{ crd }}` custom resource to
manage {{site.konnect_product_name}} Dedicated Cloud Gateways {{ entity }}s natively from your Kubernetes cluster.

{% include md/kgo/konnect-entities-prerequisites.md disable_accordian=false version=page.version release=page.release
with-control-plane=true control_plane_type="dcgw" create_network=true %}

## Create a Transit Gateway in Cloud Provider

To use transit gateway, you need to create a transit gateway in your cloud provider. You should create the transit gateway in the same region of the same provider as the {{site.konnect_short_name}} network is in.
For example. if you want to create a transit gateway in the {{site.konnect_short_name}} network in the EU southwest region of AWS, you should also create the transit gateway in the EU southwest region of AWS.
Currently we support [AWS Transit Gateway](/konnect/gateway-manager/dedicated-cloud-gateways/transit-gateways) and [Azure Virtual Network Gateway](/konnect/gateway-manager/dedicated-cloud-gateways/azure-peering).
You can refer to the {{site.konnect_short_name}} documents above to see how to create transit gateways and how to save the configuration used to create `{{ crd }}`s.


## Create a Cloud Gateway {{ entity }}

Creating the `{{ crd }}` object in your Kubernetes cluster will provision a new {{site.konnect_short_name }} Dedicated Cloud Gateway {{ entity }}.

You can refer to the [`{{ crd }}` CRD API](/gateway-operator/{{ page.release }}/reference/custom-resources/#konnectcloudgatewaytransitgateway)
for all the available fields.

To create a `{{ crd }}` object you can use the following YAML manifest:

```bash
echo '
kind: {{ crd }}
apiVersion: konnect.konghq.com/v1alpha1
metadata:
  name: konnect-aws-transit-gateway-1
  namespace: default
spec:
  networkRef:
    type: namespacedRef
    namespacedRef:
      name: konnect-network-1 
  type: AWSTransitGateway
  awsTransitGateway:
    name: "aws-transit-gateway-1"
    cidr_blocks:
    - "10.10.0.0/24"
    attachment_config:
       # The transit gateway ID in the step of creating transit gateway in AWS
      transit_gateway_id: "tgw-0123456789abcdef10"
      # The RAM share ARN in the step of sharing the transit gateway in AWS
      ram_share_arn: "arn:aws:ram:eu-southwest-1:000011112222:resource-share/c001face-abcd-1234-9009-90091ea3a20c"
' | kubectl apply -f -
```

After the `status.state` of `KonnectCloudGatewayNetwork` it refers to becomes ready, the `{{crd}}` will be configured in {{site.konnect_short_name}}.
You can fetch the status by:

```bash
kubectl get {{ crd | downcase }}s.konnect.konghq.com konnect-aws-transit-gateway-1 -o=jsonpath='{.status}' | yq -p json
```
Which should return the status of the transit gateway:

```yaml
conditions:
  - lastTransitionTime: "2025-04-23T09:16:49Z"
    message: KonnectAPIAuthConfiguration reference default/konnect-api-auth is resolved
    observedGeneration: 3
    reason: ResolvedRef
    status: "True"
    type: APIAuthResolvedRef
  - lastTransitionTime: "2025-04-23T09:16:49Z"
    message: referenced KonnectAPIAuthConfiguration default/konnect-api-auth is valid
    observedGeneration: 3
    reason: Valid
    status: "True"
    type: APIAuthValid
  - lastTransitionTime: "2025-04-23T09:16:49Z"
    message: Referenced KonnectCloudGatewayNetwork(s) are valid and programmed
    observedGeneration: 3
    reason: Valid
    status: "True"
    type: KonnectNetworkRefsValid
  - lastTransitionTime: "2025-04-23T09:16:49Z"
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

Since creating a transit gateway can take some time, you can monitor the status of the transit gateway by checking the `status.state` field.

### Accept Transit Gateway Attachment Request

For AWS transit gateways, there is one more step to let the transit gateways turn to `ready`. After the transit gateway created in {{site.konnect_short_name}},
its `status.state` will become `pending-acceptance` in several minutes. This means {{site.konnect_short_name}} has sent the request to AWS to accept attaching the transit gateway.
You need to accept the attaching in AWS following the guide of [AWS Transit Gateway#Accept Transit Gateway attachment request](/konnect/gateway-manager/dedicated-cloud-gateways/transit-gateways/#accept-transit-gateway-attachment-request).

After you accept the attachment request, the `status.state` of the `{{crd}}` should become `ready` in some time.
