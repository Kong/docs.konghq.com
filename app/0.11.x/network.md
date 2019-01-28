---
title: Network & Firewall
---

# Network & Firewall

In this section you will find a summary about the recommended network and firewall settings for Kong.

## Ports

Kong uses multiple connections for different purposes.

* proxy 
* management api


### Proxy

The proxy ports is where Kong receives its incoming traffic. There are two ports with the following defaults;

* `8000` for proxying. This is where Kong listens for HTTP traffic. Be sure to change it to `80` once you go to production. See [proxy_listen].
* `8443` for proxying HTTPS traffic. Be sure to change it to `443` once you go to production. See [proxy_listen_ssl].

These are the **only ports** that should be made available to your clients.

### Management api

This is the port where Kong exposes its management api. Hence in production this port should be firewalled to protect
it from unauthorized access.

* `8001` provides Kong's **Admin API** that you can use to operate Kong. See [admin_api_listen].
* `8444` provides the same Kong **Admin API** but using HTTPS. See [admin_api_listen_ssl].

## Firewall

Below are the recommended firewall settings:

* The upstream APIs behind Kong will be available on [proxy_listen][proxy_listen] and [proxy_listen_ssl][proxy_listen_ssl]. 
  Configure these ports according to the access level you wish to grant to the upstream APIs.
* **Protect** [admin_api_listen][admin_api_listen] and [admin_api_listen_ssl][admin_api_listen_ssl], to only allow trusted sources that can access the Admin API. See also [Securing the Admin API][secure_admin_api].


[proxy_listen]: /{{page.kong_version}}/configuration/#proxy_listen
[proxy_listen_ssl]: /{{page.kong_version}}/configuration/#proxy_listen_ssl
[admin_api_listen]: /{{page.kong_version}}/configuration/#admin_api_listen
[admin_api_listen_ssl]: /{{page.kong_version}}/configuration/#admin_api_listen_ssl
[secure_admin_api]: /{{page.kong_version}}/secure-admin-api
