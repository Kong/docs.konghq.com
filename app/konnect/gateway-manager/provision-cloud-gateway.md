---
title: Provision a Dedicated Cloud Gateway
---

This guide explains how to provision a [Dedicated Cloud Gateway](/konnect/dedicated-cloud-gateways/) and scale the data plane nodes in {{site.konnect_short_name}}.

## Prerequisites

* A network configured in {{site.konnect_short_name}} <!--I feel like a link is missing here, but I can't find a good doc to link to-->

## Provision your fully-managed data plane nodes

{% navtabs %}
{% navtab UI %}
1. From [Gateway Manager](https://cloud.konghq.com/gateway-manager) in the navigation menu, click the **New Control Plane** menu and select **{{site.base_gateway}}**.

1. Enter a name for your cloud gateway and click **Dedicated Cloud Instances**.

1. Configure any labels as needed, and click **Next Step**. 
    
	You will be redirected the provisioning dialog for your newly created Dedicated Cloud Gateway. The cloud gateway is created but not yet provisioned, and it still requires a data plane node.

1. Add a data plane node to your Dedicated Cloud Gateway:

    1. From the **Gateway Version** menu, select the {{site.base_gateway}} version you want to use. 
        
		{{site.base_gateway}} versions 3.4.x and later are supported.

    1. Select one of the following modes to configure your data plane node:
        * **Autopilot**: This mode allows Kong to automatically scale your instances based on incoming traffic. You can pre-warm your cluster by specifying the number of requests per second. 
        * **Custom**: This mode allows you to select from three different instance sizes: small, medium, or large.

    1. To configure your cluster, select your provider, region, network, and specify the number of nodes. Repeat this step for as many regions as you need. Adding multiple regions can help with high availability as well as regional failover.

    1. Configure your API access as either public or private, and then click **Create Cluster**. 

Your cloud gateway is now provisioned with data plane nodes. You can use it like you would any other {{site.base_gateway}} in {{site.konnect_short_name}}.
{% endnavtab %}
{% navtab API %}
The {{site.konnect_short_name}} API uses [Personal Access Token (PAT)](/konnect/api/#authentication) authentication. You can obtain your PAT from the [personal access token page](https://cloud.konghq.com/global/account/tokens). The PAT must be passed in the `Authorization` header of all requests.

1. Create a Dedicated Cloud Gateway control plane using the [`/control-planes` endpoint](/konnect/api/control-planes/latest/#/Control%20Planes/create-control-plane):
    ```bash
    curl --request POST \
    --url https://<region>.api.konghq.com/v2/control-planes \
    --header 'Authorization: Bearer <personal-access-token>' \
    --header 'Content-Type: application/json' \
    --data '{
		"name": "cloud-gateway-control-plane",
		"description": "A test control plane for Dedicated Cloud Gateways.",
		"cluster_type": "CLUSTER_TYPE_CONTROL_PLANE",
		"cloud_gateway": true,
		"proxy_urls": [
			{
			"host": "example.com",
			"port": 443,
			"protocol": "https"
			}
		],
    }'
    ```
	Be sure to replace the PAT as well as the following placeholders with your own values:
	* `name`: The name that you want to display for the cloud gateway control plane.
	* `description`: Description of the cloud gateway control plane.
	* `host`: The URL of the host.

    You should get a `201` response like the following:

    ```bash
    {
	"id": "3e62d2e6-45e9-4046-8065-9cd28cb3487d",
	"name": "cloud-gateway-control-plane",
	"description": "A test control plane for Dedicated Cloud Gateways.",
	"config": {
		"control_plane_endpoint": "https://cf1brr4d58.us.cp0.konghq.com",
		"telemetry_endpoint": "https://cf1brr4d58.us.tp0.konghq.com",
		"cluster_type": "CLUSTER_TYPE_HYBRID",
		"auth_type": "pinned_client_certs",
		"cloud_gateway": true,
		"proxy_urls": [
			{
			"host": "example.com",
			"port": 443,
			"protocol": "https"
			}
		]
	},
	"created_at": "2024-04-04T14:03:46.157Z",
	"updated_at": "2024-04-04T14:03:46.157Z"
    }
    ```
	Save the control plane `id` to use in the next step. 

1. Create a Dedicated Cloud Gateway data plane in Autopilot mode using the [`/cloud-gateways/configurations` endpoint](link):

    ```sh
    curl --request PUT \
	--url https://<region>.api.konghq.com/v2/cloud-gateways/configurations \
	--header 'Authorization: Bearer <personal-access-token>' \
	--header 'Content-Type: application/json' \
	--data '{
		"control_plane_id": "3e62d2c5-45e9-4046-8065-9cd28cb3487d",
		"version": "3.6",
		"control_plane_geo": "us",
		"dataplane_groups": [
			{
			"provider": "aws",
			"region": "ap-northeast-1",
			"cloud_gateway_network_id": "0e465f2f-4fa3-43ed-8900-bb6210c1e554",
			"autoscale": {
				"kind": "autopilot",
				"base_rps": 100
			}
			}
		]
	}'
    ```
	Be sure to replace the PAT as well as the following placeholders with your own values:
	* `control_plane_id`: The ID of the control plane you created in the previous step.
	* `version`: The version of {{site.base_gateway}} you want to use.
	* `control_plane_geo`: The geo of the control plane.
	* `region`: The AWS region you want to deploy the data plane nodes in.
	* `cloud_gateway_network_id`: The network ID of the cloud gateway.

    You should get a `201` response like the following:

    ```sh
    {
	"id": "3682c148-1985-44a0-8cf0-c49f76a53dda",
	"control_plane_id": "3e62d2e6-45e9-4046-8065-9cd28cb3487d",
	"control_plane_geo": "us",
	"version": "3.6",
	"api_access": "private+public",
	"dataplane_group_config": [
		{
		"provider": "aws",
		"region": "ap-northeast-1",
		"autoscale": {
			"kind": "autopilot",
			"base_rps": 100,
			"max_rps": 1000
		},
		"cloud_gateway_network_id": "0e465f2f-4fa3-43ed-8900-bb6210c1e554"
		}
	],
	"dataplane_groups": [
		{
		"id": "a27b8b9b-f3c9-42f6-b0ea-5a678c008298",
		"provider": "aws",
		"region": "ap-northeast-1",
		"autoscale": {
			"kind": "autopilot",
			"base_rps": 100,
			"max_rps": 1000
		},
		"state": "initializing",
		"cloud_gateway_network_id": "0e465f2f-4fa3-43ed-8900-bb6210c1e554",
		"created_at": "2024-04-04T14:14:22.717Z",
		"updated_at": "2024-04-04T14:14:22.717Z"
		}
	],
	"created_at": "2024-04-04T14:14:22.717Z",
	"updated_at": "2024-04-04T14:14:22.717Z",
	"entity_version": 1
    }
    ```

Your cloud gateway is now provisioned. You can use it like you would any other {{site.base_gateway}} in {{site.konnect_short_name}}.
{% endnavtab %}
{% endnavtabs %}

## Upgrade your fully-managed data plane nodes

{{site.konnect_short_name}} handles upgrades for you. There's no downtime when upgrading the infrastructure. For more information about how to upgrade your data plane nodes, see [Upgrade a Data Plane Node to a New Version](/konnect/gateway-manager/data-plane-nodes/upgrade/)

## Scale your fully-managed data plane nodes

{% navtabs %}
{% navtab UI %}
1. From [Gateway Manager](https://cloud.konghq.com/gateway-manager) in the navigation menu, click the Dedicated Cloud Gateway control plane you want to scale the data plane nodes for.

1. Click **Data Plane Nodes** in the navigation menu.

1. From the **Control Plane Actions** menu, click **Update Cluster Config** and do the following:

    1. To rescale your entire instance, select the most appropriate option based on the requests per second, CPU, and memory from the Custom Configure Mode options.

    1. To only rescale the number of data plane nodes in a cluster region, increase or decrease the number of nodes in the Configure Cluster section. 

1. Click **Update Cluster**.
{% endnavtab %}
{% navtab API %}
The {{site.konnect_short_name}} API uses [Personal Access Token (PAT)](/konnect/api/#authentication) authentication. You can obtain your PAT from the [personal access token page](https://cloud.konghq.com/global/account/tokens). The PAT must be passed in the `Authorization` header of all requests.

1. Scale your Dedicated Cloud Gateway data plane nodes by sending a request to the [`/cloud-gateways/configurations` endpoint](link to spec):

    ```sh
    curl --request PUT \
    --url https://<region>.api.konghq.com/v2/cloud-gateways/configurations \
    --header 'Authorization: Bearer <personal-access-token>' \
    --header 'Content-Type: application/json' \
    --data '{
		"control_plane_id": "3e62d2b5-45e9-4032-8065-9cd28cb3487d",
		"version": "3.6",
		"control_plane_geo": "us",
		"dataplane_groups": [
			{
			"provider": "aws",
			"region": "ap-northeast-1",
			"cloud_gateway_network_id": "0e465f2f-4fa3-43ed-8900-bb6210c1e554",
			"autoscale": {
				"kind": "static",
				"instance_type": "small",
				"requested_instances": 3
			}
			}
		]
    }'
    ```
	Be sure to replace the PAT as well as the following placeholders with your own values:
	* `control_plane_id`: The ID of the control plane you created for Dedicated Cloud Gateways.
	* `version`: The version of {{site.base_gateway}} you want to use.
	* `control_plane_geo`: The geo of the control plane.
	* `region`: The AWS region the data plane nodes are deployed in.
	* `cloud_gateway_network_id`: The network ID of the cloud gateway.
	* `requested_instances`: The number of total data plane nodes you want.

    You should get a `201` response like the following:
    ```sh
    {
	"id": "a8b122ff-8bf3-4688-b15d-2cf1af1e511f",
	"control_plane_id": "3e62d2b5-45e9-4032-8065-9cd28cb3487d",
	"control_plane_geo": "us",
	"version": "3.6",
	"api_access": "private+public",
	"dataplane_group_config": [
		{
		"provider": "aws",
		"region": "ap-northeast-1",
		"autoscale": {
			"kind": "static",
			"instance_type": "small",
			"requested_instances": 3
		},
		"cloud_gateway_network_id": "0e465f2f-4fa3-43ed-8900-bb6210c1e554"
		}
	],
	"dataplane_groups": [
		{
		"id": "a27b8b9b-f3c9-42f6-b0ea-5a678c008298",
		"provider": "aws",
		"region": "ap-northeast-1",
		"autoscale": {
			"kind": "static",
			"instance_type": "small",
			"requested_instances": 3
		},
		"state": "initializing",
		"cloud_gateway_egress_ip_addresses": [
			"54.178.193.160",
			"3.115.245.174",
			"52.192.132.237"
		],
		"cloud_gateway_network_id": "0e465f2f-4fa3-43ed-8900-bb6210c1e554",
		"created_at": "2024-04-04T14:14:22.717Z",
		"updated_at": "2024-04-04T14:19:19.516Z"
		}
	],
	"created_at": "2024-04-04T14:19:19.516Z",
	"updated_at": "2024-04-04T14:19:19.516Z",
	"entity_version": 2
    }
    ```
{% endnavtab %}
{% endnavtabs %}

## More information

* [About Dedicated Cloud Gateways](/konnect/dedicated-cloud-gateways/): Learn more about Dedicated Cloud Gateway features and use cases.