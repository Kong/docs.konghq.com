---
name: Exit Transformer
publisher: Kong Inc.
version: 1.5.x

desc: Customize Kong exit responses sent downstream
description: |
  Transform and customize Kong response exit messages using Lua functions.
  The capabilities range from changing messages, status codes, and headers, to completely transforming
  the structure of Kong responses.

type: plugin
enterprise: true
categories:
  - transformations

kong_version_compatibility:
    enterprise_edition:
      compatible:
        - 1.5.x
        - 1.3-x

params:
  name: exit-transformer
  service_id: true
  route_id: true
  consumer_id: false
  protocols: ["http", "https"]
  config:
    - name: functions
      required: true
      value_in_examples: "[]"
      description: Array of functions used to transform any Kong proxy exit response.
    - name: handle_unknown
      default: "`false`"
      required: false
      description: Allow transform to apply to unmatched route (404) responses. Should not be enabled on more than one plugin configuration.
    - name: handle_unexpected
      default: "`false`"
      required: false
      description: Allow transform to apply to unexpected request (400) responses. Should not be enabled on more than one plugin configuration.
    - name: handle_admin
      default: "`false`"
      required: false
      description: Allow transform to apply to admin API responses. Should not be enabled on more than one plugin configuration.

---

## Transforming 404 and 400 responses

By default, the exit transformer is only applied to requests that match its
criteria (its route, service, and/or consumer matching configuration) or
globally within a workspace. However, requests that result in 400 or 404
responses neither match any criteria nor fall within any specific workspace,
and standard plugin criteria will never match them. Users can designate exit
transformer configurations that _do_ handle these responses by enabling the
`handle_unknown` (404) and `handle_unexpected` (400) settings. These should
only be enabled on a single plugin configuration.

`handle_admin` allows the exit transformer to apply to admin API responses.
Users should only modify headers only applying functions to admin API
responses, as modifying the body or status will interfere with Kong Manager's
ability to communicate with the admin API.

## Function syntax

The exit transformer expects a configuration function to be Lua code that returns
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
  If you manipulate them, first check that they exist and instantiate them
  if they do not. The "Modify the body and headers, even if none were provided"
  example below shows how to do this.
</div>


### Examples

* Identity function: does not transform the exit responses

```lua
return function(status, body, headers)
  return status, body, headers
end
```

* Always return a 200 status code, bundling the status within the message

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

* Customize particular Kong messages

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

* Modify the body and headers, even if none were provided

```lua
return function(status, body, headers)
  if not body then
    body = { message = "This replaces a formerly empty body" }
  else
    body.message = "This replaces a formerly non-empty body"
  end

  if not headers then
    headers = { X-Message = "This adds X-Message to an empty set of headers" }
  else
    headers["X-Message"] = "This adds X-Message to an existing set of headers" }
  end

  return status, body, headers
end
```

## Demonstration

1. Create a Service and a Route in Kong:

    ```bash
    $ http :8001/services name=example.com host=mockbin.org
    $ http -f :8001/services/example.com/routes hosts=example.com
    ```

2. Create a file named `transform.lua` with the transformation code. The
   following example adds a header, appends "arr!" to any message, and adds
   an `error` and `status` field on the response.

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

      return status, body, headers
    end
    ```

3. Configure the `exit-transformer` plugin with `transform.lua`

    ```bash
    $ http -f :8001/services/example.com/plugins \
        name=exit-transformer \
        config.functions=@transform.lua
    ```

4. (example) Add key-auth plugin to force generation of an exit response

    ```bash
    $ http :8001/services/example.com/plugins name=key-auth
    ```

5. Attempt a request to the Service to get the custom error

    ```bash
    $ http :8000 Host:example.com
    HTTP/1.1 200 OK
    ...
    X-Some-Header: some value

    {
        "error": true,
        "status": 401,
        "kong_message": "No API key found in request, arr!"
    }
    ```

6. Note the plugin can also be applied globally

   ```bash
    $ http :8001/plugins \
        name=exit-transformer \
        config.handle_unknown=true \
        config.functions=@transform.lua

    $ http :8000 Host:non-existent.com
    HTTP/1.1 200 OK
    ...
    X-Some-Header: some value

    {
        "error": true,
        "status": 404,
        "kong_message": "no Route matched with those values, arr!"
    }
    ```
