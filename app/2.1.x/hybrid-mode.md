---
title: Hybrid Mode Deployment
---


## Introduction

Traditionally, Kong has always required a database, which could be either
Postgres or Cassandra, to store its configured entities such as Routes,
Services and Plugins. In Kong 1.1 we added the capability to run Kong without
a database, using only in-memory storage for entities: we call this [**DB-less mode**][db-less].

In Kong 2.0, we introduced a new method of deploying Kong which is
called the **Hybrid mode**, also known as **Control Plane / Data Plane Separation (CP/DP)**.

In this mode Kong nodes in a cluster are separated into two roles: Control Plane (CP), where configuration is managed and the Admin API is served from,
and Data Plane (DP), which serves traffic for the proxy. Each DP node is connected to one of the CP nodes. Instead of accessing the
database contents directly in the traditional deployment method, the DP nodes maintains
connection with CP nodes, and receives the latest configuration.

Deploying using Hybrid mode has a number of benefits:

* Drastically reduce the amount of traffic on the database, since only CP nodes need a
  direct connection to the database.
* Increased security, in an event where one of the DP nodes gets intruded, an attacker
  won't be able to affect other nodes in the Kong cluster.
* Easiness of management, since an admin will only need to interact with the CP nodes to control
  and monitor the status of the entire Kong cluster.

## Topology

![Example Hybrid Mode Topology](/assets/images/docs/hybrid-mode.png "Example Hybrid Mode Topology")

## Generating Certificate/Key Pair

Before using the Hybrid Mode, it is necessary to have a shared certificate/key pair generated
so that the communication security between CP and DP nodes can be established.

This certificate/key pair is shared by both CP and DP nodes, mutual TLS handshake (mTLS) is used
for authentication so the actual private key is never transferred on the network.

<div class="alert alert-warning">
  <strong>Protect the Private Key!</strong> Ensure the private key file can only be accessed by
  Kong nodes belonging to the cluster. If key is suspected to be compromised it is necessary to
  re-generate and replace certificate and keys on all the CP/DP nodes.
</div>

To create a certificate/key pair:

```
kong hybrid gen_cert
```

This will generate `cluster.crt` and `cluster.key` files and save them to the current directory.
By default it is valid for 3 years, but can be set longer or shorter with the `--days` option.

See `kong hybrid --help` for more usage information.

The `cluster.crt` and `cluster.key` files need to be transferred to both Kong CP and DP nodes.
Observe proper permission setting on the key file to ensure it can only be read by Kong.

## Setting Up Kong Control Plane Nodes

Starting the Control Plane is fairly simple. Aside from the database configuration
which is the same as today, we need to specify the "role" of the node to "control\_plane".
This will cause Kong to listen on `0.0.0.0:8005` by default for Data Plane
connections. The `8005` port on the Control Plane will need to be
accessible by all the Data Plane it controls through any firewalls you may have
in place.

In addition, the `cluster_cert` and `cluster_cert_key` configuration need to point to
the certificate/key pair that was generated above.

```
KONG_ROLE=control_plane KONG_CLUSTER_CERT=cluster.crt KONG_CLUSTER_CERT_KEY=cluster.key kong start
```

Or in `kong.conf`:

```
role = control_plane
cluster_cert = cluster.crt
cluster_cert_key = cluster.key
```

Note that Control Plane still needs a database (Postgres or Cassandra) to store the
"source of truth" configurations, although the database never needs to be access by
Data Plane nodes. You may run more than a single Control Plane nodes to provide load balancing
and redundancy as long as they points to the same backend database.

## Starting Data Plane Nodes

Now we have a Control Plane running, it is not much useful if no Data Plane nodes are
talking to it and serving traffic (remember Control Plane nodes can not be used
for proxying). To start the Data Plane, all we need to do is to specify the "role"
to "data\_plane", give it the address and port of where the Control Plane can be reached
and the node automatically connects and syncs itself up with the current configuration.

Similar to the CP config above, `cluster_cert` and `cluster_cert_key` configuration need to
point to the same files as the CP has. In addition the `cluster.crt` file need to be listed
as trusted by OpenResty through the `lua_ssl_trusted_certificate` configuration. If you
have already specified a different `lua_ssl_trusted_certificate`, then adding the content
of `cluster.crt` into that file will achieve the same result.

**Note:** In this release of the Hybrid Mode, the Data Plane receives updates from the Control
Plane via a format that is similar to the Declarative Config, therefore the `storage`
property has to be set to `memory` for Kong to start up properly.

```
KONG_ROLE=data_plane KONG_CLUSTER_CONTROL_PLANE=control-plane.example.com:8005 KONG_CLUSTER_CERT=cluster.crt KONG_CLUSTER_CERT_KEY=cluster.key KONG_LUA_SSL_TRUSTED_CERTIFICATE=cluster.crt KONG_DATABASE=off kong start
```

Or in `kong.conf`:

```
role = data_plane
cluster_control_plane = control-plane.example.com:8005
database = off
cluster_cert = cluster.crt
cluster_cert_key = cluster.key
lua_ssl_trusted_certificate = cluster.crt
```

## Checking the status of the cluster

You may want to check the status of the Kong cluster from time to time, such as
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
to the [Plugin Compatibility section][plugin-compat]
of declarative config documentation for more information.

---

[plugin-compat]: /{{page.kong_version}}/db-less-and-declarative-config#plugin-compatibility
[db-less]: /{{page.kong_version}}/db-less-and-declarative-config
