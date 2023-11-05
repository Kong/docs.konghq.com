---
title: KIC
type: how-to
purpose: |
  How to run multiple KIC instances with leader election
---

{{ site.kic_product_name }} reads state from the Kubernetes API server and generates a {{ site.base_gateway }} configuration. If {{ site.kic_product_name }} is not running, new {{ site.base_gateway }} instances will not receive a configuration. Existing {{ site.base_gateway }} instances will continue to process traffic using their existing configuration.

Your {{ site.kic_product_name }} instance being offline is a major issue. The configuration loaded by {{ site.base_gateway }} will quickly become outdated, especially the upstream endpoints hosting your applications. Without {{ site.kic_product_name }} running, {{ site.base_gateway }} will not detect new application pods, or remove old pods from it's routing configuration.

## Leader Election

Kong recommends running at least _two_ {{ site.kic_product_name }} instances. {{site.kic_product_name}} elects a _leader_ when connected to a database-backed cluster or when Gateway Discovery is configured. This ensures that only a single controller pushes configuration to Kong's database or to Kong's Admin API to avoid potential conflicts and race conditions.

When a leader controller shuts down, other instances will detect that there is no longer a leader, and one will promote itself to the leader.

Leader election is controlled using the `Lease` resource. For this reason, {{ site.kic_product_name }} needs permission to create a `Lease` resource. By default, the permission is given at Namespace level.

The name of the Lease is derived from the value of `election-id` CLI flag or `CONTROLLER_ELECTION_ID` environment variable (default: `5b374a9e.konghq.com`) and `election-namespace` (default: `""`) as: "<election-id>-<election-namespace>". For example, if the {{site.kic_product_name}} has been deployed using Helm , the default `Lease`` that is used for leader election will be `kong-ingress-controller-leader-kong`, and it will be present in the same namespace that the controller is deployed in.