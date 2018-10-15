---
title: Enabling Plugins
---

# Enabling Plugins

In this section, you'll learn how to configure Kong plugins. One of the core
principles of Kong is its extensibility through [plugins][plugins]. Plugins
allow you to easily add new features to your API or make your API easier to
manage.

In the steps below you will configure the [key-auth][key-auth] plugin to add
authentication to your API. Prior to the addition of this plugin, **all**
requests to your API would be proxied upstream. Once you add and configure this
plugin, **only** requests with the correct API key(s) will be proxied - all
other requests will be rejected by Kong, thus protecting your upstream service
from unauthorized use.

## 1. Configure the key-auth plugin for your API

Issue the following cURL request on the previously created API named
`example-api`:

```bash
$ curl -i -X POST \
  --url http://localhost:8001/apis/example-api/plugins/ \
  --data 'name=key-auth'
```

Or, add your first plugin via the Admin GUI:

<video width="100%" autoplay loop controls>
 <source src="https://konghq.com/wp-content/uploads/2018/07/create-keyauth-plugin-ee-0.33.mp4" type="video/mp4">
 Your browser does not support the video tag.
</video>

**Note:** This plugin also accepts a `config.key_names` parameter, which
defaults to `[apikey]`. It is a list of headers and parameters names (both
are supported) that are supposed to contain the API key during a request.

## 2. Verify that the plugin is properly configured

Issue the following cURL request to verify that the [key-auth][key-auth]
plugin was properly configured on the API:

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

Now that you've configured the **key-auth** plugin, let's learn to add
Consumers to your API so we can continue proxying requests through Kong.

Go to [Adding Consumers &rsaquo;][adding-consumers]

[key-auth]: /plugins/key-authentication
[plugins]: /plugins
[adding-consumers]: /enterprise/{{page.kong_version}}/getting-started/adding-consumers
