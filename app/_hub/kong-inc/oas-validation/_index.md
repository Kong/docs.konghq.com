---
name: OAS Validation
publisher: Kong Inc.
desc: Validate HTTP requests and responses based on an OpenAPI 3.0 or Swagger API Specification
description: |
  Validate HTTP requests and responses based on an API Specification. Supports both Swagger v2 and OpenAPI v3 specifications JSON request and response bodies, with support for schema definitions described using JSON Schema draft v4. For JSON Schema draft 4 type schemas, see the [JSON Schema documentation](https://json-schema.org/) for details on the format and examples.

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
    compatible: true
params:
  name: oas-validation
  service_id: true
  route_id: true
  consumer_id: false
  protocols:
    - name: http
    - name: https
  dbless_compatible: 'yes'
  config:
    - name: api_spec
      required: true
      datatype: string
      value_in_examples: <your API specification>
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
        If set to true, validates HTTP header parameters against the API specification.
    - name: validate_request_query_params
      required: false
      datatype: boolean
      default: true
      description: |
        If set to true, validates query parameters against the API specification.
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
        If set to true, validates the response from the upstream services against the API specification. If validation fails, this will result in a HTTP 406 "Not Acceptable" status code.
    - name: notify_only_response_body_validation_failure
      required: false
      datatype: boolean
      default: false
      description: |
        If set to true, notifications via event hooks are enabled, but response validation failures don't affect the response flow.
    - name: header_parameter_check
      required: true
      datatype: boolean
      default: false
      description: |
        If set to true, checks if HTTP header parameters in the request exist in the API specification.
    - name: query_parameter_check
      required: true
      datatype: boolean
      default: false
      description: |
        If set to true, checks if query parameters in the request exist in the API specification.
    - name: allowed_header_parameters
      required: false
      datatype: string
      default: '`Host,Content-Type,User-Agent,Accept,Content-Length`'
      description: |
        List of header parameters in the request that will be ignored when performing HTTP header validation. These are additional headers added to an API request beyond those defined in the API specification.

        For example, you might include the HTTP header `User-Agent`, which lets servers and network peers identify the application, operating system, vendor, and/or of the requesting user agent.
    - name: verbose_response
      required: false
      datatype: boolean
      default: false
      value_in_examples: true
      description: |
        If set to true, returns a detailed error message for invalid requests & responses. This is useful while testing.
---

## Tutorial

This example tutorial steps you through ensuring an API request conforms to the associated API specification. This example uses the [sample Petstore spec](https://petstore.swagger.io/).

### Create the Petstore service

Creates a service called `Petstore-Service`:

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

### Create a Petstore route

Creates a wildcard route called `Petstore-Route`:

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

### Enable the Validation plugin

Enable the Validation plugin on the service you configured:

{% navtabs %}
{% navtab cURL %}

```bash
curl -X POST http://<admin-hostname>:8001/services/Petstore-Service/plugins \
    --data name='oas-validation' \
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

### Test the Validation plugin

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

The response includes a verbose error response, since we have enabled this option in the plugin configuration:

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

## Event hooks

Event hooks are outbound calls from {{site.base_gateway}}. With event hooks, {{site.base_gateway}} can communicate with target services or resources, letting the target know that an event was triggered. Refer to the [event hooks example documentation](/gateway/latest/kong-enterprise/event-hooks/) for more information on event hooks.

For the Validation plugin, event hook events can be enabled when a Validation fails for all request parameters, that is URI, Header, & Query parameters and Request body, and/or for Response body from the Upstream Service.

1.  Add an event hook for the Validation plugin:

    ```sh
    curl -i -X POST http://{HOSTNAME}:8001/event-hooks \
      -d source=oas-validation \
      -d event=validation-failed \
      -d handler=webhook \
      -d config.url={WEBHOOK_URL}
    ```

    Response:
    ```json
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
        "source": "oas-validation",
        "event": "validation-failed",
        "handler": "webhook",
        "snooze": null,
        "on_change": null,
        "created_at": 1649732398
     }
    ```

2. Force a validation failure to a service or route to which the Validation plugin is applied. The Webhook URL will receive a response with JSON payload.

    The following is an example JSON response which includes the forwarded IP address, service, consumer, and and error message:

    ```json
    {
    "ip": "10.0.2.2",
    "source": "oas-validation",
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
