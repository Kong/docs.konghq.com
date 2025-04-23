---
title: How to configure AWS Transit Gateway
---


This guide walks you through connecting your {{site.konnect_short_name}}-managed Dedicated Cloud Gateways to AWS Transit Gateway, providing a secure and private channel for your API traffic.

## How do Transit Gateways work?

{% include_cached /md/konnect/cloud-gateway-networking.md %}

> _**Figure 3:** In this diagram, the User AWS account represents you are running your microservices, APIs, or applications. 
You can connect your infrastructure securely to {{site.konnect_short_name}} through an AWS Transit Gateway. 
On the Kong side, the Kong AWS Cloud is the cloud account running your Dedicated Cloud Gateways, which ingests traffic coming in from the Transit Gateway and securely exposes it to the internet._

To establish private connectivity between the {{site.konnect_short_name}} network and your account or VPC, you need to allow traffic via the [AWS RAM shared resource flow](https://docs.aws.amazon.com/ram/latest/userguide/shareable.html). 

## Prerequisites 


* A {{site.konnect_short_name}} control plane
* An AWS account with administrative privileges to create resources and manage peering
* The **AWS ID**. You can find this in {{site.konnect_short_name}} by selecting the desired Network from **Gateway Manager** > **Networks**

## Configure AWS Transit Gateway

1. While logged in to AWS, select the same region as your cloud gateways network. 
1. Select **VPC** > **Transit Gateways**, then click **Create transit gateway**.
1. Name the transit gateway and then click **Create transit gateway**. 

This will display a **Transit Gateway ID**, save this. 

### Configure AWS resources access

1. Navigate to the **Resource Access Manager**, then click **Create Resource Share**. 
1. Select **Transit Gateways** as the resource type, and check the box for the transit gateway that you created in the previous section.
1. Give the Resource Share a name.
1. Click **Next** and leave the default managed permission settings as they are.
1. On the next screen, select **Allow external accounts** and then choose **AWS Account**. Paste the **AWS ID** you copied from {{site.konnect_short_name}}.
1. Click **Add**, and review your settings before clicking **Create**.

After creating the resource share, copy the **RAM Share ARN**. You will need this to finish configuration in {{site.konnect_short_name}}

### Configure {{site.konnect_short_name}}

1. From {{site.konnect_short_name}}, navigate to the **Gateway Manager**.
1. Within the **Networks** tab, select the desired network, then select **Attach Transit Gateway**.
1. In the form that appears, enter a **Transit Gateway Name**.
1. Add one or more CIDR blocks that will be forwarded to your AWS Transit Gateway. Ensure these do not overlap with the CIDR of your cloud gateways network.
1. Paste the **RAM Share ARN** and the **Transit Gateway ID** you saved earlier into the matching fields.
1. For DNS configuration, add the IP addresses of DNS servers that will resolve to your private domains, along with any domains you want associated with your DNS. {{site.konnect_short_name}} supports the following mappings:
    * 1-1 Mapping
        * Each domain is mapped to a unique IP address.
        * For example: `example.com` -> `192.168.1.1`
    * N-1 Mapping
        * Multiple domains are mapped to a single IP address.
        * `example.com`, `example2.com` -> `192.168.1.1`
    * M-N Mapping
        * Multiple domains are mapped to multiple IP addresses, not necessarily in a one-to-one relationship.
        * `example.com`, `example2.com` -> `192.168.1.1`, `192.168.1.2`
        * `example3.com` -> `192.168.1.1`
1. **Save**.

### Accept Transit Gateway attachment request

1. From the **AWS Console**, go to  **VPC** > **Transit Gateway Attachments**.
1. Wait for an attachment request coming from the AWS Account ID you used in {{site.konnect_short_name}}.
1. Accept the attachment to complete the setup.

### Configure AWS Transit Gateway and VPC Routing Tables

To properly route traffic between your AWS VPCs and Kong Dedicated Cloud Gateways (DCGWs) via AWS Transit Gateway, additional routing steps are required:

1. From your AWS Console, navigate to **VPC > Transit Gateways**.
1. Select your transit gateway, then select **Transit Gateway Attachments**.
1. Click **Create transit gateway attachment** and attach each AWS VPC that needs connectivity to your Kong DCGW.
1. After attachments are created, navigate to **Transit Gateway Route Tables**.
1. If the attachment is associated with (and propagating to) the route table, the VPC CIDRs appears automatically. 
1. If not, select the relevant Transit Gateway route table, then click **Create route** to add routes to your Kong DCGW VPC CIDR range and AWS VPC CIDR ranges. Ensure these CIDR blocks do not overlap.
1. Next, navigate to your AWS VPCs, select **Route Tables**, and update your route tables:
    * Add a new route for the Kong DCGW VPC CIDR with the **Target** set to your **Transit Gateway ID**.
    * For example:  
      `Destination: 192.168.0.0/16` -> `Target: tgw-xxxxxxxx`
1. Verify your AWS Security Groups and Network ACLs:
    * Allow necessary inbound/outbound traffic for ports and protocols used by your upstream applications and Kong DCGW.
    * Ensure Network ACLs permit traffic between AWS VPCs and Kong DCGW.
1. Confirm connectivity by testing communication between your AWS VPC resources and Kong DCGW endpoints (e.g., using ping, telnet, or traceroute).    

Once the transit gateway attachment is successful and you've configured routing in your AWS VPC, add a route where the upstream services are running, and configure the route to forward all traffic for the {{site.konnect_short_name}} managed VPC via the transit gateway. This ensures that traffic from the {{site.konnect_short_name}} data plane reaches the service and the response packets are routed back correctly.


## More information

* [Dedicated Cloud Gateways](/konnect/gateway-manager/dedicated-cloud-gateways/)
* [Network Resiliency and availability](/konnect/network-resiliency/)
* [Getting started with transit gateways - Amazon VPC](https://docs.aws.amazon.com/vpc/latest/tgw/tgw-getting-started.html)
