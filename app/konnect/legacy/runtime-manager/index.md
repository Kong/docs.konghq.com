---
title: Runtime Manager Overview
no_version: true
---

The Runtime Manager is a {{site.konnect_saas}} functionality module
that lets you catalogue, connect to, and monitor the status of all runtimes in
one place.

With {{site.konnect_short_name}} acting as the control plane, a runtime
doesn't need a database to store configuration data. Instead, configuration
is stored in-memory on each node, and you can easily update multiple runtimes
from one {{site.konnect_short_name}} account with a few clicks.

The Runtime Manager, and the {{site.konnect_saas}} application as
a whole, does not have access or visibility into the data flowing through your
runtimes, and it does not store any data except the state and connection details
for each runtime.

## Hosting runtimes

Kong does not host runtimes. You must provide your own runtime
instances.

The Runtime Manager aims to simplify this process by providing a
script to provision a {{site.base_gateway}} runtime in a Docker container,
eliminating any confusion about initial configuration or setup.

## Types of runtimes

### Kong Gateway

A {{site.base_gateway}} runtime acts as a data plane, which is a node
serving traffic for the proxy. Data plane nodes are not directly connected
to a database.

Currently, the only supported runtime type in the
{{site.konnect_saas}} application is a [{{site.base_gateway}}](/gateway/)
data plane.

Choose an installation type below:

<div class="docs-grid-install">

  <a href="/konnect/legacy/runtime-manager/gateway-runtime-docker" class="docs-grid-install-block no-description">
    <img class="install-icon no-image-expand" src="https://doc-assets.konghq.com/install-logos/docker.png" alt="Docker" />
    <div class="install-text">Docker</div>
  </a>

  <a href="/konnect/legacy/runtime-manager/gateway-runtime-kubernetes" class="docs-grid-install-block no-description">
    <img class="install-icon no-image-expand" src="/assets/images/icons/documentation/kubernetes-logo.png" alt="Kubernetes" />
    <div class="install-text">Kubernetes (Helm)</div>
  </a>

    <a href="/konnect/legacy/runtime-manager/gateway-runtime-conf" class="docs-grid-install-block no-description">
      <img class="install-icon no-image-expand" src="/assets/images/icons/documentation/icn-markdown-editor.svg" alt="config file" />
      <div class="install-text">Universal (kong.conf)</div>
    </a>

</div>
