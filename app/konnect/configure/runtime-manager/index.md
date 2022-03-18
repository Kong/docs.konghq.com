---
title: Runtime Manager Overview
no_version: true
---

The [Runtime Manager](https://konnect.konghq.com/runtime-manager)
is a {{site.konnect_saas}} functionality module
that lets you catalogue, connect to, and monitor the status of all runtime
groups and instances in one place, as well as manage group configuration.

The Runtime Manager overview page displays a list of
runtime groups currently owned by the organization. From here, you can add or
delete runtime groups, or go into each individual group to manage runtime
instances and their global configuration.

_<screenshot of overview page; do we have a test environment somewhere where I could
grab a useful screenshot?>_

With {{site.konnect_short_name}} acting as the control plane, a runtime instance
doesn't need a database to store configuration data. Instead, configuration
is stored in-memory on each node, and you can easily update multiple runtime
instances from one {{site.konnect_short_name}} account with a few clicks.

The Runtime Manager, and the {{site.konnect_saas}} application as
a whole, does not have access or visibility into the data flowing through your
runtimes, and it does not store any data except the state and connection details
for each runtime instance.

## Hosting runtimes

Kong does not host runtimes. You must provide your own runtime
instances.

The Runtime Manager aims to simplify this process by providing a
script to provision a {{site.base_gateway}} runtime in a Docker container,
eliminating any confusion about initial configuration or setup.

## Runtime groups

Konnect manages runtime configuration in runtime groups. Each runtime group acts
as a separate control plane and can manage runtime configurations independently
of any other group. See [runtime groups](/konnect/configure/runtime-manager/runtime-groups)
for more information.

## Types of runtimes

Each runtime group connects to its own runtime instances. Every runtime instance
in a group must be of the same type.

Currently, the only supported runtime type in the
{{site.konnect_saas}} application is a [{{site.base_gateway}}](/gateway/)
data plane.

### Kong Gateway

A {{site.base_gateway}} runtime instance acts as a data plane, which is a node
serving traffic for the proxy. Data plane nodes are not directly connected
to a database. They receive configuration


Choose an installation type below:

<div class="docs-grid-install">

  <a href="/konnect/runtime-manager/gateway-runtime-docker" class="docs-grid-install-block no-description">
    <img class="install-icon no-image-expand" src="https://doc-assets.konghq.com/install-logos/docker.png" alt="Docker" />
    <div class="install-text">Docker</div>
  </a>

  <a href="/konnect/runtime-manager/gateway-runtime-kubernetes" class="docs-grid-install-block no-description">
    <img class="install-icon no-image-expand" src="/assets/images/icons/documentation/kubernetes-logo.png" alt="Kubernetes" />
    <div class="install-text">Kubernetes (Helm)</div>
  </a>

    <a href="/konnect/runtime-manager/gateway-runtime-conf" class="docs-grid-install-block no-description">
      <img class="install-icon no-image-expand" src="/assets/images/icons/documentation/icn-markdown-editor.svg" alt="config file" />
      <div class="install-text">Universal (kong.conf)</div>
    </a>

</div>
