---
title: FAQ
header_icon: /assets/images/icons/icn-documentation.svg
header_title: Frequently Asked Questions
---

* [How does it work?](#how-does-it-work)
* [How does it scale?](#how-does-it-scale)
* [What are plugins?](#what-are-plugins)
* [Where can I get general information about Kong?](#where-can-i-get-general-information-about-kong)
* [Why Lua?](#why-lua)
* [Why does Kong need Cassandra?](#why-does-kong-need-cassandra)
* [How many microservices/APIs can I add on Kong?](#how-many-microservices-apis-can-i-add-on-kong)
* [How can I add an authentication layer on a microservice/API?](#how-can-i-add-an-authentication-layer-on-a-microservice-api)

----

## How does it work?

Kong is made of two different components that are easy to set up and scale independently:

* The [**Kong Server**](#kong-server), based on a modified version of the widely adopted **NGINX** server, processes API requests.
* [**Apache Cassandra**](#apache-cassandra), a highly scalable Datastore for storing operational data, is used by major companies like Netflix, Comcast and Facebook.

Kong needs to have both these components set up and operational. A typical Kong installation can be summed up with the following picture:

![](/assets/images/docs/kong-detailed.png)

Don't worry if you are not experienced with these technologies, Kong works out of the box and you or your engineering team will be able to set it up quickly without issues. Feel free to contact us for any technical question.

### Kong Server

The Kong Server, built on top of **NGINX**, is the server that will actually process the API requests and execute the configured plugins to provide additional functionalities to the underlying APIs before proxying the request to the final destination.

The Proxy Server listens on two ports, that by default are:

* Port `8000`, that will be used to process the API requests.
* Port `8001`, called **Admin API port**, provides the Kong's RESTful Admin API that you can use to operate Kong, and should be private and firewalled.

You can use the **admin port** to configure Kong, create new users, installing or removing plugins, and a handful of other operations. Since you will be using a RESTful API to operate Kong, it is also extremely easy to integrate Kong with existing systems.

### Apache Cassandra

Apache Cassandra ([http://cassandra.apache.org/](http://cassandra.apache.org/)) is a popular, solid and reliable datastore used at major companies like Netflix and Facebook. It excels in securely storing data in both single-datacenter or multi-datacenter setups with a good performance and a fail-tolerant architecture.

Kong uses Cassandra as its primary datastore to store any data including APIs, Consumers and Plugins. Plugins themselves can use Cassandra to store every bit of information that needs to be persisted, for example rate-limiting data.

Depending on your use case, for production usage we recommend having at least a two-node Cassandra cluster configured with a replication factor of `2`. The beauty of Cassandra is that it can be easily scaled horizontally to accomodate more requests and more data. We recommend putting Cassandra on performant machines with a generous amount of CPU and Memory, like AWS `m4.xlarge` instances.

<div class="alert alert-warning">
  <strong>Note:</strong> If you don't want to manage/scale your own Cassandra cluster, we suggest using <a href="{{ site.links.instaclustr }}" target="_blank"> Instaclustr</a> for Cassandra in the cloud.
</div>

#### SQL support

While Cassandra supports every integration scenario, from the simplest to the more complex ones, in the future we plan to support an SQL datastore like PostgreSQL in order to keep Kong close to well known technologies that are already being used in your technology stack.

If you like the idea, +1 [the related issue]({{ site.repos.kong }}/issues/331) on Github.

----

## How does it scale?

When it comes down to scaling Kong, you need to keep in mind that you will need to scale both the API server and the underlying datastore (Apache Cassandra).

### Kong Server

Scaling the Kong Server up or down is actually very easy. Each server is stateless meaning you can add or remove as many nodes under the load balancer as you want.

Be aware that terminating a node might interrupt any ongoing HTTP requests on that server, so you want to make sure that before terminating the node all HTTP requests have been processed.

### Cassandra

Scaling Cassandra shouldn't be required often, and usually a 2-node setup per datacenter is going to be enough for most of your needs, but of course if your load is expected to be very high then you may want to consider configuring your nodes properly and prepare the cluster to be scaled to handle more requests.

The easy part is that Cassandra can be scaled up and down just by adding or removing nodes on the cluster, and the system will take care of re-balancing the data in the cluster.

<div class="alert alert-warning">
  <strong>Note:</strong> If you don't want to manage/scale your own Cassandra cluster, we suggest using <a href="{{ site.links.instaclustr }}" target="_blank">Instaclustr</a> for Cassandra in the cloud.
</div>

----

## What are plugins?

Plugins are one of the most important features of Kong. All the functionalities provided by Kong are done so by easy to use **plugins**. Authentication, rate-limiting, logging and many more. Plugins can be installed and configured through Kong's REStful Admin API.

Almost all plugins can be customized not only to target a specific API, but also to target a specific API and a **specific [Consumer](
/docs/latest/admin-api/#consumer-object)**.

From a technical perspective, a plugin is [Lua](http://www.lua.org/) code that's being executed during the life-cycle of an API request and response. Through plugins, Kong can be extended to fit any custom need or integration challenge. For example, if you need to integrate the API user authentication with a third-party enterprise security system, that would be implemented in a dedicated plugin that is run on every API request.

Feel free to explore the [available plugins](/plugins) or learn how to [enable plugins](/docs/latest/getting-started/enabling-plugins) with the [plugin configuration API](/docs/latest/admin-api/#plugin-configuration-object).

----

### Where can I get general information about Kong?

You can read the [official documentation](/docs) or ask any question to the community and the core mantainers on our [official chat on Gitter](https://gitter.im/Mashape/kong).

You can also have a face-to-face talk with us at one of our [meetups](http://www.meetup.com/The-Mashape-API-Developer-Community).

----

## Why Lua?

We wanted to develop directly on top of NGINX, since it's the most used and trusted HTTP proxy in the world. To do so, we had two options: A) write natively C code but it would not make Kong maintainable long term B) leverage a tool called OpenResty (used in production at Cloudflare) that allows Lua support on top of NGINX. Lua is a powerful, easy to learn, lightweight, embeddable scripting language. With LuaJIT (just-in-time compiler) it's also one of the fastest languages in the world. With Lua we can keep high performance while having a long term maintanble codebase.

----

### Why does Kong need Cassandra?

Kong uses Cassandra for storing all the data and to keep functioning properly. Plugins also use Cassandra to store data. Read [how Kong works](/about/faq/#how-does-it-work).

----

### How many microservices/APIs can I add on Kong?

You can add as many microservices or APIs as you like, and use Kong to process all of them. Kong currently supports RESTful services that run over HTTP or HTTPs. Learn how to [add a new service](/docs/latest/getting-started/adding-your-api/) on Kong.

You can scale Kong horizontally if you are processing lots of requests, just by adding more Kong servers to your cluster.

----

### How can I add an authentication layer on a microservice/API?

To add an authentication layer on top of a service you can choose between the authentication plugins currently available in the [Plugins Gallery](/plugins/#authentication), like the [Basic Authentication](/plugins/basic-authentication/), [Key Authentication](/plugins/key-authentication/) and [OAuth 2.0](/plugins/oauth2-authentication/) plugins.

<hr>

Were you looking for a question that you did't find? [Open an issue!]({{ site.repos.kong }})
