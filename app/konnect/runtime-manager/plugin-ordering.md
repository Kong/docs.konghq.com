---
title: Configure Dynamic Plugin Ordering
content_type: tutorial
---

This page explains how to configure dynamic plugin ordering in {{site.konnect_short_name}} by using the common use case of the [Rate Limiting Advanced plugin](/hub/kong-inc/rate-limiting-advanced/).

The order in which plugins are executed in {{site.konnect_short_name}} is determined by their
`static priority`. As the name suggests, this value is _static_ and can't be easily changed by the user. For a list of the static plugin execution order, see [Plugins execution order](/gateway/latest/plugin-development/custom-logic/#plugins-execution-order) in the {{site.base_gateway}} documentation.

You can override the priority for any {{site.konnect_short_name}} plugin using each plugin's
`ordering` field. This determines plugin ordering during the `access` phase,
and lets you create _dynamic_ dependencies between plugins.

## Rate limiting before authentication

Let's say you want to limit the amount of requests against your service and route
*before* Kong requests authentication. You can use the [Rate Limiting](/hub/kong-inc/rate-limiting)
plugin to run before the [Key Authentication](/hub/kong-inc/key-auth) plugin to accomplish this.

1. In {{site.konnect_short_name}}, open **Runtime Manager** in the sidebar and select the **default** workspace.

1. Click **Plugins** in the sidebar.

1. To add the Rate Limiting plugin, click **Add Plugin**, and then select the **Rate Limiting** plugin.

1. Complete only the following fields with the following parameters:
    * **Config.Minute:** 5
    * **Config.Policy:** local
    * **Config.Limit_by:** ip
    
    Besides the above fields, there may be others populated with default values. For this example, leave the rest of the fields as they are.

1. Click **Save**.
    
    The Rate Limiting plugin is now enabled and will limit requests against your service and route.

1. To add the Key Authentication plugin, click **Add Plugin**, and then select the **Key Authentication** plugin.

1. Click **Save**.
    
    The Key Authentication plugin is now enabled and will request authentication _before_ the Rate Limiting plugin limits requests.

1. From the plugin page, click the context menu for the Rate Limiting plugin and select **Configure Dynamic Ordering**. 

1. In the **Before** section of the execution order access phase, click **Add Plugin** and select the Key Authentication plugin. 

Now, the Rate Limiting plugin will limit requests _before_ the Key Authentiation plugin requests authentication.


## Authentication after request transformation

The following example is similar to running rate limiting before authentication.

For example, you may want to first transform a request, then request authentication
*after* transformation. Instead of changing the order of the [Request Transformer](/hub/kong-inc/request-transformer)
plugin, you can change the order of the authentication plugin
([Basic Authentication](/hub/kong-inc/basic-auth), in this example).

1. In {{site.konnect_short_name}}, open **Runtime Manager** in the sidebar and select the **default** workspace.

1. Click **Plugins** in the sidebar.

1. To add the Basic Authentication plugin, click **Add Plugin**, and then select the **Basic Authentication** plugin.

1. Click **Save**.
    
    The Basic Authentication plugin is now enabled and will request authentication.

1. To add the Request Transformer plugin, click **Add Plugin**, and then select the **Request Transformer** plugin.

1. Click **Save**.
    
    The Request Transformer plugin is now enabled and will transform a request _after_ the Basic Authentication plugin requests authentication.

1. From the plugin page, click the context menu for the Basic Authentication plugin and select **Configure Dynamic Ordering**. 

1. In the **After** section of the execution order access phase, click **Add Plugin** and select the Request Transformer plugin. 

Now, the Basic Authentication plugin requests authentication _after_ the Request Transformer plugin transforms requests.