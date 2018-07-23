---
id: page-plugin
title: Plugins - Moesif
header_title: Moesif
header_icon: /assets/images/icons/plugins/moesif.png
breadcrumbs:
  Plugins: /plugins
nav:
  - label: Usage
    items:
      - label: How it works
      - label: How to install
      - label: Kong process errors
description: |
  Logs HTTP request and response data to [Moesif](http://www.moesif.com), the modern API analytics platform for monitoring, visualizing and debugging API traffic.
params:
  name: moesif
  api_id: true
  service_id: true
  route_id: true
  consumer_id: true
  config:
    - name: application_id
      required: true
      default:
      value_in_examples: MY_MOESIF_APPLICATION_ID
      description: |
        The Moesif application token provided to you by [Moesif](http://www.moesif.com).
    - name: api_endpoint
      required: false
      default: "`https://api.moesif.net`"
      description: URL for the Moesif API.
    - name: timeout
      required: false
      default: "`10000`"
      description: An optional timeout in milliseconds when sending data to Moesif.
    - name: keepalive
      required: false
      default: "`5000`"
      description: An optional value in milliseconds that defines for how long an idle connection will live before being closed.
    - name: api_version
      required: false
      default: "`1.0`"
      description: An optional API Version you want to tag this request with
---

## How it works

When enabled, this plugin will capture API requests and responses and log to
[Moesif API Insights](https://www.moesif.com) for easy inspecting and real-time
debugging of your API traffic.

Moesif natively supports for REST, GraphQL, Ethereum Web3, SOAP, JSON-RPC, and more.

[Package on Luarocks](http://luarocks.org/modules/moesif/kong-plugin-moesif)

## How to install

The .rock file is a self contained package that can be installed locally or from a remote server.

If the luarocks utility is installed in your system (this is likely the case if you used one of the official installation packages), you can install the 'rock' in your LuaRocks tree (a directory in which LuaRocks installs Lua modules).

It can be installed from luarocks repository by doing:

```shell
luarocks install kong-plugin-moesif
```

## Kong process errors

This logging plugin will only log HTTP request and response data. If you are looking for the Kong process error file (which is the nginx error file), then you can find it at the following path: {[prefix](/{{site.data.kong_latest.release}}/configuration/#prefix)}/logs/error.log
