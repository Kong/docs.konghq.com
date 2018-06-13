---
id: page-plugin
title: Plugins - Serverless Functions
header_title: Serverless Functions
header_icon: https://konghq.com/wp-content/uploads/2018/05/azure-functions.png
breadcrumbs:
  Plugins: /plugins
nav:
  - label: Usage
    items:
      - label: Plugin Names
      - label: Demonstration
      - label: Limitations

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
      description: Array of stringified lua code to be cached and ran in sequence during access phase.

---

> **Note**: Serverless plugins are available in Enterprise as of version 0.32 
> and will soon be available as part of Kong CE 0.14.

## Plugin Names

Serverless Functions come as two separate plugins. Each one runs with a
different priority in the plugin chain.

- `pre-function`
  - Runs before other plugins are ran.
- `post-function`
  - Runs after all other plugins have ran.

## Demonstration

1. Create a Service on Kong, with a fake upstream:

    ```bash
    $ curl -i -X  POST http://localhost:8001/services/ \
      --data "name=plugin-testing" \
      --data "url=http://dead.end.com"

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

3. Apply the `pre-function` plugin

    ```bash
    $ curl -i -X POST http://localhost:8001/services/plugin-testing/plugins \
        --data "name=pre-function" \
        --data "config.functions[]=local qs=ngx.req.get_uri_args()if qs and qs.name then ngx.say('Hello '..qs.name..'!')else ngx.say('Hello Serverless Functions!')end;ngx.exit(200)"

    HTTP/1.1 201 Created
    ...
    ```

4. Test the Serverless Function

    ```bash
    curl -i -X GET http://localhost:8000/test?name=Kong

    HTTP/1.1 200 OK
    ...
    "Hello Kong!"
    ```

In this example we're only passing a query parameter `name` to the Serverless
Function and using that information through our Lua code to return that back 
without ever restarting or deploying a service.

----

### Limitations

#### Using a fake `upstream_url`

Because the [Service][service-url] entity requires defining an upstream you may
define a fake upstream such as `http://never.exists` or `http://dead.end.upstream`.

Whenever you define such an upstream, to avoid Kong sending a request to the upstream,
make sure that your function exits the request process by using:

```lua
ngx.exit(...)
```

#### Response plugins

There is a known limitation in the system that prevents some response plugins
from being executed. We are planning to remove this limitation in the future.

#### Form data and commas

Since the lua code blocks are sent in an Array, when using `form-data` you might
run into an issue with code being split when using commas. To avoid this situation
escape commas using the backslash character `\\,`.

#### Minified lua

Since we send our code over in a string format, it is advisable to use either
curl file upload `@file.lua` or to minify your lua code using a 
[lua minifier][lua-minifier].


[service-url]: https://getkong.org/docs/latest/admin-api/#service-object
[lua-minifier]: https://mothereff.in/lua-minifier
