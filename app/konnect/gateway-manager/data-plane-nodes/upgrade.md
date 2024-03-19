---
title: Upgrade a Self-managed Data Plane Node to a New Version
content_type: how-to
---

You can upgrade self-managed data plane nodes to a new {{site.base_gateway}} version by bringing
up new data plane nodes, and then shutting down the old ones. This is the best
method for high availability, as the new node starts processing data before the
old node is removed. It is the cleanest and safest way to upgrade with no
proxy downtime.

We recommend running one major version (2.x or 3.x) of a data plane node per control plane, unless you are in the middle of version upgrades to the data plane. Mixing versions may cause [compatibility issues](/konnect/gateway-manager/version-compatibility).

{:.note}
> **Note**: If you don't want to manually upgrade data plane nodes, you can use a Dedicated Cloud Gateway. With cloud gateways, Kong fully-manages the data plane and handles upgrades for you.

## Prerequisites

Read through the [{{site.base_gateway}} upgrade considerations](/gateway/latest/upgrade/) for the version that you're upgrading to.

## Upgrade a data plane node

To upgrade a data plane node to a new version, follow these steps:

1. Open {% konnect_icon runtimes %} **Gateway Manager**, choose a control plane,
and provision a new data plane node through the Gateway Manager.

    Make sure that your new data plane node appears in the list of nodes, 
    displays a _Connected_ status, and that it was last seen _Just Now_.

1. Once the new data plane node is connected and functioning, disconnect
and shut down the nodes you are replacing.

    {:.note}
    > You can't shut down data plane nodes from within Gateway Manager. Old
    nodes will also remain listed as `Connected` in Gateway Manager for a
    few hours after they have been removed or shut down.

1. Test passing data through your new data plane node by accessing your proxy
URL.

    For example, with the hostname `localhost` and the route path `/mock`:

    ```
    http://localhost:8000/mock
    ```
