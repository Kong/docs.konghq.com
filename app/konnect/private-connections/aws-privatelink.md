---
title: Create a private connection with AWS PrivateLink
subtitle: Connect your data plane to your Konnect control plane with a private connection to stay compliant and save data transfer costs.
content-type: reference
---

You can establish a private connection to ensure that the data transmitted between {{site.konnect_short_name}} and your AWS environment is secure. This private connection uses AWS PrivateLink and is available for the following AWS regions:
- ap-southeast-2
- eu-central-1
- us-east-2

If you want to create a connection with a different AWS region, contact [Kong Support](https://support.konghq.com/support/s/).

## Prerequisites

Create a VPC, subnets, and a security group in AWS. For more information, see the [AWS documentation](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html).

## Steps

1. In the AWS Console, connect to your data plane region, open the Endpoints section of the VPC dashboard and [create a new endpoint](https://docs.aws.amazon.com/vpc/latest/privatelink/create-interface-endpoint.html#create-interface-endpoint-aws).

1. Enter a name tag for the endpoint that includes the {{site.konnect_short_name}} control plane geo that you want to connect to. For example: `konnect-us-go`.

1. Select the **Other endpoint services** service category.

1. Find the correct service name for your region in the tables below. Open the tab that matches your AWS region and use the PrivateLink service name for your {{site.konnect_short_name}} geo. For example, `com.amazonaws.vpce.us-east-2.vpce-svc-096fe7ba54ebc32db` for the us-east-2 AWS region and US {{site.konnect_short_name}} geo.

{% capture tabs %}
{% navtabs %}

{% navtab ap-southeast-2 %}
| {{site.konnect_short_name}} Geographical Region | PrivateLink service name | Private DNS name |
| ------ | ------------ |
| AP | com.amazonaws.vpce.ap-southeast-2.vpce-svc-05526f43d36cc10e1 | ap.svc.konghq.com |
| EU | com.amazonaws.vpce.ap-southeast-2.vpce-svc-02392dc520d2d9ad9 | eu.svc.konghq.com |
| ME | com.amazonaws.vpce.ap-southeast-2.vpce-svc-013380defe9ad33b6 | me.svc.konghq.com |
| US | com.amazonaws.vpce.ap-southeast-2.vpce-svc-0d986920a41ab0b80 | us.svc.konghq.com |
{% endnavtab %}

{% navtab eu-central-1 %}
| {{site.konnect_short_name}} Geographical Region | PrivateLink service name | Private DNS name |
| ------ | ------------ |
| AP | com.amazonaws.vpce.eu-central-1.vpce-svc-0c3f0574080bdd859 | ap.svc.konghq.com |
| EU | com.amazonaws.vpce.eu-central-1.vpce-svc-05e6822fbce58e1a0 | eu.svc.konghq.com |
| ME | com.amazonaws.vpce.eu-central-1.vpce-svc-0e6497e6df9928a80 | me.svc.konghq.com |
| US | com.amazonaws.vpce.eu-central-1.vpce-svc-01d3dd232e277feeb | us.svc.konghq.com |
{% endnavtab %}

{% navtab us-east-2 %}
| {{site.konnect_short_name}} Geographical Region | PrivateLink service name | Private DNS name |
| ------ | ------------ |
| AP | com.amazonaws.vpce.us-east-2.vpce-svc-03da89378358921bc | ap.svc.konghq.com |
| EU | com.amazonaws.vpce.us-east-2.vpce-svc-0cb28c923823735ac | eu.svc.konghq.com |
| ME | com.amazonaws.vpce.us-east-2.vpce-svc-0f1c86fb6399d4fe5 | me.svc.konghq.com |
| US | com.amazonaws.vpce.us-east-2.vpce-svc-096fe7ba54ebc32db | us.svc.konghq.com |
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{{ tabs | indent }}

1. Verify the service. If the service name cannot be verified, contact [Kong Support](https://support.konghq.com/support/s/).

1. Once the service name is verified, select the VPC, subnets, and security groups to associate with this endpoint. Make sure that:
  * The security group accepts inbound traffic on TCP port 443.
  * The DNS name parameter in the additional settings is enabled.

1. Create the VPC endpoint and wait for its status to change to available. It is recommended to wait for 10 minutes before using it.

1. Update your data plane configuration to connect to the control plane through the private connection. Use the private DNS name that matches your control plane geo in the tables above. For the US {{site.konnect_short_name}} geo, the updated Kong data plane configuration in `kong.conf` looks like this:
```sh
cluster_control_plane = us.svc.konghq.com/cp/{cluster_prefix}
cluster_server_name = us.svc.konghq.com
```
