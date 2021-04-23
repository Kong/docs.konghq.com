---
name: Mocking
publisher: Kong Inc.
version: 0.1.x
beta: true
# internal handler v 0.1.0

desc: Provide mock endpoints to test your APIs against your services
description: |
  Mock your services.
  This plugins reads the API specification file loaded from the Kong DB and presents
  with response extracted from examples provided in the specification. Swagger v2 and OpenAPI
  v3 specifications are supported.

  Benefits of service mocking with the Kong Mocking plugin:

  - Conforms to design-first approach since mock responses are within OAS.
  - Accelerates development of services and APIs.
  - Promotes parallel development of APIs across distributed teams.
  - Provides an enhanced full lifecycle API development experience with Dev Portal
    integration.
  - Easily enable and disable the Mocking plugin for flexibility when
    testing API behavior.

  <div class="alert alert-ee blue"><strong>Note:</strong> The Mocking plugin is compatible with
  the Kong Gateway (Enterprise) beta version 2.4.x.
  </div>

enterprise: true
type:
  plugin
categories:
  - traffic control

kong_version_compatibility:
  enterprise_edition:
    compatible:
    - 2.4.x

params:
  name: mocking
  service_id: true
  consumer_id: true
  route_id: true
  protocols: ["http", "https", "grpc", "grpcs"]
  dbless_compatible: yes
  dbless_explanation: |
    Use the `api_specification` config for DB-less mode. Attach the spec contents directly
    instead of uploading to the Dev Portal. The API spec is configured directly in the plugin.
  yaml_examples: false
  k8s_examples: false
  examples: true

  config:
    - name: api_specification_filename
      required: semi
      default:
      datatype: string
      value_in_examples: myspec.yaml
      description: |
        The name of the specification file loaded into Kong DB. Do not
        use this option for DB-less mode.
    - name: api_specification
      required: semi
      default:
      datatype: string
      value_in_examples:
      description: |
        The name of the specification file. Use this option for DB-less mode.
    - name: random_delay
      required: false
      default: false
      datatype: boolean
      value_in_examples: true
      description: |
        Enables random delay in the mocked response. Introduces delays to simulate
        real-time response times by APIs.
    - name: max_delay_time
      required: semi
      default: 1
      datatype: number
      value_in_examples: 1
      description: |
        The maximum value in seconds of delay time. Set this value when `random_delay` is enabled
        and you want to adjust the default. The value must be greater than the
        `min_delay_time`.
    - name: min_delay_time
      required: semi
      default: 0.001
      datatype: number
      value_in_examples: 0.001
      description: |
        The minimum value in seconds of delay time. Set this value when `random_delay` is enabled
        and you want to adjust the default. The value must be less than the
        `max_delay_time`.

  extra: |

    Either the `api_specification_filename` or the `api_specification` must be specified for the
    plugin according to the Kong Gateway (Enterprise) deployment mode.
---

## Prerequisites

- {{site.ee_product_name}} environment with the Dev Portal enabled on at least one workspace
  (not applicable to DB-less).
- An Open API Specification (`yaml` or `json`) that has at least one API method with an
  embedded example response. Multiple examples within a spec are supported. See
  [Example Mock API Specifications](#ex-mock-spex).
- Configure the specification depending on your mode:
  - Upload and deploy the spec to the Dev Portal using either Kong Manager or Insomnia. Specify
    the filename of the spec with the `api_specification_filename` config.
  - Or, if using hybrid mode/DB-less, you must directly attach the spec contents by configuring it in the plugin.
    Indicate the specification with the `api_specification` config.

## Tutorial Example

1. Create a service.
2. Create a route.
3. Enable the Mocking plugin.
4. Enable the [CORS](/hub/kong-inc/cors/) plugin.
5. Test the mocked response.

### Create the Service

This example creates a service named `Stock-Service`.

Command:

```
http :8001/services name=Stock-Service url='http://httpbin/anything'
```

Response:

```
HTTP/1.1 201 Created
Access-Control-Allow-Credentials: true
Access-Control-Allow-Origin: http://localhost:8002
Connection: keep-alive
Content-Length: 362
Content-Type: application/json; charset=utf-8
Date: Fri, 23 Apr 2021 14:16:42 GMT
Server: kong/2.4.0.0-beta1-enterprise-edition
X-Kong-Admin-Latency: 28
X-Kong-Admin-Request-ID: a4WLWEHkurc5IjKSZO2fy8GPmWd6ffs0
vary: Origin

{
    "ca_certificates": null,
    "client_certificate": null,
    "connect_timeout": 60000,
    "created_at": 1619187402,
    "host": "httpbin",
    "id": "94d95e04-bb28-4707-bef7-32307091b5dc",
    "name": "Stock-Service",
    "path": "/anything",
    "port": 80,
    "protocol": "http",
    "read_timeout": 60000,
    "retries": 5,
    "tags": null,
    "tls_verify": null,
    "tls_verify_depth": null,
    "updated_at": 1619187402,
    "write_timeout": 60000
}

```

### Create the Route

```
http -f :8001/services/Stock-Service/routes name='getStockQuote' paths="/stock/historical"
```

Response:

```
HTTP/1.1 201 Created
Access-Control-Allow-Credentials: true
Access-Control-Allow-Origin: http://localhost:8002
Connection: keep-alive
Content-Length: 497
Content-Type: application/json; charset=utf-8
Date: Fri, 23 Apr 2021 14:26:44 GMT
Server: kong/2.4.0.0-beta1-enterprise-edition
X-Kong-Admin-Latency: 29
X-Kong-Admin-Request-ID: UtF0twm9PoeI3gD7SqH6XDvm3JRqKm8o
vary: Origin

{
    "created_at": 1619188004,
    "destinations": null,
    "headers": null,
    "hosts": null,
    "https_redirect_status_code": 426,
    "id": "5ada3c98-c732-4c05-903f-9ba8ef026776",
    "methods": null,
    "name": "getStockQuote",
    "path_handling": "v0",
    "paths": [
        "/stock/historical"
    ],
    "preserve_host": false,
    "protocols": [
        "http",
        "https"
    ],
    "regex_priority": 0,
    "request_buffering": true,
    "response_buffering": true,
    "service": {
        "id": "94d95e04-bb28-4707-bef7-32307091b5dc"
    },
    "snis": null,
    "sources": null,
    "strip_path": true,
    "tags": null,
    "updated_at": 1619188004
}
```

### Enable the Mocking plugin {#enable-mock-plugin}

Command:

```
http -f :8001/routes/getStockQuote/plugins name=mocking config.api_specification_filename=stock-0.1.json
```

Response:

```
HTTP/1.1 201 Created
Access-Control-Allow-Credentials: true
Access-Control-Allow-Origin: http://localhost:8002
Connection: keep-alive
Content-Length: 387
Content-Type: application/json; charset=utf-8
Date: Fri, 23 Apr 2021 20:40:51 GMT
Server: kong/2.4.0.0-beta1-enterprise-edition
X-Kong-Admin-Latency: 1510
X-Kong-Admin-Request-ID: iCZdp9JsqWhtmGLStICwBcOY4jT2R391
vary: Origin

{
    "config": {
        "api_specification": null,
        "api_specification_filename": "stock-0.1.json",
        "max_delay_time": 1,
        "min_delay_time": 0.001,
        "random_delay": false
    },
    "consumer": null,
    "created_at": 1619210451,
    "enabled": true,
    "id": "0d8ed6f6-6a4f-43df-8d81-980b5d9b2c7a",
    "name": "mocking",
    "protocols": [
        "grpc",
        "grpcs",
        "http",
        "https"
    ],
    "route": {
        "id": "5ada3c98-c732-4c05-903f-9ba8ef026776"
    },
    "service": null,
    "tags": null
}
```

### Enable the CORS plugin {#enable-cors-plugin}

Cross-origin resource sharing (CORS) is disabled by default for security reasons. To test the mock response
from the Dev Portal, enable the CORS plugin on the route.

Command:

```
http -f :8001/routes/getStockQuote/plugins name=cors config.origins=*
```

Response:

```
HTTP/1.1 201 Created
Access-Control-Allow-Credentials: true
Access-Control-Allow-Origin: http://localhost:8002
Connection: keep-alive
Content-Length: 449
Content-Type: application/json; charset=utf-8
Date: Fri, 23 Apr 2021 20:46:25 GMT
Server: kong/2.4.0.0-beta1-enterprise-edition
X-Kong-Admin-Latency: 10
X-Kong-Admin-Request-ID: niWS3bFPIUeHOfbLkQTQLS3qeIxSVoPx
vary: Origin

{
   "config": {
       "credentials": false,
       "exposed_headers": null,
       "headers": null,
       "max_age": null,
       "methods": [
           "GET",
           "HEAD",
           "PUT",
           "PATCH",
           "POST",
           "DELETE",
           "OPTIONS",
           "TRACE",
           "CONNECT"
       ],
       "origins": [
           "*"
       ],
       "preflight_continue": false
   },
   "consumer": null,
   "created_at": 1619210785,
   "enabled": true,
   "id": "4573e790-b0b5-4535-a1ab-88c42ca56f69",
   "name": "cors",
   "protocols": [
       "grpc",
       "grpcs",
       "http",
       "https"
   ],
   "route": {
       "id": "5ada3c98-c732-4c05-903f-9ba8ef026776"
   },
   "service": null,
   "tags": null
}
```



### Example Mock API Specs {#ex-mock-spex}




## See also

To view a video demonstration of the Mocking plugin used in conjunction with the Dev Portal,
see the [Service Mocking](https://www.youtube.com/watch?v=l8uKbgkK6_I) video available on YouTube.
