---
nav_title: Overview
---

This plugin allows you to understand customer [API usage](https://www.amberflo.io/products/metering) and implement [usage-based price & billing](https://www.amberflo.io/products/billing) by metering the requests with [Amberflo.io](https://amberflo.io).

It supports high-volume HTTP(S) usage without adding latency.

[Amberflo](https://amberflo.io) is the simplest way to integrate metering into your application. [Sign up for free](https://ui.amberflo.io/) to get started.

## How it works

This plugin intercepts the requests, detects which customer is making it, generates a meter event and sends it to Amberflo.

Customer detection occurs via inspection of the request headers. You can configure {{site.base_gateway}} to inject the `customerId` as a header before this plugin runs. For example, if you use the [Key Authentication](/hub/kong-inc/key-auth/) plugin, this occurs automatically.

To avoid impacting the performance of your gateway, the plugin batches the meter records and sends them asynchronously to Amberflo.

## Installation

This is a server plugin implemented in Go. You only need to make the binary available to {{site.base_gateway}}:

```shell
GOBIN=/tmp go install github.com/amberflo/kong-plugin-amberflo@latest
mv /tmp/kong-plugin-amberflo /usr/local/bin/amberflo
```

Then, register the plugin in your `kong.conf` file:

```
plugins = bundled,amberflo

pluginserver_names = amberflo

pluginserver_amberflo_start_cmd = /usr/local/bin/amberflo
pluginserver_amberflo_query_cmd = /usr/local/bin/amberflo -dump
```

Finally, restart {{site.base_gateway}}:

```shell
kong restart
```
