---
title: Runtime Manager Overview
no_version: true
---

The [Runtime Manager](https://cloud.konghq.com/runtime-manager)
is a {{site.konnect_saas}} functionality module
that lets you catalogue, connect to, and monitor the status of all runtime
groups and instances in one place, as well as manage group configuration.

The Runtime Manager overview page displays a list of
runtime groups currently owned by the organization. From here, you can add or
delete runtime groups, or go into each individual group to manage runtime
instances and their global configuration.

With {{site.konnect_short_name}} acting as the control plane, a runtime instance
doesn't need a database to store configuration data. Instead, configuration
is stored in-memory on each node, and you can easily update all runtime instances
in a group with a few clicks.

The Runtime Manager, and the {{site.konnect_saas}} application as
a whole, does not have access or visibility into the data flowing through your
runtimes, and it does not store any data except the state and connection details
for each runtime instance.

## Runtime groups

{{site.konnect_short_name}} manages runtime configuration in runtime groups. Each runtime group acts
as a separate control plane and can manage runtime configurations independently
of any other group. See [runtime groups](/konnect/runtime-manager/runtime-groups)
for more information.

## Runtime instances

Kong does not host runtimes. You must provide your own runtime
instances.

The Runtime Manager aims to simplify this process by providing a
script to provision a {{site.base_gateway}} runtime in a Docker container,
eliminating any confusion about initial configuration or setup. You can also
choose to manually configure runtime instances on Linux or Kubernetes, or
create custom Docker containers without the script.

A {{site.base_gateway}} runtime instance acts as a data plane, which is a node
serving traffic for the proxy. Data plane nodes are not directly connected
to a database. Instead, they receive configuration from their runtime group,
which stores and manages the configuration in {{site.konnect_saas}}.

We recommend running one major version (2.x or 3.x) of a runtime instance per runtime group, unless you are in the middle of version upgrades to the data plane. Mixing versions may cause [compatibility issues](/konnect/runtime-manager/troubleshoot/#version-compatibility).

### Set up a runtime instance

Choose an installation type below:

<div class="docs-grid-install">

  <a href="/konnect/runtime-manager/runtime-instances/gateway-runtime-docker" class="docs-grid-install-block no-description">
    <img class="install-icon no-image-expand" src="/assets/images/icons/documentation/docker.png" alt="Docker" />
    <div class="install-text">Docker</div>
  </a>

  <a href="/konnect/runtime-manager/runtime-instances/gateway-runtime-kubernetes" class="docs-grid-install-block no-description">
    <img class="install-icon no-image-expand" src="/assets/images/icons/documentation/kubernetes-logo.png" alt="Kubernetes" />
    <div class="install-text">Kubernetes (Helm)</div>
  </a>

    <a href="/konnect/runtime-manager/runtime-instances/gateway-runtime-conf" class="docs-grid-install-block no-description">
      <img class="install-icon no-image-expand" src="/assets/images/icons/documentation/icn-markdown-editor.svg" alt="config file" />
      <div class="install-text">Universal (kong.conf)</div>
    </a>

</div>
