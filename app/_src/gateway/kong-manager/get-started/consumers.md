---
title: Authentication with Consumers
badge: free
---

In this example, you’re going to enable the **Key Authentication plugin**, then create a consumer that uses key authentication. API key authentication is one of the most popular ways to conduct API authentication and can be implemented to create and delete access keys as required.

If you prefer to use the Admin API, check out the [{{site.base_gateway}} getting started guide](/gateway/latest/get-started/key-authentication/).

## Set up the Key Authentication Plugin

From the **Workspaces** tab in Kong Manager:

1. Open the **default** workspace.
2. From the menu, open **Routes** and select the **mocking** route you created.
4. From the sub-menu, select the **Plugins** tab, then click **Install Plugin**.
5. Find the **Key Authentication** plugin and click **Enable**.
6. On the **Install plugin: key-auth** page, the plugin fields are automatically scoped to the route because the plugin is selected from the mocking route's page.

    For this example, this means that you can use all of the default values.
7. Click **Create**.

Now, if you try to access the route without providing an API key, the request will fail, and you’ll see the message `"No API key found in request".`

Before Kong proxies requests for this route, it needs an API key. For this example, since you installed the Key Authentication plugin, you need to create a consumer with an associated key first.


## Set up Consumers and Credentials

From the **Workspaces** tab in Kong Manager:

1. Open the **default** workspace.
2. From the menu, open **Consumers**, then click **New Consumer**.
3. Enter a **Username** and **Custom ID**. For this example, you can use `consumer` for each field.
4. Click **Create**.
5. On the Consumers page, open your new consumer.
6. Open **Credentials** from the sub-menu.
7. Click **New Key Auth Credential**.
8. Set the key to `apikey` and click **Create**.

The new Key Authentication ID displays on the **Consumers** page under the **Credentials** tab.

## Validate Key Authentication

To validate the Key Authentication plugin, access your route through your browser by appending `?apikey=apikey` to the url:

```
http://localhost:8000/mock?apikey=apikey
```

## Next steps

Next, you’ll learn about [load balancing upstream services using targets](/gateway/{{page.release}}/kong-manager/get-started/load-balancing/).
