---
title: Enabling Plugins
---

## Introduction

In this section, you'll learn how to configure Kong plugins. One of the core
principles of Kong is its extensibility through [plugins][plugins]. Plugins
allow you to easily add new features to your API or make your API easier to
manage.

In the steps below you will configure the [basic-auth][basic-auth] plugin to add
authentication to your API. Prior to the addition of this plugin, **all**
requests to your API would be proxied upstream. Once you add and configure this
plugin, **only** requests with the correct credentials will be proxied—all
other requests will be rejected by Kong, thus protecting your upstream service
from unauthorized use.

## 1. Configure the Basic Auth Plugin for your API

Issue the following cURL request on the previously created API named
`example-api`:

```bash
$ curl -i -X POST \
  --url http://localhost:8001/apis/example-api/plugins/ \
  --data 'name=basic-auth'
  --data "config.hide_credentials=true"
```

Or, add your first plugin via Kong Manager on the "Plugins" page:

<video width="100%" autoplay loop controls>
 <source src="https://konghq.com/wp-content/uploads/2019/02/add-basic-auth-ent-34.mov" type="video/mp4">
 Your browser does not support the video tag.
</video>


## 2. Verify that the Plugin is Properly Configured

Issue the following cURL request to verify that the [basic-auth][basic-auth]
plugin was properly configured on the API:

```bash
$ curl -i -X GET \
  --url http://localhost:8000/ \
  --header 'Host: example.com'
```

Since you did not specify the required header or parameter, the response should 
be `401 Unauthorized`:

```http
HTTP/1.1 401 Unauthorized
...

{
  "message": "No API key found in request"
}
```

## Next Steps

Now that you've configured the **basic-auth** plugin, let's learn to add
Consumers to your API so we can continue proxying requests through Kong.

Go to [Adding Consumers &rsaquo;][adding-consumers]

[basic-auth]: enterprise/{{page.kong_version}}/plugins/key-authentication
[plugins]: enterprise/{{page.kong_version}}/plugins
[adding-consumers]: /enterprise/{{page.kong_version}}/getting-started/adding-consumers
