---
title: Kong Deployment Guide
redirect_from: "/enterprise/0.34-x/kong-implementation-checklist/"
---
## Introduction

- Kong can run on instances of any size with any resources. While the system
requirements vary significantly depending on the use-case, generally speaking,
we recommend to start big and then gradually reduce the instances to the
appropriate number and size.
- When allocating resources to a Kong cluster, slightly over-provision the
cluster to make room for request spikes. Kong requires a database to run and
you can choose either Cassandra or PostgreSQL.

## PostgreSQL

- Generally speaking, PostgreSQL works well for most of the use-cases, and it’s
usually easier to setup. We recommend setting up a master-slave replication with
servers located in different racks, data centers or availability zones to
account for infrastructure failures.
- In Multi-DC environments, PostgreSQL may not be the right fit, since a Kong
node located in a different datacenter will have to send write requests all the
way to the PostgreSQL data-center, adding increased latency to the system.

## Cassandra

- We recommend using Cassandra in Multi-DC environments because it supports
native replication and availability capabilities of the system. When starting a
Cassandra cluster for Kong, we recommend starting at least 3 nodes in every
datacenter with a replication setting of 2.
- Cassandra is an **eventually consistent datastore**, which means that over
time the data will be the same across the cluster, so please account for
inconsistencies in the system.

## Kong Cluster

- Regardless of the datastore being adopted with Kong, the Kong nodes themselves
need to join in a cluster. The Kong nodes will talk to each other via their
connections to the database—PostgreSQL or Cassandra. Please refer to the
[clustering reference](/0.13.x/clustering/) for more details.

## Production System Requirements

- For Kong, prefer CPU optimized instances. We recommend at least 4 CPU cores,
16GB of RAM and 24GB of disk space. Kong performs better on a system with
multiple cores. In an AWS environment, we recommend running c4.2xlarge instances
in production that guarantee enough cores (8) and memory (16GB).
- For Cassandra and PostgreSQL, prefer memory optimized instances. Assume more
intensive workload on the datastore if you are using the rate-limiting or
response rate-limiting plugins with a “cluster” policy. Use this only if Redis
is not an option. High ulimit value, possibly >=65535. A higher limit value
will allow Kong and the datastores to process more incoming requests.

## High Availability

- Instances with multiple cores are required. Kong, by leveraging the underlying
Nginx runtime, will start a worker process for each core. On systems with
multiple cores a worker crash will not badly affect the system since the other
workers can process the ongoing HTTP requests until the crashed worker is being
automatically replaced with a new one.
- At least 2 nodes/instances of Kong, behind a load balancer (Nginx, HAProxy,
AWS ELB or similar). This prevents downtime if a Kong node crashes, since the
other nodes can process the incoming HTTP requests. The number of instances
behind the load balancer should increase with the number of incoming requests,
to avoid the scenario when after a node crashes the sudden increase of load to
the remaining nodes will effectively DDoS them and make the other nodes crash
too.

## Scaling Kong

- Kong is stateless and more nodes can be added behind the load balancer to
scale the system. Incoming HTTP/s requests can be processed by any server, and
that also includes the Kong’s Admin API.
- Every new Kong node should target the same datastore, and join the existing
Kong nodes in a cluster. Failure to join the Kong nodes in a Kong cluster will
result in data inconsistencies and errors when processing requests. Kong
automates joining a node in the cluster as long as the right configuration
settings have been provided. For more information, we recommend reading the
[clustering reference](/0.13.x/clustering/).

## Kong Performance

The performance of Kong varies depending on multiple factors, including:

- Network latency from the client to Kong, and from Kong to the final upstream
servers, greatly affects the performance. The faster the network, the better
Kong will perform in pretty much every aspect, including system resources.
- Number of incoming HTTP requests and the size of requests and responses that
have to be processed.
- Response time from the upstream server. The fastest the upstream servers can
process a request, the faster Kong can process the response back to the client
and free up resources to handle more incoming requests.
- The number of plugins that are being executed. The more plugins, the more
processing time Kong will require when proxying requests.

## Cassandra

We recommend using the [NetworkTopologyStrategy][cassandra-network-topology]
with three replicas in each data center to tolerate either the failure of a one
node per replication group at a strong consistency level of LOCAL_QUORUM or
multiple node failures per data center using consistency level ONE.

## PostgreSQL

We recommend using a master-slave setup that will guarantee an appropriate
replication of data in case of failures.

## Network & Firewall

In this section, you will find a summary about the recommended network and
firewall settings for Kong.

### Ports

These are the port settings in order for Kong to work:

- Allow HTTP traffic to [`proxy_listen`](/0.13.x/configuration/#proxy_listen). By default, `8000`.
- Allow HTTPS traffic to [`proxy_listen`](/0.13.x/configuration/#proxy_listen). By default, `8443`.
- Allow HTTP traffic to [`admin_listen`](/0.13.x/configuration/#admin_listen). By default, `8001`.
- Allow HTTPS traffic to [`admin_listen`](/0.13.x/configuration/#admin_listen). By default, `8444`.

For Kong Manager:

- Allow HTTP traffic to [`admin_gui_listen`](/enterprise/{{page.kong_version}}/property-reference/#admin_gui_listen). 
By default, `8002`.
- Allow HTTPS traffic to [`admin_gui_listen`](/enterprise/{{page.kong_version}}/property-reference/#admin_gui_listen). 
By default, `8445`.

For Dev Portal:

- Allow HTTP traffic to [`portal_gui_listen`](/enterprise/{{page.kong_version}}/property-reference/#portal_gui_listen). 
By default, `8003`.
- Allow HTTPS traffic to [`portal_gui_listen`](/enterprise/{{page.kong_version}}/property-reference/#portal_gui_listen). 
By default, `8446`.

**Note**: since Kong CE 0.13.0—and EE 0.32—listen directives have a new
format, described [here](/0.13.x/configuration/#proxy_listen), where instead of
specifying SSL and non-SSL ports in different configuration directives—e.g.,
`admin_listen` and `admin_listen_ssl`—only one is required: for example, the
listen directive for the Admin API for SSL and non-SSL ports now looks like:

```
0.0.0.0:8001, 0.0.0.0:8444 ssl
```

Other listen directives comply to the new format.

### Firewall

Below are the recommended firewall settings:

- The upstream APIs behind Kong will be available on [proxy_listen][proxy].
Configure listeners accordingly to the access level you wish to grant to the
upstream APIs.
- Protect [admin_listen][admin], and only allow trusted sources that can access
the Admin API.

### Network

- Kong assumes a flat network topology in Multi-DC setups. If you have a
Multi-DC setup, Kong nodes between the datacenters should communicate over a
VPN connection.
- Kong will try to auto-detect the node’s first, non-loopback, IPv4 address and
advertise this address to other Kong nodes. Sometimes this is not enough and the
IP address needs to be manually set, you can do that by changing the advertise
property in the cluster configuration.

## Upgrades and Deployments

On every Kong release we also upgrade the [Upgrade Path][upgrade] document
available on the official Kong repository on GitHub. We recommend following the
instructions when upgrading to a newer version of Kong.

Kong provides two different ways of upgrading the software depending if you are
upgrading between major versions (0.a.x, 0.b.x) or minor versions (0.x.a, 0.x.b):

- Major versions in a pre-1.0 release are, for example, v0.7.x, v0.8.x, v0.9.x, etc.
- Minor versions in a pre-1.0 phase are v0.7.1, v0.7.2 considering a 0.7.x
baseline version, or v0.8.1, v0.8.2 in a 0.8.x baseline version.

Starting from version Kong >= 0.9.0 we adopt the following upgrade strategy:

### Upgrading to a Minor Version:

Upgrading to a minor version of the same baseline can be done easily—for
example, from v0.9.1 to v0.9.2—by installing the newer version on the fly in
the same node (and executing `kong restart` or `kong reload` to load
the new version), or by a classic blue/green deployment strategy:
1. Start a new cluster with the new version, and with the same number of nodes,
pointing to the same datastore.
2. Instructing the load balancer to point new traffic to the new cluster.
3. Terminating the old cluster.

This process can be done without any down-time.

### Upgrading to a Major Version:

Upgrading to different major versions (i.e., from v0.8.0 to v0.9.1, or from
0.9.0 to 0.10.0) is a more elaborate process that cannot be done on the fly.
Newer major versions provide database schema migrations that are not necessarily
compatible with the previous version of Kong. Administrators should follow the
instructions below carefully to avoid any issues.

Prior to Kong CE 0.11 and Kong EE 0.29, nodes automatically ran migrations when
started. On later versions, Admins should run migrations manually before
starting nodes.

Kong can keep processing existing consumers even if the datastore is down, since
it caches the used datastore entities in memory. To upgrade between major
versions:

1. Disconnect the datastore from the current Kong cluster by setting up the
appropriate firewall setting or updating the appropriate security group.
2. Kong will now rely on its internal cache to serve existing requests.
3. Create a node in a new Kong cluster and run `kong migrations up` to process
migrations. Once the node has completed the migration, start it with `kong start`.
Confirm that it can process requests and configuration changes (creating and
deleting a test API will suffice to confirm Kong can communicate with the
datastore).
4. Start additional nodes in the new cluster until its node count matches the
old cluster size.
5. Once the new cluster is running and able to process requests, configure your
load balancer to direct new traffic to the new cluster.
6. Terminate the old cluster.

Upgrades between major versions need to be planned in advance as they involve
downtime for new consumers that have not been cached in memory yet, and because
the Admin API won’t be available on the old cluster for the entire process.

### Upgrading to 0.34

#### Considerations before Upgrading to 0.34

* Key Authentication is being deprecated in favor of Basic Authentication. *Before migrating to 0.34, anyone using Key Authentication in 0.33-x should create Basic Authentication credentials for all of their Admins.*
* Vitals will now be enabled by default. Any Admin who logs in to Kong Manager will have the ability to see charts and metrics for Workspaces they have access to.
* The Dev Portal and Kong Manager no longer allow use of proxy ports in 0.34. Note that any previous proxies will need to be updated according to [Dev Portal Networking](enterprise/{{page.kong_version}}/developer-portal/configuration/networking/) and [Kong Manager Networking](enterprise/{{page.kong_version}}/kong-manager/configuration/networking/).
* The Dev Portal now supports Workspaces. Existing Dev Portal configurations, files, URLs, and developers will be moved to the 'Default' Workspace. See [Working with Workspaces](/enterprise/{{page.kong_version}}/developer-portal/configuration/workspaces)
* For a complete list of new features in 0.34, refer to the [Changelog](/enterprise/changelog).

#### How to Upgrade to 0.34

1. If using Key Authentication in 0.33-x, create Basic Authentication credentials for each Admin using [this guide](/enterprise/0.33-x/admin-gui/configuration/authentication/#basic-authentication)
2. Disconnect the datastore from the current Kong cluster by setting up the appropriate firewall setting or updating the appropriate security group. Kong will now rely on its internal cache to serve existing requests.
3. Download Kong Enterprise 0.34
4. Ensure the following properties are configured:

      [`enforce_rbac`](/enterprise/0.34-x/property-reference#enforce_rbac) is `on`

      [`admin_gui_auth`](/enterprise/0.34-x/property-reference/#admin_gui_auth) is set to `basic-auth` or `ldap-auth`

      [`portal_gui_protocol`](/enterprise/0.34-x/property-reference/#portal_gui_protocol) is set to `http` or `https`

      [`portal_gui_host`](/enterprise/0.34-x/property-reference/#portal_gui_host) is set to `localhost:8003` or the custom host name configured for Dev Portal
5. Create a node in a new Kong cluster and run kong migrations up to process migrations. 
6. Once the node has completed the migration, start it with kong start. 
7. Confirm that it can process requests and configuration changes (creating and deleting a test Service will suffice to confirm Kong can communicate with the datastore).
8. Start additional nodes in the new cluster until its node count matches the old cluster size.
9. Once the new cluster is running and able to process requests, configure your load balancer to direct new traffic to the new cluster.
10. Log in to Kong Manager as a Super Admin.
11. Provide an email address for each Admin in case they need to reset their passwords in the future, as described in [this guide](/enterprise/{{page.kong_version}}/kong-manager/organization-management/managing-admins/#how-to-invite-a-new-admin-in-a-workspace)
12. Terminate the old cluster.

---

[cassandra-network-topology]: https://docs.datastax.com/en/cassandra/3.0/cassandra/architecture/archDataDistributeReplication.html
[proxy]: /0.13.x/configuration/#proxy_listen
[admin]: /0.13.x/configuration/#admin_listen
[upgrade]: https://github.com/Kong/kong/blob/master/UPGRADE.md
