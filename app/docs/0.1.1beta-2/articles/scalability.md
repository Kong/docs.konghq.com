---
layout: docs
title: Scalability
version: 0.1.1beta-2
permalink: /docs/articles/scalability/
---

# Scalability

When it comes down to scaling Kong, you need to keep in mind that you will need to scale both the API server and the underlying datastore.

## Kong Server

Scaling the Kong Server up or down is very easy. Each server is stateless and you can just add or remove nodes under the load balancer.

Be aware that terminating a node might interrupt any ongoing HTTP requests on that server, so you might want to make sure that before terminating the node all the HTTP requests have been already processed.

## Cassandra

Scaling Cassandra won't be required often, and usually a 2-nodes setup per datacenter is going to be enough for most of the use cases, but of course if your load is going to be very high then you might consider configuring it properly and prepare the cluster to be scaled in order to handle more requests.

The easy part is that Cassandra can be scaled up and down just by adding or removing nodes to the cluster, and the system will take care of re-balancing the data in the cluster.
