---
title: Object Defaults
---

{{site.base_gateway}} sets some default values for most objects, including Kong
plugins. You can see what the defaults are for each object in the
[Admin API reference](/gateway/latest/admin-api/), or use the
[`/schemas`](#find-defaults-for-an-object) endpoint to
check the latest object schemas for your instance of the {{site.base_gateway}}.

decK recognizes value defaults and doesn't interpret them as changes to
configuration. If you push a config for an object to {{site.base_gateway}} with
`deck sync`, {{site.base_gateway}} applies its default values to the object,
but a further `diff` or `sync` does not show any changes.

If you upgrade {{site.base_gateway}} to a version that introduces a new
property with a default value, a `deck diff` will catch the difference.

You can also configure your own [custom defaults](#set-custom-defaults) to
enforce a set of standard values and avoid repetition in your configuration.

## Value order of precedence

decK assigns values in the following order of precedence, from highest to lowest:

1. Values set for a specific instance of an object in the state file
(for example, for a service named `example_service` defined in `kong.yml`).
2. Values set in the `{_info: defaults:}` object in the state file.
3. Self-managed Kong Gateway only: Values are checked against the Kong
Admin API schemas.
4. Konnect Cloud only: Values are checked against the Kong Admin API for plugins,
and against hardcoded defaults for Service, Route, Upstream, and Target objects.

## Test default value handling

Create a sample `kong.yaml` file with a service, route, and plugin, push it to
{{site.base_gateway}}, and then pull {{site.base_gateway}}'s configuration down
again to see how decK interprets default values.

1. Create a `kong.yaml` configuration file.

1. Add the following sample service, route, and plugin to the file:

   ```yaml
   _format_version: "0.1"
   services:
     - host: mockbin.org
       name: example_service
       routes:
         - name: mockpath
           paths:
           - /mock
   plugins:
   - name: basic-auth
     config:
       hide_credentials: true
   ```

1. Compare this file with the object configuration in {{site.base_gateway}}:
{% capture deck_diff1 %}
{% navtabs codeblock %}
{% navtab Command %}
```sh
deck diff
```
{% endnavtab %}
{% navtab Response %}
```sh
creating service example_service
creating route mockpath
creating plugin basic-auth (global)
Summary:
  Created: 3
  Updated: 0
  Deleted: 0
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{{ deck_diff1 | indent | replace: " </code>", "</code>" }}

    If you're using a completely empty instance, you should only see the
    service, route, and `basic-auth` plugin creation messages with no extra
    JSON data.

1. Sync your changes with {{site.base_gateway}}:

   ```sh
   deck sync
   ```

1. Now, run another diff and note the response:

{% capture deck_diff2 %}
{% navtabs codeblock %}
{% navtab Command %}
```sh
deck diff
```
{% endnavtab %}
{% navtab Response %}
```sh
Summary:
  Created: 0
  Updated: 0
  Deleted: 0
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{{ deck_diff2 | indent | replace: " </code>", "</code>" }}

    Notice that the diff doesn't show any changes. This is because decK checked
    the values against the service and route schemas and didn't find any
    differences.

1. You can check that any missing default values were set by exporting
{{site.base_gateway}}'s object configuration into a file. If you want to avoid
overwriting your current state file, specify a different filename:

   ```sh
   deck dump -o kong-test.yaml
   ```

    Even though `deck diff` didn't show any changes, the result now has
    default values populated for the service, route, and Basic Auth plugin:

   ```yaml
   _format_version: "1.1"
   plugins:
   - config:
       anonymous: null
       hide_credentials: true
     enabled: true
     name: basic-auth
     protocols:
     - grpc
     - grpcs
     - http
     - https
   services:
   - connect_timeout: 60000
     host: mockbin.org
     name: example_service
     port: 80
     protocol: http
     read_timeout: 60000
     retries: 5
     routes:
     - https_redirect_status_code: 426
       name: mockpath
       path_handling: v0
       paths:
       - /mock
       preserve_host: false
       protocols:
       - http
       - https
       regex_priority: 0
       request_buffering: true
       response_buffering: true
       strip_path: true
     write_timeout: 60000
   ```

## Set custom defaults

You can set custom configuration defaults for the following core
{{site.base_gateway}} objects:
- Service
- Route
- Upstream
- Target

Default values get applied to both new and existing objects. See the
[order of precedence](#value-order-of-precedence) for more detail on how they
get applied.

You can choose to define custom default values for any subset of entity fields,
or define all of them. decK still finds the default values using a
combination of your defined fields and the object's schema, based on the
order of precedence.

decK supports setting custom object defaults both in self-managed
{{site.base_gateway}} and with {{site.konnect_saas}}.

{:.important}
> **Important:** This feature has the following limitations:
* Custom plugin object defaults are not supported.
* If an existing property's default value changes in a future {{site.base_gateway}} release,
decK has no way of knowing that this change has occurred, as its `defaults`
configuration would overwrite the value in your environment.

1. In your `kong.yaml` configuration file, add an `_info` section with
`defaults`:

   ```yaml
   _format_version: "0.1"
   _info:
     defaults:
   services:
     - host: mockbin.org
       name: example_service
       routes:
         - name: mockpath
           paths:
             - /mock
   ```

    {:.note}
    > For production use in larger systems, we recommend that you break out
    your defaults into a [separate `defaults.yaml` file](/deck/{{page.kong_version}}/guides/multi-file-state)
    or use [tags](/deck/{{page.kong_version}}/guides/distributed-configuration)
    to apply the defaults wherever they are needed.

1. Define the properties you want to set for {{site.base_gateway}} objects.

    You can define custom defaults for `service`, `route`, `upstream`, and
    `target` objects.

    For example, you could define default values for a few fields of the
    Service object:

   ```yaml
   _format_version: "0.1"
   _info:
     defaults:
       service:
         port: 8080
         protocol: https
         retries: 10
   services:
     - host: mockbin.org
       name: example_service
       routes:
         - name: mockpath
           paths:
             - /mock
   ```

    Or you could define custom default values for all available fields:

   ```yaml
   _format_version: "0.1"
   _info:
     defaults:
       route:
         https_redirect_status_code: 426
         path_handling: v1
         preserve_host: false
         protocols:
         - http
         - https
         regex_priority: 0
         request_buffering: true
         response_buffering: true
         strip_path: true
       service:
         port: 8080
         protocol: https
         connect_timeout: 60000
         write_timeout: 60000
         read_timeout: 60000
         retries: 10
   services:
     - host: mockbin.org
       name: example_service
       routes:
         - name: mockpath
           paths:
             - /mock
   ```

1. Sync your changes with {{site.base_gateway}}:

   ```sh
   deck sync
   ```

1.  Run a diff and note the response:

{{ deck_diff2 | indent | replace: "    </code>", "</code>" }}

    Whether you choose to define a subset of custom defaults or all available
    options, the result is the same: the diff doesn't show any changes.

## Find defaults for an object

{{site.base_gateway}} defines all the defaults it applies in object schema files.
Check the schemas to find the most up-to-date default values for an object.

If you want to completely avoid differences between the configuration file and
the {{site.base_gateway}}, set all possible default values for an object in your
`kong.yaml` file.

{% navtabs %}
{% navtab Route %}

Use the Kong Admin API `/schemas` endpoint to find default values:

<!-- codeblock tabs -->
{% navtabs codeblock %}
{% navtab cURL %}
```sh
curl -i http://localhost:8001/schemas/routes
```
{% endnavtab %}
{% navtab HTTPie %}
```sh
http :8001/schemas/routes
```
{% endnavtab %}
{% endnavtabs %}
<!-- end codeblock tabs -->

In your `kong.yaml` file, set the default values you want to use across all Routes.
For example:

```yaml
_info:
  defaults:
    route:
      https_redirect_status_code: 426
      path_handling: v0
      preserve_host: false
      protocols:
      - http
      - https
      regex_priority: 0
      request_buffering: true
      response_buffering: true
      strip_path: true
```

{:.note}
> **Note:** If the Route protocols include `grpc` and `grpcs`, the `strip_path`
schema value must be `false`. If set to `true`, deck returns a schema
violation error.

For documentation on all available properties, see the
[Route object](/gateway/latest/admin-api/#route-object) documentation.

{% endnavtab %}
{% navtab Service %}

Use the Kong Admin API `/schemas` endpoint to find default values:

<!-- codeblock tabs -->
{% navtabs codeblock %}
{% navtab cURL %}
```sh
curl -i http://localhost:8001/schemas/services
```
{% endnavtab %}
{% navtab HTTPie %}
```sh
http :8001/schemas/services
```
{% endnavtab %}
{% endnavtabs %}
<!-- end codeblock tabs -->

In your `kong.yaml` file, set the default values you want to use across all
Services. For example:

```yaml
_info:
  defaults:
    service:
      port: 80
      protocol: http
      connect_timeout: 60000
      write_timeout: 60000
      read_timeout: 60000
      retries: 5
```

For documentation on all available properties, see the
[Service object](/gateway/latest/admin-api/#service-object) documentation.

{% endnavtab %}
{% navtab Upstream %}

Use the Kong Admin API `/schemas` endpoint to find default values:

<!-- codeblock tabs -->
{% navtabs codeblock %}
{% navtab cURL %}
```sh
curl -i http://localhost:8001/schemas/upstreams
```
{% endnavtab %}
{% navtab HTTPie %}
```sh
http :8001/schemas/upstreams
```
{% endnavtab %}
{% endnavtabs %}
<!-- end codeblock tabs -->

In your `kong.yaml` file, set the default values you want to use across all
Upstreams. For example:

```yaml
_info:
  defaults:
    upstream:
      slots: 10000
      algorithm: round-robin
      hash_fallback: none
      hash_on: none
      hash_on_cookie_path: /
      healthchecks:
        active:
          concurrency: 10
          healthy:
            http_statuses:
            - 200
            - 302
            interval: 0
            successes: 0
          http_path: /
          https_verify_certificate: true
          timeout: 1
          type: http
          unhealthy:
            http_failures: 0
            http_statuses:
            - 429
            - 404
            - 500
            - 501
            - 502
            - 503
            - 504
            - 505
            interval: 0
            tcp_failures: 0
            timeouts: 0
        passive:
          healthy:
            http_statuses:
            - 200
            - 201
            - 202
            - 203
            - 204
            - 205
            - 206
            - 207
            - 208
            - 226
            - 300
            - 301
            - 302
            - 303
            - 304
            - 305
            - 306
            - 307
            - 308
            successes: 0
          type: http
          unhealthy:
            http_failures: 0
            http_statuses:
              - 429
              - 500
              - 503
            tcp_failures: 0
            timeouts: 0
        threshold: 0
```

For documentation on all available properties, see the
[Upstream object](/gateway/latest/admin-api/#upstream-object) documentation.

{% endnavtab %}
{% navtab Target %}

Use the Kong Admin API `/schemas` endpoint to find default values:

<!-- codeblock tabs -->
{% navtabs codeblock %}
{% navtab cURL %}
```sh
curl -i http://localhost:8001/schemas/targets
```
{% endnavtab %}
{% navtab HTTPie %}
```sh
http :8001/schemas/targets
```
{% endnavtab %}
{% endnavtabs %}
<!-- end codeblock tabs -->

In your `kong.yaml` file, set the default values you want to use across all
Targets. For example:

```yaml
_info:
  defaults:
    target:
      weight: 100
```
For all available properties, see the
[Target object](/gateway/latest/admin-api/#target-object) documentation.

{% endnavtab %}
{% endnavtabs %}

## See also
* [Deduplicate plugin configuration](/deck/{{page.kong_version}}/guides/deduplicate-plugin-configuration)
* [Distributed configuration for Kong Gateway using decK](/deck/{{page.kong_version}}/guides/distributed-configuration)
* [Using multiple files to store configuration](/deck/{{page.kong_version}}/guides/multi-file-state)
* {{site.base_gateway}} admin API: [`/schemas` endpoint](/gateway/latest/admin-api/#retrieve-entity-schema)
