---
title: Get Started with Dynamic Plugin Ordering
badge: enterprise
content_type: how-to
---

The following examples are a result of the most common requests we received for this feature.

### Rate-limiting before Authentication


In this case we want to limit the amount of requests against our service/route even before we hit authentication.

For this example I'm using the key-auth plugin as the authentication plugin.

{% navtabs %}
{% navtab Using the Admin API %}

{:.note}
> **Note:** This section sets up the basic Rate Limiting plugin. If you have a {{site.base_gateway}} instance, see instructions for **Using Kong Manager** to set up Rate Limiting Advanced with sliding window support instead.

Call the Admin API on port `8001` and configure plugins to enable a limit of five (5) requests per minute, stored locally and in-memory, on the node.

<!-- codeblock tabs -->
{% navtabs codeblock %}
{% navtab cURL %}
```sh
curl -i -X POST http://<admin-hostname>:8001/plugins \
  --data name=rate-limiting \
  --data config.minute=5 \
  --data config.policy=local \
  --data ordering.before.access=key-auth
```
{% endnavtab %}
{% navtab HTTPie %}
```sh
http -f post :8001/plugins \
  name=rate-limiting \
  config.minute=5 \
  config.policy=local \
  ordering.before.access=key-auth
```
{% endnavtab %}
{% endnavtabs %}
<!-- end codeblock tabs -->

{% endnavtab %}
{% navtab Using decK (YAML) %}

{:.note}
> **Note:** This section sets up the basic Rate Limiting plugin. If you have a {{site.base_gateway}} instance, see instructions for **Using Kong Manager** to set up Rate Limiting Advanced with sliding window support instead.

1. Add a new `plugins` section to the bottom of your `kong.yaml` file. Enable
`rate-limiting` with a limit of five (5) requests per minute, stored locally
and in-memory, on the node:

    ``` yaml
    plugins:
    - name: rate-limiting
      config:
        minute: 5
        policy: local
      ordering:
        before:
          access:
            - key-auth
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
      ordering:
        before:
          access:
            - key-auth
    ```

    This plugin will be applied globally, which means the rate limiting
    applies to all requests, including every Service and Route in the Workspace.

    If you pasted the plugin section under an existing Service, Route, or
    Consumer, the rate limiting would only apply to that specific
    entity.

    >**Note**: By default, `enabled` is set to `true` for the plugin. You can
    disable the plugin at any time by setting `enabled: false`.

2. Sync the configuration:

    ``` bash
    deck sync
    ```

{% endnavtab %}
{% endnavtabs %}


### Authentication after Request-Transformer


This is similar to the "Rate-Limiting before Authentication". Here we want to *always* transform a request and then run an authentication plugin. We can describe this dependency with another supported token called `after`. Instead of changing the order of the "Request-Transformer" plugin, we can also change the order of the authentication plugin ("basic-auth" in this example).


{% navtabs %}
{% navtab Using the Admin API %}


<!-- codeblock tabs -->
{% navtabs codeblock %}
{% navtab cURL %}
```sh
curl -i -X POST http://<admin-hostname>:8001/plugins \
  --data name=basic-auth \
  --data ordering.after.access=request-transformer
```
{% endnavtab %}
{% navtab HTTPie %}
```sh
http -f post :8001/plugins \
  name=basic-auth \
  ordering.before.access=key-auth
```
{% endnavtab %}
{% endnavtabs %}
<!-- end codeblock tabs -->

{% endnavtab %}
{% navtab Using decK (YAML) %}

{:.note}
> **Note:** This section sets up the basic Rate Limiting plugin. If you have a {{site.base_gateway}} instance, see instructions for **Using Kong Manager** to set up Rate Limiting Advanced with sliding window support instead.

1. Add a new `plugins` section to the bottom of your `kong.yaml` file. Enable
`request-transformer` with a limit of five (5) requests per minute, stored locally
and in-memory, on the node:

    ``` yaml
    plugins:
    - name: basic-auth
      config: {}
      ordering:
        after:
          access:
            - request-transformer
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
    - name: basic-auth
      config: {}
      ordering:
        after:
          access:
            - request-transformer
    ```

    >**Note**: By default, `enabled` is set to `true` for the plugin. You can
    disable the plugin at any time by setting `enabled: false`.

2. Sync the configuration:

    ``` bash
    deck sync
    ```

{% endnavtab %}
{% endnavtabs %}
