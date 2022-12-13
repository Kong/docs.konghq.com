---
title: MeshAccessLog (beta)
---

With the MeshAccessLog policy you can easily set up access logs on every data plane proxy in a mesh.

{% warning %}
This policy uses a new policy matching algorithm and is in beta state. It should not be combined with [TrafficLog](/docs/{{ page.version }}/policies/traffic-log).
{% endwarning %}

{% tip %}
This guide assumes you have already configured your observability tools to work with Kuma.
If you haven't, see the [observability docs](/docs/{{ page.version }}/explore/observability).
{% endtip %}

## `targetRef` support matrix

| `targetRef.kind`    | top level | to  | from |
| ------------------- | --------- | --- | ---- |
| `Mesh`              | ✅        | ✅  | ✅   |
| `MeshSubset`        | ✅        | ❌  | ❌   |
| `MeshService`       | ✅        | ✅  | ❌   |
| `MeshServiceSubset` | ✅        | ❌  | ❌   |

To learn more about the information in this table, see the [matching docs](/docs/{{ page.version }}/policies/targetref).

## Configuration

### Format

Kuma gives you full control over the format of the access logs.

The shape of a single log record is defined by a template string that uses [command operators](https://www.envoyproxy.io/docs/envoy/v1.22.0/configuration/observability/access_log/usage#command-operators) to extract and format data about a `TCP` connection or an `HTTP` request.

For example:

```
%START_TIME% %KUMA_SOURCE_SERVICE% => %KUMA_DESTINATION_SERVICE% %DURATION%
```

`%START_TIME%` and `%KUMA_SOURCE_SERVICE%` are examples of available _command operators_.

All _command operators_ [defined by Envoy](https://www.envoyproxy.io/docs/envoy/v1.22.0/configuration/observability/access_log/usage#command-operators) are supported, along with additional _command operators_ defined by Kuma:

| Command Operator                     | Description                                                      |
|--------------------------------------|------------------------------------------------------------------|
| `%KUMA_MESH%`                        | Name of the mesh in which traffic is flowing.                     |
| `%KUMA_SOURCE_SERVICE%`              | Name of a `service` that is the `source` of traffic.              |
| `%KUMA_DESTINATION_SERVICE%`         | Name of a `service` that is the `destination` of traffic.         |
| `%KUMA_SOURCE_ADDRESS_WITHOUT_PORT%` | Address of a `Dataplane` that is the `source` of traffic.         |
| `%KUMA_TRAFFIC_DIRECTION%`           | Direction of the traffic, `INBOUND`, `OUTBOUND`, or `UNSPECIFIED`. |

All additional access log _command operators_ are valid to use with both `TCP` and `HTTP` traffic.

If a _command operator_ is specific to `HTTP` traffic, such as `%REQ(X?Y):Z%` or `%RESP(X?Y):Z%`, it will be replaced by a symbol "`-`" in case of `TCP` traffic.

Internally, Kuma [determines traffic protocol](/docs/{{ page.version }}/policies/protocol-support-in-kuma) based on the value of `kuma.io/protocol` tag on the `inbound` interface of a `destination` `Dataplane`.

There are two types of `format`, `plain` and `json`.

Plain accepts a string with _command operators_ and produces a string output.

JSON accepts a list of key-value pairs that produces a valid JSON object.

It is up to the user to decide which format type to use.
Some system will automatically parse JSON logs and allow you to filter and query based on available keys.

#### Plain

The default format string for `TCP` traffic is:

```
[%START_TIME%] %RESPONSE_FLAGS% %KUMA_MESH% %KUMA_SOURCE_ADDRESS_WITHOUT_PORT%(%KUMA_SOURCE_SERVICE%)->%UPSTREAM_HOST%(%KUMA_DESTINATION_SERVICE%) took %DURATION%ms, sent %BYTES_SENT% bytes, received: %BYTES_RECEIVED% bytes
```

The default format string for `HTTP` traffic is:

```
[%START_TIME%] %KUMA_MESH% "%REQ(:METHOD)% %REQ(X-ENVOY-ORIGINAL-PATH?:PATH)% %PROTOCOL%" %RESPONSE_CODE% %RESPONSE_FLAGS% %BYTES_RECEIVED% %BYTES_SENT% %DURATION% %RESP(X-ENVOY-UPSTREAM-SERVICE-TIME)% "%REQ(X-FORWARDED-FOR)%" "%REQ(USER-AGENT)%" "%REQ(X-REQUEST-ID)%" "%REQ(:AUTHORITY)%" "%KUMA_SOURCE_SERVICE%" "%KUMA_DESTINATION_SERVICE%" "%KUMA_SOURCE_ADDRESS_WITHOUT_PORT%" "%UPSTREAM_HOST%"
```

Example configuration:

```yaml
format:
  plain: '[%START_TIME%] %BYTES_RECEIVED%'
```

Example output:

```text
[2016-04-15T20:17:00.310Z] 154
```

#### JSON

Example configuration:

```yaml
format:
  json:
    - key: "start_time"
      value: "%START_TIME%"
    - key: "bytes_received"
      value: "%BYTES_RECEIVED%"
```

Example output:

```json
{
  "start_time": "2016-04-15T20:17:00.310Z",
  "bytes_received": "154"
}
```

<details>
  <summary>TCP configuration with default fields:</summary>

  <div markdown="1">
```yaml
format:
  json:
    - key: "start_time"
      value: "%START_TIME%"
    - key: "response_flags"
      value: "%RESPONSE_FLAGS%"
    - key: "kuma_mesh"
      value: "%KUMA_MESH%"
    - key: "kuma_source_address_without_port"
      value: "%KUMA_SOURCE_ADDRESS_WITHOUT_PORT%"
    - key: "kuma_source_service"
      value: "%KUMA_SOURCE_SERVICE%"
    - key: "upstream_host"
      value: "%UPSTREAM_HOST%"
    - key: "kuma_destination_service"
      value: "%KUMA_DESTINATION_SERVICE%"
    - key: "duration_ms"
      value: "%DURATION%"
    - key: "bytes_sent"
      value: "%BYTES_SENT%"
    - key: "bytes_received"
      value: "%BYTES_RECEIVED%"
```
</div>

</details>

<details>
  <summary>HTTP configuration with default fields:</summary>

<div markdown="1">
```yaml
format:
  json:
    - key: "start_time"
      value: "%START_TIME%"
    - key: "kuma_mesh"
      value: "%KUMA_MESH%"
    - key: 'method'
      value: '"%REQ(:METHOD)%'
    - key: "path"
      value: "%REQ(X-ENVOY-ORIGINAL-PATH?:PATH)%"
    - key: 'protocol'
      value: '%PROTOCOL%'
    - key: "response_code"
      value: "%RESPONSE_CODE%"
    - key: "response_flags"
      value: "%RESPONSE_FLAGS%"
    - key: "bytes_received"
      value: "%BYTES_RECEIVED%"
    - key: "bytes_sent"
      value: "%BYTES_SENT%"
    - key: "duration_ms"
      value: "%DURATION%"
    - key: "upstream_service_time"
      value: "%RESP(X-ENVOY-UPSTREAM-SERVICE-TIME)%"
    - key: 'x_forwarded_for'
      value: '"%REQ(X-FORWARDED-FOR)%"'
    - key: 'user_agent'
      value: '"%REQ(USER-AGENT)%"'
    - key: 'request_id'
      value: '"%REQ(X-REQUEST-ID)%"'
    - key: 'authority'
      value: '"%REQ(:AUTHORITY)%"'
    - key: "kuma_source_service"
      value: "%KUMA_SOURCE_SERVICE%"
    - key: "kuma_destination_service"
      value: "%KUMA_DESTINATION_SERVICE%"
    - key: "kuma_source_address_without_port"
      value: "%KUMA_SOURCE_ADDRESS_WITHOUT_PORT%"
    - key: "upstream_host"
      value: "%UPSTREAM_HOST%"
```
</div>

</details>


### Backends

A backend determines where the logs end up.

#### TCP

A TCP backend streams logs to a server via TCP protocol.
You can configure a TCP backend with an address:

```yaml
backends:
  - tcp:
      address: 127.0.0.1:5000
```

#### File

A file backend streams logs to a text file.
You can configure a file backend with a path:

```yaml
backends:
  - file:
      path: /tmp/access.log
```

## Examples

### Log outgoing traffic from specific frontend version to a backend service

{% tabs meshaccesslog-outgoing-from-frontend-to-backend useUrlFragment=false %}
{% tab meshaccesslog-outgoing-from-frontend-to-backend Kubernetes %}

```yaml
apiVersion: kuma.io/v1alpha1
kind: MeshAccessLog
metadata:
  name: default
  namespace: kuma-system
  labels:
    kuma.io/mesh: default # optional, defaults to `default` if it isn't configured
spec:
  targetRef:
    kind: MeshService
    name: frontend
    tags:
      version: canary
  to:
    - targetRef:
        kind: MeshService
        name: backend
      default:
        backends:
          - file:
              path: /tmp/access.log
```

Apply the configuration with `kubectl apply -f [..]`.

{% endtab %}
{% tab meshaccesslog-outgoing-from-frontend-to-backend Universal %}

```yaml
type: MeshAccessLog
name: default
mesh: default
spec:
  targetRef:
    kind: MeshService
    name: frontend
    tags:
      version: canary
  to:
    - targetRef:
        kind: MeshService
        name: backend
      default:
        backends:
          - file:
              path: /tmp/access.log
```

Apply the configuration with `kumactl apply -f [..]` or with the [HTTP API](../../reference/http-api).

{% endtab %}
{% endtabs %}

### Logging to multiple backends

This configuration logs to two backends: TCP and file.

{% tabs meshaccesslog-multiple-backends useUrlFragment=false %}
{% tab meshaccesslog-multiple-backends Kubernetes %}

```yaml
apiVersion: kuma.io/v1alpha1
kind: MeshAccessLog
metadata:
  name: default
  namespace: kuma-system
  labels:
    kuma.io/mesh: default # optional, defaults to `default` if it isn't configured
spec:
  targetRef:
    kind: Mesh
  from:
    - targetRef:
        kind: Mesh
      default:
        backends:
          - file:
              address: 127.0.0.1:5000
              format:
                json:
                  - key: "start_time"
                    value: "%START_TIME%"
          - file:
              path: /tmp/access.log
              format:
                plain: '[%START_TIME%]'
```

Apply the configuration with `kubectl apply -f [..]`.

{% endtab %}
{% tab meshaccesslog-multiple-backends Universal %}

```yaml
type: MeshAccessLog
name: default
mesh: default
spec:
  targetRef:
    kind: Mesh
  from:
    - targetRef:
        kind: Mesh
      default:
        backends:
          - file:
              address: 127.0.0.1:5000
              format:
                json:
                  - key: "start_time"
                    value: "%START_TIME%"
          - file:
              path: /tmp/access.log
              format:
                plain: '[%START_TIME%]'
```

Apply the configuration with `kumactl apply -f [..]` or with the [HTTP API](../../reference/http-api).

{% endtab %}
{% endtabs %}

## Log all incoming and outgoing traffic

{% tabs meshaccesslog-all useUrlFragment=false %}
{% tab meshaccesslog-all Kubernetes %}

```yaml
apiVersion: kuma.io/v1alpha1
kind: MeshAccessLog
metadata:
  name: default
  namespace: kuma-system
  labels:
    kuma.io/mesh: default # optional, defaults to `default` if it isn't configured
spec:
  targetRef:
    kind: Mesh
  from: # delete this section if you don't want to log incoming traffic
    - targetRef:
        kind: Mesh
      default:
        backends:
          - file:
              path: /tmp/access.log
  to: # delete this section if you don't want to log outgoing traffic
    - targetRef:
        kind: Mesh
      default:
        backends:
          - file:
              path: /tmp/access.log
```

Apply the configuration with `kubectl apply -f [..]`.

{% endtab %}
{% tab meshaccesslog-all Universal %}

```yaml
type: MeshAccessLog
name: default
mesh: default
spec:
  targetRef:
    kind: Mesh
  from: # delete this section if you don't want to log incoming traffic
    - targetRef:
        kind: Mesh
      default:
        backends:
          - file:
              path: /tmp/access.log
  to: # delete this section if you don't want to log outgoing traffic
    - targetRef:
        kind: Mesh
      default:
        backends:
          - file:
              path: /tmp/access.log
```

Apply the configuration with `kumactl apply -f [..]` or with the [HTTP API](../../reference/http-api).

{% endtab %}
{% endtabs %}

## Logging traffic going outside the Mesh

To target [`ExternalServices`](/docs/{{ page.version }}/policies/external-services#usage), use `MeshService` as the `targetRef` kind with `name` set to  
the `kuma.io/service` value.

To target other non-mesh traffic, i.e. [passthrough traffic](/docs/{{ page.version }}/policies/mesh/#controlling-the-passthrough-mode), use `Mesh` as the `targetRef` kind. In this case, `%KUMA_DESTINATION_SERVICE%` is set to `external`.

## Select a built-in gateway

You can select a built-in gateway using the `kuma.io/service` value. A current limitation is that traffic routed from a gateway to a service is logged by that gateway as having destination `"*"`.
