---
title: Key Concepts
---

* **Plugin**: a plugin executing actions inside Kong before or after a request has been proxied to the upstream API.

* **Service**: the Kong entity representing an external _upstream_ API or microservice.

* **Route**: the Kong entity representing a way to map downstream requests to upstream services.

* **Consumer**: the Kong entity representing a developer or machine using the API. When using Kong, a Consumer only communicates with Kong which proxies every call to the said upstream API.

* **Credential**: a unique string associated with a Consumer, also referred to as an API key.

* **Upstream Service**: this refers to your own API/service sitting behind Kong, to which client requests are forwarded.

* **API**: a legacy entity used to represent your upstream services. _Deprecated_ in favor of Services.
