---
title: Configure Dynamic Plugin Ordering
content_type: tutorial
---

This page explains how to configure dynamic plugin ordering in {{site.konnect_short_name}} by using the common use case of the [Rate Limiting Advanced plugin](/hub/kong-inc/rate-limiting-advanced/).

The order in which plugins are executed in {{site.konnect_short_name}} is determined by their
`static priority`. As the name suggests, this value is _static_ and can't be easily changed by the user.

You can override the priority for any {{site.konnect_short_name}} plugin using each plugin's
`ordering` field. This determines plugin ordering during the `access` phase,
and lets you create _dynamic_ dependencies between plugins.

## Rate limiting before authentication

Let's say you want to limit the amount of requests against your service and route
*before* Kong requests authentication. You can describe this dependency with the
token `before`.

The following example uses the [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced)
plugin with the [Key Authentication](/hub/kong-inc/key-auth) plugin as the
authentication method.