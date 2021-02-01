---
title: Protect your Services
---
In this topic, you’ll learn how to enforce rate limiting using the Rate Limiting plugin.

If you are following the getting started workflow, make sure you have completed [Exposing Your Services](/getting-started-guide/{{page.kong_version}}/expose-services) before moving on.

## What is Rate Limiting?

Rate Limiting lets you restrict how many requests your upstream services receive from your API consumers, or how often each user can call the API.

<div class="alert alert-ee">
<img class="no-image-expand" src="/assets/images/icons/icn-enterprise-grey.svg" alt="Enterprise" /> For Kong Enterprise, the Rate Limiting Advanced plugin provides support for the sliding window algorithm to prevent the API from being overloaded near the window boundaries, and adds Redis support for greater performance.
</div>

## Why Use Rate Limiting?

Rate limiting protects the APIs from accidental or malicious overuse. Without rate limiting, each user may request as often as they like, which can lead to spikes of requests that starve other consumers. After rate limiting is enabled, API calls are limited to a fixed number of requests per second.

## Set up Rate Limiting

{% navtabs %}
{% navtab Using the Admin API %}

<div class="alert alert-ee">
<img class="no-image-expand" src="/assets/images/icons/icn-enterprise-grey.svg" alt="Enterprise" /><strong>Note:</strong> This section sets up the basic Rate Limiting plugin. If you have Kong Enterprise access, see instructions for <strong>Using Kong Manager</strong> to set up Rate Limiting Advanced instead.
</div>

Call the Admin API on port `8001` and configure plugins to enable a limit of five (5) requests per minute, stored locally and in-memory, on the node.

*Using cURL*:
```
$ curl -i -X POST http://<admin-hostname>:8001/plugins \
--data "name=rate-limiting" \
--data "config.minute=5" \
--data "config.policy=local"
```
*Or using HTTPie*:
```
$ http -f post :8001/plugins name=rate-limiting config.minute=5 config.policy=local
```
{% endnavtab %}

{% navtab Using Kong Manager %}

1. Access your Kong Manager instance and your **default** workspace.

2. Go to **API Gateway** > **Plugins**.

3. Click **New Plugin**.

4. Scroll down to **Traffic Control** and find the **Rate Limiting Advanced** plugin. Click **Enable**.

5. Apply the plugin as **Global**, which means the rate limiting applies to all requests, including every Service and Route in the Workspace.

    If you switched it to **Scoped**, the rate limiting would apply the plugin to only one Service, Route, and/or Consumer.

    **Note**: By default, the plugin is automatically enabled when the form is submitted. You can also toggle the **This plugin is Enabled** button at the top of the form to configure the plugin without enabling it. For this example, keep the plugin enabled.

6. Scroll down and complete only the following fields with the following parameters.
    1. config.limit: `5`
    2. config.sync_rate: `-1`
    3. config.window_size: `30`

    Besides the above fields, there may be others populated with default values. For this example, leave the rest of the fields as they are.

7. Click **Create**.
{% endnavtab %}
{% endnavtabs %}


## Validate Rate Limiting

{% navtabs %}
{% navtab Using the Admin API %}

To validate rate limiting, access the API six (6) times from the CLI to confirm the requests are rate limited.

*Using cURL*:
```
$ curl -i -X GET http://<admin-hostname>:8000/mock/request
```
*Or using HTTPie*:
```
$ http :8000/mock/request
```

After the 6th request, you should receive a 429 "API rate limit exceeded" error:
```
{
"message": "API rate limit exceeded"
}
```
{% endnavtab %}
{% navtab Using a Web Browser %}

1. Enter `<admin-hostname>:8000/mock` and refresh your browser six times.
    After the 6th request, you’ll receive an error message.
2. Wait at least 30 seconds and try again.
    The service will be accessible until the sixth (6th) access attempt within a 30-second window.

{% endnavtab %}
{% endnavtabs %}


## Summary and next steps

In this section:
* If using Kong Community Gateway, you enabled the Rate Limiting plugin, setting the rate limit to 5 times per minute.
* If using Kong Enterprise Gateway, you enabled the Rate Limiting Advanced plugin, setting the rate limit to 5 times for every 30 seconds.

Next, head on to learn about [proxy caching](/getting-started-guide/{{page.kong_version}}/improve-performance).
