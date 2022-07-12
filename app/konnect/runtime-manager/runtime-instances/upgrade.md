---
title: Upgrade a Runtime to a New Version
no_version: true
content-type: how-to
---

You can upgrade runtimes to a new {{site.base_gateway}} version by bringing
up new runtime instances, and then shutting down the old ones. This is the best
method for high availability, as the new node starts processing data before the
old node is removed. It is the cleanest and safest way to upgrade with no
proxy downtime. 

To upgrade a runtime to a new version follow these steps: 

1. Provision a new runtime instance through the Runtime Manager:
  * [Docker](/konnect/runtime-manager/runtime-instances/gateway-runtime-docker)
  * [Linux](/konnect/runtime-manager/runtime-instances/gateway-runtime-conf)
  * [Kubernetes (Helm)](/konnect/runtime-manager/runtime-instances/gateway-runtime-kubernetes)

2. Open {% konnect_icon runtimes %} **Runtime Manager**, then choose a runtime group.
    
    Make sure that your new runtime instance appears in the list of runtime
    instances, displays a _Connected_ status, and that it was last seen _Just Now_.

3. Once the new runtime instance is connected and functioning, disconnect
and shut down the instances you are replacing.

    {:.note}
    > You can't shut down runtime instances from within Runtime Manager. Old
    instances will also remain listed as `Connected` in Runtime Manager for a
    few hours after they have been removed or shut down.

4. Test passing data through your new runtime instance by accessing your proxy
URL.

    For example, with the hostname `localhost` and the route path `/mock`:

    ```
    http://localhost:8000/mock
    ```
