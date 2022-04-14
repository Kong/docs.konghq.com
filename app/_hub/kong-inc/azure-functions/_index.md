---
name: Azure Functions
publisher: Kong Inc.
version: 1.0.0
source_url: 'https://github.com/Kong/kong-plugin-azure-functions'
desc: Invoke and manage Azure functions from Kong
description: |
  This plugin invokes
  [Azure Functions](https://azure.microsoft.com/en-us/services/functions/).
  It can be used in combination with other request plugins to secure, manage,
  or extend the function.
type: plugin
categories:
  - serverless
kong_version_compatibility:
  community_edition:
    compatible:
      - 2.8.x
      - 2.7.x
      - 2.6.x
      - 2.5.x
      - 2.4.x
      - 2.3.x
      - 2.2.x
      - 2.1.x
      - 2.0.x
      - 1.5.x
      - 1.4.x
      - 1.3.x
      - 1.2.x
      - 1.1.x
      - 1.0.x
      - 0.14.x
  enterprise_edition:
    compatible:
      - 2.8.x
      - 2.7.x
      - 2.6.x
      - 2.5.x
      - 2.4.x
      - 2.3.x
      - 2.2.x
      - 2.1.x
      - 1.5.x
      - 1.3-x
      - 0.36-x
params:
  name: azure-functions
  service_id: true
  route_id: true
  consumer_id: true
  protocols:
    - http
    - https
  dbless_compatible: 'yes'
  config:
    - name: functionname
      required: true
      default: null
      value_in_examples: <AZURE_FUNCTIONNAME>
      datatype: string
      description: Name of the Azure function to invoke.
    - name: appname
      required: true
      default: null
      value_in_examples: <AZURE_APPNAME>
      datatype: string
      description: The Azure app name.
    - name: hostdomain
      required: true
      default: azurewebsites.net
      value_in_examples: azurewebsites.net
      datatype: string
      description: The domain where the function resides.
    - name: routeprefix
      required: false
      default: /api
      value_in_examples: null
      datatype: string
      description: Route prefix to use.
    - name: apikey
      required: false
      default: null
      value_in_examples: <AZURE_APIKEY>
      datatype: string
      encrypted: true
      description: 'The apikey to access the Azure resources. If provided, it is injected as the `x-functions-key` header.'
    - name: clientid
      required: false
      default: null
      value_in_examples: null
      datatype: string
      encrypted: true
      description: 'The `clientid` to access the Azure resources. If provided, it is injected as the `x-functions-clientid` header.'
    - name: https_verify
      required: false
      default: false
      value_in_examples: null
      datatype: boolean
      description: Set to `true` to authenticate the Azure Functions server.
    - name: https
      required: false
      default: true
      value_in_examples: null
      datatype: boolean
      description: Use of HTTPS to connect with the Azure Functions server.
    - name: timeout
      required: false
      default: 600000
      value_in_examples: null
      datatype: number
      description: Timeout in milliseconds before closing a connection to the Azure Functions server.
    - name: keepalive
      required: false
      default: 60000
      value_in_examples: null
      datatype: number
      description: Time in milliseconds during which an idle connection to the Azure Functions server lives before being closed.
  extra: |
    Note: If `config.https_verify` is set as `true`, then the server certificate
    is verified according to the CA certificates specified by the
    `lua_ssl_trusted_certificate` directive in your Kong configuration.
---

## Demonstration

To demonstrate the plugin, set up the [Azure Functions "hello world" function](https://docs.microsoft.com/en-us/azure/azure-functions/functions-create-first-azure-function).

1. In this example, we'll consider the following placeholder settings. Insert your own values
    for the placeholders in the code examples:

    - `<appname>` for the functions appname
    - `<functionname>` for the function name
    - `<apikey>` for the api key

2. Test your function to make sure it works before adding it to {{site.base_gateway}}:

    ```bash
    curl -i -X GET https://<appname>.azurewebsites.net/api/<functionname>?name=Kong \
         -H "x-functions-key:<apikey>"
    ```

    ```
    HTTP/1.1 200 OK
    ...
    "Hello Kong!"
    ```

3. Set up a route in {{site.base_gateway}} and link it to the Azure function you just created.

{% navtabs %}
{% navtab With a database %}

Create the route:

```bash
curl -i -X POST http://localhost:8001/routes \
--data 'name=azure1' \
--data 'paths[1]=/azure1'
```

Add the plugin:

```bash
curl -i -X POST http://localhost:8001/routes/azure1/plugins \
--data "name=azure-functions" \
--data "config.appname=<appname>" \
--data "config.functionname=<functionname>" \
--data "config.apikey=<apikey>"
```

{% endnavtab %}
{% navtab Without a database %}

Add a route and plugin to the declarative config file:

``` yaml
routes:
- name: azure1
  paths: [ "/azure1" ]

plugins:
- route: azure1
  name: azure-functions
  config:
    appname: <appname>
    functionname: <functionname>
    apikey: <apikey>
```
{% endnavtab %}
{% endnavtabs %}


### Test the Azure Function through Kong

In this example, we're only passing a query parameter `name` to the Azure
Function. Besides query parameters, the HTTP method, path parameters,
headers, and body are also passed to the Azure Function if provided.

```bash
curl -i -X GET http://localhost:8000/azure1?name=Kong
```

You should see the same result as shown in step 2:

```
HTTP/1.1 200 OK
...
"Hello Kong!"
```

---

## Changelog

### 1.0.1

* Starting with {{site.base_gateway}} 2.7.0.0, if keyring encryption is enabled,
 the `config.apikey` and `config.clientid` parameter values will be encrypted.
