---
name: Validation
publisher: Kong Inc.
version: 0.1.x
desc: Validate HTTP requests and responses based on an API Specification
description: |
  Validate HTTP requests and responses based on an API Specification. Supports both Swagger v2 and Open API v3 specifications, with support for schema definitions describded using JSONSchema draft v4. For "JSON schema draft 4" type schema's please see the [JSON schema website](https://json-schema.org/) for details on the format and examples.

  {:.note}
  > To use this plugin in Konnect Cloud,
  [upgrade your runtimes](/konnect/runtime-manager/upgrade) to at least
  v3.x.
enterprise: true
plus: true
type: plugin
categories:
  - traffic-control
kong_version_compatibility:
  enterprise_edition:
    compatible:
      - 3.x
params:
  name: validation
  service_id: true
  route_id: true
  consumer_id: false
  protocols:
    - http
    - https
  dbless_compatible: 'yes'
  config:
    - name: api_spec
      required: true
      datatype: string
      description: |
        The API specification defined using either Swagger or the OpenAPI. This can be either a JSON or YAML based file. If using a YAML file, this will need to be URL encoded to preserve the YAML format.
    - name: validate_request_uri_params
      required: false
      datatype: boolean
      default: true
      description: |
        If set to true, validates URI parameters in the request against the API specification.
    - name: validate_request_header_params
      required: false
      datatype: boolean
      default: true
      description: |
        If set to true, validates HTTP Header parameters against the API specification.
    - name: validate_request_query_params
      required: false
      datatype: boolean
      default: true
      description: |
        If set to true, validate Query parameters against the API specification.
    - name: validate_request_body
      required: false
      datatype: boolean
      default: true
      description: |
        If set to true, validates the request body content against the API specification.
    - name: notify_only_request_validation_failure
      required: false
      datatype: boolean
      default: false
      description: |
        If set to true, notifications via event hooks are enabled, but request based validation failures do not effect the request flow.
    - name: validate_response_body
      required: false
      datatype: boolean
      default: false
      description: |
        If set to true, validates the response from the upstream services against the API specification. If validation fails, this will result in a 406 HTTP "Not Acceptable" Status code.
    - name: notify_only_response_body_validation_failure
      required: false
      datatype: boolean
      default: false
      description: |
        If set to true, notifications via event hooks are enabled, but response validation failures do not effect the response flow.
    - name: header_parameter_check
      required: false
      datatype: boolean
      default: true
      description: |
        If set to true, check if HTTP Header parameters in the request exist in the API specification.
    - name: query_parameter_check
      required: false
      datatype: boolean
      default: true
      description: |
        If set to true, check if Query parameters in the request exist in the API specification.
    - name: allowed_header_parameters
      required: false
      datatype: string
      default: '`Host,Content-Type,User-Agent,Accept,Content-Length`'
      description: |
        Header parameters in the request that will be ignored when performing HTTP Header validation. These are additional headers added to an API request beyond those defined in the API specification. Example HTTP Headers include 'User-Agent' which lets servers and network peers identify the application, operating system, vendor, and/or of the requesting user agent.
    - name: verbose_response
      required: false
      datatype: boolean
      default: false
      description: |
        If set to true, returns a detailed error message for invalid requests & responses. This is useful while testing.
---

## Configuration

### Enable the plugin on a Service

Configure this plugin on a [service](/gateway/latest/admin-api/#service-object):

```bash
curl -X POST http://<admin-hostname>:8001/services/<service>/plugins \
    --data "name=validation"  \
    --data "config.api_spec={your API specification}" \
    --data "config.verbose_response=true"
```

The `<service>` is the id or name of the service that this plugin configuration will target.

### Enable the plugin on a Route

Configure this plugin on a [route](/gateway/latest/admin-api/#route-object):

```bash
curl -X POST http://<admin-hostname>:8001/routes/<route>/plugins \
    --data "name=validation"  \
    --data "config.api_spec={your API specification}" \
    --data "config.verbose_response=true"
```

The `<route>` is the id or name of the route that this plugin configuration will target.

## Tutorial Example

This example tutorial steps you through ensuring an API request conforms to the associated API specification. For this example we will be using https://petstore.swagger.io/.

### Step 1. Create the Petstore Service

This example creates a Service called `Petstore-Service`.

{% navtabs %}
{% navtab cURL %}

```bash
curl -X POST http://<admin-hostname>:8001/services/ \
    --data name='Petstore-Service' \
    --data url='https://petstore.swagger.io/v2'
```

{% endnavtab %}
{% navtab HTTPie %}

```bash
http -f <admin-hostname>:8001/services/ name='Petstore-Service' url="https://petstore.swagger.io/v2"
```

{% endnavtab %}
{% endnavtabs %}

### Step 2. Create a Petstore Route

This example creates a wildcard Route called `Petstore-Route`.

{% navtabs %}
{% navtab cURL %}

```bash
curl -X POST http://<admin-hostname>:8001/services/Petstore-Service/routes \
    --data name='Petstore-Route' \
    --data paths='/.*'
```

{% endnavtab %}
{% navtab HTTPie %}

```bash
http -f <admin-hostname>:8001/services/Petstore-Service/routes name='Petstore-Route' paths="/.*"
```

{% endnavtab %}
{% endnavtabs %}

### Step 3. Enable the Validation plugin

Enable the Validation plugin on the Service previously configured. 

{% navtabs %}
{% navtab cURL %}

```bash
curl -X POST http://<admin-hostname>:8001/services/Petstore-Service/plugins \
    --data name='Validation' \
    --data config.api_spec='<copy contents of https://petstore.swagger.io/v2/swagger.json here>' \
    --data config.verbose_response=true
```

{% endnavtab %}
{% navtab HTTPie %}

```bash
http -f <admin-hostname>:8001/services/Petstore-Service/routes name='Petstore-Route' paths="/.*"
```

{% endnavtab %}
{% endnavtabs %}

### Step 4. Test the Validation plugin

The request resource expects a Status Query Parameter which is missing from the request.

{% navtabs %}
{% navtab cURL %}

```bash
curl -X GET "http://<proxy-host>:8000/pet/findByStatus" \
  -H "accept: application/json"
```

{% endnavtab %}
{% navtab HTTPie %}

```bash
http <proxy-host>:8000/pet/findByStatus accept:application/json
```

{% endnavtab %}
{% endnavtabs %}

The response will include a verbose error response, since we have enabled this option in the plugin configuration:

```
HTTP/1.1 400 Bad Request
Content-Length: 106
Content-Type: application/json; charset=utf-8
Date: Tue, 03 May 2022 20:45:00 GMT
Server: kong/2.8.0.0-internal-preview-enterprise-edition
X-Kong-Response-Latency: 2

{
  "message": "query 'status' validation failed with error: 'required parameter value not found in request'"
}
```

## Event Hooks

Event hooks are outbound calls from Kong Gateway. With event hooks, Kong Gateway can communicate with target services or resources, letting the target know that an event was triggered. Refer to the following for more information on Event Hooks - `https://docs.konghq.com/gateway/2.8.x/admin-api/event-hooks/examples/#main`

For the Validation plugin, Event Hook events can be enabled when a Validation fails for all Request parameters, that is URI, Header, & Query parameters and Request body, and/or for Response body from the Upstream Service.

1.  Add an Event Hook for the Validation plugin

    ```
    curl -i -X POST http://{HOSTNAME}:8001/event-hooks \
    -d source=validation \
    -d event=validation-failed \
    -d handler=webhook \
    -d config.url={WEBHOOK_URL}

    HTTP/1.1 201 Created
    ..

    {
        "config": {
            "headers": {},
            "url": {WEBHOOK_URL},
            "ssl_verify": false,
            "secret": null
        },
        "id": "3fe43989-6cf1-4936-bd5d-b7774ca52ad8",
        "source": "validation",
        "event": "validation-failed",
        "handler": "webhook",
        "snooze": null,
        "on_change": null,
        "created_at": 1649732398
     }
    ```

2. Force a validation failure to a Service or Route to which the Validation plugin is applied. The Webhook URL will receive a response with the following JSON payload. The following is an example JSON response which includes Forwared IP address, Service, Consumer, and Error Message

    ```json
    {
    "ip": "10.0.2.2",
    "source": "validation",
    "err": "query 'status' validation failed with error: 'required parameter value not found in request'",
    "event": "validation-failed",
    "service": {
        "ws_id": "7eebecc0-064e-4890-99cf-0c816280a68e",
        "enabled": true,
        "retries": 5,
        "read_timeout": 60000,
        "protocol": "https",
        "id": "6792ec72-67b2-4960-96b1-e7564dda3178",
        "connect_timeout": 60000,
        "name": "petstore-service",
        "port": 443,
        "host": "petstore.swagger.io",
        "updated_at": 1649391578,
        "path": "/v2/",
        "write_timeout": 60000,
        "created_at": 1647993371
    },
    "consumer": {}
    }
    ```
