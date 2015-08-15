---
title: How does it work?
---

# How does it work?

Kong is made of two different components that are easy to set up and scale independently:

* The [**Kong Server**](#kong-server), based on a modified version of the widely adopted **NGINX** server, processes API requests.
* [**Apache Cassandra**](#apache-cassandra), a highly scalable Datastore for storing operational data, is used by major companies like Netflix, Comcast and Facebook.

Kong needs to have both these components set up and operational. A typical Kong installation can be summed up with the following picture:

![](/assets/images/docs/kong-detailed.png)

Don't worry if you are not experienced with these technologies, Kong works out of the box and you or your engineering team will be able to set it up quickly without issues. Feel free to contact us for any technical question.

## Kong Server

The Kong Server, built on top of **NGINX**, is the server that will actually process the API requests and execute the configured plugins to provide additional functionalities to the underlying APIs before proxying the request to the final destination.

The Proxy Server listens on two ports, that by default are:

* Port `8000`, that will be used to process the API requests.
* Port `8001`, called **Admin API port**, provides the Kong's RESTful Admin API that you can use to operate Kong, and should be private and firewalled.

You can use the **admin port** to configure Kong, create new users, installing or removing plugins, and a handful of other operations. Since you will be using a RESTful API to operate Kong, it is also extremely easy to integrate Kong with existing systems.

## Apache Cassandra

Apache Cassandra ([http://cassandra.apache.org/](http://cassandra.apache.org/)) is a popular, solid and reliable datastore used at major companies like Netflix and Facebook. It excels in securely storing data in both single-datacenter or multi-datacenter setups with a good performance and a fail-tolerant architecture.

Kong uses Cassandra as its primary datastore to store any data including APIs, Consumers and Plugins. Plugins themselves can use Cassandra to store every bit of information that needs to be persisted, for example rate-limiting data.

Depending on your use case, for production usage we reccomend having at least a two-node Cassandra cluster configured with a replication factor of `2`. The beauty of Cassandra is that it can be easily scaled horizontally to accomodate more requests and more data. We reccomend putting Cassandra on performant machines with a generous amount of CPU and Memory, like AWS `m4.xlarge` instances.

# SQL support

While Cassandra supports every integration scenario, from the simplest to the more complex ones, in the future we plan to support an SQL datastore like PostgreSQL in order to keep Kong close to well known technologies that are already being used in your technology stack.

If you like the idea, +1 [the related issue]({{ site.repos.kong }}/issues/331) on Github.
