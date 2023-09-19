---
title: Upgrade a Runtime Instance to a New Version
content_type: how-to
---

You can upgrade runtimes to a new {{site.base_gateway}} version by bringing
up new runtime instances, and then shutting down the old ones. This is the best
method for high availability, as the new node starts processing data before the
old node is removed. It is the cleanest and safest way to upgrade with no
proxy downtime.

We recommend running one major version (2.x or 3.x) of a runtime instance per runtime group, unless you are in the middle of version upgrades to the data plane. Mixing versions may cause [compatibility issues](/konnect/runtime-manager/version-compatibility).

## Prerequisites

Read through the [{{site.base_gateway}} upgrade considerations](/gateway/latest/upgrade/) for the version that you're upgrading to.

## Upgrade a runtime instance

To upgrade a runtime instance to a new version, follow these steps:

1. Open {% konnect_icon runtimes %} **Runtime Manager**, choose a runtime group,
and provision a new runtime instance through the Runtime Manager.

    Make sure that your new runtime instance appears in the list of runtime
    instances, displays a _Connected_ status, and that it was last seen _Just Now_.

1. Once the new runtime instance is connected and functioning, disconnect
and shut down the instances you are replacing.

    {:.note}
    > You can't shut down runtime instances from within Runtime Manager. Old
    instances will also remain listed as `Connected` in Runtime Manager for a
    few hours after they have been removed or shut down.

1. Test passing data through your new runtime instance by accessing your proxy
URL.

    For example, with the hostname `localhost` and the route path `/mock`:

    ```
    http://localhost:8000/mock
    ```
