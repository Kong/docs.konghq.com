---
name: XML Threat Protection
publisher: Kong Inc.
desc: Apply structural and size checks on XML payloads
description: |
  Reduce the risk of XML attacks by checking the structure of XML payloads. This
  validates maximum complexity (depth of the tree), maximum size of elements
  and attributes.
enterprise: true
type: plugin
categories:
  - traffic-control
kong_version_compatibility:
  enterprise_edition:
    compatible: true
params:
  name: xml-threat-protection
  service_id: true
  route_id: true
  consumer_id: false
  dbless_compatible: 'yes'
  config:
    - name: checked_content_types
      required: true
      default: [ "application/xml" ]
      value_in_examples: null
      datatype: array of strings
      description: |
        A list of Content-Type values with payloads that must be validated.
    - name: allowed_content_types
      required: true
      default: [ ]
      value_in_examples: null
      datatype: array of strings
      description: |
        A list of Content-Type values with payloads that are allowed, but aren't validated.
        For example, if the API also accepts JSON, you can add `"application/json"`.
    - name: allow_dtd
      required: true
      default: false
      value_in_examples: null
      datatype: boolean
      description: |
        Indicates whether an XML Document Type Definition (DTD) section is allowed.
    - name: namespace_aware
      required: true
      default: true
      value_in_examples: null
      datatype: boolean
      description: |
        If not parsing namespace aware, all prefixes and namespace attributes will be counted as regular attributes and element names, and validated as such.
    - name: max_depth
      required: true
      default: 50
      value_in_examples: 50
      datatype: number
      description: |
        Maximum depth of tags. Child elements such as Text or Comments are not counted as another level.
    - name: max_children
      required: true
      default: 100
      value_in_examples: null
      datatype: number
      description: |
        Maximum number of children allowed (Element, Text, Comment, ProcessingInstruction, CDATASection).
        Note: Adjacent text and CDATA sections are counted as one. For example, `text-cdata-text-cdata` is one child.
    - name: max_attributes
      required: true
      default: 100
      value_in_examples: null
      datatype: number
      description: |
        Maximum number of attributes allowed on a tag, including default ones.
        Note: If namespace-aware parsing is disabled, then the namespaces definitions are counted as attributes.
    - name: max_namespaces
      required: semi
      default: 20
      value_in_examples: null
      datatype: number
      description: |
        Maximum number of namespaces defined on a tag. This value is required if parsing is namespace-aware.
    - name: document
      required: true
      default: 10485760 (10 mb)
      value_in_examples: null
      datatype: number
      description: |
        Maximum size of the entire document.
    - name: buffer
      required: true
      default: 1048576 (1 mb)
      value_in_examples: null
      datatype: number
      description: |
        Maximum size of the unparsed buffer (see below).
    - name: comment
      required: true
      default: 1024 (1 kb)
      value_in_examples: null
      datatype: number
      description: |
        Maximum size of comments.
    - name: localname
      required: true
      default: 1024 (1 kb)
      value_in_examples: 512
      datatype: number
      description: |
        Maximum size of the localname. This applies to tags and attributes.
        Note: If parsing isn't namespace-aware, this limit counts against the full name (prefix + localname).
    - name: prefix
      required: semi
      default: 1024 (1 kb)
      value_in_examples: 512
      datatype: number
      description: |
        Maximum size of the prefix. This applies to tags and attributes. This value is required if parsing is namespace-aware.
    - name: namespaceuri
      required: semi
      default: 1024 (1 kb)
      value_in_examples: 1024
      datatype: number
      description: |
        Maximum size of the namespace URI. This value is required if parsing is namespace-aware.
    - name: attribute
      required: true
      default: 1024 (1 kb)
      value_in_examples: null
      datatype: number
      description: |
        Maximum size of the attribute value.
    - name: text
      required: true
      default: 1024 (1 kb)
      value_in_examples: null
      datatype: number
      description: |
        Maximum text inside tags (counted over all adjacent text/CDATA elements combined).
    - name: pitarget
      required: true
      default: 1024 (1 kb)
      value_in_examples: null
      datatype: number
      description: |
        Maximum size of processing instruction targets.
    - name: pidata
      required: true
      default: 1024 (1 kb)
      value_in_examples: null
      datatype: number
      description: |
        Maximum size of processing instruction data.
    - name: entityname
      required: true
      default: 1024 (1 kb)
      value_in_examples: null
      datatype: number
      description: |
        Maximum size of entity names in EntityDecl.
    - name: entity
      required: true
      default: 1024 (1 kb)
      value_in_examples: null
      datatype: number
      description: |
        Maximum size of entity values in EntityDecl.
    - name: entityproperty
      required: true
      default: 1024 (1 kb)
      value_in_examples: null
      datatype: number
      description: |
        Maximum size of systemId, publicId, or notationName in EntityDecl.
    - name: bla_max_amplification
      required: true
      default: 100
      value_in_examples: null
      datatype: number
      description: |
        Sets the maximum allowed amplification. This protects against the Billion Laughs Attack.
    - name: bla_threshold
      required: true
      default: 8388608 (8 mb)
      value_in_examples: null
      datatype: number
      description: |
        Sets the threshold after which the protection starts. This protects against the Billion Laughs Attack.

---

### Usage

The XML Threat Protection plugin protects against excessive complex or large payloads.
The checks are implemented using a streaming [SAX parser](http://www.saxproject.org/). This ensures that even very large
payloads can be validated safely.

### Using the unparsed buffer setting

Due to the way SAX parsers work, a bad input needs to be parsed first before a SAX callback
allows the plugin to check its size. This is even
a bigger problem for elements with attributes because the element name with all its attributes are returned in a single
callback. So passing in 100 attributes, each with a 1GB value, could still overwhelm the
system and run out of resources.

To mitigate this, the unparsed buffer size setting is used. The buffer is counted from the
last byte parsed (for example, the closing tag on the previous element), to the last byte passed
into the parser. If the buffer size is greater than the allowed value, the request is rejected.

For example, if the following limits are defined:
- localname: 1 KB
- attribute value: 10 KB
- max attributes: 10
If a request comes in with an element with 100 attributes, each 1 GB, the parser reads the payload, and tries to fire a callback for a new element of at least 100 GB in size, since it also contains all attributes. This fails because the system runs out of resources.

You can mitigate this by using the unparsed buffer size:
- The maximum expected size is 111KB (one element name (1 KB), 10 attribute names (10 KB), 10 attribute values (100 KB)).
- Set the maximum unparsed buffer to 113 KB, adding 2 KB for overhead and XML whitespace.
- When validating the element with 100 one GB attributes again, the plugin now detects that the unparsed buffer exceeds the expected maximum of 113 KB and rejects the request before parsing the entire 100 GB body.

---

## Changelog

**{{site.base_gateway}} 3.1.x**
* Initial release.
