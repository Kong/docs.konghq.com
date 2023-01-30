---
name: Azure Functions
publisher: Kong Inc.
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
    compatible: true
  enterprise_edition:
    compatible: true
---

## Demonstration

To demonstrate the plugin, set up the [Azure Functions "hello world" function](https://docs.microsoft.com/en-us/azure/azure-functions/functions-create-first-azure-function).

1. In this example, we'll consider the following placeholder settings. Insert your own values
    for the placeholders in the code examples:

    - `<appname>` for the function's app name
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
