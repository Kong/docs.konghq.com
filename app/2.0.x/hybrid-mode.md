---
title: Hybrid Mode Deployment
---


## Introduction

Traditionally, Kong has always required a database, which could be either
Postgres or Cassandra, to store its configured entities such as Routes,
Services and Plugins. In Kong 1.1 we added the capability to run Kong without
a database, using only in-memory storage for entities: we call this **DB-less mode**.

For Kong 2.0, we introduced a new method of deploying cluster of Kong which is
called the **Hybrid mode**, also known as **Control Plane / Data Plane Separation (CP/DP)**.

In this mode Kong nodes in a cluster are separated into two roles: Control Plane (CP)
and Data Plane (DP). Each DP is connected to one of the CP. Instead of accessing the
database contents directly in the traditional deployment method, the DP nodes maintains
connection with CP nodes and receives the latest configuration from the DP nodes.

Deploying using Hybrid mode has a number of benefits:

* Reduce the amount of traffic on the database, since only CP needs
  direct connection to the database.
* Increased security, in an event one of the DP node got intruded, attacker
  won't be able to affect other nodes in the Kong cluster.
* Easiness of management, since admin only need to interact with the CP to control
  and monitor the status of the entire Kong cluster.

## Topology

<INSERT TYPICAL CP/DP TOPOLOGY HERE>

## Setting Up Kong Control Plane Nodes

Starting the Control Plane is fairly simple. Aside from the database configuration
which is the same as today, we need to specify the "role" of the node to "admin".
This will cause Kong to listen on `0.0.0.0:8002` by default for Data Plane
connections. The `8002` port on the Control Plane will need to be
accessible by all the Data Plane it controls through any firewalls you may have
in place.

```
KONG_ROLE=admin kong start
```

Or in `kong.conf`:

```
role = admin
```

Note that Control Plane still needs a database (Postgres or Cassandra) to store the
"source of truth" configurations, although the database never needs to be access by
Data Plane nodes. You may run more than a single Control Plane nodes to provide load balancing
and redundancy as long as they points to the same backend database.

## Starting Data Plane Nodes

Now we have a Control Plane running, it is not much useful if no Data Plane nodes are
talking to it and serving traffic (remember Control Plane nodes can not be used
for proxying). To start the Data Plane, all we need to do is to specify the "role"
to "proxy", give it the address and port of where the Control Plane can be reached
and the node automatically connects and syncs itself up with the current configuration.

**Note:** In this release of the Hybrid Mode, the Data Plane receives updates from the Control
Plane via a format that is similar to the Declarative Config, therefore the `storage`
property has to be set to `memory` for Kong to start up properly.

```
KONG_ROLE=proxy KONG_CLUSTER_CONTROL_PLANE=control-plane.example.com:8002 KONG_STORAGE=memory kong start
```

Or in `kong.conf`:

```
role = proxy
cluster_control_plane = control-plane.example.com:8002
storage = memory
```

## Checking the status of the cluster

We may want to check the status of the Kong cluster from time to time, such as
checking to see the which nodes are actively receiving config updates from
Control Plane, or when was it last updated. This can be achieved by using the
Control Plane's new Cluster Status API:

```
# on Control Plane node
http :8001/clustering/status

{
    "a08f5bf2-43b8-4f1c-bdf5-0a0ffb421c21": {
        "config_hash": "64d661f505f7e1de5b4c5e5faa1797dd",
        "hostname": "data-plane-2",
        "ip": "192.168.10.3",
        "last_seen": 1571197860
    },
    "e1fd4970-6d24-4dfb-b2a7-5a832a5de6e1": {
        "config_hash": "64d661f505f7e1de5b4c5e5faa1797dd",
        "hostname": "data-plane-1",
        "ip": "192.168.10.4",
        "last_seen": 1571197866
    }
}
```

The Cluster Status API provides helpful information such as
the name of the node and last time it synced with the Control Plane, as
well as config version currently running on them.

## Managing the cluster using Control Plane nodes

Once the nodes are setup, use the Admin API on the Control Plane as usual,
those changes will be synced and updated on the Data Plane nodes
automatically within seconds.

## Fault tolerance

A valid question you may ask is: What would happen if Control Plane nodes are down,
will the Data Plane keep functioning? The answer is yes. Data plane caches
the latest configuration it received from the Control Plane on the local disk.
In case Control Plane stops working, Data Plane will keep serving requests using
cached configurations. It does so while constantly trying to reestablish communication
with the Control Plane.

This means that the Data Plane nodes can be restarted while the Control Plane
is down, and still proxy traffic normally.

## Limitations

### Plugins compatibility

This version of Hybrid Mode uses declarative config as the config sync format which
means it has the same limitations as declarative config as of today. Please refer
to the [Plugin Compatibility section](db-less-and-declarative-config#plugin-compatibility)
of declarative config documentation for more information.
