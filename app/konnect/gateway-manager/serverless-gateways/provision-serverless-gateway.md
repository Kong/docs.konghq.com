---
title: Provision a Serverless Gateway
---

This guide explains how to provision a [serverless gateway](/konnect/gateway-manager/serverless-gateways/) in {{site.konnect_short_name}}.

## Prerequisites

* The following user permissions:
	* Control plane admin role for the Dedicated Cloud Gateway control plane

## Provision your fully-managed data plane

{% navtabs %}
{% navtab UI %}
1. From [Gateway Manager](https://cloud.konghq.com/gateway-manager), click the **New Gateway** button and select **Serverless**.

1. Enter a name, optionally a description or label, for your serverless gateway and click **Create**.

Your serverless gateway is now provisioned with the data plane attached. You can use it like you would any other {{site.base_gateway}} in {{site.konnect_short_name}}.

The URL where your serverless gateway can be accessed is shown in the `Overview` section of the Control Plane page.
{% endnavtab %}
{% navtab API %}
The {{site.konnect_short_name}} API uses [Personal Access Token (PAT)](/konnect/api/#authentication) authentication. You can obtain your PAT from the [personal access token page](https://cloud.konghq.com/global/account/tokens). The PAT must be passed in the `Authorization` header of all requests.

1. Create a serverless gateway control plane using the [`/control-planes` endpoint](/konnect/api/control-planes/latest/#/Control%20Planes/create-control-plane):
    ```bash
    curl --request POST \
    --url https://{region}.api.konghq.com/v2/control-planes \
    --header 'Authorization: Bearer <personal-access-token>' \
    --header 'Content-Type: application/json' \
    --data '{
		"name": "serverless-gateway-control-plane",
		"description": "A test control plane for Serverless Gateways.",
		"cluster_type": "CLUSTER_TYPE_SERVERLESS",
		"cloud_gateway": false,
		"auth_type": "pinned_client_certs"
    }'
    ```
	Replace the PAT as well as the following placeholders with your own values:
	* `name`: The name that you want to display for the serverless gateway control plane.
	* `description`: Description of the serverless gateway control plane.

    You should get a `201` response like the following:

    ```json
	{
		"id": "23be21c0-5984-4698-aa1f-ac258d77f0d1",
		"name": "serverless-gateway-control-plane",
		"description": "A test control plane for Serverless Gateways.",
		"labels": {},
		"config": {
			"control_plane_endpoint": "https://52ec253413.cp0.konghq.tech",
			"telemetry_endpoint": "https://52ec253413.tp0.konghq.tech",
			"cluster_type": "CLUSTER_TYPE_SERVERLESS",
			"auth_type": "pinned_client_certs",
			"cloud_gateway": false,
			"proxy_urls": []
		},
		"created_at": "2024-10-15T21:25:29.376Z",
		"updated_at": "2024-10-15T21:25:29.376Z"
	}
    ```
	Save the control plane `id` to use in the next step. 

1. Create a Dedicated Cloud Gateway data plane using the [`/cloud-gateways/configurations` endpoint](/konnect/api/cloud-gateways/latest/):

    ```sh
    curl --request PUT \
	--url https://global.api.konghq.com/v3/cloud-gateways/configurations \
	--header 'Authorization: Bearer <personal-access-token>' \
	--header 'Content-Type: application/json' \
	--data '{
		"control_plane_id": "23be21c0-5984-4698-aa1f-ac258d77f0d1",
		"control_plane_geo": "us",
		"dataplane_groups": [
			{
				"region": "na"
			}
		],
		"kind": "serverless.v0"
	}'
    ```
	Replace the PAT as well as the following placeholders with your own values:
	* `control_plane_id`: The ID of the control plane you created in the previous step.
	* `control_plane_geo`: The geo of the control plane.
	* `region`: The region you want to deploy the data plane in.

    You should get a `201` response which means your serverless gateway is now provisoned. You can use it like you would any other {{site.base_gateway}} in {{site.konnect_short_name}}.

{% endnavtab %}
{% endnavtabs %}

## More information

* [Dedicated Cloud Gateways overview](/konnect/gateway-manager/dedicated-cloud-gateways/): Learn more about Dedicated Cloud Gateway features and use cases.