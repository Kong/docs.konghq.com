---
name: OPA
publisher: Kong Inc.
version: 0.2.x

desc: Authorize requests against Open Policy Agent
description: |
    Forward request to Open Policy Agent and process the request only if the
    authorization policy allows for it.

    {:.note}
    > To use this plugin in Konnect Cloud,
    [upgrade your runtimes](/konnect/runtime-manager/upgrade) to at least
    v2.4.1.1.

enterprise: true
plus: true
type: plugin
categories:
  - security

kong_version_compatibility:
    enterprise_edition:
      compatible:
        - 2.6.x
        - 2.5.x
        - 2.4.x

params:
  name: opa
  service_id: true
  route_id: true
  consumer_id: false
  protocols: ["http", "https"]
  dbless_compatible: yes
  config:
    - name: opa_protocol
      required: false
      datatype: string
      default: "`http`"
      description: |
        The protocol to use when talking to Open Policy Agent (OPA) server. Allowed protocols are `http` and `https`.
    - name: opa_host
      required: false
      value_in_examples: localhost
      datatype: string
      default: "`localhost`"
      description: |
        The DNS name or IP address of the OPA server.
    - name: opa_port
      required: false
      value_in_examples: 8181
      datatype: integer
      default: "`8181`"
      description: |
        The port of the OPA server.
    - name: opa_path
      required: true
      value_in_examples: </v1/data/example/kong/allowBoolean>
      datatype: string
      description: |
        The HTTP path to use when making a request to the OPA server. This is usually the path to the policy and rule to evaluate, prefixed with `/v1/data/`. For example,
        if you want to evaluate the `allow` rule inside `example.kong` package, then the path would be `/v1/data/example/kong/allowBoolean`.
    - name: include_service_in_opa_input
      required: false
      datatype: boolean
      default: false
      description: |
        If set to true, the Kong Gateway Service object in use for the current request is included as input to OPA.
    - name: include_route_in_opa_input
      required: false
      datatype: boolean
      default: false
      description: |
        If set to true, the Kong Gateway Route object in use for the current request is included as input to OPA.
    - name: include_consumer_in_opa_input
      required: false
      datatype: boolean
      default: false
      description: |
        If set to true, the Kong Gateway Consumer object in use for the current request (if any) is included as input to OPA.
---

## Usage

### Set up an OPA server

If you are not already running an OPA server, start one by following instructions
on [openpolicyagent.org](https://openpolicyagent.org).

### Set up a dummy policy

Create an `example.rego` file with the following content:

```rego
package example

default allow = false

allowBoolean {
  header_present
}

header_present {
  input.request.http.headers["my-secret-header"] == "open-sesame"
}

allowDetailed = response {
  header_present
  response := {
    "allow": true,
    "headers": {
      "header-from-opa": "accepted",
    },
  }
}

allowDetailed = response {
  not header_present
  response := {
    "allow": false,
    "status": 418,
    "headers": {
      "header-from-opa": "rejected",
    },
  }
}
```

This policy allows the request to pass through if it contains the HTTP header
`my-secret-header` with value `open-sesame`.


Next, configure the policy with OPA:

```bash
curl -XPUT localhost:8181/v1/policies/example --data-binary @example.rego
```

The above command uses OPA's default port 8181. It could be different for your
setup.

### Set up Kong Gateway

Set up a Route and Service in {{site.base_gateway}} and then enable the plugin:

```bash
curl -X POST http://<admin-hostname>:8001/routes/<route>/plugins \
    --data "name=opa"  \
    --data "config.opa_path=/v1/data/example/allowBoolean" \
    --data "config.opa_host=<host-where-opa is running>"
```

### Make a request

Now, make a request to {{site.base_gateway}}:

```bash
curl http://kong:8000/{proxy_path}
```

You will get a 403 response from the gateway because OPA has rejected the request.

Next, make the same request providing the necessary header:

```bash
curl http://kong:8000/{proxy_path} \
  -H 'my-secret-header: open-sesame'
```

This time you will get the response from your upstream service, as this request
is allowed by OPA.

Next, update the plugin configuration to use `/v1/data/example/allowDetailed` as
`opa_path` and observe how the policy affects the response and proxied request.

## OPA input structure

The input to OPA has the following JSON structure:

```
{
  "input": {
    "request": { # details about the request from client to Kong
      "http": {
        "host": "example.org", # host header used by the client to make the request
        "port": "8000",        # port to which the request was made
        "tls": {},             # TLS details if the request was made on HTTPS and Kong terminated the TLS connection
        "method": "GET",       # HTTP method used in the request
        "scheme": "http",      # protocol used to make the request by the client, this can be either `http` or `https`
        "path": "/foo/bar",    # HTTP path used in the request
        "querystring": {       # Query string in the HTTP request as key-value pairs
          "foo" : "bar",
          "foo2" : "bar2",
        },
        "headers": {           # HTTP headers of the request
          "accept-encoding": "gzip, deflate",
          "connection": "keep-alive",
          "accept": "*\\/*"
        }
      }
    },
    "client_ip": "127.0.0.1",# client IP address as interpreted by Kong
    "service": {             # The Kong service resource to which this request will be forwarded to if OPA allows. Injected only if `include_service_in_opa_input` is set to `true`.
      "host": "httpbin.org",
      "created_at": 1612819937,
      "connect_timeout": 60000,
      "id": "e6fd8b19-89e5-44e6-8a2a-79e8bf3c31a5",
      "protocol": "http",
      "name": "foo",
      "read_timeout": 60000,
      "port": 80,
      "updated_at": 1612819937,
      "ws_id": "d6020dc4-67f5-4c62-8b45-e2f497c20f5c",
      "retries": 5,
      "write_timeout": 60000
    },
    "route": {               # The Kong route that was matched for this request. Injected only if `include_route_in_opa_input` is set to `true`.
      "id": "bc6d8617-76a7-441f-aa40-32eb1f5be9e6",
      "paths": [
        "\\/"
      ],
      "protocols": [
        "http",
        "https"
      ],
      "strip_path": true,
      "created_at": 1612819949,
      "ws_id": "d6020dc4-67f5-4c62-8b45-e2f497c20f5c",
      "request_buffering": true,
      "updated_at": 1612819949,
      "preserve_host": false,
      "regex_priority": 0,
      "response_buffering": true,
      "https_redirect_status_code": 426,
      "path_handling": "v0",
      "service": {
        "id": "e6fd8b19-89e5-44e6-8a2a-79e8bf3c31a5"
      }
    },
    "consumer": {            # Kong consumer that was used for authentication for this request. Injected only if `include_consumer_in_opa_input` is set to `true`.
      "id": "bc6d8617-76a7-431f-aa40-32eb1f5be7e6",
      "username": "kong-consumer-username"
    }
  }
}

```

> Note that it is possible that Consumer and Service resources are not
present for any given request in {{site.base_gateway}}.

## Expected response from OPA

After OPA is done executing policies, the plugin expects the policy evaluation
result in one of the defined formats: boolean or object. Any other format
or a status code other than `200 OK` results in the plugin returning a
`500 Internal Server Error` to the client.

### Boolean result

OPA can return a `true` or `false` result after a policy evaluation.
This should suffice for most use cases.

Examples:

To allow the request to be processed further, OPA should send the following
response:

```json
{
  "result": true
}
```

To deny the request and terminate its processing, OPA should send the following
response:

```json
{
  "result": false
}
```

Any other fields in the response in this case are ignored.

### Object result

In this case, OPA returns an object instead of a boolean result. This
allows for injecting custom HTTP headers as well as changing the HTTP status code
for rejected requests.

The plugin expects the following structure in the OPA response in this case:

```
{
  "result": {
    "allow": <boolean>,
    "status": <HTTP status code>,
    "headers": {
      "<key>": "<value>",
      "<key2>": "<value2>"
    }
  }
}
```

The only required field in this response is `result.allow`, which accepts a
`boolean` value.

If `result.allow` is set to `true`, then the key-value pairs in `result.headers` (if any)
are injected into the request before it is forwarded to the upstream Service.

If `result.allow` is set to `false`, then the key-value pairs in `result.headers` (if any)
are injected into the response and the status code of the response is set to `result.status`.
If `result.status` is absent then the default `403` status code is sent.
