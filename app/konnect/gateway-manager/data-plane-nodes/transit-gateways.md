---
title: How to configure Transit Gateway
---


This guide will walk you through connecting your {{site.konnect_short_name}} managed Dedicated Cloud Gateways to AWS Transit Gateway, providing a secure and private channel for your API traffic.

## Prerequsites 

Before you start setting up the Transit Gateway with your {{site.konnect_short_name}} Dedicated Cloud Gateways, ensure that you have the following prerequisites:

* A {{site.konnect_short_name}} Cloud Control Plane
* AWS account with administrative privileges to create resources and manage peering.
* The **AWS ID** which can be found in {{site.konnect_short_name}} by selecting the desired Network from **Gateway Manager** > **Networks**

## Configure AWS Transit Gateway

1. While logged in to AWS, select the same region as your cloud gateways network. 
1. Select **VPC** > **Transit Gateways**, then click **Create Transit Gateway**.
1. Name the transit gateway then click **Create Transit Gateway**. 

This will display a **Transit Gateway ID**, save this. 

### Configure AWS resources access

1. Navigate to the **Resource Access Manager**, then click  **Create Resource Share**. 
1. Select **Transit Gateways** as the resource type, and check the box for the transit gateway that you created in the previous section.
1. Give the Resource Share a name.
1. Click **Next** and leave the default managed permission settings as they are.
1. On the next screen, select **Allow external accounts** and then choose **AWS Account**. Paste the **AWS ID** you copied from {{site.konnect_short_name}}.
1. Click **Add**, and review your settings before clicking **Create**.

After creating the resource share, copy the **RAM Share ARN**. You will need this to finish configuration in {{site.konnect_short_name}}

### Configure {{site.konnect_short_name}}

1. From {{site.konnect_short_name}} navigate to the **Gateway Manager**.
1. Within the **Networks** tab, select the desired network then select **Attach Transit Gateway**.
1. In the form that appears, enter a **Transit Gateway Name**
1. Add one or more CIDR blocks that will be forwarded to your AWS Transit Gateway. Ensure these do not overlap with the CIDR of your cloud gateways network.
1. Paste the **RAM Share ARN** and the **Transit Gateway ID** you saved earlier into the matching fields.
1. For DNS configuration, add the IP addresses of DNS servers that will resolve to your private domains, along with any domains you want associated with your DNS.
1. Click **Save**.

### Accept Transit Gateway attachment request

1. From the AWS Console > VPC > Transit Gateway Attachments.
2. Wait for an attachment request coming from the **AWS Account ID** you used in {{site.konnect_short_name}}
1. Accept the attachment to complete the setup.

Once the transit gateway attachment is successful, add a route where the upstream services are running, and configure the route to forward all traffic for the {{site.konnect_short_name}} managed VPC via the transit gateway. This ensures that traffic from the {{site.konnect_short_name}} data plane reaches the service and the response packets are routed back correctly.


## More Information

* [Dedicated Cloud Gateways](/konnect/dedicated-cloud-gateways/)
* [Network Resiliency and availbility](/konnect/network-resiliency/)