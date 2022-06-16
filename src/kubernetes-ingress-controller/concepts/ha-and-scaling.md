---
title: High-availability and Scaling
---

## High availability

The {{site.kic_product_name}} is designed to be reasonably easy to operate and
be highly available, meaning, when some expected failures do occur, the
Controller should be able to continue to function with minimum possible
service disruption.

The {{site.kic_product_name}} is composed of two parts: 1. Kong, which handles
the requests, 2. Controller, which configures Kong dynamically.

Kong itself can be deployed in a highly-available manner by deploying
multiple instances (or pods). Kong nodes are state-less, meaning a Kong pod
can be terminated and restarted at any point of time.

The controller itself can be stateful or stateless, depending on if a database
is being used or not.

If a database is not used, then the Controller and Kong are deployed as
co-located containers in the same pod and each controller configures the Kong
container that it is running with.

For cases when a database is necessary, the Controllers can be deployed
on multiple zones to provide redundancy. In such a case, a leader election
process will elect one instance as a leader, which will manipulate Kong's
configuration.

### Leader election (database-backed clusters only)

Multiple {{site.kic_product_name}} instances elect a leader when connected to a
database-backed cluster. This ensures that only a single controller pushes
configuration to Kong's database to avoid potential conflicts and race
conditions. When a leader controller shuts down, other instances will detect
that there is no longer a leader, and one will promote itself to the leader.

For this reason, the controller needs permission to create a ConfigMap.
By default, the permission is given at Cluster level, but it can be narrowed
down to a single namespace (using Role and RoleBinding) for a stricter RBAC
policy.

It also needs permission to read and update this ConfigMap.
This permission can be specific to the ConfigMap that is being used
for leader-election purposes.
The name of the ConfigMap is derived from the value of election-id CLI flag
(default: `ingress-controller-leader`) and
ingress-class (default: `kong`) as: "<election-id>-<ingress-class>".
For example, the default ConfigMap that is used for leader election will
be `ingress-controller-leader-kong`, and it will be present in the same
namespace that the controller is deployed in.

## Scaling

Kong is designed to be horizontally scalable, meaning as traffic increases,
multiple instances of Kong can be deployed to handle the increase in load.

The configuration is either pumped into Kong directly via the Ingress
Controller or loaded via the database. Kong containers can be considered
stateless as the configuration is either loaded from the database (and
cached heavily in-memory) or loaded in-memory directly via a config file.

One can use a `HorizontalPodAutoscaler` (HPA) based on metrics
like CPU utilization, bandwidth being used, total request count per second
to dynamically scale {{site.kic_product_name}} as the traffic profile changes.
