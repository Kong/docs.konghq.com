---
title: How to configure AWS VPC Peering
---

This guide walks you through setting up a VPC Peering connection between your {{site.konnect_short_name}}-managed Dedicated Cloud Gateways and an AWS VPC, enabling private communication between the two environments.

{:.note}
> You can configure up to 10 VPC peering connections per Dedicated Cloud Gateway. VPC Peering and Transit Gateway cannot be used simultaneously with the same Dedicated Cloud Gateway instance.

## How does VPC Peering work?

VPC Peering enables direct, private IP connectivity between your AWS VPC and the {{site.konnect_short_name}} network running Dedicated Cloud Gateways. Once the peering connection is established and routing is configured, traffic can flow privately and securely between both environments without traversing the public internet.

## Prerequisites

* A {{site.konnect_short_name}} control plane
* A Dedicated Cloud Gateway network
* An AWS account with administrative privileges to accept peering requests and update route tables

## Configure AWS VPC Peering
AWS VPC Peering can be configured in the {{site.konnect_short_name}} UI and with the [Cloud Gateways API](/konnect/api/cloud-gateways/latest/).
{% navtabs %}
{% navtab Konnect UI %}
### Initiate VPC Peering in {{site.konnect_short_name}}

1. From {{site.konnect_short_name}}, navigate to the **Gateway Manager**.
1. Within the **Networks** tab, select your Dedicated Cloud Gateway network.
1. Open the **kebab menu** and select **Configure private networking**.
1. On the **VPC Peering Connection** tab, fill in the form with the following:
    * **VPC Peering Name**: A unique, friendly name for the peering connection
    * **AWS Account ID**: Your 12-digit AWS account ID, for example:`123456789012`
    * **AWS VPC ID**: The VPC ID you want to peer with for example: `vpc-0abc1234def567890`
    * **VPC CIDR**: The IP range of your AWS VPC for example: `10.0.0.0/16`
    * **VPC Region**: The AWS region where your VPC is deployed
1. Click **Initiate Peering**.

{% endnavtab %}
{% navtab Konnect API %}



```sh
curl -X 'POST' \
  'https://global.api.konghq.com/v2/cloud-gateways/networks/{NETWORKID}/transit-gateways' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
    {
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
  }
}'

```

{% endnavtab %}
{% endnavtabs %}
### Accept the Peering Request in AWS

1. Log in to the **AWS Console**.
1. Navigate to **VPC** > **Peering Connections** under **Virtual Private Cloud**.
1. Locate the pending request from {{site.konnect_short_name}}.
1. Select the request and click **Accept Request**.

### Confirm Connection in {{site.konnect_short_name}}

1. Return to the {{site.konnect_short_name}} **Gateway Manager**.
1. In the **VPC Peering** section for the network, confirm that the connection status updates to **Ready** once it is successfully established.

### Update Your AWS Route Table

1. In the AWS Console, go to **VPC** > **Route Tables**.
1. Select the route table associated with the subnet in your VPC.
1. Edit the routes and add a new route:
    * **Destination**: The CIDR block of your {{site.konnect_short_name}} Dedicated Cloud Gateway network.
    * **Target**: Select the VPC peering connection you accepted.
1. Save the changes.

This routing configuration ensures that traffic between your AWS VPC and the {{site.konnect_short_name}} network flows correctly through the VPC peering connection.



## More information

* [Dedicated Cloud Gateways overview](/konnect/gateway-manager/dedicated-cloud-gateways/): Learn more about Dedicated Cloud Gateway features and use cases.