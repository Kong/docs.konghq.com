---
nav_title: Overview
---

Validate HTTP requests and responses against an OpenAPI Specification.


{% if_version lte:3.6.x %}

The plugin supports both Swagger (v2) and OpenAPI (3.0.x) specifications, with the support of JSON Schema [Draft-04](https://json-schema.org/specification-links#draft-4). 

{% endif_version %}
{% if_version gte:3.7.x %}

The plugin supports both Swagger (v2) and OpenAPI (3.0.x and 3.1.0) specifications with a JSON Schema validator that supports [Draft 2019-09](https://json-schema.org/specification-links#draft-2019-09-(formerly-known-as-draft-8)).

{% endif_version %}

{% if_version gte:3.2.x %}
{:.important .no-icon}
> In {{site.base_gateway}} versions 3.1.0.0-3.1.1.1, this plugin is not enabled by default. Upgrade to 3.1.1.2, or manually enable the plugin.
{% endif_version %}

{% if_version eq:3.1.x %}
## Enable the plugin

In {{site.base_gateway}} versions 3.1.0.0-3.1.1.1, this plugin is not enabled by default.

To enable the plugin, use one of the following methods:
  * Package install: Set `plugins=bundled,oas-validation` in `kong.conf` before starting Kong
  * Docker: Set `KONG_PLUGINS=bundled,oas-validation` in the environment
  * Kubernetes: Set `KONG_PLUGINS=bundled,oas-validation` using [these instructions](/kubernetes-ingress-controller/latest/guides/setting-up-custom-plugins/#modify-configuration)

{% endif_version %}

{% if_version gte:3.7.x %}

## Supported OpenAPI 3.1.0 specification features

| Category                        | Supported                      | Not supported                                                            |
|---------------------------------|--------------------------------|--------------------------------------------------------------------------|
| Request Body                    | `application/json`               | `application/xml`<br>`multipart/form-data`<br>`text/plain`<br>`text/xml`<br> |
| Response Body                   | `application/json`               | -                                                                        |
| Request Parameters              | `path`, `query`, `header`, `cookie`    | -                                                                        |
| Schema                          | `allOf`<br>`oneOf`<br>`anyOf`<br> | -                                                                        |
| Parameter Serialization         | `style`, `explode `                | -                                                                        |

{% endif_version %}

## Tutorial

This example tutorial steps you through ensuring an API request conforms to the associated API specification. This example uses the [sample Petstore spec](https://petstore.swagger.io/).

1. Create a service called `Petstore-Service`:

    ```bash
    curl -X POST http://localhost:8001/services/ \
        --data name='Petstore-Service' \
        --data url='https://petstore.swagger.io/v2'
    ```

2. Create a wildcard route called `Petstore-Route`:

    ```bash
    curl -X POST http://localhost:8001/services/Petstore-Service/routes \
        --data name='Petstore-Route' \
        --data paths='~/.*' \
        --data strip_path=false
    ```
    
3. Enable the Validation plugin on the service you configured:

    ```bash
    curl -X POST http://localhost:8001/services/Petstore-Service/plugins \
        --data name='oas-validation' \
        --data config.api_spec='<copy contents of https://petstore.swagger.io/v2/swagger.json here>' \
        --data config.verbose_response=true
    ```

4. Test the Validation plugin. The request resource expects a status query parameter,
 which is missing from the following request:

    ```bash
    curl -X GET "http://localhost:8000/pet/findByStatus" \
      -H "accept: application/json"
    ```

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

    The following is an example JSON response which includes the forwarded IP address, service, consumer, and error message:

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

## Troubleshooting

### The plugin validates the ETag header with the If-Match header

If a request contains the `If-Match` request header, the OAS Validation plugin follows [RFC 2616](https://www.ietf.org/rfc/rfc2616.txt) to validate the `Etag` response header.

If you don't want the plugin to validate the `Etag` with the `If-Match` request header,
send the `If-Match` header with a wildcard (`*`) to skip validation.

For example:
```sh
curl http://localhost:8000/example-route \
  -H 'If-Match:*'
```
