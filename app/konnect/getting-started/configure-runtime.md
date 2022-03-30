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

* You have the **Organization Admin** role in
{{site.konnect_saas}}. If you created this Konnect organization, your account
is part of the organization admin team by default.
* The quick setup script requires Docker and a Unix shell (for example, bash or
  zshell). Platform-specific tools and permissions:
  * **All platforms:** [Docker](https://docs.docker.com/get-docker/) and [jq](https://stedolan.github.io/jq/) installed
  * **Linux:** User added to the [`docker` group](https://docs.docker.com/engine/install/linux-postinstall/)
  * **Windows:** Docker Desktop [installed](https://docs.docker.com/docker-for-windows/install/#install-docker-desktop-on-windows) and [integrated with a WSL 2 backend](https://docs.docker.com/docker-for-windows/wsl/).

## Set up a New Runtime Instance

 {% include_cached /md/konnect/docker-runtime.md %}

## Summary and Next Steps

In this step, you ran a script which set up a Docker container with a
{{site.base_gateway}} instance, adding your first runtime to the Runtime
Manager.

Next, [set up a your first Konnect Service through {{site.konnect_saas}}](/konnect/getting-started/configure-service).
