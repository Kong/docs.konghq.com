---
title: Upgrade a Runtime to a New Version
no_version: true
---

You can upgrade runtimes to a new {{site.base_gateway}} version by bringing
up new runtime instances, then shutting down the old ones. This is the best 
method for high availability, as the new node starts processing data before the
old one is removed. It is the cleanest and safest way to upgrade with no
proxy downtime.

1. Provision a new runtime through the Runtime Manager:
  * [Docker](/konnect/runtime-manager/gateway-runtime-docker)
  * [Linux](/konnect/runtime-manager/gateway-runtime-conf)
  * [Kubernetes (Helm)](/konnect/runtime-manager/gateway-runtime-kubernetes)

2. Open the Runtime Manager overview. Make sure that your new
runtime is up and in _Connected_ status, and that it was last seen
_Just Now_. For example:

    ![Connected runtimes in Runtime Manager](/assets/images/docs/konnect/konnect-runtimes-connected.png)

3. If the new runtime is connected and functioning, you can disconnect and
shut down any existing older runtimes that you're replacing.

    {:.note}
    > You can't shut down runtimes from within Runtime Manager.

4. Test passing data through your new runtime by accessing your proxy URL.

    For example, with the hostname `localhost` and the route path `/mock`:

    ```
    http://localhost:8000/mock
    ```
