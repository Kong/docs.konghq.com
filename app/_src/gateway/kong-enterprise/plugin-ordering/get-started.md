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

The following example uses the [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced/)
plugin with the [Key Authentication](/hub/kong-inc/key-auth/) plugin as the
authentication method.

{% navtabs %}
{% navtab Admin API %}

Call the Admin API on port `8001` and enable the
`rate-limiting` plugin, configuring it to run before `key-auth`:

```sh
curl -i -X POST http://localhost:8001/plugins \
  --data name=rate-limiting \
  --data config.minute=5 \
  --data config.policy=local \
  --data config.limit_by=ip \
  --data ordering.before.access=key-auth
```

{% endnavtab %}
{% navtab Kubernetes %}
```yaml
apiVersion: configuration.konghq.com/v1
kind: KongClusterPlugin
metadata:
  name: limit-before-key-auth
  labels:
    global: "true"
  annotations:
    kubernetes.io/ingress.class: "kong"
config:
  minute: 5
  policy: local
  limit_by: ip
plugin: rate-limiting
ordering:
  before:
    access:
    - key-auth
```
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
    - host: httpbin.org
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
{% navtab Kong Manager UI %}

{:.note}
> **Note:** Kong Manager support for dynamic plugin ordering is available starting in {{site.base_gateway}} 3.1.x.

1. In Kong Manager, open the **default** workspace.
2. From the menu, open **Plugins**, then click **Install Plugin**.
3. Find the **Rate Limiting** plugin, then click **Enable**.
4. Apply the plugin as **Global**, which means the rate limiting applies to all requests, including every service and route in the workspace.
5. Complete only the following fields with the following parameters.
    1. config.minute: `5`
    2. config.policy: `local`
    3. config.limit_by: `ip`
    
    Besides the above fields, there may be others populated with default values. For this example, leave the rest of the fields as they are.
6. Click **Install**.
7. From the **Rate Limiting** plugin page, click the **Ordering** tab.
8. Click **Add ordering**.
9. For **Before access**, click **Add plugin**.
10. Choose **Key Auth** from the **Plugin 1** dropdown menu.
11. Click **Update**.

The rate limiting plugin now limits the amount of requests against all services and routes in the default workspace *before* {{site.base_gateway}} requests authentication.

{% endnavtab %}
{% endnavtabs %}

## Authentication after request transformation

The following example is similar to running [rate limiting before authentication](#rate-limiting-before-authentication).

For example, you may want to first transform a request, then request authentication
*after* transformation. You can describe this dependency with the token `after`.

Instead of changing the order of the [Request Transformer](/hub/kong-inc/request-transformer/)
plugin, you can change the order of the authentication plugin
([Basic Authentication](/hub/kong-inc/basic-auth/), in this example).

{% navtabs %}
{% navtab Admin API %}

Call the Admin API on port `8001` and enable the
`basic-auth` plugin, configuring it to run after `request-transformer`:

```sh
curl -i -X POST http://localhost:8001/plugins \
  --data name=basic-auth \
  --data ordering.after.access=request-transformer
```

{% endnavtab %}
{% navtab Kubernetes %}
```yaml
apiVersion: configuration.konghq.com/v1
kind: KongClusterPlugin
metadata:
  name: auth-after-transform
  labels:
    global: "true"
  annotations:
    kubernetes.io/ingress.class: "kong"
plugin: basic-auth
ordering:
  after:
    access:
    - request-transformer
```
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
    - host: httpbin.org
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
{% navtab Kong Manager UI %}

{:.note}
> **Note:** Kong Manager support for dynamic plugin ordering is available starting in {{site.base_gateway}} 3.1.x.

1. In Kong Manager, open the **default** workspace.
2. From the menu, open **Plugins**, then click **Install Plugin**.
3. Find the **Basic Authentication** plugin, then click **Enable**.
4. Apply the plugin as **Global**, which means the rate limiting applies to all requests, including every service and route in the workspace.
6. Click **Install**.
7. From the **Basic Authentication** plugin page, click the **Ordering** tab.
8. Click **Add ordering**.
9. For **After access**, click **Add plugin**.
10. Choose **Request Transformer** from the **Plugin 1** dropdown menu.
11. Click **Update**.

The basic authentication plugin now requests authentication after the request is transformed.
{% endnavtab %}
{% endnavtabs %}
