---
title: Securing Backend Traffic
---

When using Dedicated Cloud Gateways, it's important to ensure that your upstream API is only receiving traffic from your Cloud Gateway. This ensures that your routing rules, custom logic and policies are applied to all traffic. To do this, you need to secure the communications between Cloud Gateways and your upstream APIs. There are several ways to do this securely. 

## AWS Transit Gateway
If you are using Dedicated Cloud Gateways and your upstream services are hosted in AWS, AWS Transit Gateway is the preferred method for most users. For more information and a guide on how to attach your Dedicated Cloud Gateway, please refer to the [Transit Gateways](/konnect/gateway-manager/dedicated-cloud-gateways/transit-gateways/) documentation.


## Azure VNet Peering
If you are using Dedicated Cloud Gateways and your upstream services are hosted in Azure, VNet Peering is the preferred method for most users. For more information and a guide on how to attach your Dedicated Cloud Gateway, please refer to the [Azure Peering](/konnect/gateway-manager/dedicated-cloud-gateways/azure-peering/) documentation.
https://docs.konghq.com/konnect/gateway-manager/dedicated-cloud-gateways/azure-peering/

## Using a Shared Secret
In this method, your upstream API is configured to only authorize traffic that contains a known shared API token or secret. We will configure {{site.base_gateway}} to inject the shared secret as a header into every request sent to the backend. Then {{site.base_gateway}} and the ecosystem of plugins can be leveraged to implement additional or alternative security measures, rate limiting, or other functionality on top of the web app, while ensuring that no unproxied traffic is authorized. For more information, please refer to the [Serverless](/konnect/gateway-manager/serverless-gateways/securing-backend-traffic/) documentation.

## FAQ

Q: Why isn’t AWS PrivateLink recommended for connecting Kong Dedicated Cloud Gateway to my upstream services?

A: AWS PrivateLink offers secure and private connectivity by routing traffic through an endpoint, but it only supports unidirectional communication. This means that Dedicated Cloud Gateway can send requests to your upstream services, but your upstream services cannot initiate communication back to the gateway (or vice-versa: Dedicated Cloud Gateways cannot send requests to your upstream service]. For many use cases requiring bidirectional communication—such as callbacks or dynamic interactions between the gateway and your upstream services. For this reason, PrivateLink is not generally recommended for secure connectivity to your upstream services. 





