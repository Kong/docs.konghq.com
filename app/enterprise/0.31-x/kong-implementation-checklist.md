---
title: Kong Implementation Checklist
---
# Kong Implementation Checklist

- Kong can run on instances of any size with any resources. While the system requirements vary significantly depending on the use-case, generally speaking, we recommend to start big and then gradually reduce the instances to the appropriate number and size.
- When allocating resources to a Kong cluster, slightly over-provision the cluster to make room for request spikes. Kong requires a database to run and you can choose either Cassandra or PostgreSQL.

### PostgreSQL

- Generally speaking, PostgreSQL works well for most of the use-cases, and it’s usually easier to setup. We recommend setting up a master-slave replication with servers located in different racks, data centers or availability zones to account for infrastructure failures.
- In multi-DC environments, PostgreSQL may not be the right fit, since a Kong node located in a different datacenter will have to send write requests all the way to the PostgreSQL data-center, adding increased latency to the system.

### Cassandra

- We recommend using Cassandra in multi-DC environments because it supports native replication and availability capabilities of the system. When starting a Cassandra cluster for Kong, we recommend starting at least 3 nodes in every datacenter with a replication setting of 2.
- Cassandra is an eventually consistent datastore, which means that over time the data will be the same across the cluster, so please account for inconsistencies in the system.

### Kong Cluster

- Regardless of the datastore being adopted with Kong, the Kong nodes themselves need to join in a cluster. The Kong nodes will talk to each other via their connections to the database (PostgreSQL or Cassandra). Please refer to the [clustering reference](/latest/clustering/) for more details.

## Production System Requirements

- For Kong, prefer CPU optimized instances. We recommend at least 4 CPU cores, 16GB of RAM and 24GB of disk space. Kong performs better on a system with multiple cores. In an AWS environment, we recommend running c4.2xlarge instances in production that guarantee enough cores (8) and memory (16GB).
- For Cassandra and PostgreSQL, prefer memory optimized instances. Assume more intensive workload on the datastore if you are using the rate-limiting or response rate-limiting plugins with a “cluster” policy. Use this only if Redis is not an option.
High ulimit systemvalue, possibly >=65535 . A higher limit value will allow Kong and the datastores to process more incoming requests.

## High Availability

- Instances with multiple cores are required. Kong, by leveraging the underlying Nginx runtime, will start a worker process for each core. On systems with multiple cores a worker crash will not badly affect the system since the other workers can process the ongoing HTTP requests until the crashed worker is being automatically replaced with a new one.
- At least 2 nodes/instances of Kong, behind a load balancer (Nginx, HAProxy, AWS ELB or similar). This prevents downtime if a Kong node crashes, since the other nodes can process the incoming HTTP requests. The number of instances behind the load balancer should increase with the number of incoming requests, to avoid the scenario when after a node crashes the sudden increase of load to the remaining nodes will effectively DDoS them and make the other nodes crash to

## Scaling Kong

- Kong is stateless and more nodes can be added behind the load balancer to scale the system. Incoming HTTP/s requests can be processed by any server, and that also includes the Kong’s Admin API.
- Every new Kong node should target the same datastore, and join the existing Kong nodes in a cluster. Failure to join the Kong nodes in a Kong cluster will result in data inconsistencies and errors when processing requests. Kong automates joining a node in the cluster as long as the right configuration settings have been provided. For more information, we recommend reading the [clustering reference](/latest/clustering/).

## Kong Performance

The performance of Kong varies depending on multiple factors, including:

- Network latency from the client to Kong, and from Kong to the final upstream servers, greatly affects the performance. The faster the network, the better Kong will perform in pretty much every aspect, including system resources.
- Number of incoming HTTP requests and the size of requests and responses that have to be processed.
- Response time from the upstream server. The fastest the upstream servers can process a request, the faster Kong can process the response back to the client and free up resources to handle more incoming requests.
- The number of plugins that are being executed. The more plugins, the more processing time Kong will require when proxying requests.

## Cassandra

We recommend using the NetworkTopologyStrategy with three replicas in each data center to tolerate either the failure of a one node per replication group at a strong consistency level of LOCAL_QUORUM or multiple node failures per data center using consistency level ONE.

## PostgreSQL

We recommend using a master-slave setup that will guarantee an appropriate replication of data in case of failures.

## Network & Firewall

In this section, you will find a summary about the recommended network and firewall settings for Kong.

### Ports

These are the port settings in order for Kong to work:

- Allow HTTP traffic to [proxy_listen](/latest/configuration/#proxy_listen). By default  8000.
- Allow HTTPS traffic to [proxy_listen_ssl](/latest/configuration/#proxy_listen_ssl). By default 8443.
- Allow HTTP traffic to [admin_listen](/latest/configuration/#admin_listen). By default 8001.
- Allow HTTPS traffic to [admin_listen_ssl](/latest/configuration/#admin_listen_ssl). By default 8444.
- Allow HTTP traffic to admin_gui_listen. By default 8002.
- Allow HTTPS traffic to admin_gui_listen_ssl. By default 8445.

### Firewall

Below are the recommended firewall settings:

- The upstream APIs behind Kong will be available on [proxy_listen](/latest/configuration/#proxy_listen) and [proxy_listen_ssl](/latest/configuration/#proxy_listen_ssl). Configure these ports accordingly to the access level you wish to grant to the upstream APIs.
- Protect [admin_listen](/latest/configuration/#admin_listen), and only allow trusted sources that can access the Admin API.

### Network

- Kong assumes a flat network topology in multi-datacenter setups. If you have a multi-datacenter setup, Kong nodes between the datacenters should communicate over a VPN connection.
- Kong will try to auto-detect the node’s first, non-loopback, IPv4 address and advertise this address to other Kong nodes. Sometimes this is not enough and the IP address needs to be manually set, you can do that by changing the advertise property in the cluster configuration.

## Upgrades and Deployments

On every Kong release we also upgrade the [Upgrade Path](https://github.com/Kong/kong/blob/master/UPGRADE.md) document available on the official Kong repository on GitHub. We recommend following the instructions when upgrading to a newer version of Kong.

Kong provides two different ways of upgrading the software depending if you are upgrading between major versions (0.a.x, 0.b.x) or minor versions (0.x.a, 0.x.b):

- Major versions in a pre-1.0 release are, for example, v0.7.x, v0.8.x, v0.9.x, etc.
- Minor versions in a pre-1.0 phase are v0.7.1, v0.7.2 considering a 0.7.x baseline version,
or v0.8.1, v0.8.2 in a 0.8.x baseline version.

Starting from version Kong >= 0.9.0 we adopt the following upgrade strategy:

### Upgrading to a minor version:

Upgrading to a minor version of the same baseline can be done easily (for example from v0.9.1 to v0.9.2) can be done by installing the newer version on the fly in the same node (and executing “kong restart” or “kong reload” to load the new version), or by a classic blue/green deployment strategy:
1. Start a new cluster with the new version, and with the same number of nodes, pointing to the same datastore.
2. Instructing the load balancer to point new traffic to the new cluster.
3. Terminating the old cluster.

This process can be done without any down-time.

### Upgrading to a major version:

Upgrading to different major versions (ie, from v0.8.0 to v0.9.1, or from 0.9.0 to 0.10.0) is a more elaborate process that cannot be done on the fly. Newer major versions provide database schema migrations that are not necessarily compatible with the previous version of Kong. Administrators should follow the instructions below carefully to avoid any issues.

Prior to Kong 0.11 and Kong Enterprise 0.29, nodes automatically ran migrations when started. On later versions, administrators should run migrations manually before starting nodes.

Kong can keep processing existing consumers even if the datastore is down, since it caches the used datastore entities in memory. To upgrade between major versions:

1. Disconnect the datastore from the current Kong cluster by setting up the appropriate firewall setting or updating the appropriate security group.
2. Kong will now rely on its internal cache to serve existing requests.
3. Create a node in a new Kong cluster and run "kong migrations up" to process migrations. Once the node has completed the migration, start it with "kong start". Confirm that it can process requests and configuration changes (creating and deleting a test API will suffice to confirm Kong can communicate with the datastore).
4. Start additional nodes in the new cluster until its node count matches the old cluster size.
5. Once the new cluster is running and able to process requests, configure your load balancer to direct new traffic to the new cluster.
6. Terminate the old cluster.

Upgrades between major versions need to be planned in advance as they involve downtime for new consumers that have not been cached in memory yet, and because the Admin API won’t be available on the old cluster for the entire process.
