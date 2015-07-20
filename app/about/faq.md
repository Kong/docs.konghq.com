---
title: FAQ
---

# Frequently Asked Questions

* [Where can I get general information about Kong?](#where-can-i-get-general-information-about-kong?)
* [Why does Kong need Cassandra?](#why-does-kong-need-cassandra?)
* [How many microservices/APIs can I add on Kong?](#how-many-microservices/apis-can-i-add-on-kong?)
* [How can I add an authentication layer on a microservice/API?](#how-can-i-add-an-authentication-layer-on-a-microservice/api?)

<hr>

#### Where can I get general information about Kong?

You can read the [official documentation](/docs) or ask any question to the community and the core mantainers on our [official chat on Gitter](https://gitter.im/Mashape/kong).

You can also have a face-to-face talk with us at one of our [meetups](http://www.meetup.com/The-Mashape-API-Developer-Community).

#### Why does Kong need Cassandra?

Kong uses Cassandra for storing all the data and to keep functioning properly. Plugins also use Cassandra to store data. Read [how Kong works](/about).

#### How many microservices/APIs can I add on Kong?

You can add as many microservices or APIs as you like, and use Kong to process all of them. Kong currently supports RESTful services that run over HTTP or HTTPs. Learn how to [add a new service](/docs/latest/getting-started/adding-your-api/) on Kong.

You can scale Kong horizontally if you are processing lots of requests, just by adding more Kong servers to your cluster.

#### How can I add an authentication layer on a microservice/API?

To add an authentication layer on top of a service you can choose between the authentication plugins currently available in the [Plugins Gallery](/plugins/#security), like the [Basic Authentication](/plugins/basic-authentication/), [Key Authentication](/plugins/key-authentication/) and [OAuth 2.0](/plugins/oauth2-authentication/) plugins.

<hr>

Were you looking for a question that you did't find? [Open an issue!](https://github.com/Mashape/getkong.org)
