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

