Note: If the value contains a `,` (comma), then the comma-separated format for lists cannot be used. The array notation must be used instead.

## Order of execution

The plugin performs the response transformation in the following order:

remove --> replace --> add --> append

## Arrays and nested objects

The plugin allows navigating complex JSON objects (arrays and nested objects)
when `config.dots_in_keys` is set to `false` (the default is `true`).

- `array[*]`: Loops through all elements of the array.
- `array[N]`: Navigates to the nth element of the array (the index of the first element is `1`).
- `top.sub`: Navigates to the `sub` property of the `top` object.

These can be combined. For example, `config.remove.json: customers[*].info.phone` removes
all `phone` properties from inside the `info` object of all entries in the `customers` array.

## Examples

In these examples, the plugin is enabled on a Route. This would work
similarly for Services.

- Add multiple headers by passing each `header:value` pair separately:

```bash
curl -X POST http://localhost:8001/routes/{route id}/plugins \
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
curl -X POST http://localhost:8001/routes/{route id}/plugins \
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
curl -X POST http://localhost:8001/routes/{route id}/plugins \
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
curl -X POST http://localhost:8001/routes/{route id}/plugins \
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
curl -X POST http://localhost:8001/routes/{route id}/plugins \
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
curl -X POST http://localhost:8001/routes/{route id}/plugins \
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
curl -X POST http://localhost:8001/routes/{route id}/plugins \
  -F "name=response-transformer-advanced" \
  -F "config.transform.functions=@transform.lua" \
  -F "config.transform.if_status=200"
```

- Remove the entire header field with a given header name:

```bash
curl -X POST http://localhost:8001/routes/{route id}/plugins \
  --data "name=response-transformer-advanced" \
  --data "config.remove.headers=h1,h2"
```

|upstream response headers | proxied response headers |
|---           | --- |
|h1:v1,v2,v3   | {} |
|h2:v2  | {} |

- Remove a specific header value of a given header field:

```bash
curl -X POST http://localhost:8001/routes/{route id}/plugins \
  --data "name=response-transformer-advanced" \
  --data "config.remove.headers=h1:v1,h1:v2"
```

|upstream response headers | proxied response headers |
|---           | --- |
|h1:v1,v2,v3   | h1:v3 |

- Remove a specific header value from a comma-separated list of header values:

```bash
curl -X POST http://localhost:8001/routes/{route id}/plugins \
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
curl -X POST http://localhost:8001/routes/{route id}/plugins \
  --data "name=response-transformer-advanced" \
  --data "config.remove.headers=h1:/JSESSIONID=.*/, h2://status/$/"
```

|upstream response headers | proxied response headers |
|---           | --- |
|h1:JSESSIONID=1876832,path=/   | h1:path=/ |
|h2:/match/status/,/status/no-match/   | h2:/status/no-match/ |

[api-object]: /gateway/latest/admin-api/#api-object
[consumer-object]: /gateway/latest/admin-api/#consumer-object
[configuration]: /gateway/latest/reference/configuration



- Explicitly set the type of the added JSON value `-1` to be a `number` (instead of the implicitly inferred type `string`) if the response code is 500:

```bash
curl -X POST http://localhost:8001/routes/{route id}/plugins \
  --data "name=response-transformer-advanced" \
  --data "config.add.json=p1:-1" \
  --data "config.add.json_types=number" \
  --data "config.add.if_status=500"
```
