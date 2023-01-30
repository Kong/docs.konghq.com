---
name: Mocking
publisher: Kong Inc.
desc: Provide mock endpoints to test your APIs against your services
description: |
  Provide mock endpoints to test your APIs in development against your services.
  The Mocking plugin leverages standards based on the Open API Specification (OAS)
  for sending out mock responses to APIs. Mocking supports both Swagger 2.0 and OpenAPI 3.0.

  Benefits of service mocking with the Kong Mocking plugin:

  - Conforms to a design-first approach since mock responses are within OAS.
  - Accelerates development of services and APIs.
  - Promotes parallel development of APIs across distributed teams.
  - Provides an enhanced full lifecycle API development experience with Dev Portal
    integration.
  - Easily enable and disable the Mocking plugin for flexibility when
    testing API behavior.

  This plugin can mock `200`, `201`, and `204` responses.

enterprise: true
plus: true
type: plugin
categories:
  - traffic-control
kong_version_compatibility:
  enterprise_edition:
    compatible: true
---

## Behavioral Headers

Behavioral headers allow you to change the behavior of the Mocking plugin for the individual request without changing the configuration.

### X-Kong-Mocking-Delay

The `X-Kong-Mocking-Delay` header tells the plugin how many milliseconds to delay before responding. The delay value must be between `0`(inclusive) and `10000`(inclusive), otherwise it returns a `400` error.

```
HTTP/1.1 400 Bad Request

{
    "message": "Invalid value for X-Kong-Mocking-Delay. The delay value should between 0 and 10000ms"
}
```

### X-Kong-Mocking-Example-Id

The `X-Kong-Mocking-Example-Id` header tells the plugin which response example is used when the endpoint has multiple examples for a single status code.

OpenAPI 3.0 allows you to define multiple examples in a single MIME type. The following example has two candidate examples: `Hao` and `Sasha`.

```yaml
paths:
  /query_user:
    get:
      responses:
        '200':
          description: A user object.
          content:
            application/json:
              examples:
                Jessica:
                  value:
                    id: 10
                    name: Hao
                Ron:
                  value:
                    id: 20
                    name: Sasha
```


Makes a request to choose a specific example to respond to:

```bash
curl -X GET http://HOSTNAME:8000/query_user -H "X-Kong-Mocking-Example-Id: Sasha"
```

Response:

```
{
    "id": 20,
    "name": "Sasha"
}
```

### X-Kong-Mocking-Status-Code

By default, the plugin chooses the minimum status code that is defined in the corresponding method.

The `X-Kong-Mocking-Status-Code` header allows requests to change the default status code selection behavior by specifying a status code that is defined in the corresponding method. 

```yaml
paths:
  /ping:
    get:
      responses:
        '200':
          description: '200'
          content:
            application/json:
              example:
                message: '200'
        '500':
          description: '500'
          content:
            application/json:
              example:
                message: '500'
```

Makes a request to choose a specific status code to respond to:

```bash
curl -i -X GET http://HOSTNAME:8000/ping -H "X-Kong-Mocking-Status-Code: 500"
```

Response:

```
HTTP/1.1 500 Internal Server Error

{
    "message": "500"
}
```

## Tutorial Example

This example tutorial steps you through testing a mock response for
a stock quote service API.

{:.note}
> **Note:** Before following the steps in this
tutorial, you can view a video demonstration of the Mocking plugin
used in conjunction with the Dev Portal. See the
[Service Mocking video demo](https://www.youtube.com/watch?v=l8uKbgkK6_I)
available on YouTube.

Prerequisites:

- {{site.ee_product_name}} environment with the Dev Portal enabled on at least one workspace. See
  [enable the Dev Portal](/gateway/latest/developer-portal/enable-dev-portal/) using `kong.conf`. Also refer to
  the instructions for your environment:
  - [Ubuntu](/gateway/latest/install-and-run/ubuntu/#enable-dev-portal)
  - [CentOS](/gateway/latest/install-and-run/centos/#enable-dev-portal)
  - [Amazon Linux 1 or 2](/gateway/latest/install-and-run/amazon-linux/#enable-dev-portal)
  - [RHEL](/gateway/latest/install-and-run/rhel/#enable-dev-portal)

- An Open API Specification (`yaml` or `json`) that has at least one API method with an
  embedded example response. Multiple examples within a spec are supported. See the
  [Stock API spec example](#stock-spec).

  {:.note}
  > **Note:** The spec must contain `200`, `201`, or `204` responses. The
  Mocking plugin doesn't support any other response status codes.

Tutorial steps:

1. Deploy the example OAS spec that contains mocked responses to the [Dev Portal](#deploy-spec-portal) or
   [Insomnia](#deploy-spec-insomnia).
2. Create the [Stock service](#create-stock-service).
3. Create the [`get stock quote` route](#create-stock-quote-route).
4. Enable the [Mocking plugin](#enable-mock-plugin) on the `get stock quote` route.
5. Enable the [CORS plugin](#enable-cors-plugin) on the `get stock quote` route.
6. [Test the mocked response](#testing123) from the Dev Portal, Insomnia, or the command line.
7. When you've completed your API mock testing, [disable the Mocking plugin and update the service URL](#post-test).

### Step 1. Deploy the Stock API example spec

Deploy the [Stock API spec example](#stock-spec) to either the [Dev Portal](#deploy-spec-portal) or
[Insomnia](#deploy-spec-insomnia).

#### Deploy a spec to the Dev Portal {#deploy-spec-portal}

Follow these steps to deploy a spec to the Dev Portal using Kong Manager. You can
copy and paste the `stock-01.json` example file into the Dev Portal using Editor Mode.

![Dev Portal Specs](/assets/images/docs/dev-portal/stock-spec-mock-example.png)

1. Open Editor Mode and click **New File**.
2. Name the file `stock-01.json`.
3. Copy and paste the contents in the [example](#stock-spec) into the new file.

Alternatively, you can also use the [Portal Files API](/gateway/latest/developer-portal/files-api/#post-a-content-file)
to upload a spec to the Dev Portal.

#### Deploy a spec to Insomnia {#deploy-spec-insomnia}

1. From the Insomnia dashboard, click **Create** > **Import from File** and select the
   `stock-0.1.json` file.

   ![Insomnia Dashboard Import File](/assets/images/docs/insomnia/insomnia-import-spec.png)


2. Click **Design Document**, then click OK on the success message.

3. (Optional) Click **Deploy to Portal** to deploy the spec to the Dev Portal.

   ![Insomnia Dashboard Deploy Spec to Portal](/assets/images/docs/insomnia/insomnia-deploy-spec-dev-portal.png)

#### Stock API spec example {#stock-spec}

The mocked responses in the example Stock spec `stock-0.1.json` are between lines `38` to `59` for `GET stock/historical`,
and from lines `86` to `103` for `GET stock/closing`.

If applicable to your environment, replace the `host` entry in the spec with your
IP address or URL for {{site.base_gateway}}.

```json
{"swagger": "2.0",
    "info" : {
        "title": "Stock API",
        "description": "Stock Information Service",
        "version": "0.1"
    },
    "host": "127.0.0.1:8000",
    "basePath": "/",
    "schemes": [
        "http",
        "https"
    ],
    "consumes": [
        "application/json"
    ],
    "produces": [
        "application/json"
    ],
    "paths": {
       "/stock/historical": {
            "get": {
                "description": "",
                "operationId": "GET /stock/historical",
                "produces": [
                    "application/json"
                ],
                "tags": [
                    "Production"
                ],
                "parameters": [
                    {
                        "required": true,
                        "in": "query",
                        "name": "tickers",
                        "type": "string"
                    }
                ],
                "responses": {
                    "200": {
                        "description": "Status 200",
                        "examples": {
                            "application/json":
                                  {
                                "meta_data" : {
                                  "api_name" : "historical_stock_price_v2",
                                  "num_total_data_points" : 1,
                                  "credit_cost" : 10,
                                  "start_date" : "yesterday",
                                  "end_date" : "yesterday"
                                },
                                "result_data" : {
                                  "AAPL" : [ {
                                    "date" : "2000-04-23",
                                    "volume" : 33,
                                    "high" : 100.75,
                                    "low" : 100.87,
                                    "adj_close" : 275.03,
                                    "close" : 100.03,
                                    "open" : 100.87
                                  } ]
                                }
                              }
                            }
                          }
                }
           }
       },
     "/stock/closing": {
            "get": {
                "description": "",
                "operationId": "GET /stock/closing",
                "produces": [
                    "application/json"
                ],
                "tags": [
                    "Beta"
                ],
                "parameters": [
                    {
                        "required": true,
                        "in": "query",
                        "name": "tickers",
                        "type": "string"
                    }
                ],
                "responses": {
                    "200": {
                        "description": "Status 200",
                        "examples": {
                            "application/json":
                                  {
                                "meta_data" : {
                                  "api_name" : "closing_stock_price_v1"
                                },
                                "result_data" : {
                                  "AAPL" : [ {
                                    "date" : "2000-06-23",
                                    "volume" : 33,
                                    "high" : 100.75,
                                    "low" : 100.87,
                                    "adj_close" : 275.03,
                                    "close" : 100.03,
                                    "open" : 100.87
                                  } ]
                                }
                              }
                            }
                          }
                }
           }
       }
    }
}
```

### Step 2. Create the stock service {#create-stock-service}

This example creates a service named `Stock-Service`.

Command:

{% navtabs %}
{% navtab cURL %}

```bash
curl -i -X POST http://<admin-hostname>:8001/services \
  --data name=Stock-Service \
  --data url='http://httpbin.org/anything'
```

{% endnavtab %}
{% navtab HTTPie %}

```bash
http :8001/services name=Stock-Service url='http://httpbin.org/anything'
```

{% endnavtab %}
{% endnavtabs %}

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

### Step 3. Create the get stock quote route {#create-stock-quote-route}

This example creates a route named `getStockQuote` on the service named `Stock-Service`.

{% navtabs %}
{% navtab cURL %}

```bash
curl -X POST http://localhost:8001/services/Stock-Service/routes \
    --data "name=getStockQuote" \
    --data paths="/stock/historical"
```

{% endnavtab %}
{% navtab HTTPie %}

```bash
http -f :8001/services/Stock-Service/routes name='getStockQuote' paths="/stock/historical"
```

{% endnavtab %}
{% endnavtabs %}

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

### Step 4. Enable the Mocking plugin {#enable-mock-plugin}

This example enables the Mocking plugin on the `getStockQuote` route.

Command:

{% navtabs %}
{% navtab cURL %}

```bash
curl -X POST http://<admin-hostname>:8001/routes/getStockQuote/plugins \
    --data "name=mocking"  \
    --data "config.api_specification_filename=stock-0.1.json"
```

Optional configuration for random simulated delay:

```bash
curl -X POST http://<admin-hostname>:8001/routes/getStockQuote/plugins \
    --data "name=mocking"  \
    --data "config.api_specification_filename=stock-0.1.json" \
    --data "config.random_delay=true" \
    --data "config.max_delay_time=1" \
    --data "config.min_delay_time=0.001"
```

DB-less or hybrid mode configuration must use `config.api_specification`:

```bash
curl -X POST http://<admin-hostname>:8001/routes/getStockQuote/plugins \
    --data "name=mocking"  \
    --data "config.api_specification=<spec_contents>"
```

Because a spec can be rather lengthy to put into a command, use a local variable to post
a spec:

```bash
mock_ex=$(cat example.yaml); \
curl -X POST http://<admin-hostname>:8001/routes/<route_id>/plugins \
  --data name=mocking \
  --data config.api_specification="$mock_ex"
```

In Kong Manager, you can copy and paste the contents of the spec directly into
the `Config.Api Specification` text field.

![Kong Manager Config API Spec Text Field](/assets/images/docs/dev-portal/km-config-api-spec-txt-fld.png)

{% endnavtab %}
{% navtab HTTPie %}

```bash
http -f :8001/routes/getStockQuote/plugins name=mocking config.api_specification_filename=stock-0.1.json
```

Optional configuration for random simulated delay using default maximum and minimum delays:

```bash
http -f :8001/routes/getStockQuote/plugins name=mocking config.api_specification_filename=stock-0.1.json config.random_delay=true
```

Specify the path to your spec file if you are using `config.api_specification`:

```bash
http -f localhost:8001/routes/mocking/plugins name=mocking config.api_specification=@../stock-0.1.json
```

{% endnavtab %}
{% endnavtabs %}

Response (random delay not enabled):

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

Response (random delay enabled):

```
HTTP/1.1 201 Created
Access-Control-Allow-Credentials: true
Access-Control-Allow-Origin: http://localhost:8002
Connection: keep-alive
Content-Length: 386
Content-Type: application/json; charset=utf-8
Date: Tue, 11 May 2021 14:50:19 GMT
Server: kong/2.4.0.0-beta1-enterprise-edition
X-Kong-Admin-Latency: 15
X-Kong-Admin-Request-ID: 2ZPP5GE3T6vL2bhbLRL7PBA2u9zgUEB8
vary: Origin

{
    "config": {
        "api_specification": null,
        "api_specification_filename": "stock-0.1.json",
        "max_delay_time": 1,
        "min_delay_time": 0.001,
        "random_delay": true
    },
    "consumer": null,
    "created_at": 1620744619,
    "enabled": true,
    "id": "273edea0-477a-4d9c-bb00-1cf99e48f191",
    "name": "mocking",
    "protocols": [
        "grpc",
        "grpcs",
        "http",
        "https"
    ],
    "route": {
        "id": "b0fad1db-eedf-4e1c-ace3-a394a640a514"
    },
    "service": null,
    "tags": null
}
```

### Step 5. Enable the CORS plugin {#enable-cors-plugin}

Cross-origin resource sharing (CORS) is disabled by default for security reasons. To test the mock response
from the Dev Portal, enable the [CORS plugin](/hub/kong-inc/cors/) on the `getStockQuote` route.

Command:

{% navtabs %}
{% navtab cURL %}

```bash
curl -X POST http://<admin-hostname>:8001/routes/getStockQuote/plugins \
    --data "name=cors"  \
    --data "config.origins=*"
```

{% endnavtab %}
{% navtab HTTPie %}

```bash
http -f :8001/routes/getStockQuote/plugins name=cors config.origins=*
```

{% endnavtab %}
{% endnavtabs %}

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

### Step 6. Test the mock response {#testing123}

Test the mocked response from within the Dev Portal Service,
[Insomnia](https://insomnia.rest/download), or from the command line.

#### Dev Portal mock spec test

Test the mock response from within the Dev Portal spec using the **Try it out** feature.

1. From the Dev Portal home page, click the **Stock API** Service tile.

   ![Dev Portal Services](/assets/images/docs/dev-portal/stock-service.png)

2. Click the **GET /stock/historical** method and the **Try it out** button.

3. Enter the ticker sign **AAPL** in the **tickers** box and click **Execute** to see the server response.


   ![Try it out Dev Portal](/assets/images/docs/dev-portal/tryitout-portal.png)

#### Insomnia mock spec test {#insomnia}

Test the mock response from within the Insomnia spec using the **Try it out** feature.

1. From the Insomnia dashboard, click the **Stock API 0.1 Document** tile.

   ![Insomnia Dashboard](/assets/images/docs/insomnia/insomnia-stock-spec.png)

2. Click the **GET /stock/historical** method and the **Try it out** button.

3. Enter the ticker sign **AAPL** in the **tickers** box and click **Execute** to see the server response.


   ![Try it out Insomnia](/assets/images/docs/insomnia/tryitout-insomnia.png)

#### Command line test

{% navtabs %}
{% navtab cURL %}

```bash
curl -X GET "http://<admin-hostname>:8000/stock/historical?tickers=AAPL" \
  -H "accept: application/json"
```

{% endnavtab %}
{% navtab HTTPie %}

```bash
http :8000/stock/historical?tickers=AAPL accept:application/json
```

{% endnavtab %}
{% endnavtabs %}

The response matches the mocked response from within the spec:

```
HTTP/1.1 200 OK
Access-Control-Allow-Origin: *
Connection: keep-alive
Content-Length: 279
Content-Type: application/json; charset=utf-8
Date: Wed, 05 May 2021 19:59:06 GMT
Server: kong/2.4.0.0-beta1-enterprise-edition
X-Kong-Mocking-Plugin: true
X-Kong-Response-Latency: 40
vary: Origin

{
    "meta_data": {
        "api_name": "historical_stock_price_v2",
        "credit_cost": 10,
        "end_date": "yesterday",
        "num_total_data_points": 1,
        "start_date": "yesterday"
    },
    "result_data": {
        "AAPL": [
            {
                "adj_close": 275.03,
                "close": 100.03,
                "date": "2000-04-23",
                "high": 100.75,
                "low": 100.87,
                "open": 100.87,
                "volume": 33
            }
        ]
    }
}
```

### Step 7. Disable the Mocking plugin and update the Service URL {#post-test}

When your API mock testing is completed, disable the Mocking plugin and update the service
URL.

Disable the Mocking plugin either in Kong Manager by clicking **Disable** for the plugin,
or by using a command. You can copy and paste the plugin ID from within Kong Manager.

![Copy Plugin ID](/assets/images/docs/dev-portal/km-copy-plugin-id.png)

{% navtabs %}
{% navtab cURL %}

```
curl -X PATCH http://localhost:8001/plugins/<plugin-id>  -i \
    --data "name=mocking"  \
    --data "enabled=false"
```

{% endnavtab %}
{% navtab HTTPie %}

```
http PATCH :8001/plugins/<plugin-id> enabled=false -f
```

{% endnavtab %}
{% endnavtabs %}

Response:

```
HTTP/1.1 200 OK
Access-Control-Allow-Credentials: true
Access-Control-Allow-Origin: http://localhost:8002
Connection: keep-alive
Content-Length: 347
Content-Type: application/json; charset=utf-8
Date: Fri, 07 May 2021 18:18:11 GMT
Server: kong/2.4.0.0-beta1-enterprise-edition
X-Kong-Admin-Latency: 11
X-Kong-Admin-Request-ID: 0s7xacYAUBFIY0LPanSkobV8mSdhOSvk
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
    "created_at": 1620403609,
    "enabled": false,
    "id": "9a7dbe34-da00-47df-9939-5787abf2d3a1",
    "name": "mocking",
    "protocols": [
        "grpc",
        "grpcs",
        "http",
        "https"
    ],
    "route": null,
    "service": null,
    "tags": null
}
```

The `enabled` config reflects `false` in line `22`.

The service URL can be anything for purposes of mocking. After you disable the Mocking plugin,
ensure you set the actual URL for your service so that the response can be received.

 ![Set Real Service URL](/assets/images/docs/dev-portal/km-service-url.png)

## See also
* [`inso` CLI documentation](https://support.insomnia.rest/collection/105-inso-cli)

---

