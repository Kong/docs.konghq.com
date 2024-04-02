---
title: High-availability, Scaling, and Robustness
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

{% if_version lte: 2.8.x %}
If a database is not used, then the Controller and Kong are deployed as
co-located containers in the same pod and each controller configures the Kong
container that it is running with.
{% endif_version %}
{% if_version gte: 2.9.x %}
If a database is not used, then the Controller and Kong can be deployed:

- as co-located containers in the same pod and each controller configures the Kong
  container that it is running with.
- in separate deployments where each can be scaled independently.
  To learn more about this approach please see
  [the Gateway Discovery section on Deployments page][concepts-gd].

[concepts-gd]: /kubernetes-ingress-controller/{{page.release}}/concepts/deployment/#gateway-discovery
{% endif_version %}

For cases when a database is necessary, the Controllers can be deployed
on multiple zones to provide redundancy. In such a case, a leader election
process will elect one instance as a leader, which will manipulate Kong's
configuration.

### Leader election

{% if_version gte: 2.9.x %}
Multiple {{site.kic_product_name}} instances elect a leader when connected to a
database-backed cluster or when Gateway Discovery is configured.
This ensures that only a single controller pushes configuration to Kong's database
or to Kong's Admin API to avoid potential conflicts and race
conditions.
{% endif_version %}
{% if_version lte: 2.8.x %}
Multiple {{site.kic_product_name}} instances elect a leader when connected to a
database-backed cluster. This ensures that only a single controller pushes
configuration to Kong's database to avoid potential conflicts and race
conditions.
{% endif_version %}

When a leader controller shuts down, other instances will detect
that there is no longer a leader, and one will promote itself to the leader.

For this reason, the controller needs permission to create a `Lease` resource.
By default, the permission is given at Namespace level.

It also needs permission to read and update this Lease.
This permission can be specific to the Lease that is being used
for leader-election purposes.
The name of the Lease is derived from the value of election-id CLI flag
(default: `5b374a9e.konghq.com`) and
election-namespace (default: `""`) as: "<election-id>-<election-namespace>".
For example, if the {{site.kic_product_name}} has been deployed by Helm chart,
the default Lease that is used for leader election will
be `kong-ingress-controller-leader-kong`, and it will be present in the same
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

{% if_version gte: 2.11.x %}

## Last Known Good Configuration

Prior to {{site.kic_product_name}} 2.11, new pods will not receive a valid
configuration and will be unable to proxy traffic if your Kubernetes API server
contains an invalid Kong configuration.

{{site.kic_product_name}} 2.11 stores the last valid configuration in memory and
uses it to configure new pods. Any pods created due to scale out events or pod
restarts will receive the latest configuration that was accepted by any Kong pod.

{:.note}
> **Note:** Any changes you make with `kubectl` will not be reflected until the
> Kubernetes API server state is fixed. This feature is designed to keep your
> deployment online until an operator can fix the k8s server state.

If the {{site.kic_product_name}} pod is restarted with a broken configuration
on the Kubernetes API server, it will fetch the last valid configuration from an
existing Kong instance and store it in memory.

If there are no running proxy pods when the controller is restarted the last
known good configuration will be lost. In this event, please fix the configuration
on your Kubernetes API server.
{% endif_version %}
