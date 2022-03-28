---
title: Upgrade a Runtime to a New Version
no_version: true
---

You can upgrade runtimes to a new {{site.base_gateway}} version by bringing
up new runtime instances, then shutting down the old ones. This is the best
method for high availability, as the new node starts processing data before the
old one is removed. It is the cleanest and safest way to upgrade with no
proxy downtime.

1. Provision a new runtime instance through the Runtime Manager:
  * [Docker](/konnect/configure/runtime-manager/runtime-instances/gateway-runtime-docker)
  * [Linux](/konnect/configure/runtime-manager/runtime-instances/gateway-runtime-conf)
  * [Kubernetes (Helm)](/konnect/configure/runtime-manager/runtime-instances/gateway-runtime-kubernetes)

2. Open the Runtime Manager, then choose a runtime group.
Make sure that your new runtime instance appears in the list of runtime
instances, is in _Connected_ status, and that it was last seen _Just Now_.
For example:

    ![Connected runtimes in Runtime Manager](/assets/images/docs/konnect/konnect-runtimes-connected.png)

3. If the new runtime instance is connected and functioning, you can disconnect
and shut down any existing older instances that you're replacing.

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
