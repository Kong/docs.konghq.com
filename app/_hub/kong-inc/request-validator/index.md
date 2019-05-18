---
name: Request Validator
publisher: Kong Inc.
version: 0.35-x

desc: Validates requests before they reach the upstream service
description: |
  Validate requests before they reach their upstream Service. Supports request
  body validation, according to a schema. **Note**: the schema format is **NOT**
  [JSON schema](https://json-schema.org/) compliant; instead, Kong's own schema
  format is used.

type: plugin
categories:
  - traffic-control

kong_version_compatibility:
    enterprise_edition:
      compatible:
        - 0.35-x

params:
  name: request-validator
  service_id: true
  route_id: true
  consumer_id: true
  config:
    - name: body_schema
      required: true
      value_in_examples: '[{"name":{"type": "string", "required": true}}]'
      description: Array of schema fields
---

## Examples

### Overview

By applying the plugin to an Service, all requests to that Service will be validated
before being proxied.

```
curl -i -X POST http://kong:8001/services/{service}/plugins \
  --data "name=request-validator" \
  --data 'config.body_schema=[{"name":{"type": "string", "required": true}}]'
```

| form parameter         | default   | description                                                       |
| ---                    | ---       | ---                                                               |
| `name`                 |           | The name of the plugin to use, in this case: `request-validator`  |
| `config.body_schema`   |           | The request body schema specification                             |

In this example, the request body data would have to be a valid JSON and
conform to the schema specified in `body_schema` - i.e., it would be required
to contain a `name` field only, which needs to be a string.

### Schema Definition

The `config.body_schema` field expects a JSON array with the definition of each
field expected to be in the request body; for example:

Each field definition contains the following attributes:

| Attribute | Required | Description |
| --- | --- | --- |
| `type` | yes | The expected type for the field |
| `required` | no | Whether or not the field is required |

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

Each field specification may also contain "validators", which perform specific
validations:

| Validator | Applies to | Description |
| --- | --- | --- |
| `between` | Integers | Whether the value is between two integer. Specified as an array; e.g., `{1, 10}` |
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
| `uuid`| Strings | True if the string is a valud UUID |

**Note**: check [this][lua-patterns] out to learn about Lua patterns.

### Schema Example

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
  }
}

```

In case either the JSON or schema validation fail, a `400 Bad Request` will
be returned as response.

### Further References

Check out the Kong docs on storing custom entities [here][schema-docs].

---

[schema-docs]: /1.0.x/plugin-development/custom-entities/#defining-a-schema
[lua-patterns]: https://www.lua.org/pil/20.2.html
[consumer-object]: /latest/admin-api/#consumer-object
[configuration]: /latest/configuration
[faq-authentication]: /about/faq/#how-can-i-add-an-authentication-layer-on-a-microservice/api?
