---
title: Getting started with the Pre-function plugin
nav_title: Getting started with Pre-function
---

The following guide shows you how set the plugin up in the access phase.
In this example, the plugin will look for a request matching `x-custom-auth`. 
If the header exists in the request, it lets the request through. 
If the header doesn't exist, it terminates the request early.

Let's test out the Pre-function plugin by filtering requests based on header names.

## Set up the plugin

{% navtabs %}
{% navtab With a database %}

1. Create a {{site.base_gateway}} service:

    ```bash
    curl -i -X POST http://localhost:8001/services/ \
      --data "name=example-service" \
      --data "url=https://httpbin.konghq.com/headers"
    ```

1. Add a route to the service:

    ```bash
    curl -i -X POST http://localhost:8001/services/example-service/routes \
      --data "name=test" \
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

1. Apply the Lua code using the `pre-function` plugin endpoint:

    ```bash
    curl -i -X POST http://localhost:8001/services/example-service/plugins \
      --form "name=pre-function" \
      --form "config.access[1]=@custom-auth.lua" \
      --form "config.access[2]=kong.log.err('Test Access')" \
      --form "config.header_filter[1]=kong.log.err('Test Header_Filter!')" \
      --form "config.body_filter[1]=kong.log.err('Test Body_Filter!')" \
      --form "config.log[1]=kong.log.err('Test Log!')"
    ```

    If successful, the API returns a `201` response code.

{% endnavtab %}
{% navtab Without a database %}

1. Create the service, route, and associated plugin in the declarative config file:

    ``` yaml
    services:
    - name: example-service
      url: https://httpbin.konghq.com/headers

    routes:
    - service: example-service
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
        - kong.log.err('Test Access!')
        header_filter:
        - kong.log.err('Test Header_Filter!')
        body_filter:
        - kong.log.err('Test Body_Filter!')
        log:
        - kong.log.err('Test Log!')
    ```

1. Sync the file to your {{site.base_gateway}} instance:

    ```sh
    deck gateway sync kong.yaml
    ```

{% endnavtab %}
{% endnavtabs %}

## Validate the code

1. Test that the code will terminate the request when no header is passed:

    ```bash
    curl -i -X GET http://localhost:8000/test
    ```

    You should get a `401` response:

    ```
    HTTP/1.1 401 Unauthorized
    ...
    "Invalid Credentials"
    ```

    The logs will show the following messages:
    ```
    [pre-function] Test Header_Filter!
    [pre-function] Test Body_Filter!
    [pre-function] Test Body_Filter!
    [pre-function] Test Log!
    ```

    The "Access" message is missing because the first function in that phase does
    an early exit, throwing the 401. Hence the subsequent functions are not executed.

7. This time, test the code by making a valid request:

    ```bash
    curl -i -X GET http://localhost:8000/test \
      --header "x-custom-auth: demo"
    ```

    You should get a `200` response:

    ```
    HTTP/1.1 200 OK
    ```
    Now the logs will also have the "Access" message.

This is just a small demonstration of the power this plugin grants. You were
able to dynamically inject Lua code into the plugin phases to dynamically
terminate, or transform the request without creating a custom plugin or
reloading and redeploying {{site.base_gateway}}.

In summary, serverless functions give you the full capabilities of a custom plugin
without requiring redeploying or restarting Kong.