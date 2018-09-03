---
title: Kong Architecture Patterns
---
# Kong Architecture Patterns

An important part of setting up a new Kong cluster is choosing the right architectural pattern that fits your needs and integrates with your existing infrastructure. Here are a few that we commonly see and recommend. Kong itself is greatly flexible, and can be setup in many ways. We present these as starting points in hopes that you find that using or extending one of these patterns provides an ideal fit for your unique needs.

## Kong between client and upstream

The classic architectural pattern we see customers setting up is adding Kong in between some, or all, of their API traffic. Kong is installed in your prefered hosting provider, and configured to proxy traffic to the existing APIs. Note that in this pattern the APIs are still accessible directly, that is both through the proxy and also without being routed through the API Gateway. We see this during initial testing, and migration phases, before customers eventually route all traffic through Kong. 

The pros of this approach are that it is simple to setup and configure. All it requires is setup, and coordinating new traffic to use the gateway. Older traffic will still flow directly to the APIs.

The cons are, in this case, the same as the pros. It’s a simple pattern, which works for new traffic, but older traffic will continue to be routed directly to the API and not take advantage of rate limiting, auth, or other plugins configured on the Kong gateway.

Often we see this initial Kong configuration morph into one where the APIs are walled off behind a firewall, which we will visit in the next pattern.

## Kong and APIs behind firewall

The next pattern we see, and the next step for security, is to setup [API servers behind a firewall](https://docs.konghq.com/latest/network/) and only allow the Kong API Gateway be accessible to the public.

This is a popular architecture pattern that we see with customers who have publicly available APIs. Either they are migrating from the initial pattern, improving security by cordoning off direct access to the APIs, or choosing it for their general use. 

This architecture pattern is the one we recommend for most customers. It is straightforward to setup, and offers security and control over API access.

The Kong cluster would be placed behind a firewall, or within an Amazon VPC. The Kong cluster's port 80 or 443, which ever your public API is available on, would be opened to the outside world. Inside the firewall the API servers would only allow connections from the Kong cluster. Other IP:ports may need to be opened for the API servers to reach resources they need to fulfill any requests.


Access to the [Kong Admin API can be secured in a couple of different ways](https://docs.konghq.com/latest/secure-admin-api/). Depending on your needs you would lock it down to localhost on the machine it is running on, use the firewall to prevent access from anyone outside your network, or proxy the Admin API through Kong itself, and secure it using one of the authentication plugins.

With Kong Enterprise you also have the option of using Role Based Access Control (RBAC) to shape fine grained access for your team, and co-workers. [RBAC in Kong](https://docs.konghq.com/enterprise/0.31-x/plugins/rbac-api/) is used to create roles with defined permissions; roles are then assigned to users who are limited in what they can and cannot do by the permissions. Roles could be created for read-only roles; for when you want to let co-workers look, but not edit, the configuration. You could also create roles for different teams; giving them access to edit and update only their APIs.

## Multi-datacenter with Cassandra

Application availability is important, and high availability can be achieved by configuring Kong in a multi-datacenter setup using [Apache Cassandra](https://docs.konghq.com/about/faq/#apache-cassandra) as the backing datastore. In this configuration each geographically disparate datacenter is host to at least three Kong nodes, and the appropriate number of Cassandra nodes.

The minimum number of Kong nodes per data center needed for high availability is three. This will ensure that in the unlikely event of a node failure there will still be a node and a backup. Cassandra would be configured in an optimal way; you can use the [Cassandra Calculator](https://www.ecyrd.com/cassandracalculator/) to determine how many Cassandra nodes are needed per data center to ensure high availability, and  performance for your specific needs.

Logically Kong will act as a single cluster, and in a multi-datacenter strategy, can be configured similar to the previous architecture patterns. We recommending having the upstream services behind a firewall (or in a VPC in AWS) and only allow Kong nodes direct access to the APIs. 

## Separate Kong Admin node

For security conscious customers we recommend a pattern of having a single node in a Kong cluster allow access to the Admin API. 

Each node in Kong cluster can be configured using its kong.conf file. Two separate configurations can be created, one for a proxy only node, and the other for an admin only node. The proxy only nodes would be accessible from the outside world. They would connect to the database and the upstream APIs that are behind the firewall. The admin only node would be inside the firewall, or a separate firewall (or VPC on AWS), and it would connect to the database that the proxy nodes connects to.

So long as the proxy nodes and admin nodes use the same database they will be part of the same cluster. The admin node itself can be located anywhere. There are a few different ways to achieve this. Read [securing the Kong Admin API](https://docs.konghq.com/latest/secure-admin-api/) for details.

### Unlimited options

Kong as a tool is flexible, and offers many possibilities for incorporating it into your existing infrastructure. These patterns we touch upon are the ones we commonly see and recommend. Every situation is unique, and we are happy to assist you with your specific needs.

