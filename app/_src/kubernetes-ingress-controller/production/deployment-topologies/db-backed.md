---
title: Database Backed
type: explanation
purpose: |
  What is a DB-backed deployment and when should it be used?
---

{:.important}
> Database backed deployments should only be used in a small set of circumstances. We recommend using [Gateway Discovery](/kubernetes-ingress-controller/{{ page.release }}/production/deployment-topologies/gateway-discovery/) unless you've been otherwise advised by a member of the Kong team.

Database backed deployments are when {{ site.kic_product_name }} is used to update a Lua control plane that is attached to a PostgreSQL database. {{ site.base_gateway }} may be deployed in either [Traditional](/gateway/latest/production/deployment-topologies/traditional/) or [Hybrid](/gateway/latest/production/deployment-topologies/hybrid-mode/) mode.

Both [Gateway Discovery](/kubernetes-ingress-controller/{{ page.release }}/production/deployment-topologies/gateway-discovery/) and [Sidecar](/kubernetes-ingress-controller/{{ page.release }}/production/deployment-topologies/sidecar/) deployments can be used alongside a database. If you're starting a greenfield project today we recommend using Gateway Discovery.

## Traditional Mode

Traditional mode is when every {{ site.base_gateway }} instance acts as both a control plane and a data plane. All nodes connect to the database and load the latest configuration at a regular interval.

![Traditional Architecture Diagram](/assets/images/products/kubernetes-ingress-controller/topology/db-backed-traditional.png)

{{ site.kic_product_name }} sends configuration to a random {{ site.base_gateway }} instance, which writes the configuration to the database. All other nodes read the configuration from the database.

## Hybrid Mode

Database backed Hybrid mode is similar to Traditional mode, but instead of every node reading from the database a single control plane is responsible for managing the configuration and distributing it to all active data planes.

In Hybrid mode, {{ site.kic_product_name }} uses Gateway Discovery to find the control plane and send {{ site.base_gateway }} configuration to the Admin API. This configuration is persisted to the PostgreSQL database and transmitted to the data planes using the {{ site.base_gateway }} CP/DP protocol.

![Hybrid Mode Architecture Diagram](/assets/images/products/kubernetes-ingress-controller/topology/db-backed-hybrid.png)