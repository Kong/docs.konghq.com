---
nav_title: Overview
---

Log [metrics](#metrics) for a service or route to a local
[Datadog agent](http://docs.datadoghq.com/guides/basic_agent_usage/).

{% if_version gte:3.3.x %}
## Queueing

The Datadog uses a queue to decouple the production and
consumption of data. This reduces the number of concurrent requests
made to the upstream server under high load situations and provides
buffering during temporary network or upstream outages.

You can set several parameters to configure the behavior and capacity
of the queues used by the plugin. For more information about how to
use these parameters, see
[Plugin Queuing Reference](/gateway/latest/kong-plugins/queue/reference/)
in the {{site.base_gateway}} documentation.

The queue parameters all reside in a record under the key `queue` in
the `config` parameter section of the plugin.
{% endif_version %}

---

## Metrics
The Datadog plugin currently logs the following metrics to the Datadog server about a service or route.

Metric                     | Description | Namespace
---                        | ---         | ---
`request_count`            | tracks the request | `kong.request.count`
`request_size`             | tracks the request's body size in bytes | `kong.request.size`
`response_size`            | tracks the response's body size in bytes | `kong.response.size`
`latency`                  | tracks the time interval between the request started and response received from the upstream server | `kong.latency`
`upstream_latency`         | tracks the time it took for the final service to process the request | `kong.upstream_latency`
`kong_latency`             | tracks the internal Kong latency that it took to run all the plugins | `kong.kong_latency`

The metrics will be sent with the tags `name` and `status` carrying the API name and HTTP status code respectively. If you specify `consumer_identifier` with the metric, a tag `consumer` will be added.

### Metric fields

Plugin can be configured with any combination of [Metrics](#metrics), with each entry containing the following fields.

Field           | Description                                           | Data types   | Allowed values
---             | ---                                                   | ---         | ---
`name`          | Datadog metric's name                                 | String      | [Metrics](#metrics)
`stat_type`     | Determines what sort of event the metric represents   | String      | `gauge`, `timer`, `counter`, `histogram`, `meter`, `set` {% if_plugin_version gte:2.7.x %}, `distribution` {% endif_plugin_version %}
`sample_rate`<br>*conditional*   | Sampling rate                        | Number      | `number`
`consumer_identifier`<br>*conditional* | Authenticated user detail       | String      | `consumer_id`, `custom_id`, `username`
`tags`<br>*optional* | List of tags                                      | Array of strings    | `key[:value]`

### Metric requirements

- All metrics get logged by default.
- Metrics with `stat_type` as `counter` or `gauge` must have `sample_rate` defined as well.

## Migrating Datadog queries
The plugin updates replace the api, status, and consumer-specific metrics with a generic metric name.
You must change your Datadog queries in dashboards and alerts to reflect the metrics updates.

For example, the following query:
```
avg:kong.sample_service.latency.avg{*}
```
would need to change to:

```
avg:kong.latency.avg{name:sample-service}
```

## Setting host and port per Kong node basis

When installing a multi-data center setup, you might want to set Datadog's agent host and port on a per Kong node basis. This configuration is possible by setting the host and port properties using environment variables.

{:.note}
> **Note:** `host` and `port` fields in the plugin config take precedence over environment variables.
{% if_plugin_version gte:3.3.x %}
> <br><br>
> For Kubernetes, there is a known limitation that you can't set `host` to null to use the environment variable. 
> You can work around this by using a vault reference, for example: `{vault://env/kong-datadog-agent-host}`. 
> Refer to [Configure with Kubernetes](#configure-with-kubernetes).
{% endif_plugin_version %}

Field           | Description                                           | Data types
---             | ---                                                   | ---
`KONG_DATADOG_AGENT_HOST` | The IP address or hostname to send data to. | string
`KONG_DATADOG_AGENT_PORT` | The port to send data to on the upstream server. | integer

## Kong process errors

{% include /md/plugins-hub/kong-process-errors.md %}

{% if_plugin_version gte:3.3.x %}

## Configure with Kubernetes

In most Kubernetes setups, `datadog-agent` runs as a daemon set. 
This means that a `datadog-agent` runs on each node in the Kubernetes cluster, and {{site.base_gateway}} must forward metrics to the `datadog-agent` running on the same node as {{site.base_gateway}}. 

This can be accomplished by providing the IP address of the Kubernetes worker node to {{site.base_gateway}}, then configuring the plugin to use that IP address. 
This is achieved using environment variables.

{% navtabs %}
{% navtab Helm %}

1. Modify the `env` section in `values.yaml`:

    ```yaml
    env:
      datadog_agent_host:
        valueFrom:
          fieldRef:
            fieldPath: status.hostIP
    ```

1. Update the Helm deployment:

    ```sh
    helm upgrade -f values.yaml RELEASE_NAME kong/kong --version VERSION --namespace NAMESPACE
    ```

1. Modify the plugin's configuration:

    ```yaml
    apiVersion: configuration.konghq.com/v1
    kind: KongClusterPlugin
    metadata:
      name: datadog
      annotations:
        kubernetes.io/ingress.class: kong
      labels:
        global: "true"
    config:
      host: "{vault://env/kong-datadog-agent-host}"
      port: 8125
    ```

{% endnavtab %}
{% navtab Kubernetes YAML %}

1. Modify the `env` section in `values.yaml`:

    ```yaml
    env:
      - name: KONG_DATADOG_AGENT_HOST
        valueFrom:
          fieldRef:
            fieldPath: status.hostIP
    ```

2. Modify the plugin's configuration:

    ```yaml
    apiVersion: configuration.konghq.com/v1
    kind: KongClusterPlugin
    metadata:
      name: datadog
      annotations:
        kubernetes.io/ingress.class: kong
      labels:
        global: "true"
    config:
      host: "{vault://env/kong-datadog-agent-host}"
      port: 8125
    ```
{% endnavtab %}
{% endnavtabs %}
{% endif_plugin_version %}

