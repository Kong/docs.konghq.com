---
title: Network & Firewall
---

## Introduction

In this section you will find a summary about the recommended network and firewall settings for Kong.

## Ports

Kong uses multiple connections for different purposes.

* proxy
* management api

### Proxy

The proxy ports is where Kong receives its incoming traffic. There are two ports with the following defaults;

* `8000` for proxying. This is where Kong listens for HTTP traffic. Be sure to change it to `80` once you go to production. See [proxy_listen].
* `8443` for proxying HTTPS traffic. Be sure to change it to `443` once you go to production. See [proxy_listen] and the `ssl` suffix.

These are the **only ports** that should be made available to your clients.

### Management api

This is the port where Kong exposes its management api. Hence in production this port should be firewalled to protect
it from unauthorized access.

* `8001` provides Kong's **Admin API** that you can use to operate Kong. See [admin_listen].
* `8444` provides the same Kong **Admin API** but using HTTPS. See [admin_listen] and the `ssl` suffix.

## Firewall

Below are the recommended firewall settings:

* The upstream Services behind Kong will be available via the [proxy_listen] interface/port values.
  Configure these values according to the access level you wish to grant to the upstream Services.
* If you are binding the Admin API to a public-facing interface (via [admin_listen]), then **protect** it to only allow trusted clients to access the Admin API.
  See also [Securing the Admin API][secure_admin_api].
* Your proxy will need have rules added for any TCP Stream listeners that you configure. For example, if you want Kong to manage traffic on port `4242`, your
  firewall will need to be allow traffic on said port.

[proxy_listen]: /enterprise/{{page.kong_version}}/property-reference/#proxy_listen
[admin_listen]: /enterprise/{{page.kong_version}}/property-reference/#admin_listen
[secure_admin_api]: /enterprise/{{page.kong_version}}/secure-admin-api
