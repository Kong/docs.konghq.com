---
title: Traffic Log
---

With the Traffic Log policy you can easily set up access logs on every data plane in a mesh. 

{% warning %}
This policy only records outbound traffic. It doesn't record inbound traffic.
{% endwarning %}

To configure access logs in Kuma you need to:

* [1. Add a logging backend](#add-a-logging-backend)
* [2. Add a TrafficLog resource](#add-a-trafficlog-resource)

{% tip %}
In the rest of this page we assume you have already configured your observability tools to work with Kuma.
If you haven't already read the [observability docs](/docs/{{ page.version }}/explore/observability).
{% endtip %}

## Add a logging backend

A _logging backend_ is essentially a sink for access logs.

Currently, it can be either a `file` or a `TCP log collector`, such as Logstash, Splunk or other.



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
          # Address of a log collector (like logstash, splunk or other).
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

You need to create a `TrafficLog` policy to select a subset of traffic and write its access logs into one of the backends configured for that mesh.

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
When `backend ` field is omitted, the logs will be forwarded into the `defaultBackend` of that `Mesh`.
{% endtip %}

### Matching

`TrafficLog` is an [Outbound Connection Policy](/docs/{{ page.version }}/policies/how-kuma-chooses-the-right-policy-to-apply/#outbound-connection-policy).
For this reason the only supported value for `destinations.match` is `kuma.io/service`.

## Logging external services

When running Kuma on Kubernetes you can also log the traffic to external services. To do it, the matched destination section has to have wildcard `*` value.
In such case `%KUMA_DESTINATION_SERVICE%` will have value `external` and `%UPSTREAM_HOST%` will have an IP of the service.

## Builtin Gateway support

Traffic Log is a Kuma outbound connection policy, so Kuma chooses a Traffic Log policy by matching the service tag of the data plane's outbounds.
Since a builtin gateway data plane does not have outbounds, Kuma always uses the builtin service name `pass_through` to match the Traffic Log policy for Gateways.

## Access Log Format

Kuma gives you full control over the format of the access logs.

The shape of a single log record is defined by a template string that uses [command operators](https://www.envoyproxy.io/docs/envoy/latest/configuration/observability/access_log/usage#command-operators) to extract and format data about a `TCP` connection or an `HTTP` request.

E.g.,

```
%START_TIME% %KUMA_SOURCE_SERVICE% => %KUMA_DESTINATION_SERVICE% %DURATION%
```

where `%START_TIME%` and `%KUMA_SOURCE_SERVICE%` are examples of available _command operators_.

All _command operators_ [defined by Envoy](https://www.envoyproxy.io/docs/envoy/latest/configuration/observability/access_log/usage#command-operators) are supported, along with additional _command operators_ defined by Kuma:

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

Internally, Kuma [determines traffic protocol](/docs/{{ page.version }}/policies/protocol-support-in-kuma) based on the value of `kuma.io/protocol` tag on the `inbound` interface of a `destination` `Dataplane`.

The default format string for `TCP` traffic is:

```
[%START_TIME%] %RESPONSE_FLAGS% %KUMA_MESH% %KUMA_SOURCE_ADDRESS_WITHOUT_PORT%(%KUMA_SOURCE_SERVICE%)->%UPSTREAM_HOST%(%KUMA_DESTINATION_SERVICE%) took %DURATION%ms, sent %BYTES_SENT% bytes, received: %BYTES_RECEIVED% bytes
```

The default format string for `HTTP` traffic is:

```
[%START_TIME%] %KUMA_MESH% "%REQ(:METHOD)% %REQ(X-ENVOY-ORIGINAL-PATH?:PATH)% %PROTOCOL%" %RESPONSE_CODE% %RESPONSE_FLAGS% %BYTES_RECEIVED% %BYTES_SENT% %DURATION% %RESP(X-ENVOY-UPSTREAM-SERVICE-TIME)% "%REQ(X-FORWARDED-FOR)%" "%REQ(USER-AGENT)%" "%REQ(X-REQUEST-ID)%" "%REQ(:AUTHORITY)%" "%KUMA_SOURCE_SERVICE%" "%KUMA_DESTINATION_SERVICE%" "%KUMA_SOURCE_ADDRESS_WITHOUT_PORT%" "%UPSTREAM_HOST%"
```

{% tip %}
To provide different format for TCP and HTTP logging you can define two separate logging backends with the same address and different format. Then define two TrafficLog entity, one for TCP and one for HTTP with matching `kuma.io/protocol` selector.
{% endtip %}

#### JSON format

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
