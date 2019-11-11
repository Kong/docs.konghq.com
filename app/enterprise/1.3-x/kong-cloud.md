---
title: Kong Cloud
layout: reference
---

## Kong Cloud Proxy TLS

Kong Cloud enforces HTTPS for all of the services that it operates, including Admin API, Kong Manager, and Kong Developer Portal. Kong Cloud does not enforce HTTPS for traffic destined for the customer's proxy, since certificate management and associated domains are under the customer's control. To enforce HTTPS on upstream traffic, use the [certificate](https://docs.konghq.com/enterprise/1.3-x/admin-api/#certificate-object) and [SNI](https://docs.konghq.com/enterprise/1.3-x/admin-api/#sni-object.) objects through the Admin API.

For non-proxy traffic, Kong Cloud is the terminus for the request, and Kong controls the protocol and shape of traffic carefully. Additionally, Kong generally considers non-proxy traffic to be sensitive (e.g., Admin API requests, login credentials to Kong Manager). Kong Cloud accomplishes enforcement through HTTP → HTTPS redirects, and the use of the HSTS response header. Because Kong Cloud controls the domain hosting the endpoints for these services, e.g., https://manager-client.kong-cloud.com, Kong Cloud maintains the TLS certificate for this service since Kong owns the domain.

For dedicated production Kong Cloud clusters (e.g., clusters setup for paying customers), proxy traffic is funneled through a network load balancer to Kong nodes, which then pass the request to the customer's upstream. Kong Cloud does not enforce any protocol or application layer behaviors here, because this traffic would be specific to the customer's upstream APIs. Thus, securing proxy traffic on a production Kong Cloud cluster is the customer's responsibility (e.g., setting up TLS certificates through Kong's Admin API/Manager). Customers generally use their own domain name for production API (e.g., api.example.com), so Kong does not provide a TLS certificate to use out-of-the-box for production proxy traffic. Kong would have no way to enforce TLS traffic and no manageable certificate/key to provide. Thus, securing production proxy traffic via TLS is the customer's responsibility.
