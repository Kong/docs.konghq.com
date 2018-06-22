---
id: page-plugin
title: Plugins - Azure Functions
header_title: Azure Functions
header_icon: https://konghq.com/wp-content/uploads/2018/05/azure-functions.png
header_btn_repo_href: https://github.com/Kong/kong-plugin-azure-functions
breadcrumbs:
  Plugins: /plugins
nav:
  - label: Usage
    items:
      - label: Demonstration
      - label: Limitations

description: |

  This plugin invokes
  [Azure Functions](https://azure.microsoft.com/en-us/services/functions/).
  It can be used in combination with other request plugins to secure, manage
  or extend the function.

installation: |

  You can either use the LuaRocks package manager to install the plugin

  ```bash
  $ luarocks install kong-plugin-azure-functions
  ```

  or install it from [source](https://github.com/kong/kong-plugin-azure-functions).
  For more infomation on Plugin installation, please see the documentation
  [Plugin Development - (un)Install your plugin](/docs/latest/plugin-development/distribution/)

params:
  name: azure-functions
  api_id: true
  service_id: true
  route_id: true
  consumer_id: true
  config:
    - name: functionname
      required: true
      default:
      value_in_exaples: AZURE_FUNCTIONNAME
      description: Name of the Azure function to invoke.
    - name: appname
      required: true
      default:
      value_in_examples: AZURE_APPNAME
      description: The Azure app name.
    - name: hostdomain
      required: false
      default: azurewebsites.net
      value_in_examples:
      description: The domain where the function resides.
    - name: routeprefix
      required: false
      default: /api
      value_in_examples:
      description: Route prefix to use.
    - name: apikey
      required: false
      default:
      value_in_examples: AZURE_APIKEY
      description: The apikey to access the Azure resources. If provided it will be injected as the `x-functions-key` header.
    - name: clientid
      required: false
      default:
      value_in_examples:
      description: The clientid to access the Azure resources. If provided it will be injected as the `x-functions-clientid` header.
    - name: https_verify
      required: false
      default: false
      value_in_examples:
      description: Set it to true to authenticate the Azure Functions server.
    - name: https
      required: false
      default: true
      value_in_examples:
      description: Use of HTTPS to connect with the Azure Functions server.
    - name: timeout
      required: false
      default: 600000
      value_in_examples:
      description: Timeout in milliseconds before aborting a connection to Azure Functions server.
    - name: keepalive
      required: false
      default: 60000
      value_in_examples:
      description: Time in milliseconds for which an idle connection to the Azure Functions server will live before being closed.

  extra: |
    Note: If `config.https_verify` is set as `true` then the server certificate
    will be verified according to the CA certificates specified by the
    `lua_ssl_trusted_certificate` directive in your Kong configuration.

---

## Demonstration

To demonstrate the plugin, set up the [Azure Functions "hello world" function](https://docs.microsoft.com/en-us/azure/azure-functions/functions-create-first-azure-function).

1. In this example we'll consider the following settings/placeholders, insert your own values here:

    ```
    - `<appname>` for the Functions appname
    - `<functionname>` for the function name
    - `<apikey>` for the api key
    ```

2. Test your function to make sure it works before adding it to Kong

    ```bash
    curl -i -X GET https://<appname>.azurewebsites.net/api/<functionname>?name=Kong \
         -H "x-functions-key:<apikey>"

    HTTP/1.1 200 OK
    ...
    "Hello Kong!"
    ```

3. Create a Service on Kong

    ```bash
    $ curl -i -X  POST http://localhost:8001/services/ \
      --data "name=plugin-testing" \
      --data "url=http://dead.end.com"

    HTTP/1.1 201 Created
    ...
    ```

4. Add a Route to the Service on Kong

    ```bash
    $ curl -i -X  POST http://localhost:8001/services/plugin-testing/routes \
      --data "paths[]=/mytest"

    HTTP/1.1 201 Created
    ...
    ```

5. Apply the Azure-functions plugin

    ```bash
    $ curl -i -X POST http://localhost:8001/services/plugin-testing/plugins \
        --data "name=azure-functions" \
        --data "config.appname=<appname>" \
        --data "config.functionname=<functionname>" \
        --data "config.apikey=<apikey>"

    HTTP/1.1 201 Created
    ...

    ```

6. Test the Azure Function through Kong (same result as step 2)

    ```bash
    curl -i -X GET http://localhost:8000/mytest?name=Kong

    HTTP/1.1 200 OK
    ...
    "Hello Kong!"
    ```

In this example we're only passing a query parameter `name` to the Azure
Function. Besides query parameters, also the HTTP method, path parameters,
headers, and body will be passed to the Azure Function if provided.

----

### Limitations

#### Use a fake upstream_url

When using the this plugin, the response will be returned by the plugin itself
without proxying the request to any upstream service. This means that whatever
`url` has been set on the [Service](https://getkong.org/docs/latest/admin-api/#service-object)
it will never be used. Although `url` will never be used, it's
currently a mandatory field in Kong's data model, so feel free to set a fake
value (ie, `http://dead.end.com` as per the example above) if you are planning to use this plugin.
In the future, we will provide a more intuitive way to deal with similar use cases.

#### Response plugins

There is a known limitation in the system that prevents some response plugins
from being executed. We are planning to remove this limitation in the future.
