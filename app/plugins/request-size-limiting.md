---
id: page-plugin
title: Plugins - Request Size Limiting
header_title: Request Size Limiting
header_icon: /assets/images/icons/plugins/request-size-limiting.png
breadcrumbs:
  Plugins: /plugins
nav:
  - label: Getting Started
    items:
      - label: Configuration
---

<div class="alert alert-warning">
  For security reasons we suggest enabling this plugin for any API you add to Kong to prevent a DOS (Denial of Service) attack.
</div>

Block incoming requests whose body is greater than a specific size in megabytes.

---

## Configuration

Configuring the plugin is straightforward, you can add it on top of an [API][api-object] (or [Consumer][consumer-object]) by executing the following request on your Kong server:

```bash
$ curl -X POST http://kong:8001/apis/{api}/plugins \
    --data "name=request-size-limiting" \
    --data "config.allowed_payload_size=128"
```

`api`: The `id` or `name` of the API that this plugin configuration will target

You can also apply it for every API using the `http://kong:8001/plugins/` endpoint. Read the [Plugin Reference](/docs/latest/admin-api/#add-plugin) for more information.

form parameter                | default    | description
---                           | ---        | ---
`name`                        |            | The name of the plugin to use, in this case: `request-size-limiting`
`consumer_id`<br>*optional*   |            | The CONSUMER ID that this plugin configuration will target. This value can only be used if [authentication has been enabled][faq-authentication] so that the system can identify the user making the request.
`config.allowed_payload_size`<br>*optional* | `128` | Allowed request payload size in megabytes, default is `128` (128000000 Bytes)

[api-object]: /docs/latest/admin-api/#api-object
[configuration]: /docs/latest/configuration
[consumer-object]: /docs/latest/admin-api/#consumer-object
[faq-authentication]: /about/faq/#how-can-i-add-an-authentication-layer-on-a-microservice/api?
