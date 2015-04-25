---
title: How does it scale?
---

# How does it scale?

When it comes down to scaling Kong, you need to keep in mind that you will need to scale both the API server and the underlying datastore (Apache Cassandra).

## Kong Server

Scaling the Kong Server up or down is actually very easy. Each server is stateless meaning you can add or remove as many nodes under the load balancer as you want.

Be aware that terminating a node might interrupt any ongoing HTTP requests on that server, so you want to make sure that before terminating the node all HTTP requests have been processed.

## Cassandra

Scaling Cassandra shouldn't be required often, and usually a 2-node setup per datacenter is going to be enough for most of your needs, but of course if your load is expected to be very high then you may want to consider configuring your nodes properly and prepare the cluster to be scaled to handle more requests.

The easy part is that Cassandra can be scaled up and down just by adding or removing nodes on the cluster, and the system will take care of re-balancing the data in the cluster.
