---
name: Websocket Size Limit
publisher: Kong Inc.

categories:
  - traffic-control

type: plugin

desc: Block incoming WebSocket messages greater than a specified size
description: |
  Allows operators to specify a maximum size for incoming WebSocket messages.

  Separate limits can be applied to clients and upstreams.

  When an incoming message exceeds the limit:
    1. A close frame with status code `1009` is sent to the sender
    2. A close frame with status code `1001` is sent to the peer
    3. Both sides of the connection are closed


kong_version_compatibility:
  enterprise_edition:
    compatible:
      - 3.0.x

cloud: true

enterprise: true

plus: true

params:
  name: websocket-size-limit
  service_id: true
  route_id: true
  consumer_id: false
  dbless_compatible: 'yes'
  protocols: ["ws", "wss"]
  config:
    - name: client_max_payload
      required: semi
      value_in_examples: '''1024'''
      datatype: integer
      default: null
      encrypted: false
      description: |
        Maximum size (in bytes) of client-originated WebSocket messages. Must
        be greater than `0` and less than `33554432` (32 MiB)
      extra: |
        At least one of `client_max_payload` and `upstream_max_payload` is
        required.
    - name: upstream_max_payload
      required: semi
      value_in_examples: '''16384'''
      datatype: integer
      default: null
      encrypted: false
      description: |
        Maximum size (in bytes) of upstream-originated WebSocket messages. Must
        be greater than `0` and less than `33554432` (32 MiB)
      extra: |
        At least one of `client_max_payload` and `upstream_max_payload` is
        required.

---

## Usage Examples

Limits can be applied to client messages, upstream messages, or both.

### Limit client messages to 4 KiB

{% navtabs %}
{% navtab With a database %}

Use a request like this:

``` bash
curl -i -X POST http://kong:8001/services/{service}/plugins \
  --data "name=websocket-size-limit" \
  --data "config.client_max_payload=4096"
```
{% endnavtab %}

{% navtab Without a database %}

Add the following entry to the `plugins:` section in the declarative configuration file:

``` yaml
plugins:
- name: websocket-size-limit
  service: {service}
  config:
    client_max_payload: 4096
```
{% endnavtab %}
{% endnavtabs %}


### Limit upstream messages to 1 MiB

{% navtabs %}
{% navtab With a database %}

Use a request like this:

``` bash
curl -i -X POST http://kong:8001/services/{service}/plugins \
  --data "name=websocket-size-limit" \
  --data "config.upstream_max_payload=1048576"
```
{% endnavtab %}

{% navtab Without a database %}

Add the following entry to the `plugins:` section in the declarative configuration file:

``` yaml
plugins:
- name: websocket-size-limit
  service: {service}
  config:
    upstream_max_payload: 1048576
```
{% endnavtab %}
{% endnavtabs %}


### Limit both client and upstream messages

{% navtabs %}
{% navtab With a database %}

Use a request like this:

``` bash
curl -i -X POST http://kong:8001/services/{service}/plugins \
  --data "name=websocket-size-limit" \
  --data "config.client_max_payload=4096" \
  --data "config.upstream_max_payload=1048576"
```
{% endnavtab %}

{% navtab Without a database %}

Add the following entry to the `plugins:` section in the declarative configuration file:

``` yaml
plugins:
- name: websocket-size-limit
  service: {service}
  config:
    client_max_payload: 4096
    upstream_max_payload: 1048576
```
{% endnavtab %}
{% endnavtabs %}


### Raising the default limits

Kong applies some default limits to incoming messages for all WebSocket
services:

| Sender   | Default Limit        |
|----------|----------------------|
| client   | `1048576` (`1MiB`)   |
| upstream | `16777216` (`16MiB`) |

This plugin can be used to increase the limit beyond the default. This example
increases the client limit to 2 MiB, up from the default of 1 MiB:


{% navtabs %}
{% navtab With a database %}

Use a request like this:

``` bash
curl -i -X POST http://kong:8001/services/{service}/plugins \
  --data "name=websocket-size-limit" \
  --data "config.client_max_payload=2097152"
```
{% endnavtab %}

{% navtab Without a database %}

Add the following entry to the `plugins:` section in the declarative configuration file:

``` yaml
plugins:
- name: websocket-size-limit
  service: {service}
  config:
    client_max_payload: 2097152
```
{% endnavtab %}
{% endnavtabs %}

---

> Why is the default client limit smaller than the default upstream limit?

Proxying client-originated messages is much more computationally expensive than
upstream messages due to the client-to-server masking [required by the WebSocket
specification](https://datatracker.ietf.org/doc/html/rfc6455#section-5.3), so
in general it is wise to maintain a lower limit for client messages.


## Under the hood

## How limits are applied

**Note:** Limits are evaluated based on the message payload length and not the
entire length of the WebSocket frame (header + payload).

### Standalone data frames (`text` and `binary`)

For limits of 125 bytes and lower, the message is fully read and unserialized
before checking the message length.

For limits of 125 bytes and higher, the message length is checked from the
frame header _before_ the entire message is read from the socket buffer,
allowing Kong to close the connection without having to read and unserialize
the entire message in memory.

### Continuation data frames

Kong aggregates `continuation` frames, buffering them in-memory before forwarding
them to their final destination. In addition to evaluating limits on an
individual frame basis (just like singular `text` and `binary` frames), Kong
also tracks the running size of all the frames that are buffered for
aggregation. If an incoming `continuation` frame causes the total buffer size to
exceed the limit, the message is rejected, and the connection is closed.

Example (assume `client_max_payload = 1024`)

```
 .------.                                       .----.
 |Client|                                       |Kong|
 '------'                                       '----'
    |                                             |
    |     text(fin=false, len=500, msg=[...])     |
    |>------------------------------------------->| # buffer += 500 (500)
    |                                             |
    |                                             |
    |   continue(fin=false, len=500, msg=[...])   |
    |>------------------------------------------->| # buffer += 500 (1000)
    |                                             |
    |                                             |
    |   continue(fin=false, len=500, msg=[...])   |
    |>------------------------------------------->| # buffer += 500 (1500)
    |                                             | # buffer >= 1024 (limit exceeded!)
    |                                             |
    | close(status=1009, msg="Payload Too Large") |
    |<-------------------------------------------<|
 .------.                                       .----.
 |Client|                                       |Kong|
 '------'                                       '----'
```

### For control frames

All control frames (`ping`, `pong`, and `close`) have a max payload size of
`125` bytes, as per the WebSocket
[specification](https://datatracker.ietf.org/doc/html/rfc6455#section-5.5). Kong
does not enforce any limits on control frames (even when set to a value lower
than `125`).


## See also

* [The complete WebSocket RFC](https://datatracker.ietf.org/doc/html/rfc6455)