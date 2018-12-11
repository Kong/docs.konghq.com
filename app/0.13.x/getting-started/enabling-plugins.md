---
title: Enabling Plugins
---

# Introduction

<div class="alert alert-warning">
  <strong>Before you start:</strong>
  <ol>
    <li>Make sure you've <a href="https://konghq.com/install/">installed Kong</a> - It should only take a minute!</li>
    <li>Make sure you've <a href="/{{page.kong_version}}/getting-started/quickstart">started Kong</a>.</li>
    <li>Also, make sure you've <a href="/{{page.kong_version}}/getting-started/configuring-a-service">configured your Service in Kong</a>.</li>
  </ol>
</div>

In this section, you'll learn how to configure Kong plugins. One of the core
principles of Kong is its extensibility through [plugins][plugins]. Plugins
allow you to easily add new features to your API or make your API easier to
manage.

In the steps below you will configure the [key-auth][key-auth] plugin to add
authentication to your Service. Prior to the addition of this plugin, **all**
requests to your Service would be proxied upstream. Once you add and configure this
plugin, **only** requests with the correct API key(s) will be proxied - all
other requests will be rejected by Kong, thus protecting your upstream service
from unauthorized use.


## 1. Configure the key-auth plugin for the Service you <a href="/{{page.kong_version}}/getting-started/configuring-a-service">configured in Kong</a>.

    Issue the following cURL request:

    ```bash
    $ curl -i -X POST \
      --url http://localhost:8001/services/example-service/plugins/ \
      --data 'name=key-auth'
    ```

    **Note:** This plugin also accepts a `config.key_names` parameter, which
    defaults to `['apikey']`. It is a list of headers and parameters names (both
    are supported) that are supposed to contain the apikey during a request.

## 2. Verify that the plugin is properly configured

    Issue the following cURL request to verify that the [key-auth][key-auth]
    plugin was properly configured on the Service:

    ```bash
    $ curl -i -X GET \
      --url http://localhost:8000/ \
      --header 'Host: example.com'
    ```

    Since you did not specify the required `apikey` header or parameter, the
    response should be `401 Unauthorized`:

    ```http
    HTTP/1.1 401 Unauthorized
    ...

    {
      "message": "No API key found in request"
    }
    ```

## Next Steps

Now that you've configured the **key-auth** plugin lets learn how to add
consumers to your Service so we can continue proxying requests through Kong.

Go to [Adding Consumers &rsaquo;][adding-consumers]

[key-auth]: /plugins/key-authentication
[plugins]: /plugins
[adding-consumers]: /{{page.kong_version}}/getting-started/adding-consumers
