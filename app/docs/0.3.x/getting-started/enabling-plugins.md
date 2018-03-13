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

In this section, you'll learn how to enable plugins. One of the core principals of Kong is its extensibility through [plugins][plugins]. Plugins allow you to easily add new features to your API or make your API easier to manage.

First, we'll have you configure and enable the [keyauth][keyauth] plugin to add authentication to your API.

1. ### Add plugin to your Kong config

    Add `keyauth` under the `plugins_available` property in your Kong instance [configuration file][configuration] should it not already exist:

    ```yaml
    plugins_available:
      - keyauth
    ```

2. ### Restart Kong

    Issue the following command to restart Kong. This allows Kong to load the plugin.

    ```bash
    $ kong restart
    ```

    **Note:** If you have a cluster of Kong instances that share the configuration, you should restart each node in the cluster.

3. ### Configure the plugin for your API

    Now that Kong has loaded the plugin, we should configure it to be enabled on your API.

    Issue the following cURL request on the previously created API named `mockbin`:

    ```bash
    $ curl -i -X POST \
      --url http://localhost:8001/apis/mockbin/plugins/ \
      --data 'name=keyauth'
    ```

    **Note:** This plugin also accepts a `value.key_names` parameter, which defaults to `[apikey]`. It is a list of headers and parameters names (both are supported) that are supposed to contain the API key during a request.

4. ### Verify that the plugin is enabled for your API

    Issue the following cURL request to verify that the [keyauth][keyauth] plugin was enabled for your API:

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

Now that you've enabled the **keyauth** plugin lets learn how to add consumers to your API so we can continue proxying requests through Kong.

Go to [Adding Consumers &rsaquo;][adding-consumers]

[CLI]: /docs/{{page.kong_version}}/cli
[API]: /docs/{{page.kong_version}}/admin-api
[keyauth]: /plugins/key-authentication
[plugins]: /plugins
[configuration]: /docs/{{page.kong_version}}/configuration
[adding-consumers]: /docs/{{page.kong_version}}/getting-started/adding-consumers
