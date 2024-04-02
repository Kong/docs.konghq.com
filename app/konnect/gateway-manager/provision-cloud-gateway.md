---
title: Provision a Dedicated Cloud Gateway
---

This guide explains how to provision a [Dedicated Cloud Gateway](/konnect/dedicated-cloud-gateways/) in {{site.konnect_short_name}}.

## Prerequisites

* Network configured

## Provision your fully-managed data plane nodes

{% navtabs %}
{% navtab UI %}
1. From [Gateway Manager](https://cloud.konghq.com/gateway-manager) in the navigation menu, click the **New Control Plane** menu and select **Kong Gateway**.

1. In the **Create a Control Plane** dialog, enter a name for your cloud gateway and click **Dedicated Cloud Instances**.

1. Configure any labels as needed, and click **Next Step**. 
    You will be redirected the provisioning dialog for your newly created Dedicated Cloud Gateway. The cloud gateway is only created, it still needs to be provisioned and a data plane node needs to be added.

1. To add a data plane node to your Dedicated Cloud Gateway, do the following in the **Create a Data Plane Node** dialog:

    1. From the **Gateway Version** menu, select the {{site.base_gateway}} version you want to use. 
        {{site.base_gateway}} versions 3.4.x and later are supported.

    1. Select one of the following modes to configure your data plane node:
        * **Autopilot**: This mode allows Kong to automatically scale your instances based on incoming traffic. You can pre-warm your cluster by specifying the number of requests per second. 
        * **Custom**: This mode allows you to select from three different instance sizes: small, medium, or large.

    1. To configure your cluster, select your provider, region, network, and specify the number of nodes. Repeat this step for as many regions as you need. <!-- why would you want multiple regions? Would you ever want two or more of the same region? Why?-->

    1. Configure you API access to either public or private, and then click **Create Cluster**. 

Your cloud gateway is now provisioned. You can use it like you would any other {{site.base_gateway}} in {{site.konnect_short_name}}.
{% endnavtab %}
{% navtab API %}
The {{site.konnect_short_name}} API uses [Personal Access Token (PAT)](/konnect/api/#authentication) authentication. You can obtain your PAT from the [personal access token page](https://cloud.konghq.com/global/account/tokens). The PAT must be passed in the `Authorization` header of all requests.

1. 
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

1. ? 
{% endnavtab %}
{% endnavtabs %}

## More information

* [About Dedicated Cloud Gateways](/konnect/dedicated-cloud-gateways/): Learn more about Dedicated Cloud Gateway features and use cases.