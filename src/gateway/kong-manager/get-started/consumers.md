---
title: Authentication with Consumers
---

In this example, you’re going to enable the **Key Authentication plugin**, then create a consumer that uses key authentication. API key authentication is one of the most popular ways to conduct API authentication and can be implemented to create and delete access keys as required.

## Set up the Key Authentication Plugin

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


## Set up Consumers and Credentials

1. In Kong Manager, go to **API Gateway** > **Consumers**.
2. Click **New Consumer**.
3. Enter the **Username** and **Custom ID**. For this example, use `consumer` for each field.
4. Click **Create**.
5. On the Consumers page, find your new consumer and click **View**.
6. Scroll down the page and click the **Credentials** tab.
7. Click **New Key Auth Credential**.
8. Set the key to **apikey** and click **Create**.

  The new Key Authentication ID displays on the **Consumers** page under the **Credentials** tab.

## Validate Key Authentication

To validate the Key Authentication plugin, access your route through your browser by appending `?apikey=apikey` to the url:
```
http://<admin-hostname>:8000/mock?apikey=apikey
```

## Summary and next steps

In this topic, you:

* Enabled the Key Authentication plugin.
* Created a new consumer named `consumer`.
* Gave the consumer an API key of `apikey` so that it could access the `/mock` route with authentication.

Next, you’ll learn about [load balancing upstream services using targets](/gateway/{{page.kong_version}}/get-started/comprehensive/load-balancing).
