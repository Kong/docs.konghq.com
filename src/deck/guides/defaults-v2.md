---
title: Set Up Object Defaults
---
Use object defaults to enforce a set of standard values and avoid
repetition in your configuration.

You can set configuration defaults for the following core {{site.base_gateway}} objects:
- Service
- Route
- Upstream
- Target

decK supports setting object defaults both in self-managed
{{site.base_gateway}} and with {{site.konnect_saas}}.

{:.important}
> **Important:** This feature has the following limitations:
* Plugin object defaults are not supported.
* If an existing property's default value changes in a future {{site.base_gateway}} release,
decK has no way of knowing that this change has occured, as its `defaults`
configuration would overwrite the value in your environment.

## Object defaults behavior

Defaults get applied to both new and existing objects. If an object has an
explicit setting for a property, the object-level setting takes precedence over
the default.

{{site.base_gateway}} sets some default values for most objects. You can see
what the defaults are for each object in the
[Admin API reference](/gateway/latest/admin-api/), or use the
[`/schemas`](/gateway/latest/admin-api/#retrieve-entity-schema) endpoint to
retrieve the latest object schemas for your instance of the {{site.base_gateway}}.

Configuring your own defaults is a good way to keep updated on potential
breaking changes between versions. If you upgrade {{site.base_gateway}} to a
version which introduces a new property with a default value, a `deck diff`
will catch the difference.

If defaults are not set in the declarative configuration file, any newly
configured objects pick up {{site.base_gateway}}'s defaults and diverge from
the source configuration file. This situation creates a false positive: decK sees
a diff where one doesn't exist. Refer to ["Create a file and test without defaults"](#create-a-file-and-test-without-defaults) for an example.

## Configure object defaults
The following guide creates a sample `kong.yaml` file with a service and
route, shows you what responses look like without defaults set, and then walks
you through setting defaults.

If you are already familiar with the problem or have a configuration file you
want to use, skip to [setting defaults](#set-defaults).

### Create a file and test without defaults

1. Create a `kong.yaml` configuration file.

2. Add the following sample service and route to the file:

    ```yaml
    _format_version: "0.1"
    services:
      - host: mockbin.org
        name: example_service
        routes:
          - name: mockpath
            paths:
            - /mock
    ```

3. Compare this file with the object configuration in {{site.base_gateway}}:
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
Summary:
  Created: 2
  Updated: 0
  Deleted: 0
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{{ deck_diff1 | indent | replace: " </code>", "</code>" }}

    If you're using a completely empty instance, you should only see the
    service and route creation messages with no extra JSON data.

4. Sync your changes with {{site.base_gateway}}:

    ```sh
    deck sync
    ```

5. Now, run another diff and note the difference in the response:

{% capture deck_diff2 %}
{% navtabs codeblock %}
{% navtab Command %}
```sh
deck diff
```
{% endnavtab %}
{% navtab Response %}
```sh
updating service example_service  {
   "connect_timeout": 60000,
   "host": "mockbin.org",
   "id": "1c088e59-b5fb-4c14-8d3a-401c02fc50b7",
   "name": "example_service",
   "port": 80,
   "protocol": "http",
   "read_timeout": 60000,
-  "retries": 5,
   "write_timeout": 60000
 }

updating route mockpath  {
-  "https_redirect_status_code": 426,
   "id": "1f900445-1957-4c79-aa16-1c86ea41df7f",
   "name": "mockpath",
-  "path_handling": "v0",
   "paths": [
     "/mock"
   ],
   "preserve_host": false,
   "protocols": [
     "http",
     "https"
   ],
   "regex_priority": 0,
-  "request_buffering": true,
-  "response_buffering": true,
   "service": {
     "id": "1c088e59-b5fb-4c14-8d3a-401c02fc50b7"
   },
   "strip_path": false
 }

Summary:
  Created: 0
  Updated: 2
  Deleted: 0
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{{ deck_diff2 | indent | replace: " </code>", "</code>" }}

    Even though you've made no changes, the response shows a list
    of new property configurations. The list of new configurations appears because {{site.base_gateway}} applied defaults and decK is unaware of them, so decK treats them like changes to the configuration.

### Set defaults

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

2. Define the properties you want to set for core {{site.base_gateway}} objects.

    You can define defaults for `service`, `route`, `upstream`, and `target`
    objects.

    For example:

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
          port: 80
          protocol: http
          connect_timeout: 60000
          write_timeout: 60000
          read_timeout: 60000
          retries: 5
    services:
      - host: mockbin.org
        name: example_service
        routes:
          - name: mockpath
            paths:
              - /mock
    ```

3. Save the file and run a diff:

{% capture deck_diff3 %}
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
{{ deck_diff3 | indent | replace: " </code>", "</code>" }}

    Notice that the diff doesn't show extra changes anymore.

## Defaults reference
The following properties are the defaults applied by {{site.base_gateway}} (as of
v2.5.x), and setting them in your declarative configuration file is required to
avoid differences between the configuration file and the {{site.base_gateway}}.

{:.note}
> **Note:** The following are only properties that **have defaults**, and are
not all of the available properties for each object.

{% navtabs %}
{% navtab Route %}

Set the following properties to the values you want to use across all Routes:

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

For all available properties, see the
[Route object](/gateway/latest/admin-api/#route-object) documentation.

{% endnavtab %}
{% navtab Service %}

Set the following properties to the values you want to use across all Services:

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
For all available properties, see the
[Service object](/gateway/latest/admin-api/#service-object) documentation.

{% endnavtab %}
{% navtab Upstream %}

Set the following properties to the values you want to use across all Upstreams:

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
For all available properties, see the
[Upstream object](/gateway/latest/admin-api/#upstream-object) documentation.

{% endnavtab %}
{% navtab Target %}

Set the following property to the value you want to use across all Targets:

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

### Find default values for your Gateway version

For the most accurate default values for your version of {{site.base_gateway}}, see the
[Admin API reference](/gateway/latest/admin-api/), or use the
[`/schemas`](/gateway/latest/admin-api/#retrieve-entity-schema) endpoint. For example, you can check the schema for `targets` and look for any value that
has defined defaults:

{% navtabs codeblock %}
{% navtab cURL %}
```sh
curl -i -X GET http://localhost:8001/schemas/targets
```
{% endnavtab %}
{% navtab HTTPie %}
```sh
http :8001/schemas/targets
```
{% endnavtab %}
{% endnavtabs %}

## See also
* [Deduplicate plugin configuration](/deck/{{page.kong_version}}/guides/deduplicate-plugin-configuration)
* [Distributed configuration for Kong Gateway using decK](/deck/{{page.kong_version}}/guides/distributed-configuration)
* [Using multiple files to store configuration](/deck/{{page.kong_version}}/guides/multi-file-state)
* {{site.base_gateway}} admin API: [`/schemas` endpoint](/gateway/latest/admin-api/#retrieve-entity-schema)
