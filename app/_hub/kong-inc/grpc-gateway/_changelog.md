## Changelog

**{{site.base_gateway}} 3.4.x**
* Fixed an issue where an array with one element would fail to be encoded.
* Fixed an issue where empty (all default value) messages couldn't be unframed correctly.
[#10836](https://github.com/Kong/kong/pull/10836)

**{{site.base_gateway}} 2.6.x**
* Fields of type `.google.protobuf.Timestamp` on the gRPC side are now transcoded to and from ISO8601 strings on the REST side.
* URI arguments like `..?foo.bar=x&foo.baz=y` are interpreted as structured fields, equivalent to `{"foo": {"bar": "x", "baz": "y"}}`.
