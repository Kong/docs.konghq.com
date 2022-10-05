---
title: Get Started with Dynamic Plugin Ordering
badge: enterprise
content_type: how-to
---

Here are some common use cases for [dynamic plugin ordering](/gateway/{{page.kong_version}}/kong-enterprise/plugin-ordering/).

## Rate limiting before authentication

Let's say you want to limit the amount of requests against your service and route
*before* Kong requests authentication. You can describe this dependency with the
token `before`.

The following example uses the [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced)
plugin with the [Key Authentication](/hub/kong-inc/key-auth) plugin as the
authentication method.

{% navtabs %}
{% navtab Admin API %}

Call the Admin API on port `8001` and enable the
`rate-limiting` plugin, configuring it to run before `key-auth`:

<!-- codeblock tabs -->
{% navtabs codeblock %}
{% navtab cURL %}
```sh
curl -i -X POST http://<admin-hostname>:8001/plugins \
  --data name=rate-limiting \
  --data config.minute=5 \
  --data config.policy=local \
  --data config.limit_by=ip \
  --data ordering.before.access=key-auth
```
{% endnavtab %}
{% navtab HTTPie %}
```sh
http -f post :8001/plugins \
  name=rate-limiting \
  config.minute=5 \
  config.policy=local \
  config.limit_by=ip \
  ordering.before.access=key-auth
```
{% endnavtab %}
{% endnavtabs %}
<!-- end codeblock tabs -->

{% endnavtab %}
{% navtab decK (YAML) %}

1. Add a new `plugins` section to the bottom of your `kong.yaml` file. Enable
`rate-limiting` and set the plugin to run before `key-auth`:

    ``` yaml
    plugins:
    - name: rate-limiting
      config:
        minute: 5
        policy: local
        limit_by: ip
      ordering:
        before:
          access:
            - key-auth
    ```

    Your file should now look like this:

    ``` yaml
    _format_version: "3.0"
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
        limit_by: ip
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

    {:.note}
    > **Note**: By default, `enabled` is set to `true` for the plugin. You can
    disable the plugin at any time by setting `enabled: false`.

2. Sync the configuration:

    ``` bash
    deck sync
    ```

{% endnavtab %}
{% endnavtabs %}

## Authentication after request transformation

The following example is similar to running [rate limiting before authentication](#rate-limiting-before-authentication).

For example, you may want to first transform a request, then request authentication
*after* transformation. You can describe this dependency with the token `after`.

Instead of changing the order of the [Request Transformer](/hub/kong-inc/request-transformer)
plugin, you can change the order of the authentication plugin
([Basic Authentication](/hub/kong-inc/basic-auth), in this example).

{% navtabs %}
{% navtab Admin API %}

Call the Admin API on port `8001` and enable the
`basic-auth` plugin, configuring it to run after `request-transformer`:

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
  ordering.after.access=request-transformer
```
{% endnavtab %}
{% endnavtabs %}
<!-- end codeblock tabs -->

{% endnavtab %}
{% navtab decK (YAML) %}

1. Add a new `plugins` section to the bottom of your `kong.yaml` file. Enable
`basic-auth` and set the plugin to run after `request-transformer`:

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
    _format_version: "3.0"
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

    {:.note}
    > **Note**: By default, `enabled` is set to `true` for the plugin. You can
    disable the plugin at any time by setting `enabled: false`.

2. Sync the configuration:

    ``` bash
    deck sync
    ```

{% endnavtab %}
{% endnavtabs %}
