---
title: Ports and Network Requirements
no_version: true
---

## Konnect Cloud ports

The {{site.konnect_saas}} control plane uses the following port:

| Port      | Protocol  | Description |
|:----------|:----------|:------------|
| `:443`    | TCP <br>HTTPS | Cluster communication port for configuration and telemetry data. The {{site.konnect_saas}} control plane uses this port to listen for runtime node connections and to communicate with the runtime nodes. |

Kong's hosted control plane expects traffic on this port, so the cluster port
can't be customized.

The cluster communication port must be accessible by all
the data planes within the same cluster. This port is protected by mTLS to
ensure end-to-end security and integrity.

## Runtime ports

{% include /md/gateway-ports.md %}

## Hostnames to add to allow lists

The {{site.konnect_saas}} control plane uses the following hostnames:
* `cp.konnect.konghq.com`: configuration
* `tp.konnect.konghq.com`: telemetry

You can find your specific instance hostnames through Runtime manager.
Start configuring a new runtime, choose the Linux or Kubernetes tab, and note
the hostnames in the codeblock.
