---
# This file is for documenting an individual Kong plugin.
#
# 1. Duplicate this file in your own *publisher path* on your own branch.
# Your publisher path is relative to app/_hub/.
# The path must consist only of alphanumeric characters and hyphens (-).
#
# 2. Create a versions.yml file in your new plugin directory.
# Set the Kong Gateway version that the plugin is being added to.
# Use the following format in that file (see docs/single-sourced-plugins.md for more info):
#
# strategy: gateway
#
# releases: # Fill in the Gateway version that this plugin is being added in.
#   - 3.0.x
#
# 3. Add a 64x64px icon for the plugin to app/_assets/images/icons/hub.
# The name of the file must be in the following format: <publisher>_<plugin-directory-name>.png
# For example, for the rate limiting plugin the icon name is kong-inc_rate-limiting.png
# If your plugin doesn't have an icon yet, you can duplicate the default_icon.png file.
#
# 4. Fill in the template in this file.
#
# The following YAML data must be filled out as prescribed by the comments
# on individual parameters. Also see documentation at:
# https://github.com/Kong/docs.konghq.com/app/_hub for examples.
# Remove inapplicable entries and comments as needed.

name: Websocket Size Limit
publisher: Kong Inc.

categories:
  - traffic-control

type: plugin

desc: Block incoming WebSocket messages greater than a specified size
description: |
  Allows operators to specify a maximum size for incoming WebSocket messages.
  Client and Upstream limits can have separate limits. Limits are applied to
  both text and binary frames as well as aggregated size of continuation frames.

  When an incoming message exceeds the limit:
    1. A close frame with status code `1009` is sent to the sender
    2. A close frame with status code `1001` is sent to the peer
    3. Both sides of the connection are closed

# COMPATIBILITY
# Uncomment at least one of 'community_edition' (Kong Gateway open-source) or
# 'enterprise_edition' (Kong Gateway Enterprise) and set `compatible: true`.

kong_version_compatibility:
  enterprise_edition:
    compatible:
      - 3.0.x

cloud: # (Kong Inc plugins only) Boolean
  # Specifies if your plugin is available in Konnect.
  # Set true if available, or false if not.

# SUBSCRIPTION TIERS (KONG INC PLUGINS ONLY)
# Set the subscription tiers that your plugin is restricted to.
# If your plugin is free/open-source, set `false` for both the enterprise and plus tiers.

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


#### Raising the default limits

Kong applies some default limits to incoming messages for all WebSocket
services:

| Sender   | Default Limit        |
|----------|----------------------|
| client   | `1048576` (`1MiB`)   |
| upstream | `16777216` (`16MiB`) |

This plugin can be used to increase the limit beyond the default.

#### Raise the client limit from the default (1MiB) to 2 MiB

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


> Why is the default client limit smaller than the default upstream limit?

Proxying client-originated messages is much more computationally expensive than
upstream messages due to the client-to-server masking [required by the WebSocket
specification](https://datatracker.ietf.org/doc/html/rfc6455#section-5.3), so
in general it is wise to maintain a lower limit for client messages.


## Under the hood

## How limits are applied

_Note_: Limits are evaluated based on the message payload length and not the
entire length of the WebSocket frame (header + payload).

### `text` and `binary` frames

For limits of 125 bytes and lower, the message is fully unserialized before
checking the message length.

For limits of 125 bytes and higher, the message length is checked from the
frame header _before_ the entire message is read from the socket buffer.

### `continuation` frames

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
    |     text(fin=false, len=500, msg=[...])     | # buffer += 500 (500)
    |-------------------------------------------->|
    |                                             |
    |   continue(fin=false, len=500, msg=[...])   |
    |-------------------------------------------->| # buffer += 500 (1000)
    |                                             |
    |   continue(fin=false, len=500, msg=[...])   |
    |-------------------------------------------->| # buffer += 500 (1500)
    |                                             | # buffer >= 1024
    | close(status=1009, msg="Payload Too Large") |
    |<--------------------------------------------|
 .------.                                       .----.
 |Client|                                       |Kong|
 '------'                                       '----'
```

### control frames

All control frames (`ping`, `pong`, and `close`) have a max payload size of
`125` bytes, as per the WebSocket
[specification](https://datatracker.ietf.org/doc/html/rfc6455#section-5.5). Kong
does not enforce any limits on control frames (even when set to a value lower
than `125`).