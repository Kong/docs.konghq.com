---
title: Event Hooks Reference
book: event-hooks
---

## Introduction

{:.important}
> **Important:** Before you can use event hooks for the first time, Kong needs to be
reloaded.

{% include /md/enterprise/event-hooks-intro.md %}

{:.note}
> **Note:** Event hooks do not work with Konnect Cloud yet.

## List all event hooks

**Endpoint**

<div class="endpoint get">/event-hooks</div>

**Response**

```json
{
    "data": [
        {
            "config": {
                "body": null,
                "body_format": true,
                "headers": {
                    "content-type": "application/json"
                },
                "headers_format": false,
                "method": "POST",
                "payload": {
                    "text": "{% raw %}Admin account \`{{ entity.username }}\` {{ operation}}d; email address set to \`{{ entity.email }}\`{% endraw %}"
                },
                "payload_format": true,
                "secret": null,
                "ssl_verify": false,
                "url": "https://hooks.slack.com/services/foo/bar/baz"
            },
            "created_at": 1627588552,
            "event": "admins",
            "handler": "webhook-custom",
            "id": "937df175-3db2-4e6d-8aa1-d95c94a76089",
            "on_change": null,
            "snooze": null,
            "source": "crud"
        },
        {
            "config": {
                "headers": {},
                "secret": null,
                "ssl_verify": false,
                "url": "https://webhook.site/a1b2c3-d4e5-g6h7-i8j9-k1l2m3n4o5p6"
            },
            "created_at": 1627581575,
            "event": "consumers",
            "handler": "webhook",
            "id": "c57340ab-9fed-40fd-bb7e-1cef8d37c2df",
            "on_change": null,
            "snooze": null,
            "source": "crud"
        },
        {
            "config": {
                "functions": [
                    "return function (data, event, source, pid)\n  local user = data.entity.username\n  error(\"Event hook on consumer \" .. user .. \"\")\nend\n"
                ]
            },
            "created_at": 1627595513,
            "event": "consumers",
            "handler": "lambda",
            "id": "c9fdd58d-5416-4d3a-9467-51e5cfe4ca0e",
            "on_change": null,
            "snooze": null,
            "source": "crud"
        }
    ],
    "next": null
}
```

## List all sources

Sources are the actions that trigger the event hook. The `/sources` JSON output follows the following pattern:
- 1st level = The source, which is the action that triggers the event hook.
- 2nd level = The event, which is the Kong entity the event hook will listen to for events.
- 3rd level = The available template parameters for use in webhook-custom payloads.

For instance, in the example below `balancer` is the source, `health` is the event, and `upstream_id`,
`ip`, `port`, `hostname`, and `health` are the available template parameters.

**Endpoint**

<div class="endpoint get">/event-hooks/sources/</div>

**Response**

```json
{
    "data": {
        "balancer": {
            "health": {
                "fields": [
                    "upstream_id",
                    "ip",
                    "port",
                    "hostname",
                    "health"
                ]
            }
        },
        "crud": {
            "acls": {
                "fields": [
                    "operation",
                    "entity",
                    "old_entity",
                    "schema"
                ]
            },
            . . .

        "rate-limiting-advanced": {
            "rate-limit-exceeded": {
                "description": "Run an event when a rate limit has been exceeded",
                "fields": [
                    "consumer",
                    "ip",
                    "service",
                    "rate",
                    "limit",
                    "window"
                ],
                "unique": [
                    "consumer",
                    "ip",
                    "service"
                ]
            }
        }
    }
}
```

{:.note}
> **Note:** The response has been shortened because it is too long to include in its entirety.
The ellipsis in the center of the response represents the missing content.

## List all events for a source

Events are the Kong entities the event hook will listen to for events. With this endpoint you
can list all of the events associated with a particular source. 

<div class="endpoint get">/event-hooks/sources/{source}/</div>

The following response lists all of the events for the `dao:crud` source.

**Response**

```json
{
    "data": {
        "create": {
            "fields": [
                "operation",
                "entity",
                "old_entity",
                "schema"
            ]
        },
        "delete": {
            "fields": [
                "operation",
                "entity",
                "old_entity",
                "schema"
            ]
        },
        "update": {
            "fields": [
                "operation",
                "entity",
                "old_entity",
                "schema"
            ]
        }
    }
}
```

## Add a webhook

**Endpoint**

<div class="endpoint post">/event-hooks</div>

**Request Body**

| Attribute                             | Description                                                                                                              |
| ---------:                            | --------                                                                                                                 |
| `event`<br>*optional*                 | A string describing the Kong entity the event hook will listen to for events.                                            |
| `handler`<br>*required*               | A string describing one of four handler options: webhook, webhook-custom, log, or lambda.                                |
| `source`<br>*required*                | A string describing the action that triggers the event hook.                                                             |
| `snooze`<br>*optional*                | An optional integer describing the time in seconds to delay an event trigger to avoid spamming an integration.           |
| `on_change`<br>*optional*             | An optional boolean indicating whether to trigger an event when key parts of a payload have changed.                     |
| `config.url`<br>*required*            | The URL the JSON POST request is made to with the event data as the payload.                                             |
| `config.headers`<br>*optional*        | An object defining additional HTTP headers to send in the webhook request, for example `{"X-Custom-Header": "My Value"}`.|
| `config.secret`<br>*optional*         | An optional string used to sign the remote webhook for remote verification. When set, Kong will sign the body of the event hook with HMAC-SHA1 and include it in a header, `x-kong-signature`, to the remote endpoint. |
| `config.ssl_verify`<br>*optional*     | A boolean indicating whether to verify the SSL certificate of the remote HTTPS server where the event hook will be sent. The default is `false`. |

**Response**

```json
{
    "config": {
        "headers": {},
        "secret": null,
        "ssl_verify": false,
        "url": "https://webhook.site/a1b2c3-d4e5-g6h7-i8j9-k1l2m3n4o5p6"
    },
    "created_at": 1627581575,
    "event": "consumers",
    "handler": "webhook",
    "id": "c57340ab-9fed-40fd-bb7e-1cef8d37c2df",
    "on_change": null,
    "snooze": null,
    "source": "crud"
}
```

## Add a custom webhook

**Endpoint**

<div class="endpoint post">/event-hooks</div>

**Request Body**

| Attribute                             | Description                                                                                                     |
| ---------:                            | --------                                                                                                        |
| `event`<br>*optional*                 | A string describing the Kong entity the event-hook will listen to for events.                                   |
| `handler`<br>*required*               | A string describing one of four handler options: webhook, webhook-custom, log, or lambda.                       |
| `source`<br>*required*                | A string describing the action that triggers the event hook.                                                    |
| `snooze`<br>*optional*                | An optional integer describing the time in seconds to delay an event trigger to avoid spamming an integration.  |
| `on_change`<br>*optional*             | An optional boolean indicating whether to trigger an event when key parts of a payload have changed.            |
| `config.url`<br>*required*            | The URL the JSON POST request is made to with the event data as the payload.                                    |
| `config.method`<br>*required*         | The HTTP method used to create the custom webhook.                                                              |
| `config.payload`<br>*optional*        | An object that includes key/value pairs that describe the configurable payload body. Supports templating. The full list of available template parameters can be found in the `/sources` API output, under the `fields` JSON object. |
| `config.payload_format`<br>*optional* | A optional boolean (defaults to `true`) indicating whether to format the `config.payload` with resty templating. When set to `false`, the payload is sent as a raw object. |
| `config.body`<br>*optional*           | An optional string sent in the remote request.                                                          |
| `config.body_format`<br>*optional*    | An optional boolean (defaults to `true`) indicating whether to format the `config.body` with resty templating. When set to `false`, the body is sent as a raw object. To see all the available parameters defined for a specific `source`, check the source fields displayed by the `/event-hooks/source` endpoint. |
| `config.headers`                      | An object defining additional HTTP headers to send in the webhook request, for example `{"Content-type": "application/json", "X-Custom-Header": "My Value"}`. |
| `config.headers_format`<br>*optional* | An optional boolean (defaults to `false`) indicating whether to format the `config.headers` with resty templating. When set to `true`, the `config.headers` value will be treated as a template. To see all the available parameters defined for a specific `source`, check the source fields displayed by the `/event-hooks/sources` endpoint. |
| `config.secret`<br>*optional*         | An optional string used to sign the remote webhook for remote verification. When set, Kong will sign the body of the event hook with HMAC-SHA1 and include it in a header, `x-kong-signature`, to the remote endpoint. |
| `config.ssl_verify`<br>*optional*     | A boolean indicating whether to verify the SSL certificate of the remote HTTPS server where the event hook will be sent. The default value is `false`. |

**Response**

```json
{
    "config": {
        "body": null,
        "body_format": true,
        "headers": {
            "content-type": "application/json"
        },
        "headers_format": false,
        "method": "POST",
        "payload": {
            "text": "Admin account `{{ entity.username }}` {{ operation }}d; email address set to `{{ entity.email }}`"
        },
        "payload_format": true,
        "secret": null,
        "ssl_verify": false,
        "url": "https://hooks.slack.com/services/foo/bar/baz"
    },
    "created_at": 1627588552,
    "event": "admins",
    "handler": "webhook-custom",
    "id": "937df175-3db2-4e6d-8aa1-d95c94a76089",
    "on_change": null,
    "snooze": null,
    "source": "crud"
}
```

## Add a log event hook

**Endpoint**

<div class="endpoint post">/event-hooks</div>

**Request Body**

| Attribute                           | Description                                                                                                       |
| ---------:                          | --------                                                                                                          |
| `event`<br>*optional*               | A string describing the Kong entity the event hook will listen to for events.                                     |
| `handler`<br>*required*             | A string describing one of four handler options: webhook, webhook-custom, log, or lambda.                         |
| `source`<br>*required*              | A string describing the action that triggers the event hook.                                                      |
| `snooze`<br>*optional*              | An optional integer describing the time in seconds to delay an event trigger to avoid spamming an integration.    |
| `on_change`<br>*optional*           | An optional boolean indicating whether to trigger an event when key parts of a payload have changed.              |

**Response**

```json
{
  "config": {},
  "on_change": null,
  "created_at": 1627346155,
  "snooze": null,
  "id": "13a16f91-68b6-4384-97f7-d02763a551ac",
  "handler": "log",
  "source": "crud",
  "event": "routes"
}
```

## Add a lambda event hook

**Endpoint**

<div class="endpoint post">/event-hooks</div>

**Request Body**

| Attribute                             | Description                                                                                                     |
| ---------:                            | --------                                                                                                        |
| `event`<br>*optional*                 | A string describing the Kong entity the event hook will listen to for events.                                   |
| `handler`<br>*required*               | A string describing one of four handler options: webhook, webhook-custom, log, or lambda.                       |
| `source`<br>*required*                | A string describing the action that triggers the event hook.                                                    |
| `snooze`<br>*optional*                | An optional integer describing the time in seconds to delay an event trigger to avoid spamming an integration.  |
| `on_change`<br>*optional*             | An optional boolean indicating whether to trigger an event when key parts of a payload have changed.            |
| `config.functions`<br>*required*      | An array of Lua code functions to execute on the event hook.                                                    |

**Response**

```json
{
    "config": {
        "functions": [
            "return function (data, event, source, pid)\n  local user = data.entity.username\n  error(\"Event hook on consumer \" .. user .. \"\")\nend\n"
        ]
    },
    "created_at": 1627595513,
    "event": "consumers",
    "handler": "lambda",
    "id": "c9fdd58d-5416-4d3a-9467-51e5cfe4ca0e",
    "on_change": null,
    "snooze": null,
    "source": "crud"
}
```

## Test an event hook

It's useful to manually trigger an event hook without provoking the event to be triggered.
For instance, you might want to test the integration, or see if your hook's service is receiving a payload from Kong.

POST any data to `/event-hooks/:id-of-hook/test`, and the `/test` endpoint executes the with the provided data as the event payload.

**Endpoint**

<div class="endpoint post">/event-hooks/{event-hook-id}/test</div> 

**Response**

```json
{
    "data": {
        "consumer": {
            "username": "Jane Austen"
        },
        "event": "consumers",
        "source": "crud"
    },
    "result": {
        "body": "",
        "headers": {
            "Cache-Control": "no-cache, private",
            "Content-Type": "text/plain; charset=UTF-8",
            "Date": "Fri, 30 Jul 2021 16:07:09 GMT",
            "Server": "nginx/1.14.2",
            "Transfer-Encoding": "chunked",
            "Vary": "Accept-Encoding",
            "X-Request-Id": "f1e703a5-d22c-435c-8d5d-bc9c561ead4a",
            "X-Token-Id": "1cc1c53b-f613-467f-a5c9-20d276405104"
        },
        "status": 200
    }
}

```

## Ping a webhook event hook

**Endpoint**

<div class="endpoint get">/event-hooks/{event-hook-id}/ping</div>

**Response**

```json
{
  "source": "kong:event_hooks",
  "event_hooks": {
    "source": "crud",
    "id": "c57340ab-9fed-40fd-bb7e-1cef8d37c2df",
    "on_change": null,
    "event": "consumers",
    "handler": "webhook",
    "created_at": 1627581575,
    "config": {
      "headers": {
        "content-type": "application/json"
      },
      "ssl_verify": false,
      "url": "https://webhook.site/a1b2c3-d4e5-g6h7-i8j9-k1l2m3n4o5p6",
      "secret": null
    },
    "snooze": null
  },
  "event": "ping"
}
```
