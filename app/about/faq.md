---
title: FAQ
header_icon: /assets/images/icons/icn-documentation.svg
header_title: Frequently Asked Questions
---

* [How does it work?](#how-does-it-work)
  * [Kong server](#kong-server)
  * [Kong datastore](#kong-datastore)
* [Which datastores are supported?](#which-datastores-are-supported)
  * [Apache Cassandra](#apache-cassandra)
  * [PostgreSQL](#postgresql)
* [How does it scale?](#how-does-it-scale)
* [What are plugins?](#what-are-plugins)
* [How many microservices/APIs can I add on Kong?](#how-many-microservices-apis-can-i-add-on-kong)
* [How can I add authentication to a microservice/API?](#how-can-i-add-authentication-to-a-microservice-api)
* [How can I migrate to Kong from another API Gateway?](#how-can-i-migrate-to-kong-from-another-api-gateway)
* [Where can I get help?](#where-can-i-get-help)

----

## How does it work?

A typical Kong setup is made of two main components:

* [Kong's server](#kong-server), based on the widely adopted **NGINX** HTTP
  server, which is a reverse proxy processing your clients' requests to your
  upstream services.
* Kong's datastore, in which the configuration is stored
  to allow you to horizontally scale Kong nodes.
  [Apache Cassandra](#apache-cassandra) and [PostgreSQL](#postgresql) can be
  used to fulfill this role.

Kong needs to have both these components set up and operational. A typical Kong
installation can be summed up with the following picture:

![](/assets/images/docs/kong-detailed.png)

### Kong server

The Kong Server, built on top of **NGINX**, is the server that will actually
process the API requests and execute the configured plugins to provide
additional functionalities to the underlying APIs before proxying the request
upstream.

Kong listens on several ports that must allow external traffic and are by
default:

* `8000` for proxying. This is where Kong listens for HTTP traffic. See [proxy_listen].
* `8443` for proxying HTTPS traffic. See [proxy_listen_ssl].

Additionally, those ports are used internally and should be firewalled in
production usage:

* `8001` provides Kong's **Admin API** that you can use to operate Kong. See
  [admin_api_listen].
* `7946` which Kong uses for inter-nodes communication with other Kong nodes. Both UDP and TCP traffic
  must be allowed. See [cluster_listen].
* `7373` used by Kong to communicate with the local clustering agent.
  See [cluster_listen_rpc].

You can use the **Admin API** to configure Kong, create new users, enable or
disable plugins, and a handful of other operations. Since you will be using
this RESTful API to operate Kong, it is also extremely easy to integrate Kong
with existing systems.

[proxy_listen]: /docs/latest/configuration/#proxy_listen
[cluster_listen]: /docs/latest/configuration/#cluster_listen
[cluster_listen_rpc]:
/docs/latest/configuration/#cluster_listen_rpc
[proxy_listen_ssl]: /docs/latest/configuration/#proxy_listen_ssl
[admin_api_listen]: /docs/latest/configuration/#admin_api_listen

### Kong datastore

Kong uses an external datastore to store its configuration such as registered
APIs, Consumers and Plugins. Plugins themselves can store every bit of
information they need to be persisted, for example rate-limiting data or
Consumer credentials.

**Kong maintains a cache** of this data so that there is no need for a database
roundtrip while proxying requests, which would critically impact performance.
This cache is invalidated by the inter-node communication when calls to the
Admin API are made. As such, it is discouraged to manipulate Kong's datastore
directly, since your nodes cache won't be properly invalidated.

This architecture allows Kong to scale horizontally by simply adding new nodes
that will connect to the same datastore and maintain their own cache.

## Which datastores are supported?

### Apache Cassandra

Apache Cassandra ([http://cassandra.apache.org/](http://cassandra.apache.org/))
is a popular, solid and reliable datastore used at major companies like Netflix
and Facebook. It excels in securely storing data in both single-datacenter or
multi-datacenter setups with a good performance and a fail-tolerant
architecture.

Kong can use Cassandra as its primary datastore if you are aiming at a
distributed, high-availability Kong setup. The two main reasons why one would
chose Cassandra as Kong's datastore are:
- An ease to create a distributed setup (ideal for multi-region).
- Ease to scale. Since Kong maintains its own cache, only plugins such as
  Rate-Limiting or Response-Rate-Limiting will require a highly responsive
  datastore. Cassandra is a good fit for such setups.

We recommend putting Cassandra on performant machines with a generous amount of
CPU and Memory, like AWS `m4.xlarge` instances. If you are aiming at Cassandra
for your production infrastructure, make sure to go through a few important
reads:

- [Data Replication](https://docs.datastax.com/en/cassandra/2.0/cassandra/architecture/architectureDataDistributeReplication_c.html)
  and [this neat Replication Calculator](http://www.ecyrd.com/cassandracalculator/).
- [Reading/Writing data consistency](http://docs.datastax.com/en/cassandra/2.0/cassandra/dml/dml_config_consistency_c.html)
- [Recommended production settings](https://docs.datastax.com/en/cassandra/2.0/cassandra/install/installRecommendSettings.html)

<div class="alert alert-warning">
  <strong>Note:</strong> If you don't want to
  manage/scale your own Cassandra cluster, we suggest using <a href="{{site.links.instaclustr}}" target="_blank">Instaclustr</a> for Cassandra in
  the cloud.
</div>

### PostgreSQL

[PostgreSQL](http://www.postgresql.org/) is one of the most established SQL
databases out there, meaning your team might already use it or have experience
with it.

It is a good candidate if the setup you are aiming at is not distributed, or if
you feel comfortable scaling PostgreSQL yourself. It is also worth pointing out
that many cloud providers can host and scale PostgreSQL instances for you, most
notably [Amazon RDS](https://aws.amazon.com/rds/).

Again, since Kong maintain its own cache, performance should be of concern for
most use-cases, making PostgreSQL a good candidate for your Kong cluster too.

----

## How does it scale?

When it comes to scaling Kong, you need to keep in mind that you will mostly
need to scale Kong's server and eventually ensure its datastore is not a single
point of failure in your infrastructure.

### Kong server

Scaling the Kong Server up or down is fairly easy. Each server is stateless
meaning you can add or remove as many nodes under the load balancer as you want
as long as they point to the same datastore.

Be aware that terminating a node might interrupt any ongoing HTTP requests on
that server, so you want to make sure that before terminating the node, all
HTTP requests have been processed.

### Kong datastore

Scaling the datastore should not be your main concern, mostly because as
mentioned before, Kong maintains its own cache, so expect your datastore's
traffic to be relatively quiet.

However, keep it mind that it is always a good practise to ensure your
infrastructure does not contain single points of failure (SPOF). As such,
closely monitor your datastore, and ensure replication of your datastore.

If you use Cassandra, one of its main advantages is its easy-to-use replication
capabilities due to its distributed nature. Make sure to read the documentation
pointed out by the [Cassandra section](#apache-cassandra) of this FAQ.

----

## What are plugins?

Plugins are one of the most important features of Kong. All the functionalities
provided by Kong actually are **plugins**. Authentication, rate-limiting,
transformation, logging etc, are all implemented independantly. Plugins can be
installed and configured via the Admin API running alongside Kong.

Almost all plugins can be customized not only to target a specific proxied
service, but also to target **specific [Consumers](
/docs/latest/admin-api/#consumer-object)**.

From a technical perspective, a plugin is [Lua](http://www.lua.org/) code
that's being executed during the life-cycle of a proxied request and response.
Through plugins, Kong can be extended to fit any custom need or integration
challenge. For example, if you need to integrate the you API's user
authentication with a third-party enterprise security system, that would be
implemented in a dedicated plugin that is run on every request targetting that
given API.

Feel free to explore the [Plugins Gallery](/plugins) and the [Plugin
development guide](/docs/latest/plugin-development). Learn how
to [enable plugins](/docs/latest/getting-started/enabling-plugins) with the
[plugin configuration
API](/docs/latest/admin-api/#plugin-configuration-object).

----

## How many microservices/APIs can I add on Kong?

You can add as many microservices or APIs as you like, and use Kong to process
all of them. Kong currently supports RESTful services that run over HTTP or
HTTPs. Learn how to [add a new
service](/docs/latest/getting-started/adding-your-api/) on Kong.

You can scale Kong horizontally if you are processing lots of requests, just by
adding more Kong servers to your cluster.

----

## How can I add authentication to a microservice/API?

To add an authentication layer on top of a service you can choose between the
authentication plugins currently available in the [Plugins Gallery](/plugins),
like the [Basic Authentication](/plugins/basic-authentication/), [Key
Authentication](/plugins/key-authentication/) and [OAuth
2.0](/plugins/oauth2-authentication/) plugins.

To restrict usage of a service to only some of the authenticated users, add the
[ACL](/plugins/acl/) plugin and create whitelist or blacklist groups of users.

----

## How can I migrate to Kong from another API Gateway?

In case you are already using an existing API Gateway and thinking to migrate
to Kong, you will need to take in considerations two steps:

1) Migrate the data. Kong offers a RESTful API that you can use to migrate data
from an existing API Gateway into Kong. Some API Gateways allow to export your
data in either JSON or CSV files, among other methods. You will need to write
a script that reads the exported data and then triggers the appropriate requests
to Kong to provision APIs, Consumers and Plugins.

2) Migrate the network settings. Once the data has been migrated and Kong has
been configured, you will need to check in a staging environment that everything
works well. Once you are ready to switch your users into Production over Kong, 
you will then need to adjust your network settings so point to your Kong cluster
(most likely by updating the DNS configuration).

If you are a 
[Mashape Enterprise](https://www.mashape.com/enterprise/) customer we can help
with the migration.

----

## Where can I get help?

You can read the [official documentation](/docs) or ask any question to the
community and the core mantainers on our [official chat on
Gitter](https://gitter.im/Mashape/kong). We are also on Freenode at
[#kong](http://webchat.freenode.net/?channels=kong).

You can also have a face-to-face talk with us at one of our
[meetups](http://www.meetup.com/The-Mashape-API-Developer-Community).

[Mashape Enterprise](https://www.mashape.com/enterprise/) is our Enterprise
Subscription that offers 24/7 Support SLAs among other features.

<hr>

Were you looking for a question that you did't find? [Open an issue!]({{site.repos.kong}})
