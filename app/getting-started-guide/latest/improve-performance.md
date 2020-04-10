---
title: Improve Performance with Proxy Caching
---

In this topic, you’ll learn how to use proxy caching to improve response efficiency using Kong Gateway’s Proxy Caching plugin.

If you are following the getting started workflow, make sure you have completed [Protect your Services](/getting-started-guide/{{page.kong_version}}/protect-services) before moving on.

## What is Proxy Caching?

Kong Gateway delivers fast performance through caching. The Proxy Caching plugin provides this fast performance using a reverse proxy cache implementation. It caches response entities based on the request method, configurable response code, content type, and can cache per Consumer or per API.

Cache entities are stored for a configurable period of time. When the timeout is reached, Kong Gateway forwards the request to the upstream, caches the result and responds from cache until the timeout. The plugin can store cached data in memory, or for improved performance, in Redis.

## Why use Proxy Caching?

Use proxy caching so that upstream services are not bogged down with repeated requests, and instead, Kong Gateway can respond with cached results.

## Set up the Proxy Caching plugin

{% navtabs %}
{% navtab Using the Admin API %}

Call the Admin API on port `8001` and configure plugins to enable in-memory caching globally, with a timeout of 30 seconds for Content-Type `application/json`.

*Using cURL*:
```
$ curl -i -X POST http://<admin-hostname>:8001/plugins \
--data name=proxy-cache \
--data config.content_type="application/json" \
--data config.cache_ttl=30 \
--data config.strategy=memory
```

*Or using HTTPie*:
```
$ http -f :8001/plugins name=proxy-cache config.strategy=memory config.content_type="application/json"
```

{% endnavtab %}
{% navtab Using Kong Manager %}

1. Access your Kong Manager instance and your **default** workspace.

2. Go to **API Gateway** and click **Plugins**.

3. Click **New Plugin**.

4. Scroll down to the Traffic Control section and find the **Proxy Caching** plugin.

5. Click **Enable**.

6. Select to apply the plugin as **Global**. This means that proxy caching applies to all requests.

7. Scroll down and complete only the following fields with the parameters listed.
    1. config.cache_ttl: `30`
    2. config.content_type: `application/json`
    3. config.strategy: `memory`

    Besides the above fields, there may be others populated with default values. For this example, leave the rest of the fields as they are.

8. Click **Create**.
{% endnavtab %}
{% endnavtabs %}


## Validate Proxy Caching

Let’s check that proxy caching works.

1. Access the */mock* route using the Admin API and note the response headers.

    *Using cURL*:
    ```
    $ curl -i -X GET http://<admin-hostname>:8000/mock/request
    ```

    *Or using HTTPie*:
    ```
    $ http :8000/mock/request
    ```

    In particular, pay close attention to the values of `X-Cache-Status`, `X-Kong-Proxy-Latency`, and `X-Kong-Upstream-Latency`:
    ```
    HTTP/1.1 200 OK
    ...
    X-Cache-Key: d2ca5751210dbb6fefda397ac6d103b1
    X-Cache-Status: Miss
    X-Content-Type-Options: nosniff
    ...
    X-Kong-Proxy-Latency: 25
    X-Kong-Upstream-Latency: 37

    ```

2. Access the */mock* route one more time.

    This time, notice the differences in the values of `X-Cache-Status`, `X-Kong-Proxy-Latency`, and `X-Kong-Upstream-Latency`. Cache status is a `hit`, which means Kong Gateway is responding to the request directly from cache instead of proxying the request to the upstream service.

    Further, notice the minimal latency in the response, which allows Kong Gateway to deliver the best performance:

    ```
    HTTP/1.1 200 OK
    ...
    X-Cache-Key: d2ca5751210dbb6fefda397ac6d103b1
    X-Cache-Status: Hit
    ...
    X-Kong-Proxy-Latency: 0
    X-Kong-Upstream-Latency: 1
    ```

3. To test more rapidly, the cache can be deleted by calling the Admin API:

    *Using cURL*:
    ```
    $ curl -i -X DELETE http://<admin-hostname>:8001/proxy-cache
    ```
    *Or using HTTPie*:
    ```
    $ http delete :8001/proxy-cache
    ```

## Summary and Next Steps

In this section, you:

* Set up the Proxy Caching plugin, then accessed the `/mock` route multiple times to see caching in effect.
* Saw the differences in latency with caching and without.

Next, you’ll learn about [securing services](/getting-started-guide/{{page.kong_version}}/secure-services).
