---
title: Enabling a Plugin on a Service
no_search: true
no_version: true
beta: true
---
In this topic, you’ll learn how to enable and configure a simple plugin for a
Service Version.

If you are following the getting started workflow, make sure you have completed
[Configuring a Service](/konnect/configuring-a-service) before moving on.

## What is a Plugin?

Plugins provide advanced functionality and extend the use of
{{site.konnect_product_name}}, which allows you to add new features to your
implementation. Plugins can be configured to run in a variety of contexts,
ranging from a specific Service Version, one Route, to all Upstreams, and can
execute actions inside Kong before or after a request has been proxied to the
upstream API, as well as on any incoming responses.

## Configure a Plugin on a Service

In this example, you'll configure the
[IP Restriction plugin](/hub/kong-inc/ip-restriction). This plugin restricts
access to a Service Version or a Route by either allowing or denying IP
addresses.

1. Open the overview page for your Service Version.

2. Scroll down to the **Plugins** section and select **New Plugin**.

3. Find and select the **IP Restriction** plugin.

4. On the **Create new ip-restriction plugin** page, enter an IP address into
the allow field.

    Entering any value into this field implicitly sets a deny rule for any
    IP not appearing in the allow list.

    For the purpose of this example, enter the localhost IP (`127.0.0.1`).

5. Click **Create** to save.

## Validate the IP Restriction Plugin
1. Copy the Proxy URL from your Service Version overview.

2. From a browser, access the Route you implemented earlier:
    ```
    <proxy-url>/mock
    ```
    If the plugin was successfully enabled and the only the localhost IP address
    is allowed, you should see:
    ```
    Kong Error
    Your IP address is not allowed.
    ```

## Disable the Plugin

Disable the IP Restriction plugin so that you can keep progressing through the
tasks in this guide.

1. On the overview page for your Service Version, scroll down to the Plugins
section.

2. Click the toggle for the IP Restriction plugin to disable it.

3. Verify that it worked by visiting the `/mock` route again.

## Summary and Next Steps

In this topic, you:
* Enabled the IP Restriction plugin on a Service Version, configuring a deny
rule for your IP address.
* Tested that your IP was denied.
* Disabled the plugin.

Next, [enable a plugin on a Route](/konnect/getting-started/enable-route-plugin).
