---
title: Improve Performance with Proxy Caching
---

In this topic, you’ll learn how to use proxy caching to improve response efficiency using the Proxy Caching plugin.

If you are following the getting started workflow, make sure you have completed [Protect your Services](/getting-started-guide/{{page.kong_version}}/protect-services) before continuing.

## What is Proxy Caching?

{{site.base_gateway}} delivers fast performance through caching. The Proxy Caching plugin provides this fast performance using a reverse proxy cache implementation. It caches response entities based on the request method, configurable response code, content type, and can cache per Consumer or per API.

Cache entities are stored for a configurable period of time. When the timeout is reached, the gateway forwards the request to the Upstream, caches the result and responds from cache until the timeout. The plugin can store cached data in memory, or for improved performance, in Redis.

## Why use Proxy Caching?

Use proxy caching so that Upstream services are not bogged down with repeated requests. With proxy caching, {{site.base_gateway}} can respond with cached results for better performance.

## Set up the Proxy Caching plugin

{% navtabs %}
{% navtab Using Kong Manager %}

1. Access your Kong Manager instance and your **default** workspace.

2. Go to **API Gateway** and click **Plugins**.

3. Click **New Plugin**.

4. Scroll down to the Traffic Control section and find the **Proxy Caching** plugin.

5. Click **Enable**.

6. Select to apply the plugin as **Global**. This means that proxy caching applies to all requests.

7. Scroll down and complete only the following fields with the parameters listed.
    1. config.cache_ttl: `30`
    2. config.content_type: `application/json; charset=utf-8`
    3. config.strategy: `memory`

    Besides the above fields, there may be others populated with default values. For this example, leave the rest of the fields as they are.

8. Click **Create**.
{% endnavtab %}
{% navtab Using the Admin API %}

Call the Admin API on port `8001` and configure plugins to enable in-memory caching globally, with a timeout of 30 seconds for Content-Type `application/json`.

<!-- codeblock tabs -->
{% navtabs codeblock %}
{% navtab cURL %}
```sh
$ curl -i -X POST http://<admin-hostname>:8001/plugins \
  --data name=proxy-cache \
  --data config.content_type="application/json; charset=utf-8" \
  --data config.cache_ttl=30 \
  --data config.strategy=memory
```
{% endnavtab %}
{% navtab HTTPie %}
```sh
$ http -f :8001/plugins \
  name=proxy-cache \
  config.strategy=memory \
  config.cache_ttl=30 \
  config.content_type="application/json; charset=utf-8"
```
{% endnavtab %}
{% endnavtabs %}
<!-- end codeblock tabs -->

{% endnavtab %}
{% navtab Using decK (YAML) %}

1. In the `plugins` section of your `kong.yaml` file, add the `proxy-cache`
plugin with a timeout of 30 seconds for Content-Type
`application/json; charset=utf-8`.

    ``` yaml
    plugins:
    - name: proxy-cache
      config:
        content_type:
        - "application/json; charset=utf-8"
        cache_ttl: 30
        strategy: memory
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

    ```bash
    $ deck sync
    ```

{% endnavtab %}
{% endnavtabs %}


## Validate Proxy Caching

Let’s check that proxy caching works. You'll need the Kong Admin API for this
step.

Access the */mock* route using the Admin API and note the response headers:

<!-- codeblock tabs -->
{% navtabs codeblock %}
{% navtab cURL %}
```sh
$ curl -i -X GET http://<admin-hostname>:8000/mock/request
```
{% endnavtab %}
{% navtab HTTPie %}
```sh
$ http :8000/mock/request
```
{% endnavtab %}
{% endnavtabs %}
<!-- end codeblock tabs -->

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

Next, access the */mock* route one more time.

This time, notice the differences in the values of `X-Cache-Status`, `X-Kong-Proxy-Latency`, and `X-Kong-Upstream-Latency`. Cache status is a `hit`, which means Kong Gateway is responding to the request directly from cache instead of proxying the request to the Upstream service.

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

To test more rapidly, the cache can be deleted by calling the Admin API:

<!-- codeblock tabs -->
{% navtabs codeblock %}
{% navtab cURL %}
```sh
$ curl -i -X DELETE http://<admin-hostname>:8001/proxy-cache
```
{% endnavtab %}
{% navtab HTTPie %}
```sh
$ http delete :8001/proxy-cache
```
{% endnavtab %}
{% endnavtabs %}
<!-- end codeblock tabs -->

## Summary and Next Steps

In this section, you:

* Set up the Proxy Caching plugin, then accessed the `/mock` route multiple times to see caching in effect.
* Witnessed the performance differences in latency with and without caching.

Next, you’ll learn about [securing services](/getting-started-guide/{{page.kong_version}}/secure-services).
