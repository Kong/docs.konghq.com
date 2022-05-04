---
title: Getting Started with Dynamic Plugin Ordering
badge: enterprise
---

The order in which plugins are executed in Kong is determined by their `static priority`. As the name suggests, this value is _static_ and can't easily be changed by the user.

To overcome this limitation Kong introduces a new `ordering` field to all plugins which allows to describe dependencies between plugins.




## Dependency Tokens


There are currently two tokens that can be used to describe a dependency to a plugin.

* `before`


* `after`


## Phases


When a request is proccessed by Kong it will go through various phases, depending on the configured plugins. You can influence the order in which plugins are executed for each phase.

Currently Kong supports only the `access` phase.


## API


To express dependencies for plugins within a certain request phase you may use the following interface.


```yaml
ordering:
  $dependency_token:
    $supported_phase:
      - pluginA
      - ...
```

When you'd like to express that PluginA's _access_ phase should run _before_ PluginB's _access_ phase you would write something like this. (Examples are in deck-style yaml format)

```yaml
PluginA:
  ordering:
    before:
      access:
        - PluginB
```

## Examples


The following examples are a result of the most common requests we received for this feature.



### Rate-limiting before Authentication


In this case we want to limit the amount of requests against our service/route even before we hit authentication.

For this example I'm using the key-auth plugin as the authentication plugin.

{% navtabs %}
{% navtab Using Kong Manager %}

1. Access your Kong Manager instance and your **default** workspace.

2. Go to **API Gateway** > **Plugins**.

3. Click **New Plugin**.

4. Scroll down to **Traffic Control** and find the **Rate Limiting Advanced** plugin. Click **Enable**.

5. Apply the plugin as **Global**, which means the rate limiting applies to all requests, including every Service and Route in the Workspace.

    If you switched it to **Scoped**, the rate limiting would apply the plugin to only one Service, Route. Note that Consumer scoping is not supported

    > **Note**: By default, the plugin is automatically enabled when the form is submitted. You can also toggle the **This plugin is Enabled** button at the top of the form to configure the plugin without enabling it. For this example, keep the plugin enabled.

6. Scroll down and complete only the following fields with the following parameters.
    1. config.limit: `5`
    2. config.sync_rate: `-1`
    3. config.window_size: `30`
    4. ordering.. TODO: this needs to be implemented in KongManager first

    Besides the above fields, there may be others populated with default values. For this example, leave the rest of the fields as they are.

7. Click **Create**.
{% endnavtab %}
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
{% navtab Using Kong Manager %}

1. Access your Kong Manager instance and your **default** workspace.

2. Go to **API Gateway** > **Plugins**.

3. Click **New Plugin**.

4. Scroll down to **Security** and find the **Basic-Auth** plugin. Click **Enable**.

5. Apply the plugin as **Global**, which means the rate limiting applies to all requests, including every Service and Route in the Workspace.

    If you switched it to **Scoped**, the rate limiting would apply the plugin to only one Service, Route. Note that Consumer scoping is not supported

    > **Note**: By default, the plugin is automatically enabled when the form is submitted. You can also toggle the **This plugin is Enabled** button at the top of the form to configure the plugin without enabling it. For this example, keep the plugin enabled.

6. Scroll down and complete only the following fields with the following parameters.
    1. config.foo
    2. ordering.. TODO: this needs to be implemented in KongManager first

    Besides the above fields, there may be others populated with default values. For this example, leave the rest of the fields as they are.

7. Click **Create**.
{% endnavtab %}
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


## Known Limitations


### Consumer Scoping

It is not supported to apply a new order to plugins that are consumer-scoped. As the order of the plugins must be determined after the consumer mapping has happened (which happens in the acceess phase) we can't reliably change the order to plugins.


### Cascading Deletes & Updates


Currently there is no support to detect if a plugin that has a dependency to another plugin was deleted or not so handle your configuration with care.


### Performance Implications


Dynamic Plugin Ordering requires to sort plugins during the a request. This adds natrually adds latency to a request. In some cases this might be compensated for when you run rate-limiting before an expensive authentication plugin. 

### Workspaces

Re-ordering _any_ plugin in a workspace has performance implications to all other plugins withing this workspace. If you can, consider offloading this to a separate workspace.


### Validation


Validation is a on-trivial task to do as it would require insight in the user's business logic.
Kong tries to catch basic mistakes but can't detect all potentially dangerous configurations. Please handle this feature with care!

