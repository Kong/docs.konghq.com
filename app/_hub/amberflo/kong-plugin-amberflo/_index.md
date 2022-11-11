---
name: Amberflo.io API Metering
publisher: Amberflo.io Inc.
version: 0.2.x

categories:
  - analytics-monitoring
  - logging

type: plugin

desc: API usage metering and usage-based billing.

description: |
  This plugin allows you to understand customer [API usage](https://www.amberflo.io/products/metering-cloud) and implement [usage-based price & billing](https://www.amberflo.io/products/billing-cloud) by metering the requests with [Amberflo.io](https://amberflo.io).

  It supports high-volume HTTP(S) usage without adding latency.

  [Amberflo](https://amberflo.io) is the simplest way to integrate metering into your application. [Sign up for free](https://ui.amberflo.io/) to get started.

support_url: https://github.com/amberflo/kong-plugin-amberflo/issues

source_code: https://github.com/amberflo/kong-plugin-amberflo

license_url: https://github.com/amberflo/kong-plugin-amberflo/blob/main/LICENSE

privacy_policy_url: https://www.amberflo.io/privacy-policy

terms_of_service_url: https://www.amberflo.io/terms-of-use

kong_version_compatibility:
  community_edition:
    compatible:
      - 3.0.x
  enterprise_edition:
    compatible:
      - 3.0.x

params:
  name: amberflo
  service_id: true
  route_id: true
  protocols:
    - name: http
    - name: https
  dbless_compatible: 'yes'
  dbless_explanation: The plugin is compatible with any with DB-less mode, including `local`, `cluster`, and `redis`.
  config:
    - name: apiKey
      required: true
      description: Your Amberflo API key.
    - name: meterApiName
      required: true
      description: The meter for metering the requests.
    - name: customerHeader
      required: true
      description: The header to get the Amberflo `customerId` from.
    - name: intervalSeconds
      required: false
      default: "`1`"
      description: The rate (in seconds) at which to send the meter record batch.
    - name: batchSize
      required: false
      default: "`10`"
      description: The size at which to send the meter record batch.
    - name: methodDimension
      required: false
      description: The dimension name for the request method.
    - name: hostDimension
      required: false
      description: The dimension name for the target URL host.
    - name: routeDimension
      required: false
      description: The dimension name for the route name.
    - name: serviceDimension
      required: false
      description: The dimension name for the service name.
    - name: dimensionHeaders
      required: false
      description: |
        The map of "dimension name" to "header name", for inclusion in the meter record.
    - name: replacements
      required: false
      default: |
        `{"/": ":"}`
      description: The map of "old" to "new" values for transforming dimension values.

---

### How it works

This plugin intercepts the requests, detects which customer is making it, generates a meter event and sends it to Amberflo.

Customer detection occurs via inspection of the request headers. You can configure {{site.base_gateway}} to inject the `customerId` as a header before this plugin runs. For example, if you use the [Key Authentication](https://docs.konghq.com/hub/kong-inc/key-auth/) plugin, this occurs automatically.

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
