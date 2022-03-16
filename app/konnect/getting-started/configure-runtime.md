---
title: Configure a Runtime
no_version: true
---

Set up your first runtime through the
[{{site.konnect_short_name}} Runtime Manager](/konnect/configure/runtime-manager).

At this time, the only runtime type available is a {{site.base_gateway}}
data plane.

{{site.base_gateway}} data planes proxy service traffic. With
{{site.konnect_saas}} working as the control plane, a
runtime doesn't need a database to store configuration data. Instead,
configuration is stored in-memory on each node, and you can easily update
multiple runtimes from one {{site.konnect_short_name}} account with a few clicks.

{:.note}
> **Note:** Kong does not host runtimes. You must install and host your own
runtime instances.

## Prerequisites

* You have **Runtime Admin** or **Organization Admin** permissions in
{{site.konnect_saas}}. If you created this account, the account has
organization admin permissions by default. _[To do: check what the new permissions are]_
* The quick setup script requires Docker and a Unix shell (for example, bash or
  zshell). Platform-specific tools and permissions:
  * **All platforms:** [Docker](https://docs.docker.com/get-docker/) and [jq](https://stedolan.github.io/jq/) installed
  * **Linux:** User added to the [`docker` group](https://docs.docker.com/engine/install/linux-postinstall/)
  * **Windows:** Docker Desktop [installed](https://docs.docker.com/docker-for-windows/install/#install-docker-desktop-on-windows) and [integrated with a WSL 2 backend](https://docs.docker.com/docker-for-windows/wsl/).

## Set up a New Runtime Instance

1. From the left navigation menu, open **Runtime Manager**.

1. Select a runtime group. [to do: check what happens if you only have the default group - is it open automatically?]

1. Click **Configure Runtime**.

     The page opens to a **Configure New Runtime** form with the Docker tab
     selected.

1. Click **Copy Script**.

1. Replace the placeholder for `<your-password>` with your own
{{site.konnect_saas}} password.

1. Run the script on any host you choose.

    This script creates a Docker container running a simple
    {{site.base_gateway}} instance and connects it to your
    {{site.konnect_saas}} account.

1. Click **Done** to go to the Runtime Manager page.

Once the script has finished running, the Runtime Manager will include
a new entry for your instance and the tag in the **Sync Status** column should
say **Connected**.

The default proxy URL for this runtime is `http://localhost:8000`. Take
note of this URL, as you'll need it later to access a Service
implementation.

{:.important}
> Important: {{site.konnect_saas}} provisions certificates for the data
plane. These certificates expire after six months and must be renewed. See
[Renew Certificates](/konnect/runtime-manager/renew-certificates).

## Summary and Next Steps

In this step, you ran a script which set up a Docker container with a
{{site.base_gateway}} instance, adding your first runtime to the Runtime
Manager.

Next, [set up a your first Service through {{site.konnect_saas}}](/konnect/getting-started/configure-service).
