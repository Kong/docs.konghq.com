---
name: Azure Functions
publisher: Kong Inc.
version: 1.0.0

source_url: https://github.com/Kong/kong-plugin-azure-functions

desc: Invoke and manage Azure functions from Kong
description: |
  This plugin invokes
  [Azure Functions](https://azure.microsoft.com/en-us/services/functions/).
  It can be used in combination with other request plugins to secure, manage
  or extend the function.

type: plugin
categories:
  - serverless

kong_version_compatibility:
    community_edition:
      compatible:
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
        - 2.1.x
        - 1.5.x
        - 1.3-x
        - 0.36-x
        - 0.35-x

params:
  name: azure-functions
  service_id: true
  route_id: true
  consumer_id: true
  protocols: ["http", "https"]
  dbless_compatible: yes
  config:
    - name: functionname
      required: true
      default:
      value_in_examples: AZURE_FUNCTIONNAME
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
      description: The apikey to access the Azure resources. If provided, it will be injected as the `x-functions-key` header.
    - name: clientid
      required: false
      default:
      value_in_examples:
      description: The clientid to access the Azure resources. If provided, it will be injected as the `x-functions-clientid` header.
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
    Note: If `config.https_verify` is set as `true`, then the server certificate
    will be verified according to the CA certificates specified by the
    `lua_ssl_trusted_certificate` directive in your Kong configuration.

---

## Demonstration

To demonstrate the plugin, set up the [Azure Functions "hello world" function](https://docs.microsoft.com/en-us/azure/azure-functions/functions-create-first-azure-function).

1. In this example, we'll consider the following settings/placeholders, insert your own values
   in the placeholders:

    ```
    - `<appname>` for the Functions appname
    - `<functionname>` for the function name
    - `<apikey>` for the api key
    ```

2. Test your function to make sure it works before adding it to Kong:

    ```bash
    curl -i -X GET https://<appname>.azurewebsites.net/api/<functionname>?name=Kong \
         -H "x-functions-key:<apikey>"

    HTTP/1.1 200 OK
    ...
    "Hello Kong!"
    ```

3. Set up a Route in Kong and link it to the Azure function you just created.

{% navtabs %}
{% navtab With a database %}

Create the Route:

```bash

curl -i -X POST http://{kong_hostname}:8001/routes \
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

Add a Route and Plugin to the declarative config file:

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
Function. Besides query parameters, also the HTTP method, path parameters,
headers, and body will be passed to the Azure Function if provided.

You should see the same result as step 2 above:

```bash
curl -i -X GET http://localhost:8000/azure1?name=Kong

HTTP/1.1 200 OK
...
"Hello Kong!"
```
