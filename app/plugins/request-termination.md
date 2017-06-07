---
id: page-plugin
title: Plugins - Request Termination
header_title: Request Termination
header_icon: /assets/images/icons/plugins/request-termination.png
breadcrumbs:
  Plugins: /plugins
nav:
  - label: Getting Started
    items:
      - label: Configuration
      - label: Example Use Cases
---

This plugin terminates incoming requests with a specified status code and
message. This allows to (temporarily) block an API or Consumer.

----

## Configuration

Configuring the plugin is straightforward, you can add it on top of an
[API][api-object] by executing the following request on your Kong server:

```bash
$ curl -X POST http://kong:8001/apis/{api}/plugins \
    --data "name=request-termination" \
    --data "config.status_code=403" \
    --data "config.message=So long and thanks for all the fish!"
```

`api`: The `id` or `name` of the API that this plugin configuration will target

form parameter                      | default | description
---                                 | ---     | ---
`name`                              |         | The name of the plugin to use, in this case: `request-termination`.
`config.status_code`<br>*optional*  | `503`   | The response code to send.
`config.message`<br>*optional*      |         | The message to send, if using the default response generator.
`config.body`<br>*optional*         |         | The raw response body to send, this is mutually exclusive with the `config.message` field.
`config.content_type`<br>*optional* | `application/json; charset=utf-8` | Content type of the raw response configured with `config.body`.

You can also apply it for every API or only on a specific Consumer by using
the `http://kong:8001/plugins/` endpoint. Read the
[Plugin Reference](/docs/latest/admin-api/#add-plugin) for more information.

Once applied, every request (within the configured plugin scope of an API,
Consumer, or global) will be immediately terminated by sending the configured
response.

---

## Example Use Cases

- Temporarily disable an API (ex: maintenance mode).
- Temporarily disable a Consumer (ex: excessive consumption).
- Block anonymous access with multiple auth plugins in a logical `OR` setup.

[api-object]: /docs/latest/admin-api/#api-object
