---
title: Securing Backend Traffic
---

This guide explains how to configure [serverless gateways](/konnect/gateway-manager/serverless-gateways/) to securely communicate between the data plane and the backend application. These methods are required because serverless gateways only support public networking and not direct private networking options such as [AWS Direct Connect](https://aws.amazon.com/directconnect/) or other VPN-type connectivity. For use cases where private networking is required, [Dedicated Cloud Gateways](/konnect/gateway-manager/dedicated-cloud-gateways) with [AWS Transit Gateways](/konnect/gateway-manager/dedicated-cloud-gateways/transit-gateways/) is a better choice.


## Using a Shared Secret

In this method, your web application is configured to only authorize traffic that contains a known shared API token or secret. We will configure {{site.base_gateway}} to inject the shared secret as a header into every request sent to the backend. Then {{site.base_gateway}} and the ecosystem of plugins can be leveraged to implement additional or alternative security measures, rate limiting, or other functionality on top of the web app, while ensuring that no unproxied traffic is authorized. 

### Prerequisites

* A web application that is accessible to the public internet.
* The application endpoints are secured by a known API token. 

{% navtabs %}
{% navtab UI %}
1. From [Gateway Manager](https://cloud.konghq.com/gateway-manager), click the name of the Serverless CP that you want to configure.

1. Click **Gateway Services** in the navigation sidebar and select the service you want to secure.

1. Click the **Plugins** tab, then click the **New Plugin** button.

1. Find the **Request Transformer** plugin, click **Enable**.

1. Locate the **Add.Headers** field and click **Add**.
	
1. Enter the required header in the field in the `key: value` format, and **Save**.

	For example to use a bearer token secret with the value `my-secret-key` enter: `Authorization: Bearer my-secret-key`.

The serverless gateway is now configured to add the pre-shared secret token in all requests sent to the backend.
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
	* `controlPlaneId`: The ID of the serverless control plane that includes your service.
	* `serviceId`: The ID of the service that you want to add the plugin to.
	* `secretTokenValue`: The value of your shared secret token to authenticate to the backend.

    You should get a `201` response, serverless gateways are now configured to add the pre-shared secret token in all requests sent to the backend.

{% endnavtab %}
{% endnavtabs %}

Now you can add as many other security methods or implement additional plugins and functionality in the serverless gateway and have your users hit the {{site.base_gateway}} and be protected rather than directly hitting your backend application.

## More information

* [Request Transformer Plugin](/hub/kong-inc/request-transformer/how-to/basic-example/): Learn about additional ways to configure the Request Transformer Plugin.