---
name: XML Threat Protection
publisher: Kong Inc.
desc: Apply structural and size checks on XML payloads
description: |
  Reduce the risk of XML attacks by checking the structure of XML payloads. This
  will validate maximum complexity (depth of the tree), maximum size of elements
  and attributes, etc.
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
        A list of Content-Type values that have payloads that need to be validated
    - name: allowed_content_types
      required: true
      default: [ ]
      value_in_examples: null
      datatype: array of strings
      description: |
        A list of Content-Type values that have payloads that are allowed, but will not be validated.
        For example if the API also accepts JSON, then `"application/json"` can be added.
    - name: allow_dtd
      required: true
      default: false
      value_in_examples: null
      datatype: boolean
      description: |
        Indicating whether an XML Document Type Definition (DTD) section is allowed.
    - name: namespace_aware
      required: true
      default: true
      value_in_examples: null
      datatype: boolean
      description: |
        If not parsing namespace aware, all prefixes and namesapce attributes will be counted as regular attributes and element names, and validated as such.
    - name: max_depth
      required: true
      default: 50
      value_in_examples: 50
      datatype: number
      description: |
        Maximum depth of tags, child elements like Text or Comments are not counted as another level.
    - name: max_children
      required: true
      default: 100
      value_in_examples: null
      datatype: number
      description: |
        Maximum number of children allowed (Element, Text, Comment, ProcessingInstruction, CDATASection).
        NOTE: adjacent text/CDATA sections are counted as 1 (such that text-cdata-text-cdata is 1 child).
    - name: max_attributes
      required: true
      default: 100
      value_in_examples: null
      datatype: number
      description: |
        Maximum number of attributes allowed on a tag (including default ones).
        NOTE: if not parsing namespace-aware, then the namespaces definitions will be counted as attributes.
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
        Maximum size of entire document
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
        NOTE: If not parsing namespace-aware, this limit will count against the full name (prefix + localname).
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
        Maximum size of the namespace uri. This value is required if parsing is namespace-aware.
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
        Sets the maximum amplification to be allowed. This protects against the Billion Laughs Attack.
    - name: bla_threshold
      required: true
      default: 8388608 (8 mb)
      value_in_examples: null
      datatype: number
      description: |
        Sets the threshold after which the protection starts. This protects against the Billion Laughs Attack.

---

### Usage

The XML Threat Protection plugin will protect against excessive complex or large payloads.
The checks are implemented using a streaming [SAX parser](http://www.saxproject.org/). This ensures that even very large
payloads can be validated safely.

### Using the `unparsed buffer` setting

Due to the way SAX parsers work, a bad input would first need to be parsed before a SAX callback
allows the plugin to check its size. Specifically for elements with attributes this is even
a bigger problem since the element name plus all its attributes are returned in a single
callback. So passing in 100 attributes each having a 1GB value, could still overwhelm the
system and have it run out of resources.

To mitigate this the unparsed buffer size setting is used. The buffer is counted from the
last byte parsed (eg. the closing tag on the previous element), to the last byte passed
into the parser. If the buffer size is greater than the allowed value, the request is rejected.

An example;
- following limits defined:
  - localname: 1 kb
  - attribute value: 10 kb
  - max attributes: 10
- A request comes in with an element having 100 attributes, each 1 gb in size
- The parser will read the payload, and try to fire a callback for a new element
  of at least 100 gb in size, since it also contains all attributes. This will fail
  because the system will run out of resources.

To mitigate this using the unparsed buffer size:
- the maximum expected size is: 1 element name (1 kb), 10 attribute names (10 kb),
  10 attribute values (100 kb), so a total of 111 kb.
- set the maximum unparser buffer to 113 kb (adding 2 kb for overhead and XML whitespace)
- when validating the element with 100 1 gb attributes again, the plugin will now
  detect that the unparsed buffer will exceed the expected maximum of 113 kb, and will
  reject the request before parsing the entire 100 gb body.

---

## Changelog

**{{site.base_gateway}} 3.1.x**
* Initial release.
