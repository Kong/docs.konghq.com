---
title: Configure key authentication
---
In this topic, you’ll learn about API Gateway authentication, set up the Key Authentication plugin, and add a consumer.  

If you are following the getting started workflow, make sure you have completed [Improve Performance with Proxy Caching](/gateway/{{page.kong_version}}/get-started/comprehensive/improve-performance) before moving on.

## What is Authentication?

API gateway authentication is an important way to control the data that is allowed to be transmitted using your APIs. Basically, it checks that a particular consumer has permission to access the API, using a predefined set of credentials.

{{site.base_gateway}} has a library of plugins that provide simple ways to implement the best known and most widely used [methods of API gateway authentication](/hub/#authentication). Here are some of the commonly used ones:

* Basic Authentication
* Key Authentication
* OAuth 2.0 Authentication
* LDAP Authentication Advanced
* OpenID Connect

Authentication plugins can be configured to apply to service entities within the {{site.base_gateway}}. In turn, service entities are mapped one-to-one with the upstream services they represent, essentially meaning that the authentication plugins apply directly to those upstream services.

## Why use API Gateway Authentication?

With authentication turned on, {{site.base_gateway}} won’t proxy requests unless the client successfully authenticates first. This means that the upstream (API) doesn’t need to authenticate client requests, and it doesn’t waste critical resources validating credentials.

{{site.base_gateway}} has visibility into all authentication attempts, successful, failed, and so on, which provides the ability to catalog and dashboard those events to prove the right controls are in place, and to achieve compliance. Authentication also gives you an opportunity to determine how a failed request is handled. This might mean simply blocking the request and returning an error code, or in some circumstances, you might still want to provide limited access.

In this example, you’re going to enable the **Key Authentication plugin**. API key authentication is one of the most popular ways to conduct API authentication and can be implemented to create and delete access keys as required.

For more information, see [What is API Gateway Authentication?](https://konghq.com/learning-center/api-gateway/api-gateway-authentication).

## Set up the Key Authentication Plugin

Call the Admin API on port `8001` and configure plugins to enable key
authentication. For this example, apply the plugin to the */mock* route you
created:


```sh
curl -X POST http://localhost:8001/routes/mocking/plugins \
  --data name=key-auth
```

Try to access the service again:

```sh
curl -i http://localhost:8000/mock
```



Since you added key authentication, you should be unable to access it:

```sh
HTTP/1.1 401 Unauthorized
...
{
    "message": "No API key found in request"
}
```

Before Kong proxies requests for this route, it needs an API key. For this
example, since you installed the Key Authentication plugin, you need to create
a consumer with an associated key first.


## Set up Consumers and Credentials


To create a consumer, call the Admin API and the consumer’s endpoint.
The following creates a new consumer called **consumer**:



```sh
curl -i -X POST http://localhost:8001/consumers/ \
  --data username=consumer \
  --data custom_id=consumer
```


Once provisioned, call the Admin API to provision a key for the consumer
created above. For this example, set the key to `apikey`.



```sh
curl -i -X POST http://localhost:8001/consumers/consumer/key-auth \
  --data key=apikey
```


If no key is entered, Kong automatically generates the key.

Result:

```sh
HTTP/1.1 201 Created
...
{
    "consumer": {
        "id": "2c43c08b-ba6d-444a-8687-3394bb215350"
    },
    "created_at": 1568255693,
    "id": "86d283dd-27ee-473c-9a1d-a567c6a76d8e",
    "key": "apikey"
}
```

You now have a consumer with an API key provisioned to access the route.

## Validate Key Authentication

To validate the Key Authentication plugin, access the *mocking* route again, using the header `apikey` with a key value of `apikey`.

```sh
curl -i http://localhost:8000/mock/request \
  -H 'apikey:apikey'
```
You should get an `HTTP/1.1 200 OK` message in response.

## (Optional) Disable the plugin
If you are following this getting started guide topic by topic, you will need to use this API key in any requests going forward. If you don’t want to keep specifying the key, disable the plugin before moving on.


Find the plugin ID and copy it:

```sh
curl -X GET http://localhost:8001/routes/mocking/plugins/
```


Output:
```sh
"id": "2512e48d9-7by0-674c-84b7-00606792f96b"
```

Disable the plugin:

```sh
curl -X PATCH http://localhost:8001/routes/mocking/plugins/{<plugin-id>} \
  --data enabled=false
```

## Summary and next steps

In this topic, you:

* Enabled the Key Authentication plugin.
* Created a new consumer named `consumer`.
* Gave the consumer an API key of `apikey` so that it could access the `/mock` route with authentication.

Next, you’ll learn about [load balancing upstream services using targets](/gateway/{{page.kong_version}}/get-started/comprehensive/load-balancing).
