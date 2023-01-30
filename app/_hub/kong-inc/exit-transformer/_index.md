---
name: Exit Transformer
publisher: Kong Inc.
desc: Customize Kong exit responses sent downstream
description: |
  Transform and customize Kong response exit messages using Lua functions.
  The capabilities range from changing messages, status codes, and headers,
  to completely transforming the structure of Kong responses.
type: plugin
enterprise: true
plus: true
categories:
  - transformations
kong_version_compatibility:
  enterprise_edition:
    compatible: true
---

## Transforming 4xx and 5xx Responses

By default, the Exit Transformer is only applied to requests that match its
criteria (its Route or Service matching configuration) or globally within a Workspace.

### Handling Unmatched 400 and 404 Responses

Requests that result in 400 or 404 responses neither match any criteria nor fall
within any specific Workspace, and standard plugin criteria will never match those
responses. You can designate Exit Transformer configurations that _do_ handle these
responses by enabling the `handle_unexpected` (400) and `handle_unknown` (404) settings:

- The `handle_unknown` parameter should only be enabled on a single plugin configuration.
- The `handle_unexpected` parameter can be enabled on as many plugin configurations
as you want.

It's not a prerequisite for `handle_unexpected` to also have `handle_unknown` set,
if an unexpected error happened within some known Service or Route context. If a
configuration has both `handle_unknown` and `handle_unexpected` enabled, then an
unexpected error on an _unknown_ Service or Route will pass through the Exit Transformer plugin.

### HTTP Response Status Codes {#http-msgs}

**4xx** codes are client error responses:

- [400 Bad request](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/400)
- [401 Unauthorized](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/401)
- [402 Payment required](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/402)
- [403 Forbidden](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/403)
- [404 Not found](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/404)
- [405 Method not allowed](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/405)
- [406 Not acceptable](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/406)
- [407 Proxy authentication required](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/407)
- [409 Conflict](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/409)
- [410 Gone](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/410)
- [411 Length required](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/411)
- [412 Precondition failed](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/412)
- [413 Payload too large](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/413)
- [414 URI too long](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/414)
- [415 Unsupported media type](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/415)
- [416 Range not satisfiable](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/416)
- [417 Expectation failed](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/417)
- [418 I'm a teapot](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/418)
- [421 Misdirected request](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/421)
- [422 Unprocessable entity](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/422)
- [423 Locked](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/423)
- [424 Failed dependency](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/424)
- [425 Too early](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/425)
- [426 Upgrade required](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/426)
- [428 Precondition required](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/428)
- [429 Too many requests](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/429)
- [431 Request header fields too large](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/431)
- [451 Unavailable for legal reasons](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/451)
- [494 Request header or cookie too large](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/494)

**5xx** codes are server error responses:

- [500 An unexpected error occurred](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/500)
- [501 Not implemented](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/501)
- [502 An invalid response was received from the upstream server](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/502)
- [503 The upstream server is currently unavailable](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/503)
- [504 The upstream server is timing out](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/504)
- [505 HTTP version not supported](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/505)
- [506 Variant also negotiates](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/506)
- [507 Insufficient storage](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/507)
- [508 Loop detected](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/508)
- [510 Not extended](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/510)
- [511 Network authentication required](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/511)

## Function Syntax

The Exit Transformer plugin expects a configuration function to be Lua code that returns
a function accepting three arguments: status, body, and headers.

Any Kong exit call exposed on the proxy side gets reduced through these
functions.

```
Kong -> f(status, body, headers) -> ... -> exit(status, body, headers)
```

<div class="alert alert-warning">
  <strong>Warning</strong>
  <code>kong.response.exit()</code> requires a <code>status</code> argument only.
  <code>body</code> and <code>headers</code> may be <code>nil</code>.
  If you manipulate the body and headers, first check that they exist and
  instantiate them if they do not exist.
</div>

If you manipulate body and headers, see the
[Modify the body and headers regardless if provided](#mod-body-head) example below.

### Example Lua Functions

#### Identity function that does not transform the exit responses

```lua
return function(status, body, headers)
  return status, body, headers
end
```

#### Function that always returns a 200 status code with status bundled within the message

```lua
return function(status, body, headers)
  -- identity
  if not body or not body.message then
    return status, body, headers
  end

  body.status = status

  return 200, body, headers
end
```

#### Customize particular Kong messages

```lua
local responses = {
  ["No API key found in request"] = {
    message = "Please provide an API key",
    status = 418,
    headers = { ["x-some-header"] = "some value" },
  },
  ["Invalid authentication credentials"] = {
    message = "Invalid API key",
  },
  -- ...
}

return function(status, body, headers)
  if not body or not body.message then
    return status, body, headers
  end

  local response = responses[body.message]

  body.message = response.message or body.message
  status = response.status or status
  headers = response.headers or headers

  return status, body, headers
end
```

#### Modify the body and headers regardless if provided {#mod-body-head}

```lua
return function(status, body, headers)
  if not body then
    body = { message = "This replaces a formerly empty body" }
  else
    body.message = "This replaces a formerly non-empty body"
  end

  if not headers then
    headers = { ["X-Message"] = "This adds X-Message to an empty set of headers" }
  else
    headers["X-Message"] = "This adds X-Message to an existing set of headers"
  end

  return status, body, headers
end
```

## Demonstration

### Step 1: Create a Service in Kong

   {% navtabs %}
   {% navtab Using cURL %}

   ```bash
   curl -i -X POST http://<admin-hostname>:8001/services \
     --data name=example.com \
     --data url='http://mockbin.org'
   ```

   {% endnavtab %}
   {% navtab Using HTTPie %}

   ```bash
   http :8001/services name=example.com host=mockbin.org
   ```

   {% endnavtab %}
   {% endnavtabs %}

### Step 2: Create a Route in Kong

   {% navtabs %}
   {% navtab Using cURL %}

```bash
curl -i -X POST http://<admin-hostname>:8001/services/example.com/routes \
  --data 'hosts[]=example.com'
```

   {% endnavtab %}
   {% navtab Using HTTPie %}

```bash
http -f :8001/services/example.com/routes hosts=example.com
```

   {% endnavtab %}
   {% endnavtabs %}

### Step 3: Create a Transform

Create a file named `transform.lua` with the transformation code. The
following example adds a header, appends "arr!" to any message, and adds
`error` and `status` fields on the response body.

```lua
    -- transform.lua
    return function(status, body, headers)
      if not body or not body.message then
        return status, body, headers
      end

      headers = { ["x-some-header"] = "some value" }
      local new_body = {
        error = true,
        status = status,
        message = body.message .. ", arr!",
      }

      return status, new_body, headers
    end
```

### Step 4: Configure the Plugin with its Transform

Configure the `exit-transformer` plugin with `transform.lua`.

   {% navtabs %}
   {% navtab Using cURL %}

   ```bash
   curl -X POST http://<admin-hostname>:8001/services/example.com/plugins \
     -F "name=exit-transformer"  \
     -F "config.functions=@transform.lua"
   ```
   {% endnavtab %}
   {% navtab Using HTTPie %}

   ```bash
   http -f :8001/services/example.com/plugins \
     name=exit-transformer \
     config.functions=@transform.lua
   ```

   {% endnavtab %}
   {% endnavtabs %}

### Step 5: Configure the Key-Auth Plugin to Test the Exit Transform

Add the `key-auth` plugin to test a forced generation of an exit transform
response in [step 6](#testy-exit):

   {% navtabs %}
   {% navtab Using cURL %}

   ```bash
   curl -X POST http://<admin-hostname>:8001/services/example.com/plugins \
     --data "name=key-auth"
   ```

   {% endnavtab %}
   {% navtab Using HTTPie %}

   ```bash
   http :8001/services/example.com/plugins name=key-auth
   ```

   {% endnavtab %}
   {% endnavtabs %}

### Step 6: Test a Forced Generation of an Exit Response {#testy-exit}

Attempt a request to the Service to get the custom error. Because the
request did not provide credentials (API key), a 401 response is returned
in the message body.

{% navtabs %}
{% navtab Using cURL %}

```bash
curl --header 'Host: example.com' 'localhost:8000'
```

{% endnavtab %}
{% navtab Using HTTPie %}

```bash
http :8000 Host:example.com
```

{% endnavtab %}
{% endnavtabs %}

Response:

```bash
    HTTP/1.1 200 OK
    ...
    X-Some-Header: some value

    {
        "error": true,
        "status": 401,
        "kong_message": "No API key found in request, arr!"
    }
```

## More Examples

### Apply the Plugin Globally to Handle Unknown Responses

The plugin can also be applied globally:

{% navtabs %}
{% navtab Using cURL %}

```bash
curl -X POST http://<admin-hostname>:8001/plugins/ \
  -F "name=exit-transformer"  \
  -F "config.handle_unknown=true" \
  -F "config.functions=@transform.lua"
...
curl --header 'Host: non-existent.com' 'localhost:8000'
```

{% endnavtab %}
{% navtab Using HTTPie %}

```bash
http :8001/plugins \
  name=exit-transformer \
  config.handle_unknown=true \
  config.functions=@transform.lua

http :8000 Host:non-existent.com
```

{% endnavtab %}
{% endnavtabs %}

Response:

```bash  
    HTTP/1.1 200 OK
    ...
    X-Some-Header: some value

    {
        "error": true,
        "status": 404,
        "kong_message": "No Route matched with those values, arr!"
    }
  ```

### Custom Errors by MIME Type

This example shows a use case where you want custom JSON and HTML responses
based on an [Accept header](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Accept).

Create a file named `custom-errors-by-mimetype.lua` with the transformation
code shown below. Include the status codes you want to customize. See the full list
of HTTP response codes [above](#http-msgs). Any status code not listed in the
`custom-errors-by-mimetype.lua` file will use the default
response `The upstream server responded with <status code>`.

```lua
local template = require "resty.template"
local split = require "kong.tools.utils".split

local HTTP_MESSAGES = {
    s400 = "Bad request",
    s401 = "Unauthorized",
    -- ...
    -- See HTTP Response Status Codes section above for the full list
    s511 = "Network authentication required",
    default = "The upstream server responded with %d"
}

local function get_message(status)
  return HTTP_MESSAGES["s" .. status] or HTTP_MESSAGES.default.format(status)
end

local html = template.compile([[
<!doctype html>
<html>
  <head>
    <meta charset="utf-8">
    <title>Some Title</title>
  </head>
  <body>
    <h1>HTTP {{ status }}</h1>
    <p>{{ error }}</p>
    <img src="https://thumbs.gfycat.com/RegularJointEwe-size_restricted.gif"/>
  </body>
</html>
]])

-- Customize responses based on content type
local formats = {
  ["application/json"] = function(status, message, headers)
    return status, { status = status, error = message }, headers
  end,
  ["text/html"] = function(status, message, headers)
    return status, html { status = status, error = message }, headers
  end,
}

return function(status, body, headers)
  if status < 400 then
    return status, body, headers
  end

  local accept = kong.request.get_header("accept")
  -- Gets just first accept value. Can be improved to be compliant quality
  -- etc parser. Look into kong.pdk.response get_response_type
  if type(accept) == "table" then
    accept = accept[1]
  end
  accept = split(accept, ",")[1]

  if not formats[accept] then
    return status, body, headers
  end

  return formats[accept](status, get_message(status), headers)
end
```

Configure the `exit-transformer` plugin with `custom-errors-by-mimetype.lua`.

{% navtabs %}
{% navtab Using cURL %}

```bash
curl -X POST http://<admin-hostname>:8001/services/example.com/plugins \
  -F "name=exit-transformer"  \
  -F "config.handle_unknown=true" \
  -F "config.handle_unexpected=true" \
  -F "config.functions=@examples/custom-errors-by-mimetype.lua"
```

{% endnavtab %}
{% navtab Using HTTPie %}

```bash
http -f :8001/plugins name=exit-transformer \
  config.handle_unknown=true \
  config.handle_unexpected=true \
  config.functions=@examples/custom-errors-by-mimetype.lua
```

{% endnavtab %}
{% endnavtabs %}
