---
title: Set up an AWS VPC peering connection with Dedicated Cloud Gateways
---

This guide walks you through setting up a VPC peering connection between your {{site.konnect_short_name}}-managed Dedicated Cloud Gateways and an AWS VPC, enabling private communication between the two environments.

{:.note}
> You can configure up to 10 VPC peering connections per Dedicated Cloud Gateway. VPC Peering and Transit Gateway cannot be used simultaneously with the same Dedicated Cloud Gateway instance.

## How does VPC peering work?

VPC peering enables direct, private IP connectivity between your AWS VPC and the {{site.konnect_short_name}} network running Dedicated Cloud Gateways. Once the peering connection is established and routing is configured, traffic can flow privately and securely between both environments without traversing the public internet.

## Prerequisites

* A {{site.konnect_short_name}} control plane
* A [Dedicated Cloud Gateway](https://cloud.konghq.com/gateway-manager/create-control-plane) network
* An AWS account with administrative privileges to accept peering requests and update route tables

## Configure AWS VPC peering

You can configure AWS VPC peering using the {{site.konnect_short_name}} UI or the [Cloud Gateways API](/konnect/api/cloud-gateways/latest/).

### Initiate VPC peering in {{site.konnect_short_name}}
{% navtabs %}
{% navtab Konnect UI %}

1. In {{site.konnect_short_name}}, navigate to [**Gateway Manager**](https://cloud.konghq.com/gateway-manager/) and select your control plane.
1. From the **Networks** tab, select your Dedicated Cloud Gateway network.
1. From the menu, select **Configure private networking**.
1. From the **VPC Peering Connection** tab, configure the following:
    * **VPC Peering Name**: A unique, readable name for the peering connection
    * **AWS Account ID**: Your 12-digit AWS account ID, for example:`123456789012`
    * **AWS VPC ID**: The VPC ID you want to peer with, for example: `vpc-0abc1234def567890`
    * **VPC CIDR**: The IP range of your AWS VPC, for example: `10.0.0.0/16`
    * **VPC Region**: The AWS region where your VPC is deployed
1. Click **Initiate Peering**.

{% endnavtab %}
{% navtab Konnect API %}

To initiate peering, send a POST request to the `/transit-gateways` endpoint:

```sh
curl -X 'POST' \
  'https://global.api.konghq.com/v2/cloud-gateways/networks/{networkId}/transit-gateways' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -H "Authorization: Bearer $KONNECT_TOKEN" \
  -d '{
    "name": "us-east-2 vpc peering",
    "cidr_blocks": [
      "10.0.0.0/16"
    ],
    "transit_gateway_attachment_config": {
      "kind": "aws-vpc-peering-attachment",
      "peer_account_id": "123456789012",
      "peer_vpc_id": "vpc-0f1e2d3c4b5a67890",
      "peer_vpc_region": "us-east-2"
    }
  }'

```

Be sure to replace `{networkId}` with the UUID of your network in {{site.konnect_short_name}} and `KONNECT_TOKEN` with your [{{site.konnect_short_name}} personal access token (PAT)](/konnect/org-management/access-tokens/).

{% endnavtab %}
{% endnavtabs %}
### Accept the peering request in AWS

1. From the AWS Console, navigate to **VPC** > **Peering Connections** under **Virtual Private Cloud**.
1. Locate the pending request from {{site.konnect_short_name}}.
1. Select the request and click **Accept Request**.

### Confirm connection in {{site.konnect_short_name}}

1. In {{site.konnect_short_name}}, navigate to [**Gateway Manager**](https://cloud.konghq.com/gateway-manager/) and select your control plane.
1. In the **VPC Peering** section for the network, confirm that the connection status updates to `Ready` once it is successfully established.

### Update your AWS route table

1. In the AWS Console, go to **VPC** > **Route Tables**.
1. Select the route table associated with the subnet in your VPC.
1. Edit the routes and add a new route:
    * **Destination**: The CIDR block of your {{site.konnect_short_name}} Dedicated Cloud Gateway network.
    * **Target**: Select the VPC peering connection you accepted.
1. Save the changes.

This routing configuration ensures that traffic between your AWS VPC and the {{site.konnect_short_name}} network flows correctly through the VPC peering connection.



## More information

* [Dedicated Cloud Gateways overview](/konnect/gateway-manager/dedicated-cloud-gateways/): Learn more about Dedicated Cloud Gateway features and use cases.