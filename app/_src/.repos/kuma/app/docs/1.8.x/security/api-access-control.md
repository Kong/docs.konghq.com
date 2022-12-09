---
title: Kuma API Access Control
---

Kuma provide a simple access control to administrative actions executed on Kuma API Server (port 5681 by default).

## Manage admin resources

Admin resources are `Secret` and `GlobalSecret`.

* `KUMA_ACCESS_STATIC_ADMIN_RESOURCES_USERS` allows users to manage admin resources. Default is `mesh-system:admin`.
* `KUMA_ACCESS_STATIC_ADMIN_RESOURCES_GROUPS` allows groups to manage admin resources. Default is `mesh-system:admin`.

## Generate dataplane token

* `KUMA_ACCESS_STATIC_GENERATE_DP_TOKEN_USERS` allows users to generate dataplane token. Default `mesh-system:admin`.
* `KUMA_ACCESS_STATIC_GENERATE_DP_TOKEN_GROUPS` allows groups to generate dataplane token. Default `mesh-system:admin`.

## Generate user token

* `KUMA_ACCESS_STATIC_GENERATE_USER_TOKEN_USERS` allows users to generate user token. Default `mesh-system:admin`.
* `KUMA_ACCESS_STATIC_GENERATE_USER_TOKEN_GROUPS` allows groups to generate user token. Default `mesh-system:admin`.

## Generate zone token

* `KUMA_ACCESS_STATIC_GENERATE_ZONE_TOKEN_USERS` allows users to generate zone token. Default `mesh-system:admin`.
* `KUMA_ACCESS_STATIC_GENERATE_ZONE_TOKEN_GROUPS` allows groups to generate zone token. Default `mesh-system:admin`.

## View Envoy config dump

* `KUMA_ACCESS_STATIC_GET_CONFIG_DUMP_USERS` allows users to view Envoy config dump. Default is an empty list.
* `KUMA_ACCESS_STATIC_GET_CONFIG_DUMP_GROUPS` allows groups to view Envoy config dump. Default: `mesh-system:unauthenticated`, `mesh-system:authenticated`.

## View Envoy stats

* `KUMA_ACCESS_STATIC_VIEW_STATS_USERS` allows users to view Envoy stats. Default is an empty list.
* `KUMA_ACCESS_STATIC_VIEW_STATS_GROUPS` allows groups to view Envoy stats. Default: `mesh-system:unauthenticated`, `mesh-system:authenticated`.

## View Envoy clusters

* `KUMA_ACCESS_STATIC_VIEW_CLUSTERS_USERS` allows users to view Envoy clusters. Default is an empty list.
* `KUMA_ACCESS_STATIC_VIEW_CLUSTERS_GROUPS` allows groups to view Envoy clusters. Default: `mesh-system:unauthenticated`, `mesh-system:authenticated`.
