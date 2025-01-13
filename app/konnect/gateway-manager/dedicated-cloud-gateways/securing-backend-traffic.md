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
In this method, your upstream API is configured to only authorize traffic that contains a known shared API token or secret. We will configure {{site.base_gateway}} to inject the shared secret as a header into every request sent to the backend. Then {{site.base_gateway}} and the ecosystem of plugins can be leveraged to implement additional or alternative security measures, rate limiting, or other functionality on top of the web app, while ensuring that no unproxied traffic is authorized. 

### Prerequisites

* A web application that is accessible to the public internet.
* The application endpoints are secured by a known API token. 

{% navtabs %}
{% navtab UI %}
1. From [Gateway Manager](https://cloud.konghq.com/gateway-manager), click the name of the Dedicated Cloud CP that you want to configure.

1. Click **Gateway Services** in the navigation sidebar and select the service you want to secure.

1. Click the **Plugins** tab, then click the **New Plugin** button.

1. Find the **Request Transformer** plugin, click **Enable**.

1. Locate the **Add.Headers** field and click **Add**.
	
1. Enter the required header in the field in the `key: value` format, and **Save**.

	For example to use a bearer token secret with the value `my-secret-key` enter: `Authorization: Bearer my-secret-key`.

The Dedicated Cloud gateway is now configured to add the pre-shared secret token in all requests sent to the backend.
{% endnavtab %}
{% navtab API %}
The {{site.konnect_short_name}} API uses [Personal Access Token (PAT)](/konnect/api/#authentication) authentication. You can obtain your PAT from the [personal access token page](https://cloud.konghq.com/global/account/tokens). The PAT must be passed in the `Authorization` header of all requests.

1. Attach a new plugin to the control plane and service that you want to secure:
    ```bash
    curl -X POST \
	https://{region}.api.konghq.com/v2/control-planes/{controlPlaneId}/core-entities/services/{serviceId}/plugins \
    --header "accept: application/json" \
    --header "Content-Type: application/json" \
    --header "Authorization: Bearer {PAT}" \
    --data '{
		"name": "request-transformer",
		"config": {
			"add": {
				"headers": [
					"Authorization:Bearer {secretTokenValue}"
				]
			}
		}
    }'
    ```
	Replace the PAT as well as the following placeholder values with your own values:
	* `controlPlaneId`: The ID of the Dedicated Cloud control plane that includes your service.
	* `serviceId`: The ID of the service that you want to add the plugin to.
	* `secretTokenValue`: The value of your shared secret token to authenticate to the backend.

    You should get a `201` response, Dedicated Cloud gateways are now configured to add the pre-shared secret token in all requests sent to the backend.

{% endnavtab %}
{% endnavtabs %}

Now you can add as many other security methods or implement additional plugins and functionality in the Dedicated Cloud gateway and have your users hit the {{site.base_gateway}} and be protected rather than directly hitting your backend application.


## FAQ

Q: Why isn’t AWS PrivateLink recommended for connecting Dedicated Cloud Gateway to my upstream services?

A: AWS PrivateLink offers secure and private connectivity by routing traffic through an endpoint, but it only supports unidirectional communication. This means that Dedicated Cloud Gateway can send requests to your upstream services, but your upstream services cannot initiate communication back to the gateway (or vice-versa: Dedicated Cloud Gateways cannot send requests to your upstream service]. For many use cases requiring bidirectional communication—such as callbacks or dynamic interactions between the gateway and your upstream services. For this reason, PrivateLink is not generally recommended for secure connectivity to your upstream services. 





