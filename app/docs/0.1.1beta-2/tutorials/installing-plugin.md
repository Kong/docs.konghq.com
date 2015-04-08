---
title: Tutorials - Installing a Plugin
---

# Installing a Plugin

One of Kong's core principle is its extensibility through [Plugins](/plugins/), which allow you to add features to your APIs.

Let's configure the [Key Authentication](/plugins/key-authentication/) plugin to add a simple key authentication to the API.

## 1. Enabling the Plugin

We nedd to make sure that the plugin name is in the `plugins_available` property of your node's configuration:

```yaml
plugins_available:
  - keyauth
```

This will make Kong load the plugin. When changing the configuration file, we need to restart Kong:

```bash
$ kong restart
```

Repeat this step for every node in your cluster.

## 2. Configuring the Plugin

To enable the plugin on the API, we need to retrieve the API `id` that has been created when we added the API on Kong. We can list all of the APIs configured on Kong by executing:

```
$ curl http://127.0.0.1:8001/apis/
```

Once we have got the `id` of the API, we can configure the key authentication plugin by performing a `POST` request with the following parameters:

* **name**: name of the Plugin
* **api_id**: `id` of the API the plugin will be added to
* **value.key_names**: `value` is a property that is being shared by every plugin, and it is where their configuration is being set. As documented in the [Plugin's Profile](/plugins/key-authentication/#configuration), `key_names` is a comma-separated string array that represents the key names, header names or JSON property nams where Kong will look for a credential.

We would like every API consumer to send their credential in an `apikey` field, so we would configure the Plugin like this:

```bash
$ curl -i -X POST \
  --url http://127.0.0.1:8001/plugins_configurations/ \
  --data 'name=keyauth&api_id=<api_id>&value.key_names=apikey'
HTTP/1.1 201 Created
...
{
  "api_id": "<api_id>",
  "value": { "key_names":["apikey"], "hide_credentials":false },
  "id": "<id>",
  "enabled": true,
  "name": "keyauth"
}
```

Here we go, the Plugin has been successfully configured and enabled.

If we now try to make an HTTP request to the same API, Kong will tell us that we are not authenticated to make the request.

```bash
$ curl -i -X GET \
  --url http://127.0.0.1:8000/ \
  --header 'Host: api.mockbin.com'
HTTP/1.1 403 Forbidden
...
{ "message": "Your authentication credentials are invalid" }
```

That happened because the request we made didn't provide a key named `apikey` (as specified by our plugin configuration) and it has been blocked by Kong. The request never reached the final API.

To authenticate against the API, we need to pass a credential along with the request. As documented in the [Plugin's Usage](/plugins/key-authentication/), we need to create a [Consumer](/docs/{{site.latest}}/api/#consumer-object) and a credential key:

```bash
$ curl -i -X POST \
  --url http://127.0.0.1:8001/consumers/
  --data 'username=tutorial_user'
HTTP/1.1 201 Created

# Make sure the given consumer_id matches the freshly created account:
$ curl -i -X POST \
  --url http://127.0.0.1:8001/keyauth_credentials/
  --data 'key=123456&consumer_id=<consumer_id>'
HTTP/1.1 201 Created
```

That consumer with an associated `123456` key credential can now consume the API. We can retry to make the request passing the proper value into an `apikey` parameter:

```bash
$ curl -i -X GET \
  --url http://127.0.0.1:8000/?apikey=123456 \
  --header 'Host: api.mockbin.com'
HTTP/1.1 200 OK
```

Success! The request was proxied successfully to the final API.

To go further into mastering Kong and its plugins, refer to the complete [documentation](/docs/), and read carefully each plugin's instruction in the [Plugins Gallery](/plugins/).
