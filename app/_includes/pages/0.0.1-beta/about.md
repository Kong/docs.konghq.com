# Welcome to Kong

Kong is a scalable, lightweight open source **API Layer** *(also known as a API Gateway, or API Middleware)*. Kong runs in front of any RESTful API and is extended through [Plugins](#plugins), which provide [extra functionalities and services](/plugins/) beyond the core platform.

* **Scalable**: Kong easily scales horizontally by simply adding more machines, meaning your platform can handle virtually any load while keeping latency low.

* **Modular**: Kong can be extended by adding new plugins, which are easily configured through an internal RESTful API.

* **Runs on any infrastructure**: Kong runs anywhere. You can deploy Kong in the cloud or on-premise environments, including single or multi-datacenter setups and for public, private or invite-only APIs.

Kong is built on top of reliable technologies like **NGINX** and **Apache Cassandra**, and provides you with an easy to use [RESTful API](#internal-api-endpoints) to operate and configure the system.

### Request Workflow

To better understand the system, this is a typical request workflow of an API that uses Kong:

![](/assets/images/docs/kong-simple.png)

Once Kong is running, every request being made to the API will hit Kong first, and then it will be proxied to the final API. In between requests and responses Kong will execute any plugin that you decided to install, empowering your APIs. Kong is effectively going to be the entry point for every API request.

## How does it work?

Kong is made of two different components, that are easy to set up and to scale independently:

* The **Kong Server**, based on a modified version of the widely adopted **NGINX** server, that processes the API requests.
* An underlying **Datastore** for storing operational data, **Apache Cassandra**, which is being used by major companies like Netflix, Comcast or Facebook and it's known for being highly scalable.

Kong needs to have both these components set up and operational. A typical Kong installation can be summed up with the following picture:

![](/assets/images/docs/kong-detailed.png)

Don't worry if you are not experienced with these technologies, Kong works out of the box and you or your engineering team will be able to set it up quickly without issues. Feel free to contact us for any technical question.

### Kong Server

The Kong Server, built on top of **NGINX**, is the server that will actually process the API requests and execute the configured plugins to provide additional functionalities to the underlying APIs before proxying the request to the final destination.

The Proxy Server listens on two ports, that by default are:

* Port `8000`, that will be used to process the API requests.
* Port `8001`, called **admin port**, provides the Kong's internal RESTful API that you can use to operate Kong, and should be private and firewalled.

You can use the **admin port** to configure Kong, create new users, installing or removing plugins, and a handful of other operations. Since you will be using a RESTful API to operate Kong, it is also extremely easy to integrate Kong with existing systems.