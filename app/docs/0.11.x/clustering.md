---
title: Clustering Reference
---

# Clustering Reference

Multiple Kong nodes using the same datastore belong to the same "Kong cluster".

A Kong cluster allows you to scale the system horizontally by adding more
machines to handle a bigger load of incoming requests, and they all share the
same data since they point to the same datastore.

A Kong cluster can be created in one datacenter, or in multiple datacenters,
in both cloud or on-premise environments. Kong will take care of all cluster
related synchronisation automatically, as long as the nodes are configured
to use the same datastore.

## Summary

- 1. [Getting Started][1]
- 2. [Network Requirements][2]

[1]: #1-getting-started
[2]: #2-network-requirements

## 1. Getting Started

Kong nodes pointing to the same datastore will join in the same Kong cluster.
Changes (to for example APIs, Consumers, Credentials, etc...) are propagated
over the Kong cluster through events that are being
registered in the datastore. Periodically all nodes will check for updates
here and apply the changes.

Kong clustering settings are specified in the configuration file via the
following entries:

* [db_update_frequency][db_update_frequency]
* [db_update_propagation][db_update_propagation]

<div class="alert alert-warning">
  Please note that Kong follows an `eventual consistency` model and hence
  there will be some latency for changes to be effectuated across the cluster.
</div>

## 2. Network Requirements

There are no networking requirements other than Kong being able to connect to
the datastore.

When multiple datacenters or regions are being used (or any other reason to
suspect latency in datastore updates) then please adjust the
[db_update_propagation][db_update_propagation] setting to match accordingly.



[cluster-api-status]: /docs/{{page.kong_version}}/admin-api/#retrieve-cluster-status
[cluster-api-remove]: /docs/{{page.kong_version}}/admin-api/#forcibly-remove-a-node
