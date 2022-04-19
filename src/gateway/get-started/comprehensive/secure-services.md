---
title: Secure your Services Using Authentication
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

For more information, see [What is API Gateway Authentication?](https://konghq.com/learning-center/api-gateway/api-gateway-authentication/).

## Set up the Key Authentication Plugin

{% navtabs %}
{% navtab Using Kong Manager %}

1. Access your Kong Manager instance and your **default** workspace.
2. Go to the **Routes** page and select the **mocking** route you created.
3. Click **View**.
4. On the Scroll down and select the **Plugins** tab, then click **Add a Plugin**.
5. In the Authentication section, find the **Key Authentication** plugin and click **Enable**.
6. In the **Create new key-auth plugin** dialog, the plugin fields are automatically scoped to the route because the plugin is selected from the mocking Routes page.

    For this example, this means that you can use all of the default values.

7. Click **Create**.

    Once the plugin is enabled on the route, **key-auth** displays under the Plugins section on the route’s overview page.

Now, if you try to access the route without providing an API key, the request will fail, and you’ll see the message `"No API key found in request".`

Before Kong proxies requests for this route, it needs an API key. For this example, since you installed the Key Authentication plugin, you need to create a consumer with an associated key first.
{% endnavtab %}
{% navtab Using the Admin API %}

Call the Admin API on port `8001` and configure plugins to enable key
authentication. For this example, apply the plugin to the */mock* route you
created:

<!-- codeblock tabs -->
{% navtabs codeblock %}
{% navtab cURL %}
```sh
curl -X POST http://<admin-hostname>:8001/routes/mocking/plugins \
  --data name=key-auth
```
{% endnavtab %}
{% navtab HTTPie %}
```sh
http :8001/routes/mocking/plugins \
  name=key-auth
```
{% endnavtab %}
{% endnavtabs %}
<!-- end codeblock tabs -->

Try to access the service again:

<!-- codeblock tabs -->
{% navtabs codeblock %}
{% navtab cURL %}
```sh
curl -i http://<admin-hostname>:8000/mock
```
{% endnavtab %}
{% navtab HTTPie %}
```sh
http :8000/mock
```
{% endnavtab %}
{% endnavtabs %}
<!-- end codeblock tabs -->

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

{% endnavtab %}
{% navtab Using decK (YAML) %}
1. Under the `mocking` route in the `routes` section of the `kong.yaml` file,
add a plugin section and enable the `key-auth` plugin:

    ``` yaml
    plugins:
    - name: key-auth
    ```

    Your file should now look like this:

    ``` yaml
    _format_version: "1.1"
    services:
    - host: mockbin.org
      name: example_service
      port: 80
      protocol: http
      routes:
      - name: mocking
        paths:
        - /mock
        strip_path: true
        plugins:
        - name: key-auth
    plugins:
    - name: rate-limiting
      config:
        minute: 5
        policy: local
    - name: proxy-cache
      config:
        content_type:
        - "application/json; charset=utf-8"
        cache_ttl: 30
        strategy: memory
    ```

2. Sync the configuration:

    ``` bash
    deck sync
    ```

Now, if you try to access the route at `http://<admin-hostname>:8000/mock`
without providing an API key, the request will fail, and you’ll see the message
`"No API key found in request".`

Before Kong proxies requests for this route, it needs an API key. For this
example, since you installed the Key Authentication plugin, you need to create
a consumer with an associated key first.

{% endnavtab %}
{% endnavtabs %}


## Set up Consumers and Credentials

{% navtabs %}
{% navtab Using Kong Manager %}

1. In Kong Manager, go to **API Gateway** > **Consumers**.
2. Click **New Consumer**.
3. Enter the **Username** and **Custom ID**. For this example, use `consumer` for each field.
4. Click **Create**.
5. On the Consumers page, find your new consumer and click **View**.
6. Scroll down the page and click the **Credentials** tab.
7. Click **New Key Auth Credential**.
8. Set the key to **apikey** and click **Create**.

  The new Key Authentication ID displays on the **Consumers** page under the **Credentials** tab.
{% endnavtab %}
{% navtab Using the Admin API %}

To create a consumer, call the Admin API and the consumer’s endpoint.
The following creates a new consumer called **consumer**:

<!-- codeblock tabs -->
{% navtabs codeblock %}
{% navtab cURL %}
```sh
curl -i -X POST http://<admin-hostname>:8001/consumers/ \
  --data username=consumer \
  --data custom_id=consumer
```
{% endnavtab %}
{% navtab HTTPie %}
```sh
http :8001/consumers \
  username=consumer \
  custom_id=consumer
```
{% endnavtab %}
{% endnavtabs %}
<!-- end codeblock tabs -->

Once provisioned, call the Admin API to provision a key for the consumer
created above. For this example, set the key to `apikey`.

<!-- codeblock tabs -->
{% navtabs codeblock %}
{% navtab cURL %}
```sh
curl -i -X POST http://<admin-hostname>:8001/consumers/consumer/key-auth \
  --data key=apikey
```
{% endnavtab %}
{% navtab HTTPie %}
```sh
http :8001/consumers/consumer/key-auth \
  key=apikey
```
{% endnavtab %}
{% endnavtabs %}
<!-- end codeblock tabs -->

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

{% endnavtab %}
{% navtab Using decK (YAML) %}
1. Add a `consumers` section to your `kong.yaml` file and create a new consumer:

    ``` yaml
    consumers:
    - custom_id: consumer
      username: consumer
      keyauth_credentials:
      - key: apikey
    ```

    Your file should now look like this:

    ``` yaml
    _format_version: "1.1"
    services:
    - host: mockbin.org
      name: example_service
      port: 80
      protocol: http
      routes:
      - name: mocking
        paths:
        - /mock
        strip_path: true
        plugins:
        - name: key-auth
    consumers:
    - custom_id: consumer
      username: consumer
      keyauth_credentials:
      - key: apikey
    plugins:
    - name: rate-limiting
      config:
        minute: 5
        policy: local
    - name: proxy-cache
      config:
        content_type:
        - "application/json; charset=utf-8"
        cache_ttl: 30
        strategy: memory
    ```

2. Sync the configuration:

    ``` bash
    deck sync
    ```

You now have a consumer with an API key provisioned to access the route.

{% endnavtab %}
{% endnavtabs %}


## Validate Key Authentication

{% navtabs %}
{% navtab Using a Web Browser %}

To validate the Key Authentication plugin, access your route through your browser by appending `?apikey=apikey` to the url:
```
http://<admin-hostname>:8000/mock?apikey=apikey
```

{% endnavtab %}
{% navtab Using the Admin API %}
To validate the Key Authentication plugin, access the *mocking* route again, using the header `apikey` with a key value of `apikey`.

<!-- codeblock tabs -->
{% navtabs codeblock %}
{% navtab cURL %}
```sh
curl -i http://<admin-hostname>:8000/mock/request \
  -H 'apikey:apikey'
```
{% endnavtab %}
{% navtab HTTPie %}
```sh
http :8000/mock/request apikey:apikey
```
{% endnavtab %}
{% endnavtabs %}
<!-- end codeblock tabs -->

You should get an `HTTP/1.1 200 OK` message in response.

{% endnavtab %}
{% endnavtabs %}

## (Optional) Disable the plugin
If you are following this getting started guide topic by topic, you will need to use this API key in any requests going forward. If you don’t want to keep specifying the key, disable the plugin before moving on.

{% navtabs %}
{% navtab Using Kong Manager %}
1. Go to the Plugins page and click on **View** for the key-auth row.
2. Use the toggle at the top of the page to switch the plugin from **Enabled** to **Disabled**.
{% endnavtab %}
{% navtab Using the Admin API %}

Find the plugin ID and copy it:

<!-- codeblock tabs -->
{% navtabs codeblock %}
{% navtab cURL %}
```sh
curl -X GET http://<admin-hostname>:8001/routes/mocking/plugins/
```
{% endnavtab %}
{% navtab HTTPie %}
```sh
http :8001/routes/mocking/plugins
```
{% endnavtab %}
{% endnavtabs %}
<!-- end codeblock tabs -->

Output:
```sh
"id": "2512e48d9-7by0-674c-84b7-00606792f96b"
```

Disable the plugin:

<!-- codeblock tabs -->
{% navtabs codeblock %}
{% navtab cURL %}
```sh
curl -X PATCH http://<admin-hostname>:8001/routes/mocking/plugins/{<plugin-id>} \
  --data enabled=false
```
{% endnavtab %}
{% navtab HTTPie %}
```sh
http -f patch :8001/routes/mocking/plugins/{<plugin-id>} \
  enabled=false
```
{% endnavtab %}
{% endnavtabs %}
<!-- end codeblock tabs -->

{% endnavtab %}
{% navtab Using decK (YAML) %}

1. Disable the key-auth plugin in the `kong.yaml` file by setting
`enabled` to `false`:

    ``` yaml
    plugins:
    - name: key-auth
      enabled: false
    ```

2. Sync the configuration:

    ``` bash
    $ deck sync
    ```

{% endnavtab %}
{% endnavtabs %}

## Summary and next steps

In this topic, you:

* Enabled the Key Authentication plugin.
* Created a new consumer named `consumer`.
* Gave the consumer an API key of `apikey` so that it could access the `/mock` route with authentication.

Next, you’ll learn about [load balancing upstream services using targets](/gateway/{{page.kong_version}}/get-started/comprehensive/load-balancing).
