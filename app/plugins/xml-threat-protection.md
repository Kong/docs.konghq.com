---
id: page-plugin
title: Plugins - XML Threat Protection
header_title: XML Threat Protection
header_icon: /_assets/images/icons/plugins/xmlthreadprotection.png
breadcrumbs:
  Plugins: /plugins
nav:
  - label: Getting Started
  - label: Usage
    items:
      - label: Terminology
      - label: Configuration
---

Address XML vulnerabilities and minimize attacks on your API. Optionally, detect XML payload attacks based on configured limits. Screen against XML threats using the following approaches:

* Validate messages against an XML schema (.xsd)
* Evaluate message content for specific blacklisted keywords or patterns
* Detect corrupt or malformed messages before those messages are parsed

----

## Terminology

- `API`: your upstream service, for which Kong proxies requests to.
- `Plugin`: a plugin executes actions inside Kong during the request/response lifecycle.

----

## Configuration

Configuring the plugin is straightforward, you can add it on top of an [API][api-object] by executing the following request on your Kong server:

```bash
$ curl -X POST http://kong:8001/apis/{api}/plugins \
--data "name=xml-threat-protection"
--data "config.name_limits_element=0" \
--data "config.name_limits_attribute=0" \
--data "config.name_limits_namespace_prefix=0" \
--data "config.name_limits_processing_instruction_target=0" \
--data "config.structure_limits_node_depth=0" \
--data "config.structure_limits_attribute_count_per_element=0" \
--data "config.structure_limits_namespace_count_per_element=0" \
--data "config.structure_limits_child_count=0" \
--data "config.value_limits_text=0" \
--data "config.value_limits_attribute=0" \
--data "config.value_limits_namespace_uri=0" \
--data "config.value_limits_comment=0" \
--data "config.value_limits_processing_instruction_data=0"
```



`api`: The `id` or `name` of the API that this plugin configuration will target

form parameter                                        | required     | description
---                                                   | ---          | ---
`name`                                                | *required*   | The name of the plugin to use, in this case: `xml-threat-protection`
`config.name_limits_element`                          | *optional*   | Specifies a limit on the maximum number of characters permitted in any element name in the XML document.
`config.name_limits_attribute`                        | *optional*   | Specifies a limit on the maximum number of characters permitted in any attribute name in the XML document.
`config.name_limits_namespace_prefix`                 | *optional*   | Specifies a limit on the maximum number of characters permitted in the namespace prefix in the XML document.
`config.name_limits_processing_instruction_target`    | *optional*   | Specifies a limit on the maximum number of characters permitted in the target of any processing instructions in the XML document.
`config.structure_limits_node_depth`                  | *optional*   | Specifies the maximum node depth allowed in the XML.
`config.structure_limits_attribute_count_per_element` | *optional*   | Specifies a limit on the maximum number of characters permitted in any element name in the XML document.
`config.structure_limits_namespace_count_per_element` | *optional*   | Specifies the maximum number of namespace definitions allowed for any element.
`config.structure_limits_child_count`                 | *optional*   | Specifies the maximum number of child elements allowed for any element.
`config.value_limits_text`                            | *optional*   | Specifies a character limit for any text nodes present in the XML document.
`config.value_limits_attribute`                       | *optional*   | Specifies a character limit for any attribute values present in the XML document.
`config.value_limits_namespace_uri`                   | *optional*   | Specifies a character limit for any namespace URIs present in the XML document.
`config.value_limits_comment`                         | *optional*   | Specifies a character limit for any comments present in the XML document.
`config.value_limits_processing_instruction_data`     | *optional*   | Specifies a character limit for any processing instruction text present in the XML document.

----


