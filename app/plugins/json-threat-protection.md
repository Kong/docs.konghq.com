---
id: page-plugin
title: Plugins - Json Threat Protection
header_title: Json Threat Protection
header_icon: /_assets/images/icons/plugins/json-threat-prot.png
breadcrumbs:
  Plugins: /plugins
nav:
  - label: Getting Started
  - label: Usage
    items:
      - label: Terminology
      - label: Configuration
---

Like XML-based services, APIs that support JavaScript object notation (JSON) are vulnerable to content-level attacks. Simple JSON attacks attempt to use structures that overwhelm JSON parsers to crash a service and induce application-level denial-of-service attacks. All settings are optional and should be tuned to optimize your service requirements against potential vulnerabilities.

----

## Terminology

- `API`: your upstream service, for which Kong proxies requests to.
- `Plugin`: a plugin executes actions inside Kong during the request/response lifecycle.

----

## Configuration

Configuring the plugin is straightforward, you can add it on top of an [API][api-object] by executing the following request on your Kong server:

```bash
$ curl -X POST http://kong:8001/apis/{api}/plugins \
--data "name=json-threat-protection"
--data "config.array_element_count=0" \
--data "config.container_depth=0" \
--data "config.object_entry_count=0" \
--data "config.object_entry_name_length=0" \
--data "config.string_value_length=0"
```

`api`: The `id` or `name` of the API that this plugin configuration will target

form parameter            | required     | description
---                       | ---          | ---
`name`                    | *required*   | The name of the plugin to use, in this case: `json-threat-protection`
`config.array_element_count`  | *optional*   | Specifies the maximum number of elements allowed in an array. If you do not specify this element, or if you specify a negative integer, the system does not enforce a limit. Defaults to `0`.
`config.container_depth`  | *optional*   | Specifies the maximum allowed containment depth, where the containers are objects or arrays. For example, an array containing an object which contains an object would result in a containment depth of 3. If you do not specify this element, or if you specify a negative integer, the system does not enforce any limit. Defaults to `0`.
`config.object_entry_count`  | *optional*   | Specifies the maximum number of entries allowed in an object. If you do not specify this element, or if you specify a negative integer, the system does not enforce any limit. Defaults to `0`.
`config.object_entry_name_length`  | *optional*   | Specifies the maximum string length allowed for a property name within an object. If you do not specify this element, or if you specify a negative integer, the system does not enforce any limit. Defaults to `0`.
`config.string_value_length`  | *optional*   | Specifies the maximum length allowed for a string value. If you do not specify this element, or if you specify a negative integer, the system does not enforce a limit. Defaults to `0`.

----


