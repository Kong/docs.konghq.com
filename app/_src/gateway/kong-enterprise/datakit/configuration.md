---
title: Datakit configuration reference
badge: enterprise
alpha: true
---

Datakit can be configured via the `/plugins` endpoint.

## The execution model

Nodes can have input ports and output ports.
Input ports consume data. Output ports produce data.

You can link one node's output port to another node's input port.
An input port can receive at most one link, that is, data can only arrive
into an input via one other node. Therefore, there are no race conditions.

An output port can be linked to multiple nodes. Therefore, one node can
provide data to several other nodes.

Each node triggers at most once.

A node only triggers when data is available to all its connected input ports;
that is, only when all nodes connected to its inputs have finished
executing.

## Node types

The following node types are implemented:

**Node type**        | **Input ports**            | **Output ports**  |  **Supported attributes**
---------------------|----------------------------|-------------------|---------------------------
`call`               | `body`, `headers`, `query` | `body`, `headers` | `url`, `method`, `timeout`
`jq`                 | user-defined               | user-defined      | `jq`
`handlebars`         | user-defined               | `output`          | `template`, `content_type`
`exit`               | `body`, `headers`          | none              | `status`
`property`           | `value`                    | `value`           | `property`, `content_type`

### `call` node type

An HTTP dispatch call.

#### Input ports

* `body`: body to use in the dispatch request.
* `headers`: headers to use in the dispatch request.
* `query`: key-value pairs to encode as the query string.

#### Output ports

* `body`: body returned as the dispatch response.
* `headers`: headers returned as the dispatch response.
* `error`: triggered if a dispatch error occurs, such as a DNS resolver timeout, etc.
  The port returns the error message.

#### Supported attributes

* `url` (**required**): the URL to use when dispatching.
* `method`: the HTTP method (default is `GET`).
* `timeout`: the dispatch timeout, in seconds (default is 60).

#### Examples

Make an external API call:

```yaml
- name: CALL
  type: call
  url: https://httpbin.konghq.com/anything
```

### `jq` node type

Execution of a JQ script for processing JSON. The JQ script is processed
using the [jaq] implementation of the JQ language.

#### Input ports

User-defined. Each input port declared by the user will correspond to a
variable in the JQ execution context. A user can declare the name of the port
explicitly, which is the name of the variable. If a port does not have a given
name, it will get a default name based on the peer node and port to which it
is connected, and the name will be normalized into a valid variable name (e.g.
by replacing `.` to `_`).

#### Output ports

User-defined. When the JQ script produces a JSON value, that is made available
in the first output port of the node. If the JQ script produces multiple JSON
values, each value will be routed to a separate output port.

#### Supported attributes

* `jq`: the JQ script to execute when the node is triggered.

#### Examples

Set a header:
```yaml
- name: MY_HEADERS
  type: jq
  inputs:
  - req: request.headers
  jq: |
    {
      "X-My-Call-Header": $req.apikey // "default value"
      }
```

Join the output of two API calls:

```yaml
- name: JOIN
  type: jq
  inputs:
  - cat: CAT_FACT.body
  - dog: DOG_FACT.body
  jq: |
    {
      "cat_fact": $cat.fact,
      "dog_fact": $dog.facts[0]
    }
```

### `handlebars` node type

Application of a [Handlebars] template on a raw string, useful for producing
arbitrary non-JSON content types.

#### Input ports

User-defined. Each input port declared by the user will correspond to a
variable in the Handlebars execution context. A user can declare the name of
the port explicitly, which is the name of the variable. If a port does not
have a given name, it will get a default name based on the peer node and port
to which it is connected, and the name will be normalized into a valid
variable name (e.g. by replacing `.` to `_`).

#### Output ports

* `output`: the rendered template. The output payload will be in raw string
  format, unless an alternative `content_type` triggers a conversion.

#### Supported attributes

* `template`: the Handlebars template to apply when the node is triggered.
* `content_type`: if set to a MIME type that matches one of DataKit's
  supported payload types, such as `application/json`, the output payload will
  be converted to that format, making its contents available for further
  processing by other nodes (default is `text/plain`, which produces a raw
  string).

#### Examples

Create a template for parsing the output of an external API call to a coordinates API:

```yaml
- name: MY_BODY
  type: handlebars
  content_type: text/plain
  inputs:
  - first: FIRST.body
  output: service_request.body
  template: |
    Coordinates for {{ first.places.0.[place name] }}, {{ first.places.0.state }}, {{ first.country }} are ({{ first.places.0.latitude }}, {{ first.places.0.longitude }}).
```

### `exit` node type

Trigger an early exit that produces a direct response, rather than forwarding
a proxied response.

#### Input ports

* `body`: body to use in the early-exit response.
* `headers`: headers to use in the early-exit response.

#### Output ports

None.

#### Supported attributes

* `status`: the HTTP status code to use in the early-exit response (default is
  200).

#### Examples

Exit and pass the input directly to the client:

```yaml
- name: EXIT
  type: exit
  inputs:
  - body: CALL.body
```
  
### `property` node type

Get and set {{site.base_gateway}} host properties.

Whether a **get** or **set** operation is performed depends upon the node inputs:

* If an input port is configured, **set** the property
* If no input port is configured, **get** the property and map it to the output
    port

#### Input ports

* `value`: set the property to the value from this port

#### Output ports

* `value`: the property value that was retrieved

#### Supported attributes

* `property` (**required**): the name of the property
* `content_type`: the MIME type of the property (example: `application/json`)
    * **get**: controls how the value is _decoded_ after reading it.
    * **set**: controls how the value is _encoded_ before writing it. This is
        usually does not need to be specified, as DataKit can typically infer
        the correct encoding from the input type.

#### Examples

Get the current value of `my.property`:

```yaml
- name: get_property
  type: property
  property: my.property
```

Set the value of `my.property` from `some_other_node.port`:

```yaml
- name: set_property
  type: property
  property: my.property
  input: some_other_node.port
```

Get the value of `my.json-encoded.property` and decode it as JSON:

```yaml
- name: get_json_property
  type: property
  property: my.json-encoded.property
  content_type: application/json
```

## Implicit nodes

DataKit defines a number of implicit nodes that can be used without being
explicitly declared. These reserved node names cannot be used for user-defined
nodes. These are:

**Node**             | **Input ports**            | **Output ports**           |  **Description**
---------------------|----------------------------|----------------------------|------------------
`request`            | none                       | `body`, `headers`, `query` | the incoming request
`service_request`    | `body`, `headers`, `query` | none                       | request sent to the service being proxied to
`service_response`   | none                       | `body`, `headers`          | response sent by the service being proxied to
`response`           | `body`, `headers`          | none                       | response to be sent to the incoming request

The `headers` ports produce and consume maps from header names to their values.
Keys are header names are normalized to lowercase.
Values are strings if there is a single instance of a header,
or arrays of strings if there are multiple instances of the same header.

The `query` ports produce and consume maps with key-value pairs representing
decoded URL query strings. If the value in the pair is JSON null,
the key is encoded without a value (to encode `key=null`, use `"null"`
as a value).

The `body` output ports produce either raw strings or JSON objects,
depending on their corresponding `Content-Type` values.

Likewise, the `body` input ports accept either raw strings or JSON objects,
and both their `Content-Type` and `Content-Length` are automatically adjusted,
according to the type and size of the incoming data.

## Debugging

DataKit includes support for debugging your configuration.

### Execution tracing

By setting the `X-DataKit-Debug-Trace` header, DataKit records the execution
flow and the values of intermediate nodes, reporting the output in the request
body in JSON format.

If the debug header value is set to `0`, `false`, or `off`, this is equivalent to
unsetting the debug header: tracing will not happen and execution will run
as normal. Any other value will enable debug tracing.

---

[Handlebars]: https://docs.rs/handlebars/latest/handlebars/
[jaq]: https://lib.rs/crates/jaq