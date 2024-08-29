---
nav_title: Overview
---

The JSON Threat Protection plugin provides security validation against various aspects of JSON structure.
The plugin validates the incoming JSON request body to ensure the payload adheres to the policy limits, regardless of whether the `Content-Type` header exists or is set to `application/json`.
Requests violating the policy are considered malicious.
You can configure the plugin to drop such requests, which stops them from reaching the service.
Optionally, the plugin can operate in tap mode to monitor the traffic.

## How it works

The plugin checks the following limits:

- Maximum container depth of the entire JSON
- Maximum number of array elements
- Maximum number of object entries
- Maximum length of object keys
- Maximum length of strings

For example, for the following JSON:

```
{
  "name": "Jason",
  "age": 20,
  "gender": "male",
  "parents": ["Joseph", "Viva"]
}
```

- Maximum container depth: 2
- Maximum number of array elements: 2
- Maximum number of object entries: 4
- Maximum length of object keys: 7 (`parents`)
- Maximum length of strings: 6 (`Joseph`)

{:.note}
> **Note**: Length calculation for JSON strings and object entry names is based on UTF-8 characters, not bytes.


Additionally, there is a limit named `max_body_size`, which is used to restrict the request body size.
This can effectively reduce resource overhead and potential attack risks associated with excessively large bodies.
The plugin reads the `Content-Length` header and compares its value with `max_body_size`.
Therefore, in block mode, if the `Content-Length` header is missing or its value exceeds `max_body_size`, the request will be terminated.
In tap mode, only the body size is checked, and logs are recorded.

{:.note}
> **Note**: max_body_size and nginx_http_client_max_body_size are independent of each other. Therefore, users should be aware that if nginx_http_client_max_body_size is set to a larger value while max_body_size is smaller and block mode is enabled, any request with a body size greater than max_body_size but less than nginx_http_client_max_body_size will be terminated.


## Using the plugin

The following example assumes you have a service listening on port 80.
When accessed successfully, the service responds with `200 OK`.
In the example, you'll configure the following:
* A service in {{site.base_gateway}} that points to the service you just deployed
* A route for this service
* Enable the JSON threat protection policy on the route to enforce payload limits.
Specifically, you'll configure the plugin to reject violating requests.

Kong inspects the incoming requests, validates the payload adheres to the limits, and rejects requests that violate the policy.



### Create a service

```bash
curl -i -s -X POST http://localhost:8001/services \
  --data name=example_service \
  --data url='http://localhost/'
```

The response is:

```json
{
  "tls_verify": null,
  "created_at": 1718876195,
  "tls_verify_depth": null,
  "connect_timeout": 60000,
  "write_timeout": 60000,
  "host": "localhost",
  "updated_at": 1718876195,
  "name": "example_service",
  "protocol": "http",
  "enabled": true,
  "ca_certificates": null,
  "id": "1c5ba231-a3fe-4884-b422-ce6395fa227f",
  "port": 80,
  "read_timeout": 60000,
  "tags": null,
  "client_certificate": null,
  "retries": 5,
  "path": "/"
}
```



### Create a route

```bash
curl -i -X POST http://localhost:8001/services/example_service/routes \
  --data 'paths[]=/' \
  --data name=example_route
```

The response is:

```json
{
  "created_at": 1718876213,
  "https_redirect_status_code": 426,
  "protocols": [
    "http",
    "https"
  ],
  "hosts": null,
  "methods": null,
  "path_handling": "v0",
  "updated_at": 1718876213,
  "destinations": null,
  "preserve_host": false,
  "name": "example_route",
  "headers": null,
  "paths": [
    "/"
  ],
  "service": {
    "id": "1c5ba231-a3fe-4884-b422-ce6395fa227f"
  },
  "sources": null,
  "snis": null,
  "id": "8ec673f6-3399-4b74-b3dc-f31632770dd1",
  "regex_priority": 0,
  "tags": null,
  "strip_path": true,
  "request_buffering": true,
  "response_buffering": true
}
```



### Create a JSON threat protection policy

```bash
curl -X POST http://localhost:8001/plugins \
  --data "name=json-threat-protection" \
  --data "service.name=example_service" \
  --data "config.max_body_size=1024" \
  --data "config.max_container_depth=2" \
  --data "config.max_object_entry_count=4" \
  --data "config.max_object_entry_name_length=7" \
  --data "config.max_array_element_count=2" \
  --data "config.max_string_value_length=6" \
  --data "config.enforce_mode=block" \
  --data "config.error_status_code=400" \
  --data "config.error_message=BadRequest1"
```

The configuration fields have the following meanings:

- `config.max_body_size=1024`: The request body must not exceed 1024 bytes.
- `config.max_container_depth=2`: The maximum depth of the container is 2.
- `config.max_object_entry_count=4`: The number of object entries must not exceed 4.
- `config.max_object_entry_name_length=7`: The key for an object entry must not exceed 7 bytes.
- `config.max_array_element_count=2`: The number of array elements must not exceed 2.
- `config.max_string_value_length=6`: The length of string values must not exceed 6 bytes.
- `config.enforce_mode=block`: Enables `block` mode, where the request will not be proxied to the upstream service if the JSON violates the above limits.
- `config.error_status_code=400`: When a JSON violation occurs, Kong returns an error code `400`.
- `config.error_message=BadRequest1`: When a JSON violation occurs, Kong returns the error message `BadRequest1`.

### Tap mode
In tap mode, the plugin inspects the JSON in the request body, but if there are any violations of the limits, it doesn't block the request. Instead, it logs a warning and proxies the request to the upstream service. In other words, in tap mode, the plugin only monitors the traffic.

To enable tap mode,  set `config.enforce_mode` to `log_only`:

```
config.enforce_mode=log_only
```


The response will look something like this:

```json
{
  "updated_at": 1718876232,
  "created_at": 1718876232,
  "consumer": null,
  "config": {
    "max_body_size": 1024,
    "max_container_depth": 2,
    "max_array_element_count": 2,
    "max_object_entry_count": 4,
    "max_object_entry_name_length": 7,
    "max_string_value_length": 6,
    "enforce_mode": "block",
    "error_status_code": 400,
    "error_message": "BadRequest1"
  },
  "protocols": [
    "grpc",
    "grpcs",
    "http",
    "https"
  ],
  "service": {
    "id": "1c5ba231-a3fe-4884-b422-ce6395fa227f"
  },
  "name": "json-threat-protection",
  "id": "d8ef3743-f97e-4c98-87f1-53621cb28958",
  "tags": null,
  "route": null,
  "ordering": null,
  "consumer_group": null,
  "instance_name": null,
  "enabled": true
}
```



### Example requests and responses

This request is successfully proxied and returns a response:

```bash
curl -XPOST http://localhost:8000/ \
  -H "Content-Type: application/json" \
  -d '{"name": "Jason","age": 20,"gender": "male","parents": ["Joseph", "Viva"]}' 
```

The response is:

```html
200 OK
```



The following request is intercepted by the JSON Threat Protection plugin and returns the configured message instead of the standard response:

```bash
curl -XPOST http://localhost:8000/ \
  -H "Content-Type: application/json" \
  -d '{"name": "Jason","age": 20,"gender": "male","parents": ["Dad Joseph", "Viva"]}' 
```

The response is:

```json
{
  "message":"BadRequest1",
  "request_id":"176e093c766974458e8de53b907ff25f"
}
```
