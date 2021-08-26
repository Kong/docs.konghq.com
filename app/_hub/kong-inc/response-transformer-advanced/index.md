---
name: Response Transformer Advanced
publisher: Kong Inc.
version: 2.3.x (0.4.4 internal)

desc: Modify the upstream response before returning it to the client
description: |
  Transform the response sent by the upstream server on the fly before returning
  the response to the client.

  The Response Transformer Advanced plugin is a superset of the
  open source [Response Transformer plugin](/hub/kong-inc/response-transformer/), and
  provides additional features:

  * When transforming a JSON payload, transformations are applied to nested JSON objects and
    arrays. This can be turned off and on using the `config.dots_in_keys` configuration parameter.
    See [Arrays and nested objects](#arrays-and-nested-objects).
  * Transformations can be restricted to responses with specific status codes using various
    `config.*.if_status` configuration parameters.
  * JSON body contents can be restricted to a set of allowed properties with
    `config.allow.json`.
  * The entire response body can be replaced using `config.replace.body`.
  * Arbitrary transformation functions written in Lua can be applied.
  * The plugin will decompress and recompress Gzip-compressed payloads
    when the `Content-Encoding` header is `gzip`.

  <div class="alert alert-warning">
    <strong>Note on transforming bodies:</strong> Be aware of the performance of transformations on the
    response body. In order to parse and modify a JSON body, the plugin needs to retain it in memory,
    which might cause pressure on the worker's Lua VM when dealing with large bodies (several MBs).
    Because of Nginx's internals, the <code>Content-Length</code> header will not be set when transforming a response body.
  </div>

type: plugin
categories:
  - transformations

enterprise: true
kong_version_compatibility:
    enterprise_edition:
      compatible:
        - 2.4.x
        - 2.3.x
        - 2.2.x
        - 2.1.x
        - 1.5.x
        - 1.3-x
        - 0.36-x

params:
  name: response-transformer-advanced
  service_id: true
  route_id: true
  consumer_id: true
  konnect_examples: false
  config:
    - name: remove.headers
      required: false
      value_in_examples: ["x-toremove", "x-another-one:application/json", "x-list-of-values:v1,v2,v3", "Set-Cookie:/JSESSIONID=.*/", "x-another-regex://status/$/", "x-one-more-regex:/^/begin//"]
      datatype: array of string elements
      description: List of `headername[:value]`. If only `headername` is given, unset the header field with the given `headername`. If `headername:value` is given, unset the header field `headername` when it has a specific `value`. If `value` starts and ends with a `/` (slash character), then it is considered to be a regular expression. Note that in accordance with [RFC 7230](https://httpwg.org/specs/rfc7230.html#field.order) multiple header values with the same header name are allowed if the entire field value for that header field is defined as a comma-separated list or the header field is a `Set-Cookie` header field.
    - name: remove.json
      required: false
      datatype: array of string elements
      value_in_examples: ["json-key-toremove", "another-json-key"]
      description: List of property names. Remove the property from the JSON body if it is present.
    - name: remove.if_status
      required: false
      datatype: array of string elements
      description: List of response status codes or status code ranges to which the transformation will apply. Empty means all response codes.
    - name: rename.headers
      required: false
      datatype: array of string elements
      description: List of `headername1:headername2` pairs. If a header with `headername1` exists and `headername2` is valid, rename header to `headername2`.
    - name: replace.headers
      required: false
      datatype: array of string elements
      description: List of `headername:value` pairs. If and only if the header is already set, replace its old value with the new one. Ignored if the header is not already set.
    - name: replace.json
      required: false
      datatype: array of string elements
      description: List of property `name:value` pairs. If and only if the parameter is already present, replace its old value with the new one. Ignored if the parameter is not already present.
    - name: replace.json_types
      required: false
      datatype: array of string, boolean, or number elements
      description: List of JSON type names. Specify the types of the JSON values returned when replacing JSON properties.
    - name: replace.body
      required: false
      datatype: string
      description: String with which to replace the entire response body.
    - name: replace.if_status
      required: false
      datatype: array of string elements
      description: List of response status codes or status code ranges to which the transformation will apply. Empty means all response codes.
    - name: add.headers
      required: false
      value_in_examples: ["x-new-header:value","x-another-header:something"]
      datatype: array of string elements
      description: List of `headername:value` pairs. If and only if the header is not already set, set a new header with the given value. Ignored if the header is already set.
    - name: add.json
      required: false
      value_in_examples: ["new-json-key:some_value", "another-json-key:some_value"]
      datatype: array of string elements
      description: List of `name:value` pairs. If and only if the property is not present, add a new property with the given value to the JSON body. Ignored if the property is already present.
    - name: add.json_types
      required: false
      value_in_examples: ["new-json-key:string", "another-json-key:boolean", "another-json-key:number"]
      datatype: array of string, boolean, or number elements
      description: List of JSON type names. Specify the types of the JSON values returned when adding a new JSON property.
    - name: add.if_status
      required: false
      datatype: array of string elements
      description: List of response status codes or status code ranges to which the transformation will apply. Empty means all response codes.
    - name: append.headers
      required: false
      value_in_examples: ["x-existing-header:some_value", "x-another-header:some_value"]
      datatype: array of string elements
      description: List of `headername:value` pairs. If the header is not set, set it with the given value. If it is already set, a new header with the same name and the new value will be set.
    - name: append.json
      required: false
      datatype: array of string elements
      description: List of `name:value` pairs. If the property is not present in the JSON body, add it with the given value. If it is already present, the two values (old and new) will be aggregated in an array.
    - name: append.json_types
      required: false
      datatype: array of string, boolean, or number elements
      description: List of JSON type names. Specify the types of the JSON values returned when appending JSON properties.
    - name: append.if_status
      required: false
      datatype:
      description: List of response status codes or status code ranges to which the transformation will apply. Empty means all response codes.
    - name: allow.json
      required: false
      default:
      value_in_examples:
      datatype: array of string elements
      description: |
        Set of parameter names. Only allowed parameters are present in the JSON response body.
    - name: transform.functions
      required: false
      datatype: array of function elements
      description: Set of Lua functions to perform arbitrary transforms in a response JSON body.
    - name: transform.if_status
      required: false
      datatype: array of string elements
      description: List of response status codes or ranges to which the arbitrary transformation applies. Leaving empty implies that the transformations apply to all response codes.
    - name: transform.json
      required: false
      datatype: array of string elements
      description: Apply Lua functions to a particular list of JSON property `name` or `name:value` pairs.
    - name: dots_in_keys
      required: false
      datatype: boolean
      default: true
      description: Whether dots (for example, `customers.info.phone`) should be treated as part of a property name or used to descend into nested JSON objects. See [Arrays and nested objects](#arrays-and-nested-objects).
---

Note: If the value contains a `,` (comma), then the comma-separated format for lists cannot be used. The array notation must be used instead.

## Order of execution

The plugin performs the response transformation in the following order:

remove --> replace --> add --> append

## Arrays and nested objects

The plugin allows navigating complex JSON objects (arrays and nested objects)
when `config.dots_in_keys` is set to `false` (the default is `true`).

- `array[*]`: Loops through all elements of the array.
- `array[N]`: Navigates to the `N`th element of the array (the index of the first element is `1`).
- `top.sub`: Navigates to the `sub` property of the `top` object.

These can be combined. For example, `config.remove.json: customers[*].info.phone` removes
all `phone` properties from inside the `info` object of all entries in the `customers` array.

## Examples

In these examples, the plugin is enabled on a Route. This would work
similarly for Services.

- Add multiple headers by passing each `header:value` pair separately:

```bash
$ curl -X POST http://localhost:8001/routes/{route id}/plugins \
  --data "name=response-transformer-advanced" \
  --data "config.add.headers[1]=h1:v1" \
  --data "config.add.headers[2]=h2:v1"
```

<table>
  <tr>
    <th>upstream response headers</th>
    <th>proxied response headers</th>
  </tr>
  <tr>
    <td>h1: v1</td>
    <td>
     <ul><li>h1: v1</li><li>h2: v1</li></ul>
    </td>
  </tr>
</table>

- Add multiple headers by passing comma-separated `header:value` pair:

```bash
$ curl -X POST http://localhost:8001/routes/{route id}/plugins \
  --data "name=response-transformer-advanced" \
  --data "config.add.headers=h1:v1,h2:v2"
```

<table>
  <tr>
    <th>upstream response headers</th>
    <th>proxied response headers</th>
  </tr>
  <tr>
    <td>h1: v1</td>
    <td>
      <ul><li>h1: v1</li><li>h2: v1</li></ul>
    </td>
  </tr>
</table>


- Add multiple headers passing config as a JSON body:

```bash
$ curl -X POST http://localhost:8001/routes/{route id}/plugins \
  --header 'content-type: application/json' \
  --data '{"name": "response-transformer-advanced", "config": {"add": {"headers": ["h1:v2", "h2:v1"]}}}'
```

<table>
  <tr>
    <th>upstream response headers</th>
    <th>proxied response headers</th>
  </tr>
  <tr>
    <td>h1: v1</td>
    <td>
      <ul><li>h1: v1</li><li>h2: v1</li></ul>
    </td>
  </tr>
</table>

- Add a body property and a header:

```bash
$ curl -X POST http://localhost:8001/routes/{route id}/plugins \
  --data "name=response-transformer-advanced" \
  --data "config.add.json=p1:v1,p2=v2" \
  --data "config.add.headers=h1:v1"
```

<table>
  <tr>
    <th>upstream response headers</th>
    <th>proxied response headers</th>
  </tr>
  <tr>
    <td>h1: v2</td>
    <td>
      <ul><li>h1: v2</li><li>h2: v1</li></ul>
    </td>
  </tr>
  <tr>
    <td>h3: v1</td>
    <td>
      <ul><li>h1: v1</li><li>h2: v1</li><li>h3: v1</li></ul>
    </td>
  </tr>
</table>


| upstream response JSON body | proxied response body |
| ---           | --- |
| {}            | {"p1" : "v1", "p2": "v2"} |
| {"p1" : "v2"}  | {"p1" : "v2", "p2": "v2"} |

- Append multiple headers and remove a body property:

```bash
$ curl -X POST http://localhost:8001/routes/{route id}/plugins \
  --header 'content-type: application/json' \
  --data '{"name": "response-transformer-advanced", "config": {"append": {"headers": ["h1:v2", "h2:v1"]}, "remove": {"json": ["p1"]}}}'
```

<table>
  <tr>
    <th>upstream response headers</th>
    <th>proxied response headers</th>
  </tr>
  <tr>
    <td>h1: v1</td>
    <td>
      <ul><li>h1: v1</li><li>h1: v2</li><li>h2: v1</li></ul>
    </td>
  </tr>
</table>

|upstream response JSON body | proxied response body |
|---           | --- |
|{"p2": "v2"}   | {"p2": "v2"} |
|{"p1" : "v1", "p2" : "v1"}  | {"p2": "v2"} |

- Replace entire response body if response code is 500:

```bash
$ curl -X POST http://localhost:8001/routes/{route id}/plugins \
  --data "name=response-transformer-advanced" \
  --data "config.replace.body='{\"error\": \"internal server error\"}'" \
  --data "config.replace.if_status=500"
```
**Note**: The plugin doesn't validate the value in `config.replace.body` against
the content type as defined in the `Content-Type` response header.

- Remove nested JSON content:

```bash
curl -X POST http://localhost:8001/routes/{route id}/plugins \
  --data "name=response-transformer-advanced" \
  --data "config.remove.json=customers.info.phone" \
  --data "config.dots_in_keys=false"
```

When `dots_in_keys` is `false`, the `customers.info.phone` value is interpreted as
nested JSON objects. When `dots_in_keys` is `true` (default), `customers.info.phone` is
treated as a single property.

- Perform arbitrary transforms to a JSON body

Use the power of embedding Lua to perform arbitrary transformations on JSON bodies. Transformation functions
receive an argument with the JSON body, and must return the transformed response body:

```lua
-- transform.lua
-- this function transforms
-- { "foo": "something", "something": "else" }
-- into
-- { "foobar": "hello world", "something": "else" }
return function (data)
  if type(data) ~= "table" then
    return data
  end

  -- remove foo key
  data["foo"] = nil

  -- add a new key
  data["foobar"] = "hello world"

  return data
end
```

```bash
$ curl -X POST http://localhost:8001/routes/{route id}/plugins \
  -F "name=response-transformer-advanced" \
  -F "config.transform.functions=@transform.lua" \
  -F "config.transform.if_status=200"
```

- Remove the entire header field with a given header name:

```bash
$ curl -X POST http://localhost:8001/routes/{route id}/plugins \
  --data "name=response-transformer-advanced" \
  --data "config.remove.headers=h1,h2"
```

|upstream response headers | proxied response headers |
|---           | --- |
|h1:v1,v2,v3   | {} |
|h2:v2  | {} |

- Remove a specific header value of a given header field:

```bash
$ curl -X POST http://localhost:8001/routes/{route id}/plugins \
  --data "name=response-transformer-advanced" \
  --data "config.remove.headers=h1:v1,h1:v2"
```

|upstream response headers | proxied response headers |
|---           | --- |
|h1:v1,v2,v3   | h1:v3 |

- Remove a specific header value from a comma-separated list of header values:

```bash
$ curl -X POST http://localhost:8001/routes/{route id}/plugins \
  --data "name=response-transformer-advanced" \
  --data "config.remove.headers=h1:v1,h1:v2"
```

|upstream response headers | proxied response headers |
|---           | --- |
|h1:v1,v2,v3   | h1:v3 |

**Note**: The plugin doesn't remove header values if the values are not separated by commas, unless it's a `Set-Cookie` header field
(as specified in [RFC 7230](https://httpwg.org/specs/rfc7230.html#field.order)).

- Remove a specific header value defined by a regular expression

```bash
$ curl -X POST http://localhost:8001/routes/{route id}/plugins \
  --data "name=response-transformer-advanced" \
  --data "config.remove.headers=h1:/JSESSIONID=.*/, h2://status/$/"
```

|upstream response headers | proxied response headers |
|---           | --- |
|h1:JSESSIONID=1876832,path=/   | h1:path=/ |
|h2:/match/status/,/status/no-match/   | h2:/status/no-match/ |

[api-object]: /gateway-oss/latest/admin-api/#api-object
[consumer-object]: /gateway-oss/latest/admin-api/#consumer-object
[configuration]: /gateway-oss/latest/configuration



- Explicitly set the type of the added JSON value `-1` to be a `number` (instead of the implicitly inferred type `string`) if the response code is 500:

```bash
$ curl -X POST http://localhost:8001/routes/{route id}/plugins \
  --data "name=response-transformer-advanced" \
  --data "config.add.json=p1:-1" \
  --data "config.add.json_types=number" \
  --data "config.add.if_status=500"
```
