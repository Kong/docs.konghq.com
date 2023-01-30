---
name: Request Validator
publisher: Kong Inc.
desc: Validates requests before they reach the Upstream service
description: |
  Validate requests before they reach their Upstream service. Supports validating
  the schema of the body and the parameters of the request using either Kong's own
  schema validator (body only) or a JSON Schema Draft 4-compliant validator.
enterprise: true
plus: true
type: plugin
categories:
  - traffic-control
kong_version_compatibility:
  enterprise_edition:
    compatible: true
---

## Examples

### Overview

By applying the plugin to a Service, all requests to that Service will be validated
before being proxied.

{% navtabs %}
{% navtab With a database %}

Use a request like this:

``` bash
curl -i -X POST http://kong:8001/services/{service}/plugins \
  --data "name=request-validator" \
  --data "config.version=kong" \
  --data 'config.body_schema=[{\"name\":{\"type\": \"string\", \"required\": true}}]'
```
{% endnavtab %}

{% navtab Without a database %}

Add the following entry to the `plugins:` section in the declarative configuration file:

``` yaml
plugins:
- name: request-validator
  service: {service}
  config:
    version: kong
    body_schema:
      name:
        type: string
        required: true
```
{% endnavtab %}
{% endnavtabs %}

In this example, the request body data would have to be valid JSON and
conform to the schema specified in `body_schema` - i.e., it would be required
to contain a `name` field only, which needs to be a string.

In case the validation fails, a `400 Bad Request` will be returned as the response.

### Schema Definition

*For using the JSON Schema Draft 4-compliant validator, see the [JSON Schema website](
https://json-schema.org/) for details on the format and examples. The rest of
this paragraph will explain the Kong schema.*

The `config.body_schema` field expects a JSON array with the definition of each
field expected to be in the request body; for example:

Each field definition contains the following attributes:

| Attribute | Required | Description |
| --- | --- | --- |
| `type` | yes | The expected type for the field |
| `required` | no | Whether the field is required |

Additionally, specific types may have their own required fields:

Map:

| Attribute | Required | Description |
| --- | --- | --- |
| `keys` | yes | The schema for the map keys |
| `values` | yes | The schema for the map values |

Example string-boolean map:

```
{
  "type": "map",
  "keys": {
    "type": "string"
  },
  "values": {
    "type": "boolean"
  }
}
```

Array:

| Attribute | Required | Description |
| --- | --- | --- |
| `elements` | yes | The array's elements schema |

Example integer array schema:

```
{
  "type": "array",
  "elements": {
    "type": "integer"
  }
}
```

Record:

| Attribute | Required | Description |
| --- | --- | --- |
| `fields` | yes | The record schema |

Example record schema:

```
{
  "type": "record",
  "fields": [
    {
      "street": {
        "type": "string",
      }
    },
    {
      "zipcode": {
        "type": "string",
      }
    }
  ]
}
```


The `type` field assumes one the following values:

- `string`
- `number`
- `integer`
- `boolean`
- `map`
- `array`
- `record`

Each field specification may also contain validators, which perform specific
validations:

| Validator | Applies to | Description |
| --- | --- | --- |
| `between` | Integers | Whether the value is between two integers. Specified as an array; for example, `{1, 10}` |
| `len_eq` | Arrays, Maps, Strings | Whether an array's length is a given value |
| `len_min` | Arrays, Maps, Strings | Whether an array's length is at least a given value |
| `len_max` | Arrays, Maps, strings | Whether an array's length is at most a given value |
| `match` | Strings | True if the value matches a given Lua pattern ** |
| `not_match` | String | True if the value doesn't match a given Lua pattern ** |
| `match_all` | Arrays | True if all strings in the array match the specified Lua pattern ** |
| `match_none` | Arrays | True if none of the strings in the array match the specified Lua pattern ** |
| `match_any` | Arrays | True if any one of the strings in the array matches the specified Lua pattern ** |
| `starts_with` | Strings | True if the string value starts with the specified substring |
| `one_of` | Strings, Numbers, Integers | True if the string field value matches one of the specified values |
| `timestamp` | Integers | True if the field value is a valid timestamp |
| `uuid`| Strings | True if the string is a valid UUID |

**Note**: To learn more, see [Lua patterns][lua-patterns].

#### Semantic validation for `format` attribute

Structural validation alone may be insufficient to validate that an instance
meets all the requirements of an application. The `format` keyword is defined
to allow interoperable semantic validation for a fixed subset of values that
are accurately described by authoritative resources, be they RFCs or other
external specifications. The following attributes are available:

| Attribute | Description |
| --- | --- |
| `date` | defined by [RFC 3339], sections [5.6] and further validated by [5.7] |
| `date-time` | defined by [RFC 3339], sections [5.6] |
| `time` | defined by [RFC 3339], sections [5.6] and further validated by [5.7] |

**Note**: The value of the `format` attribute must be a string.

Example `date` schema:

```
{
  "type": "string",
  "format": "date"
}
```

### Kong Schema Example

```
[
  {
    "name": {
      "type": "string",
      "required": true
    }
  },
  {
    "age": {
      "type": "integer",
      "required": true
    }
  },
  {
    "address": {
      "type": "record",
      "required": true,
      "fields": [
        {
          "street": {
            "type": "string",
            "required": true
          }
        },
        {
          "zipcode": {
            "type": "string",
            "required": true
          }
        }
      ]
    }
  },
  {
    "born": {
      "type": "string",
      "format": "date-time",
      "required": true
    }
  }
]
```

Such a schema would validate the following request body:

```
{
  "name": "Gruce The Great",
  "age": 4,
  "address": {
    "street": "251 Post St.",
    "zipcode": "94108"
  },
  "born": "2009-07-20T08:30:37.012Z"
}

```

### Parameter Schema Definition

You can setup definitions for each parameter based on the OpenAPI Specification and
the plugin will validate each parameter against it. For more information, see the
[OpenAPI specification](https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.2.md#parameter-object)
or the [OpenAPI examples](https://swagger.io/docs/specification/serialization/).

#### Fixed Fields

|Field Name | Type | Description|
| --- | --- | --- |
|name | `string` | **REQUIRED**. The name of the parameter. Parameter names are *case sensitive*, and corresponds to the parameter name used by the `in` property. If `in` is `"path"`, the `name` field MUST correspond to the [named capture group](https://docs.konghq.com/latest/proxy/#capturing-groups) from the configured `route`.|
|in | `string` | **REQUIRED**. The location of the parameter. Possible values are `query`, `header`, or `path`.|
|required | `boolean` | **REQUIRED** Determines whether this parameter is mandatory.|
|style | `string` | **REQUIRED** when schema and explode are set<br> Describes how the parameter value will be serialized depending on the type of the parameter value.|
|schema | `string` | **REQUIRED** when style and explode are set<br> The schema defining the type used for the parameter. It is validated using `draft4` for JSONschema draft 4 compliant validator.|
|explode | `boolean` | **REQUIRED** when schema and style are set<br> When this is true, parameter values of type `array` or `object` generate separate parameters for each value of the array or key-value pair of the map.  For other types of parameters this property has no effect.|

#### Examples

In this example, use the plugin to validate a request's path parameter.

1.  Add a Service to Kong:

    ```
    curl -i -X POST http://kong:8001/services \
      --data name=httpbin \
      --data url=http://httpbin.org

    HTTP/1.1 201 Created
    ..

    {
      "host":"httpbin.org",
      "created_at":1563479714,
      "connect_timeout":60000,
      "id":"0a7f3795-bc92-43b5-aada-258113b7c4ed",
      "protocol":"http",
      "name":"httpbin",
      "read_timeout":60000,
      "port":80,
      "path":null,
      "updated_at":1563479714,
      "retries":5,
      "write_timeout":60000
    }
    ```

2.  Add a Route with [named capture group](https://docs.konghq.com/latest/proxy/#capturing-groups):

    ```
    curl -i -X POST http://kong:8001/services/httpbin/routes \
      --data paths="~/status/(?<status_code>\d%+)" \
      --data strip_path=false

    HTTP/1.1 201 Created
    ..

    {
      "created_at": 1563481399,
      "methods": null,
      "id": "cd78749a-33a3-4bbd-9560-588eaf4116d3",
      "service": {
        "id": "0a7f3795-bc92-43b5-aada-258113b7c4ed"
      },
      "name": null,
      "hosts": null,
      "updated_at": 1563481399,
      "preserve_host": false,
      "regex_priority": 0,
      "paths": [
        "\\/status\\/(?<status_code>\\d+)"
      ],
      "sources": null,
      "destinations": null,
      "snis": null,
      "protocols": [
        "http",
        "https"
      ],
      "strip_path": false
    }
    ```

3. Enable `request-validator` plugin to validate body and parameter:

    ```
    curl -i -X POST http://kong:8001/services/httpbin/plugins \
      --header "Content-Type: application/json" \
      --data @parameter_schema.json

    HTTP/1.1 201 Created
    ..

    {
      "created_at": 1563483059,
      "config": {
        "body_schema": "{\"properties\":{\"name\":{\"type\":\"string\"}},\"required\":[\"name\"]}",
        "parameter_schema": [
          {
            "style": "simple",
            "required": true,
            "in": "path",
            "schema": "{\"type\": \"number\"}",
            "explode": false,
            "name": "status_code"
          }
        ],
        "version": "draft4"
      },
      "id": "ad91a2d4-6217-4d34-9133-4a2508ddda9f",
      "service": {
        "id": "0a7f3795-bc92-43b5-aada-258113b7c4ed"
      },
      "enabled": true,
      "run_on": "first",
      "consumer": null,
      "route": null,
      "name": "request-validator"
    }
    ```

    Content of file `parameter_schema.json`:

    ```json
    {
      "name": "request-validator",
      "config": {
        "body_schema": "{\"properties\":{\"name\":{\"type\":\"string\"}},\"required\":[\"name\"]}",
        "version": "draft4",
        "parameter_schema": [
          {
            "name": "status_code",
            "in": "path",
            "required": true,
            "schema": "{\"type\": \"number\"}",
            "style": "simple",
            "explode": false
          }
        ]
      }
    }
    ```

4. In these step examples, validation ensures that `status_code` is a number and the body contains a parameter called `name`.

   A proxy request with a non-numerical status code is blocked:

    ```
    curl -i -X POST \
    --url http://localhost:8000/status/abc \
    --header 'Content-Type: application/json' \
    --data '{ "name": "foo" }'
    HTTP/1.1 400 Bad Request
    ...

    {"message":"request param doesn't conform to schema"}
    ```

    A proxy request with a numeric status code is allowed:

    ```
    curl -i -X POST \
    --url http://localhost:8000/status/123 \
    --header 'Content-Type: application/json' \
    --data '{ "name": "foo" }'
    HTTP/1.1 200 OK
    X-Kong-Upstream-Latency: 163
    X-Kong-Proxy-Latency: 37
    ...

    ```

### Further References

The Kong schema validation format is based on the plugin schemas.
For more information, see the Kong plugin docs on
[storing custom entities](/gateway/latest/plugin-development/custom-entities/#defining-a-schema).

---

[schema-docs]: /1.0.x/plugin-development/custom-entities/#defining-a-schema
[lua-patterns]: https://www.lua.org/pil/20.2.html
[RFC 3339]: https://tools.ietf.org/html/rfc3339
[5.6]: https://tools.ietf.org/html/rfc3339#section-5.6
[5.7]: https://tools.ietf.org/html/rfc3339#section-5.7
