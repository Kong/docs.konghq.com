---
title: Overview
type: explanation
purpose: |
  What deployment topologies are available and when should they be used?
---

{{ site.kic_product_name }} can be deployed in many different topologies depending on your needs. The primary methods to deploy {{ site.kic_product_name }} are:

1. [Gateway Discovery](/kubernetes-ingress-controller/{{ page.release }}/production/deployment-topologies/gateway-discovery/) - The recommended method to deploy {{ site.kic_product_name }}.
1. [Database Backed with Gateway Discovery](/kubernetes-ingress-controller/{{ page.release }}/production/deployment-topologies/db-backed/) - Gateway Discovery with an additional Lua control plane and Postgres database.
1. [Traditional (Sidecar)](/kubernetes-ingress-controller/{{ page.release }}/production/deployment-topologies/sidecar/) - Run {{ site.kic_product_name }} as a sidecar container in the same Pod as {{ site.base_gateway }} (legacy deployment).

If you're starting a greenfield project today we recommend using Gateway Discovery. If you're a long-time user of {{ site.kic_product_name }} you're likely to be using the sidecar model. This approach is still valid and supported, but is not as resource efficient as Gateway Discovery.

