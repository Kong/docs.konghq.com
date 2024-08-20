---
title: Connect your Data Plane to Konnect Control Plane over PrivateLink
subtitle: Sync configurations privately to stay compliant and save data transfer costs
content-type: reference
---
## Steps

<ol>

<li>
Connect the AWS Console to your <b>data plane region</b> and create a VPC endpoint.

<center>
<img src="/assets/images/docs/privatelink-1.png" alt="" style="width: 600px; margin-top:10px; margin-bottom:10px">
</center>
</li>

<li>
Include the Konnect <b>control plane geo</b> <i>(for example: US)</i> you want to connect to in the endpoint name. In this example, we are connecting to Konnect in US geo. Next, choose <i>Other Endpoint Services</i> under Service Category.

<center>
<img src="/assets/images/docs/privatelink-2.png" alt="" style="width: 600px; margin-top:10px; margin-bottom:10px">
</center>
</li>

<li>
Choose your data plane region from the menu below.
{% navtabs %}

{% navtab ap-southeast-2 %}
| Konnect Geographical Region | PrivateLink service name | Private DNS name
| ------ | ------------ |
| AP | com.amazonaws.vpce.ap-southeast-2.vpce-svc-05526f43d36cc10e1 | ap.svc.konghq.com
| EU | com.amazonaws.vpce.ap-southeast-2.vpce-svc-02392dc520d2d9ad9 | eu.svc.konghq.com
| ME | com.amazonaws.vpce.ap-southeast-2.vpce-svc-013380defe9ad33b6 | me.svc.konghq.com
| US | com.amazonaws.vpce.ap-southeast-2.vpce-svc-0d986920a41ab0b80 | us.svc.konghq.com
{% endnavtab %}

{% navtab eu-central-1 %}
| Konnect Geographical Region | PrivateLink service name | Private DNS name
| ------ | ------------ |
| AP | com.amazonaws.vpce.eu-central-1.vpce-svc-0c3f0574080bdd859 | ap.svc.konghq.com
| EU | com.amazonaws.vpce.eu-central-1.vpce-svc-05e6822fbce58e1a0 | eu.svc.konghq.com
| ME | com.amazonaws.vpce.eu-central-1.vpce-svc-0e6497e6df9928a80 | me.svc.konghq.com
| US | com.amazonaws.vpce.eu-central-1.vpce-svc-01d3dd232e277feeb | us.svc.konghq.com
{% endnavtab %}

{% navtab us-east-2 %}
| Konnect Geographical Region | PrivateLink service name | Private DNS name
| ------ | ------------ |
| AP | com.amazonaws.vpce.us-east-2.vpce-svc-03da89378358921bc | ap.svc.konghq.com
| EU | com.amazonaws.vpce.us-east-2.vpce-svc-0cb28c923823735ac | eu.svc.konghq.com
| ME | com.amazonaws.vpce.us-east-2.vpce-svc-0f1c86fb6399d4fe5 | me.svc.konghq.com
| US | com.amazonaws.vpce.us-east-2.vpce-svc-096fe7ba54ebc32db | us.svc.konghq.com
{% endnavtab %}
{% endnavtabs %}
Now choose the <b>control plane geo</b> from the table and copy the corresponding <i>PrivateLink service name</i>.
</li>

<li>
Fill the <i>Service Name</i> text box using the copied value and click <i>Verify service</i>.

<center>
<img src="/assets/images/docs/privatelink-3.png" alt="" style="width: 600px; margin-top:10px; margin-bottom:10px">
</center>

If this does not return <i>Service name verified</i> or if your data plane region is not yet supported, reach out to Kong support.
</li>

<li>
Choose the VPC, subnets, and security group to associate with this endpoint. 
Notes:
<ul>
<li>
The security group must accept inbound traffic on TCP port 443
</li>
<li>
Under the VPC additional settings, ensure that <i>Enable DNS name</i> is ticked
<center>
<img src="/assets/images/docs/privatelink-4.png" alt="" style="width: 600px; margin-top:10px; margin-bottom:10px">
</center>
</li>
</ul>
</li>

<li>
Create the VPC Endpoint and wait for its status to change to available. It is recommended to wait for 10 minutes before attempting to use it.
</li>

<li>
Now you can configure your data plane to connect to the control plane using the <i>Private DNS Name</i> corresponding to the control plane geo you are using. You can get that from the table above.
</li>
</ol>
Example of Kong DP Configuration:
```sh
cluster_control_plane = us.svc.konghq.com/cp/{cluster_prefix}
cluster_server_name = us.svc.konghq.com
```
