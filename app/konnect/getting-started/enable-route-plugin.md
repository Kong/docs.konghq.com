---
title: Enabling a Plugin on a Route
no_search: true
no_version: true
beta: true
---
In this topic, you’ll learn how to enable and configure the Key Authentication
plugin for a Route, and add a Consumer.

If you are following the getting started workflow, make sure you have completed
[Configuring a Service](/konnect/configuring-a-service) before moving on.

## What is Authentication?

API gateway authentication is an important way to control the data that is
allowed to be transmitted using your APIs. Basically, it checks that a
particular consumer has permission to access the API, using a predefined set of
credentials.

{{site.konnect_product_name}} provides access to a library of plugins that
give you simple ways to implement the best known and most widely used
[methods of API gateway authentication](/hub/#authentication).
Here are some of the commonly used ones:

* Basic Authentication
* Key Authentication
* OAuth 2.0 Authentication
* LDAP Authentication Advanced
* OpenID Connect

Authentication plugins can be configured to apply to Service Versions or Routes
within {{site.konnect_product_name}}. In turn, those Services Versions or Routes
are mapped one-to-one with the upstream services they represent, essentially
meaning that the authentication plugins apply directly to those upstream
services.

## Enable the Plugin on a Route

1. Open the overview page for your Service Version.

2. Scroll down to the Routes section and select the `/mock` Route you created
earlier.

3. On the Route's overview page, scroll down to Plugins and select
**Add Plugin**.

4. Find and select the **Key Authentication** plugin.

5.  In the **Create new key-auth plugin** dialog, use all of the default values.

    Note the value in the `Config.Key Names` field. You'll need this later.

6. Click **Create** to save.

## Create a Consumer

1. In Konnect's left navigation, open the **Shared Config** section, located
at the bottom of the menu.

2. Open **Consumers** from the menu that appears.

3. Click **New Consumer**.

3. Enter a **Username** and **Custom ID**. For this example, use `consumer` for
each field.

4. Click **Create** to save.

5. Open the Consumer you just created.

6. On the Consumer's overview page, scroll down the page and click the
**Credentials** tab.

7. Click **New Key Auth Credential**.

8. Set the key to `apikey` and click **Create**.

## Validate Key Authentication

To validate the Key Authentication plugin, access your Route through your
browser by appending `?apikey=apikey` to the url:

```
<proxy-url>/mock/?apikey=apikey
```

## Disable the Plugin

1. Return to the overview page for your Route by going to **Services** >
**example_service** > **v1** > **mocking** Route.

2. Scroll down to the Plugins section.

3. Select the key-auth plugin.

4. Click **Edit Plugin** in the top right, then switch the toggle at the top of
the page.

    The toggle should now display:
    ```
    This plugin is Disabled.
    ```

5. Click **Update** to save.

6. Verify that it worked by visiting the `/mock` route without `?apikey=apikey`.

    ```
    <proxy-url>/mock
    ```

## Summary and Next Steps

In this topic, you:
* Enabled the Key Authentication plugin on a Route.
* Created a new consumer named `consumer`.
* Gave the consumer an API key of `apikey` so that it could access the `/mock`
route with authentication.
* Disabled the plugin.

Next, [monitor the health of your Services and Routes with Vitals](/konnect/getting-started/vitals).
