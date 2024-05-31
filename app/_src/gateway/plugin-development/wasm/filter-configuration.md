---
title: Proxy-Wasm Filter Configuration
book: plugin_dev
chapter: 13
---

## Proxy-Wasm Filter Configuration

{:.note}
> As of this writing, only [Draft 4](https://json-schema.org/specification-links#draft-4)
of the JSON schema specification is supported.

### Purpose

The [Proxy-Wasm specification](https://github.com/proxy-wasm/spec) defines
filter runtime configuration only as an array of bytes. The finer details of
configuration-handling (encoding, serialization, validation) are left to the
filter to implement.

As a result, Proxy-Wasm implementations have no means of validating
configuration until runtime, when a filter instance is created. In
{{site.base_gateway}}, executing a filter with an invalid configuration will
trigger a 500 error, as Kong has no choice but to assume that it is not safe to
continue processing the request.

This presents a challenge for filter deployment: how do operators prevent users
from creating improperly-configured filters?

### JSON Schema for Filter Configuration

Filters that take configuration in JSON form can optionally make use of 
{{site.base_gateway}}'s [JSON schema](https://json-schema.org/) validation.

This is accomplished by providing a JSON schema in a filter metadata file
adjacent to the filter's bytecode within the `wasm_filters_path` directory:

```
/path/to/wasm-filters
├── my-filter.wasm
├── my-filter.meta.json
├── other-filter.wasm
└── other-filter.meta.json
```

The configuration schema is supplied in the `config_schema` metadata field. For example:

```json
{
  "config_schema": {
    "type": "object",
    "properties": {
      "my-property": {
        "type": "string"
      }
    },
    "required": [
      "my-property"
    ]
  }
}
```

The presence of a schema allows Kong to interpret the filter configuration as
JSON instead of treating it as an opaque string when reading and writing request
and response bodies.

Without a schema, JSON filter configuration must be serialized as a string in
API requests:

```
POST /services/test/filter-chains HTTP/1.1
Host: kong
User-Agent: curl/8.0.1
Content-Type: application/json
Accept: application/json
Content-Length: 143

{
  "name": "my-filter-chain",
  "filters": [
    {
      "name": "my-filter",
      "config": "{ \"my-property\": \"My value\" }"
    }
  ]
}
```

But with a schema, the configuration is accepted as JSON:

```
POST /services/test/filter-chains HTTP/1.1
Host: kong
User-Agent: curl/8.0.1
Content-Type: application/json
Accept: application/json
Content-Length: 151

{
  "name": "my-filter-chain",
  "filters": [
    {
      "name": "my-filter",
      "config": {
        "my-property": "My value"
      }
    }
  ]
}
```

### Example

In this example, `set-response-header` is a filter that sets a single response
header. It takes a JSON configuration with a header name and value.

Here are the contents of `$KONG_WASM_FILTERS_PATH/set-response-header.meta.json`:

```json
{
  "config_schema": {
    "type": "object",
    "properties": {
      "header-name": {
        "type": "string"
      },
      "header-value": {
        "type": "string"
      }
    },
    "required": [
      "header-name",
      "header-value"
    ]
  }
}
```

With the schema in place, configurations that do not pass validation are
rejected:

```
POST /services/test/filter-chains HTTP/1.1
Host: kong
User-Agent: curl/8.0.1
Content-Type: application/json
Accept: application/json
Content-Length: 171

{
  "name": "my-filter-chain",
  "filters": [
    {
      "name": "set-response-header",
      "config": {
        "header-name": "X-My-Custom-Header"
      }
    }
  ]
}
```

Response:

```
HTTP/1.1 400 Bad Request
Access-Control-Allow-Credentials: true
Access-Control-Allow-Origin: *
Connection: keep-alive
Content-Length: 203
Content-Type: application/json; charset=utf-8
Date: Mon, 06 Nov 2023 00:11:33 GMT
Server: kong/3.6.0
X-Kong-Admin-Latency: 6

{
    "code": 2,
    "fields": {
        "filters": [
            {
                "config": "property header-value is required"
            }
        ]
    },
    "message": "schema violation (filters.1: {\n  config = \"property header-value is required\"\n})",
    "name": "schema violation"
}
```

Whereas valid configurations are accepted:

```
POST /services/test/filter-chains HTTP/1.1
Host: kong
User-Agent: curl/8.0.1
Content-Type: application/json
Accept: application/json
Content-Length: 211

{
  "name": "my-filter-chain",
  "filters": [
    {
      "name": "set-response-header",
      "config": {
        "header-name": "X-My-Custom-Header",
        "header-value": "Hello, Wasm!"
      }
    }
  ]
}
```

Response:

```
HTTP/1.1 201 Created
Access-Control-Allow-Credentials: true
Access-Control-Allow-Origin: *
Connection: keep-alive
Content-Length: 348
Content-Type: application/json; charset=utf-8
Date: Mon, 06 Nov 2023 00:21:30 GMT
Server: kong/3.6.0
X-Kong-Admin-Latency: 23

{
    "created_at": 1699230090,
    "enabled": true,
    "filters": [
        {
            "config": {
                "header-name": "X-My-Custom-Header",
                "header-value": "Hello, Wasm!"
            },
            "enabled": true,
            "name": "set-response-header"
        }
    ],
    "id": "da8659e3-db85-435f-ba62-f95ec7615ddc",
    "name": "my-filter-chain",
    "route": null,
    "service": {
        "id": "992c4491-9962-48ff-8d5d-249ba82848d1"
    },
    "tags": null,
    "updated_at": 1699230090
}
```

## Further Reading

* [JSON schema](https://json-schema.org/)
* [Create a Proxy-Wasm filter](/gateway/latest/plugin-development/wasm/filter-development-guide)
* [WebAssembly for Proxies (Proxy-Wasm) specification](https://github.com/proxy-wasm/spec)
