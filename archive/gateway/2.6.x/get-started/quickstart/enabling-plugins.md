---
title: Enabling Plugins
---

In this section, you'll learn how to configure Kong plugins. One of the core
principles of Kong is its extensibility through [plugins][plugins]. Plugins
allow you to easily add new features to your Service or make it easier to
manage.

In the steps below, you will configure the [key-auth][key-auth] plugin to add
authentication to your Service. Prior to the addition of this plugin, **all**
requests to your Service would be proxied upstream. Once you add and configure this
plugin, **only** requests with the correct key(s) will be proxied - all
other requests will be rejected by Kong, thus protecting your upstream service
from unauthorized use.

## Before you start

* You have installed and started {{site.base_gateway}}, either through the [Docker quickstart](/gateway/{{page.kong_version}}/get-started/quickstart) or a more [comprehensive installation](/gateway/{{page.kong_version}}/install-and-run)
* You have [configured your Service](/gateway/{{page.kong_version}}/get-started/quickstart/configuring-a-service) in {{site.base_gateway}}

## 1. Configure the key-auth plugin

To configure the key-auth plugin for the Service you <a href="/gateway/{{page.kong_version}}/get-started/quickstart/configuring-a-service/">configured in Kong</a>,
issue the following cURL request:

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
curl -i -X GET \
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

[key-auth]: /hub/kong-inc/key-auth
[plugins]: /hub/
[adding-consumers]: /gateway/{{page.kong_version}}/get-started/quickstart/adding-consumers
