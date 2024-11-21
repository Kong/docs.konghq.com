---
title: How to configure Azure Virtual Network Peering
---

{{site.konnect_short_name}} can leverage [Azure Virtual Network Peering](https://learn.microsoft.com/en-us/azure/virtual-network/virtual-network-peering-overview) to create virtual networks, and ingest data from your Azure services and expose them to the internet via {{site.konnect_short_name}}. 

## How virtual network peering works

{% include_cached /md/konnect/azure-peering.md %}
> _**Figure 1:** In this diagram, the "User Azure Cloud", represents the Azure infrastructure that runs your microservices. The "Kong Azure Cloud", powers your Kong data planes. Using virtual network peering, you can ingest traffic from your Azure environment and expose it to the internet._

## Prerequisites

* A {{site.konnect_short_name}} control plane
* An Azure Tenant account with administrative privileges to create resources and manage peering, including the following information:
  * Azure tenant ID
  * Azure VNET subscription ID
  * Azure VNET resource group name
  * Azure VNET name

## Configure VNET Peering

### Configure Azure

Grant access to your Azure AD Tenant: 

1. Navigate to the following URL making sure to replace `<tenant-id>` with your own Azure tenant ID and approve the `kong-cgw-azure-vnet-peering-app`. 

    `https://login.microsoftonline.com/<tenant-id>/adminconsent?client_id=207b296f-cf25-4d23-9eba-9a2c41dc62ca`

1. Input the following command into the Azure CLI making sure to replace `<subscription-id>` with your Azure VNET subscription ID:
    
    ```bash
    az role definition create --output none --role-definition '{
        "Name": "Kong Cloud Gateway Peering Creator - Kong",
        "Description": "Perform cross-tenant network peering.",
        "Actions": [
            "Microsoft.Network/virtualNetworks/read",
            "Microsoft.Network/virtualNetworks/virtualNetworkPeerings/read",
            "Microsoft.Network/virtualNetworks/virtualNetworkPeerings/write",
            "Microsoft.Network/virtualNetworks/virtualNetworkPeerings/delete",
            "Microsoft.Network/virtualNetworks/peer/action"
        ],
        "AssignableScopes": [
            "/subscriptions/<subscription-id>",
        ]
    }'
    ```
1. Run the following command with your Azure VNET Subscription ID `<subscription-id>`, Azure VNET resource group name `<resource-group>`, and Azure VNET Name `<vnet-name>` specified to assign the role to the service principal:

    ```bash
    az role assignment create \
        --role "Kong Cloud Gateway Peering Creator" \
        --assignee "$(az ad sp list --filter "appId eq '207b296f-cf25-4d23-9eba-9a2c41dc62ca'" \
        --output tsv --query '[0].id')" \
        --scope "/subscriptions/<subscription-id>/resourceGroups/<resource-group>/providers/Microsoft.Network/virtualNetworks/<vnet-name>"
    ```


### Configure {{site.konnect_short_name}}

1. From {{site.konnect_short_name}}, navigate to the **Gateway Manager**.
1. On the **Networks** tab, select the desired network, then select **Configure VNET Peering**.
1. In the form that appears, enter the following values: 
    * Azure Tenant ID 
    * Azure VNET Subscription ID
    * Azure VNET Resource Group Name
    * Azure VNET Name
1. For DNS configuration, add the IP addresses of DNS servers that will resolve to your private domains, along with any domains you want associated with your DNS. {{site.konnect_short_name}} supports the following mappings:

    * 1-1 Mapping
        * Each domain is mapped to a unique IP address.
        * For example: `example.com` -> `192.168.1.1`
    * N-1 Mapping
        * Multiple domains are mapped to a single IP address.
        * For example: `example.com`, `example2.com` -> `192.168.1.1`
    * M-N Mapping
        * Multiple domains are mapped to multiple IP addresses, not necessarily in a one-to-one relationship.
        * For example: `example.com`, `example2.com` -> `192.168.1.1`, `192.168.1.2`
        * For example: `example3.com` -> `192.168.1.1`

    {:.note}
    > **Note**: You will need to create an inbound endpoint for private DNS zone within your tenant. The IP of the inbound endpoint should be the IP of the DNS server.

1. Click **Next** and move on to configuring Azure in the next section.


After VNET Peering is successfully established you will be able to configure a [route](/konnect/api/control-plane-configuration/latest/#/Routes/list-route) for the upstream service and forward all traffic through the virtual network to the data plane. This guarantees that traffic from the {{site.konnect_short_name}} data plane reaches the services and that response packets are routed back properly.

