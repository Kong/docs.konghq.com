---
title: Traffic Log
---

With `TrafficLog` policy you can easily set up access logs on every data-plane in a [`Mesh`](/docs/{{ page.version }}/policies/mesh).

`TrafficLog` only logs outbound traffic. It doesn't log inbound traffic.

Configuring access logs in `Kuma` is a 3-step process:

* [1. Add a logging backend](#add-a-logging-backend)
* [2. Add a TrafficLog resource](#add-a-trafficlog-resource)
* [3. Log aggregation and visualisation](#log-aggregation-and-visualisation) (kubernetes only)

## Add a logging backend

A _logging backend_ is essentially a sink for access logs.

Currently, a _logging backend_ can be either a `file` or a `TCP log collector`, such as Logstash.

{% tabs logging-backend useUrlFragment=false %}
{% tab logging-backend Kubernetes %}
```yaml
apiVersion: kuma.io/v1alpha1
kind: Mesh
metadata:
  name: default
spec:
  logging:
    # TrafficLog policies may leave the `backend` field undefined.
    # In that case the logs will be forwarded into the `defaultBackend` of that Mesh.
    defaultBackend: file
    # List of logging backends that can be referred to by name
    # from TrafficLog policies of that Mesh.
    backends:
      - name: logstash
        # Use `format` field to adjust the access log format to your use case.
        format: '{"start_time": "%START_TIME%", "source": "%KUMA_SOURCE_SERVICE%", "destination": "%KUMA_DESTINATION_SERVICE%", "source_address": "%KUMA_SOURCE_ADDRESS_WITHOUT_PORT%", "destination_address": "%UPSTREAM_HOST%", "duration_millis": "%DURATION%", "bytes_received": "%BYTES_RECEIVED%", "bytes_sent": "%BYTES_SENT%"}'
        type: tcp
        # Use `config` field to co configure a TCP logging backend.
        conf:
          # Address of a log collector.
          address: 127.0.0.1:5000
      - name: file
        type: file
        # Use `file` field to configure a file-based logging backend.
        conf:
          path: /tmp/access.log
        # When `format` field is omitted, the default access log format will be used.
```

{% endtab %}
{% tab logging-backend Universal %}
```yaml
type: Mesh
name: default
logging:
  # TrafficLog policies may leave the `backend` field undefined.
  # In that case the logs will be forwarded into the `defaultBackend` of that Mesh.
  defaultBackend: file
  # List of logging backends that can be referred to by name
  # from TrafficLog policies of that Mesh.
  backends:
    - name: logstash
      # Use `format` field to adjust the access log format to your use case.
      format: '{"start_time": "%START_TIME%", "source": "%KUMA_SOURCE_SERVICE%", "destination": "%KUMA_DESTINATION_SERVICE%", "source_address": "%KUMA_SOURCE_ADDRESS_WITHOUT_PORT%", "destination_address": "%UPSTREAM_HOST%", "duration_millis": "%DURATION%", "bytes_received": "%BYTES_RECEIVED%", "bytes_sent": "%BYTES_SENT%"}'
      type: tcp
      conf: # Use `config` field to configure a TCP logging backend.
        # Address of a log collector.
        address: 127.0.0.1:5000
    - name: file
      type: file
      # Use `config` field to configure a file-based logging backend.
      conf:
        path: /tmp/access.log
      # When `format` field is omitted, the default access log format will be used.
```
{% endtab %}
{% endtabs %}

## Add a TrafficLog resource

You need to create a `TrafficLog` policy to select a subset of traffic and forward its access logs into one of the _logging backends_ configured for that `Mesh`.

{% tabs traffic-log useUrlFragment=false %}
{% tab traffic-log Kubernetes %}
```yaml
apiVersion: kuma.io/v1alpha1
kind: TrafficLog
metadata:
  name: all-traffic
mesh: default
spec:
  # This TrafficLog policy applies all traffic in that Mesh.
  sources:
    - match:
        kuma.io/service: "*"
  destinations:
    - match:
        kuma.io/service: "*"
  # When `backend ` field is omitted, the logs will be forwarded into the `defaultBackend` of that Mesh.
```

```yaml
apiVersion: kuma.io/v1alpha1
kind: TrafficLog
metadata:
  name: backend-to-database-traffic
mesh: default
spec:
  # This TrafficLog policy applies only to traffic from service `backend` to service `database`.
  sources:
    - match:
        kuma.io/service: backend_kuma-example_svc_8080
  destinations:
    - match:
        kuma.io/service: database_kuma-example_svc_5432
  conf:
    # Forward the logs into the logging backend named `logstash`.
    backend: logstash
```
{% endtab %}
{% tab traffic-log Universal %}
```yaml
type: TrafficLog
name: all-traffic
mesh: default
# This TrafficLog policy applies to all traffic in the Mesh.
sources:
  - match:
      kuma.io/service: "*"
destinations:
  - match:
      kuma.io/service: "*"
# When `backend ` field is omitted, the logs will be forwarded into the `defaultBackend` of that Mesh.
```

```yaml
type: TrafficLog
name: backend-to-database-traffic
mesh: default
# this TrafficLog policy applies only to traffic from service `backend` to service `database`.
sources:
  - match:
      kuma.io/service: backend
destinations:
  - match:
      kuma.io/service: database
conf:
  # Forward the logs into the logging backend named `logstash`.
  backend: logstash
```
{% endtab %}
{% endtabs %}

{% tip %}
When `backend ` field of a `TrafficLog` policy is omitted, the logs will be forwarded into the `defaultBackend` of that `Mesh`.
{% endtip %}

## Log aggregation and visualisation

`Kuma` is presenting a simple solution to aggregate the **logs of your containers** and the **access logs of your data-planes**.

{% tabs log-aggregation useUrlFragment=false %}
{% tab log-aggregation Kubernetes %}

**1. Install Loki**

To install Loki use `kumactl install logging | kubectl apply -f -`. This will deploy Loki automatically in a `kuma-logging` namespace.

**2. Update the mesh**

The logging backend needs to be configured to send the access logs of your data-planes to `stdout`. 
Loki will directly retrieve the logs from `stdout` of your containers.

```yaml
apiVersion: kuma.io/v1alpha1
kind: Mesh
metadata:
  name: default
spec:
    logging:
      defaultBackend: loki
      backends:
        - name: loki
          type: file
          conf:
            path: /dev/stdout
```

**3. Configure Grafana to visualize the logs**

To visualise your **containers' logs** and your **access logs** you need to have a Grafana up and running.
You can install Grafana by following the information of the [official page](https://grafana.com/docs/grafana/latest/installation/) or use the one installed with [Traffic metrics](/docs/{{ page.version }}/policies/traffic-metrics).

If you have installed Grafana yourself you can configure a new datasource with url:`http://loki.kuma-logging:3100` so Grafana will be able to retrieve the logs from Loki.

<center>
<img src="/assets/images/docs/loki_grafana_config.png" alt="Loki Grafana configuration" style="width: 600px; padding-top: 20px; padding-bottom: 10px;"/>
</center>

At this point you can visualize your **containers' logs** and your **access logs** in Grafana by choosing the loki datasource in the [explore section](https://grafana.com/docs/grafana/latest/explore/).

For example, running: `{container="kuma-sidecar"} |= "GET"` will show all GET requests on your cluster.
To learn more about the search syntax check the [Loki docs](https://grafana.com/docs/loki/latest/logql/).
{% endtab %}
{% tab log-aggregation Universal %}

**1. Install Loki**

To install Loki use the instructions on the official [Loki Github repository](https://github.com/grafana/loki/blob/v1.5.0/docs/installation/README).

**2. Update the mesh**

The logging backend needs to be configured to send the access logs of your data-planes to `stdout`. 
Loki will directly retrieve the logs from `stdout` of your containers.

```yaml
type: Mesh
name: default
logging:
  defaultBackend: loki
  backends:
    - name: loki
      type: file
      conf:
        path: /dev/stdout
```
    
**3. Configure Grafana to visualize the logs**

To visualise your **containers' logs** and your **access logs** you need to have a Grafana up and running. 
You can install Grafana by following the information of the [official page](https://grafana.com/docs/grafana/latest/installation/) or use the one installed with [Traffic metrics](/docs/{{ page.version }}/policies/traffic-metrics).

<center>
<img src="/assets/images/docs/loki_grafana_config.png" alt="Loki Grafana configuration" style="width: 600px; padding-top: 20px; padding-bottom: 10px;"/>
</center>

At this point you can visualize your **containers' logs** and your **access logs** in Grafana by choosing the loki datasource in the [explore section](https://grafana.com/docs/grafana/latest/explore/).

For example, running: `{container="kuma-sidecar"} |= "GET"` will show all GET requests on your cluster.
To learn more about the search syntax check the [Loki docs](https://grafana.com/docs/loki/latest/logql/).
{% endtab %}
{% endtabs %}

{% tip %}
**Nice to have**

Having your Logs and Traces in the same visualisation tool can come really handy. By adding the traceId in your app logs you can visualize your logs and the related Jaeger traces. 
To learn more about it go read this [article](https://grafana.com/blog/2020/05/22/new-in-grafana-7.0-trace-viewer-and-integrations-with-jaeger-and-zipkin/).

To set up tracing see the [traffic-trace policy](/docs/{{ page.version }}/policies/traffic-trace).
{% endtip %}

You can also forward the access logs to a collector (such as logstash) that can further transmit them into systems like Splunk, ELK and Datadog.

### Access Log Format

`Kuma` gives you full control over the format of access logs.

The shape of a single log record is defined by a template string that uses [command operators](https://www.envoyproxy.io/docs/envoy/latest/configuration/observability/access_log/usage#command-operators) to extract and format data about a `TCP` connection or an `HTTP` request.

E.g.,

```
%START_TIME% %KUMA_SOURCE_SERVICE% => %KUMA_DESTINATION_SERVICE% %DURATION%
```

where `%START_TIME%` and `%KUMA_SOURCE_SERVICE%` are examples of available _command operators_.

A complete set of supported _command operators_ consists of:

1. All _command operators_ [supported by Envoy](https://www.envoyproxy.io/docs/envoy/latest/configuration/observability/access_log/usage#command-operators)
2. _Command operators_ unique to `Kuma`

The latter include:

| Command Operator                     | Description                                                      |
| ------------------------------------ | ---------------------------------------------------------------- |
| `%KUMA_MESH%`                        | name of the mesh in which traffic is flowing                     |
| `%KUMA_SOURCE_SERVICE%`              | name of a `service` that is the `source` of traffic              |
| `%KUMA_DESTINATION_SERVICE%`         | name of a `service` that is the `destination` of traffic         |
| `%KUMA_SOURCE_ADDRESS_WITHOUT_PORT%` | address of a `Dataplane` that is the `source` of traffic         |
| `%KUMA_TRAFFIC_DIRECTION%`           | direction of the traffic, `INBOUND`, `OUTBOUND` or `UNSPECIFIED` |

### Access Logs for TCP and HTTP traffic

All access log _command operators_ are valid to use with both `TCP` and `HTTP` traffic.

If a _command operator_ is specific to `HTTP` traffic, such as `%REQ(X?Y):Z%` or `%RESP(X?Y):Z%`, it will be replaced by a symbol "`-`" in case of `TCP` traffic.

Internally, `Kuma` [determines traffic protocol](/docs/{{ page.version }}/policies/protocol-support-in-kuma) based on the value of `kuma.io/protocol` tag on the `inbound` interface of a `destination` `Dataplane`.

The default format string for `TCP` traffic is:

```
[%START_TIME%] %RESPONSE_FLAGS% %KUMA_MESH% %KUMA_SOURCE_ADDRESS_WITHOUT_PORT%(%KUMA_SOURCE_SERVICE%)->%UPSTREAM_HOST%(%KUMA_DESTINATION_SERVICE%) took %DURATION%ms, sent %BYTES_SENT% bytes, received: %BYTES_RECEIVED% bytes
```

The default format string for `HTTP` traffic is:

```
[%START_TIME%] %KUMA_MESH% "%REQ(:METHOD)% %REQ(X-ENVOY-ORIGINAL-PATH?:PATH)% %PROTOCOL%" %RESPONSE_CODE% %RESPONSE_FLAGS% %BYTES_RECEIVED% %BYTES_SENT% %DURATION% %RESP(X-ENVOY-UPSTREAM-SERVICE-TIME)% "%REQ(X-FORWARDED-FOR)%" "%REQ(USER-AGENT)%" "%REQ(X-REQUEST-ID)%" "%REQ(:AUTHORITY)%" "%KUMA_SOURCE_SERVICE%" "%KUMA_DESTINATION_SERVICE%" "%KUMA_SOURCE_ADDRESS_WITHOUT_PORT%" "%UPSTREAM_HOST%"
```

{% tip %}
To provide different format for TCP and HTTP logging you can define two separate logging backends with the same address and different format. Then define two TrafficLog entity, one for TCP and one for HTTP with `kuma.io/protocol: http` selector.
{% endtip %}

### Access Logs in JSON format

If you need an access log with entries in `JSON` format, you have to provide a template string that is a valid `JSON` object, e.g.

```json
{
  "start_time":          "%START_TIME%",
  "source":              "%KUMA_SOURCE_SERVICE%",
  "destination":         "%KUMA_DESTINATION_SERVICE%",
  "source_address":      "%KUMA_SOURCE_ADDRESS_WITHOUT_PORT%",
  "destination_address": "%UPSTREAM_HOST%",
  "duration_millis":     "%DURATION%",
  "bytes_received":      "%BYTES_RECEIVED%",
  "bytes_sent":          "%BYTES_SENT%"
}
```

To use it with Logstash, use `json_lines` codec and make sure your JSON is formatted into one line.

### Logging external services

When running Kuma on Kubernetes you can also log the traffic to external services. To do it, the matched destination section has to have wildcard `*` value.
In such case `%KUMA_DESTINATION_SERVICE%` will have value `external` and `%UPSTREAM_HOST%` will have an IP of the service.  

## Matching

`TrafficLog` is an [Outbound Connection Policy](/docs/{{ page.version }}/policies/how-kuma-chooses-the-right-policy-to-apply/#outbound-connection-policy).
The only supported value for `destinations.match` is `kuma.io/service`.

## Builtin Gateway support

Traffic Log is a Kuma outbound connection policy, so Kuma chooses a Traffic Log policy by matching the service tag of the Dataplane’s outbounds.
Since a builtin gateway Dataplane does not have outbounds, Kuma always uses the builtin service name “pass_through” to match the Traffic Log policy for Gateways.
