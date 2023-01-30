---
name: Serverless Functions
publisher: Kong Inc.
desc: Dynamically run Lua code from Kong
description: |
  Dynamically run Lua code from Kong.

  The Serverless Functions plugin comes as two separate plugins. Each one runs with a
  different priority in the plugin chain.

  - `pre-function`
    - Runs before other plugins run during each phase. The `pre-function` plugin can be applied to individual services, routes, or globally.
  - `post-function`
    - Runs after other plugins in each phase. The `post-function` plugin can be applied to individual services, routes, or globally.

  {:.important}
  > **Warning:** The pre-function and post-function serverless plugin
    allows anyone who can enable the plugin to execute arbitrary code.
    If your organization has security concerns about this, disable the plugin
    in your `kong.conf` file.

type: plugin
categories:
  - serverless
kong_version_compatibility:
  community_edition:
    compatible: true
  enterprise_edition:
    compatible: true
---

## Usage

{% navtabs %}
{% navtab With a database %}

1. Create a service on Kong:

    ```bash
    curl -i -X  POST http://localhost:8001/services/ \
      --data "name=plugin-testing" \
      --data "url=http://httpbin.org/headers"
    ```

2. Add a route to the service:

    ```bash
    curl -i -X  POST http://localhost:8001/services/plugin-testing/routes \
      --data "paths[]=/test"
    ```

1. Create a file named `custom-auth.lua` with the following content:

    ```lua
      -- Get list of request headers
      local custom_auth = kong.request.get_header("x-custom-auth")

      -- Terminate request early if our custom authentication header
      -- does not exist
      if not custom_auth then
        return kong.response.exit(401, "Invalid Credentials")
      end

      -- Remove custom authentication header from request
      kong.service.request.clear_header('x-custom-auth')
    ```

4. Ensure the file contents:

    ```bash
    cat custom-auth.lua
    ```

5. Apply our Lua code using the `pre-function` plugin using cURL file upload:

    ```bash
    curl -i -X POST http://localhost:8001/services/plugin-testing/plugins \
        -F "name=pre-function" \
        -F "config.access[1]=@custom-auth.lua" \
        -F "config.access[2]=kong.log.err('Hi there Access!')" \
        -F "config.header_filter[1]=kong.log.err('Hi there Header_Filter!')" \
        -F "config.body_filter[1]=kong.log.err('Hi there Body_Filter!')" \
        -F "config.log[1]=kong.log.err('Hi there Log!')"
    ```

    Response:
    ```
    HTTP/1.1 201 Created
    ...
    ```

6. Test that our Lua code will terminate the request when no header is passed:

    ```bash
    curl -i -X GET http://localhost:8000/test

    HTTP/1.1 401 Unauthorized
    ...
    "Invalid Credentials"
    ```
    In the logs, there will be the following messages:
    ```
    [pre-function] Hi there Header_Filter!
    [pre-function] Hi there Body_Filter!
    [pre-function] Hi there Body_Filter!
    [pre-function] Hi there Log!
    ```
    The "Access" message is missing because the first function in that phase does
    an early exit, throwing the 401. Hence the subsequent functions are not executed.

7. Test the Lua code we just applied by making a valid request:

    ```bash
    curl -i -X GET http://localhost:8000/test \
      --header "x-custom-auth: demo"

    HTTP/1.1 200 OK
    ...
    ```
    Now the logs will also have the "Access" message.

{% endnavtab %}
{% navtab Without a database %}

1. Create the service, route, and associated plugin in the declarative config file:

    ``` yaml
    services:
    - name: plugin-testing
      url: http://httpbin.org/headers

    routes:
    - service: plugin-testing
      paths: [ "/test" ]

    plugins:
    - name: pre-function
      config:
        access:
        - |2
            -- Get list of request headers
            local custom_auth = kong.request.get_header("x-custom-auth")

            -- Terminate request early if the custom authentication header
            -- does not exist
            if not custom_auth then
              return kong.response.exit(401, "Invalid Credentials")
            end

            -- Remove custom authentication header from request
            kong.service.request.clear_header('x-custom-auth')
        - kong.log.err('Hi there Access!')
        header_filter:
        - kong.log.err('Hi there Header_Filter!')
        body_filter:
        - kong.log.err('Hi there Body_Filter!')
        log:
        - kong.log.err('Hi there Log!')
    ```

2. Test that the Lua code will terminate the request when no header is passed:

    ```bash
    curl -i -X GET http://localhost:8000/test

    HTTP/1.1 401 Unauthorized
    ...
    "Invalid Credentials"
    ```
    The following messages will be in the logs:
    ```
    [pre-function] Hi there Header_Filter!
    [pre-function] Hi there Body_Filter!
    [pre-function] Hi there Body_Filter!
    [pre-function] Hi there Log!
    ```
    The "Access" message is missing because the first function in that phase does
    an early exit, throwing the 401. Hence the subsequent functions are not executed.

3. Test the Lua code we just applied by making a valid request:

    ```bash
    curl -i -X GET http://localhost:8000/test \
      --header "x-custom-auth: demo"

    HTTP/1.1 200 OK
    ...
    ```
    Now the logs will also have the "Access" message.

{% endnavtab %}
{% endnavtabs %}

This is just a small demonstration of the power these plugins grant. You were
able to dynamically inject Lua code into the plugin phases to dynamically
terminate, or transform the request without creating a custom plugin or
reloading / redeploying Kong.

In summary, serverless functions give you the full capabilities of a custom plugin
without requiring redeploying or restarting Kong.

## Sandboxing

The provided Lua environment is sandboxed.

{% include /md/plugins-hub/sandbox.md %}

## Upvalues

You can return a function to run on each request,
allowing for upvalues to keep state in between requests:

```lua
-- this runs once on the first request
local count = 0

return function()
  -- this runs on each request
  count = count + 1
  ngx.log(ngx.ERR, "hello world: ", count)
end
```

## Minifying Lua

Since we send our code over in a string format, it is advisable to use either
curl file upload `@file.lua` (see demonstration) or to minify your Lua code
using a [minifier][lua-minifier].


[service-url]: https://getkong.org/docs/latest/admin-api/#service-object
[lua-minifier]: https://mothereff.in/lua-minifier

---

