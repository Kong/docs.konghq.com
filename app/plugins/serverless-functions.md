---
id: page-plugin
title: Plugins - Serverless Functions
header_title: Serverless Functions
header_icon: https://konghq.com/wp-content/uploads/2018/06/serverless-functions.png
header_btn_repo_href: https://github.com/Kong/kong-plugin-serverless-functions
breadcrumbs:
  Plugins: /plugins
nav:
  - label: Usage
    items:
      - label: Plugin Names
      - label: Demonstration
      - label: Notes

description: |

  Dynamically run Lua code from Kong during access phase.

params:
  name: serverless-functions
  api_id: true
  service_id: true
  route_id: true
  consumer_id: false
  config:
    - name: functions
      required: true
      default: "[]"
      value_in_examples: "[]"
      description: Array of stringified Lua code to be cached and run in sequence during access phase.

---

## Plugin Names

Serverless Functions come as two separate plugins. Each one runs with a
different priority in the plugin chain.

- `pre-function`
  - Runs before other plugins run during access phase.
- `post-function`
  - Runs after other plugins in the access phase.

## Demonstration

1. Create a Service on Kong:

    ```bash
    $ curl -i -X  POST http://localhost:8001/services/ \
      --data "name=plugin-testing" \
      --data "url=http://httpbin.org/headers"

    HTTP/1.1 201 Created
    ...
    ```

2. Add a Route to the Service:

    ```bash
    $ curl -i -X  POST http://localhost:8001/services/plugin-testing/routes \
      --data "paths[]=/test"

    HTTP/1.1 201 Created
    ...
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
    kong.request.clear_header('x-custom-auth')
    ```

4. Ensure the file contents:

    ```bash
    $ cat custom-auth.lua
    ```

5. Apply our Lua code using the `pre-function` plugin using cURL file upload:

    ```bash
    $ curl -i -X POST http://localhost:8001/services/plugin-testing/plugins \
        --data "name=pre-function" \
        --data "config.functions[]=@custom-auth.lua"

    HTTP/1.1 201 Created
    ...
    ```

6. Test that our lua code will terminate the request when no header is passed:

    ```bash
    curl -i -X GET http://localhost:8000/test

    HTTP/1.1 401 Unauthorized
    ...
    "Invalid Credentials"
    ```

7. Test the Lua code we just applied by making a valid request:

    ```bash
    curl -i -X GET http://localhost:8000/test \
      --header "x-custom-auth=key"

    HTTP/1.1 200 OK
    ...
    ```

This is just a small demonstration of the power these plugins grant. We were 
able to dynamically inject Lua code into the plugin access phase to dynamically 
terminate, or transform the request without creating a custom plugin or 
reloading / redeploying Kong.

In short, serverless functions give you the full capabilities of a custom plugin
in the access phase without ever redeploying / restarting Kong. 

----

### Notes

#### Fake Upstreams

Since the [Service][service-url] entity requires defining an upstream you may
define a fake upstream and take care to terminate the request. See the 
[`lua-ngx-module`](https://github.com/openresty/lua-nginx-module#ngxexit) 
documentation for more information.

#### Escaping Commas

Since the Lua code blocks are sent in an Array, when using `form-data` you might
run into an issue with code being split when using commas. To avoid this situation
escape commas using the backslash character `\,`.

#### Minifying Lua

Since we send our code over in a string format, it is advisable to use either
curl file upload `@file.lua` (see demonstration) or to minify your Lua code 
using a [minifier][lua-minifier].


[service-url]: https://getkong.org/docs/latest/admin-api/#service-object
[lua-minifier]: https://mothereff.in/lua-minifier
