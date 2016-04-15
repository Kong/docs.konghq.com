---
title: Enabling Plugins
---

# Enabling Plugins

<div class="alert alert-warning">
  <strong>Before you start:</strong>
  <ol>
    <li>Make sure you've <a href="/install/">installed Kong</a> - It should only take a minute!</li>
    <li>Make sure you've <a href="/docs/{{page.kong_version}}/getting-started/quickstart">started Kong</a>.</li>
    <li>Also, make sure you've <a href="/docs/{{page.kong_version}}/getting-started/adding-your-api">added your API to Kong</a>.</li>
  </ol>
</div>

In this section, you'll learn how to configure plugins. One of the core principals of Kong is its extensibility through [plugins][plugins]. Plugins allow you to easily add new features to your API or make your API easier to manage.

As an example, we'll have you configure the [key-auth][key-auth] plugin to add authentication to your API.

1. ### Configure the plugin for your API

    Issue the following cURL request on the previously created API named `mockbin`:

    ```bash
    $ curl -i -X POST \
      --url http://localhost:8001/apis/mockbin/plugins/ \
      --data 'name=key-auth'
    ```

    **Note:** This plugin also accepts a `config.key_names` parameter, which defaults to `[apikey]`. It is a list of headers and parameters names (both are supported) that are supposed to contain the API key during a request.

2. ### Verify that the plugin is properly configured

    Issue the following cURL request to verify that the [key-auth][key-auth] plugin was properly configured on the API:

    ```bash
    $ curl -i -X GET \
      --url http://localhost:8000/ \
      --header 'Host: mockbin.com'
    ```

    Since you did not specify the required `apikey` header or parameter, the response should be `403 Forbidden`:

    ```http
    HTTP/1.1 403 Forbidden
    ...

    {
      "message": "Your authentication credentials are invalid"
    }
    ```

### Next Steps

Now that you've configured the **key-auth** plugin lets learn how to add consumers to your API so we can continue proxying requests through Kong.

Go to [Adding Consumers &rsaquo;][adding-consumers]

[CLI]: /docs/{{page.kong_version}}/cli
[API]: /docs/{{page.kong_version}}/admin-api
[key-auth]: /plugins/key-authentication
[plugins]: /plugins
[configuration]: /docs/{{page.kong_version}}/configuration
[adding-consumers]: /docs/{{page.kong_version}}/getting-started/adding-consumers
