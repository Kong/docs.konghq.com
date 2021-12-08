---
title: Consumer Groups Reference
badge: enterprise
---

You can use consumer groups to manage custom rate limiting configuration for
subsets of consumers.

The `consumer_groups` endpoint works together with the [Rate Limiting Advanced plugin](/hub/kong-inc/rate-limiting-advanced).
To use consumer groups for rate limiting, configure the plugin with the
`enforce_consumer_groups` and `consumer_groups` parameters, then use the
`/consumer_groups` endpoint to manage the groups.


## List consumer groups

### List all consumer groups

**Endpoint**

<div class="endpoint get">/consumer-groups</div>

**Response**

```json
{
    "data": [
        {
            "created_at": 1557522650,
            "id": "42b022c1-eb3c-4512-badc-1aee8c0f50b5",
            "name": "my_group"
        },
        {
            "created_at": 1637706162,
            "id": "fa6881b2-f49f-4007-9475-577cd21d34f4",
            "name": "my_group2"
        }
    ],
    "next": null
}
```

### List a specific consumer group

**Endpoint**

<div class="endpoint get">/consumer-groups/{GROUP_NAME|GROUP_ID}</div>

Attribute                             | Description
---------:                            | --------  
`GROUP_NAME|GROUP_ID`<br>*required*  | The name or UUID of the consumer group.

**Response**

```json
{
    "consumer_group": {
        "created_at": 1638917780,
        "id": "be4bcfca-b1df-4fac-83cc-5cf6774bf48e",
        "name": "JL"
    }
}
```


### List all consumers in a consumer group

**Endpoint**

<div class="endpoint get">/consumer-groups/{GROUP_NAME|GROUP_ID}/consumers</div>

Attribute                             | Description
---------:                            | --------  
`GROUP_NAME|GROUP_ID`<br>*required*  | The name or UUID of the consumer group.

**Response**

```json
{
    "consumers": [
        {
            "created_at": 1638918560,
            "id": "288f2bfc-04e2-4ec3-b6f3-40408dff5417",
            "type": 0,
            "username": "BarryAllen",
            "username_lower": "barryallen"
        },
        {
            "created_at": 1638915577,
            "id": "8089a0e6-1d31-4e00-bf51-5b902899b4cb",
            "type": 0,
            "username": "DianaPrince",
            "username_lower": "dianaprince"
        }
    ]
}
```

### List consumer groups for a consumer

**Endpoint**

<div class="endpoint get">/consumers/{CONSUMER_NAME|CONSUMER_ID}/consumer_groups</div>

Attribute                             | Description
---------:                            | --------  
`USERNAME|CONSUMER_ID`<br>*required*  | The name or UUID of the consumer.

**Response**

```json
{
    "consumer_groups": [
        {
            "created_at": 1638918476,
            "id": "e2c3f16e-22c7-4ef4-b6e4-ab25c522b339",
            "name": "JL"
        }
    ]
}
```


## Create a consumer group

**Endpoint**

<div class="endpoint post">/consumer-groups</div>

**Request body**

Attribute                             | Description
---------:                            | --------
`GROUP_NAME|GROUP_ID`<br>*required*   | The name or UUID of the consumer group.

**Response**

```json
HTTP 201 Created

{
  "created_at": 1557522650,
  "id": "fa6881b2-f49f-4007-9475-577cd21d34f4",
  "name": "JL",
}
```

**Endpoint**

<div class="endpoint put">/consumer-groups/{GROUP_NAME}</div>

Attribute                             | Description
---------:                            | --------
`GROUP_NAME|GROUP_ID`<br>*required*   | The name or UUID of the consumer group.


**Response**

```json
HTTP 201 Created

{
  "created_at": 1557522650,
  "id": "fa6881b2-f49f-4007-9475-577cd21d34f4",
  "name": "JL",
}
```

## Add a consumer to a group

**Endpoint**
<div class="endpoint post">/consumers/{USERNAME|CONSUMER_ID}/consumer_groups</div>

Attribute                             | Description
---------:                            | --------  
`USERNAME|CONSUMER_ID`<br>*required*  | The name or UUID of the consumer.

**Request body**

Attribute                             | Description
---------:                            | --------   
`group` *required*                    | The name or ID of the group to add the consumer to.

**Response**
```json
{
    "consumer": {
        "created_at": 1638918560,
        "custom_id": null,
        "id": "288f2bfc-04e2-4ec3-b6f3-40408dff5417",
        "tags": null,
        "type": 0,
        "username": "BarryAllen",
        "username_lower": "barryallen"
    },
    "consumer_groups": [
        {
            "created_at": 1638918476,
            "id": "e2c3f16e-22c7-4ef4-b6e4-ab25c522b339",
            "name": "JL"
        }
    ]
}
```

**Endpoint**
<div class="endpoint post">/consumer_groups/{GROUP_NAME|GROUP_ID}/consumers</div>

Attribute                             | Description
---------:                            | --------
`GROUP_NAME|GROUP_ID`<br>*required*   | The name or UUID of the consumer group.


**Request body**

Attribute                             | Description
---------:                            | --------   
`consumer` *required*                 | The name or ID of the consumer to add to this group.

**Response**
```json
{
  "consumer_group": {
  "created_at": 1638915521,
  "id": "8a4bba3c-7f82-45f0-8121-ed4d2847c4a4",
  "name": "JL"
  },
  "consumers": [
    {
        "created_at": 1638915577,
        "id": "8089a0e6-1d31-4e00-bf51-5b902899b4cb",
        "type": 0,
        "username": "DianaPrince",
        "username_lower": "dianaprince"
    }
  ]
}
```

## Delete a consumer group

Deleting a consumer group removes all consumers from that group. It does
**not** delete any consumers.

**Endpoint**
<div class="endpoint delete">/consumer-groups/{GROUP_NAME|GROUP_ID}</div>

Attribute                             | Description
---------:                            | --------
`GROUP_NAME|GROUP_ID`<br>*required*   | The name or UUID of the consumer group to delete.

## Remove a consumer

### Remove a consumer from all groups

**Endpoint**
<div class="endpoint delete">/consumers/{USERNAME|CONSUMER_ID}/consumer_groups</div>

Attribute                             | Description
---------:                            | --------
`USERNAME|CONSUMER_ID`<br>*required*   | The name or UUID of the consumer to remove from all groups.

**Response**

```
HTTP/1.1 204 No Content
```

### Remove a consumer from a specific group

**Consumer endpoint**
<div class="endpoint delete">/consumers/{USERNAME|CONSUMER_ID}/consumer_groups/{GROUP_NAME|GROUP_ID}</div>

Attribute                             | Description
---------:                            | --------  
`USERNAME|CONSUMER_ID`<br>*required*  | The name or UUID of the consumer to remove.
`GROUP_NAME|GROUP_ID`<br>*required*   | The name or UUID of the consumer group to remove the consumer from.

**Response**

```
HTTP/1.1 204 No Content
```

**Consumer groups endpoint**
<div class="endpoint delete">/consumer_groups/{GROUP_NAME|GROUP_ID}/consumers/{USERNAME|CONSUMER_ID}</div>

Attribute                             | Description
---------:                            | --------    
`GROUP_NAME|GROUP_ID`<br>*required*   | The name or UUID of the consumer group to remove the consumer from.
`USERNAME|CONSUMER_ID`<br>*required*  | The name or UUID of the consumer to remove.

**Response**

```
HTTP/1.1 204 No Content
```

## Configure rate limiting for a consumer group

<div class="endpoint put">/consumer_groups/{GROUP_NAME|GROUP_ID}/overrides/plugins/rate-limiting-advanced</div>

Attribute                             | Description
---------:                            | --------    
`GROUP_NAME|GROUP_ID`<br>*required*   | The name or UUID of the consumer group to configure.

**Request Body**

Attribute     | Description  
---------:    | --------
`limit`<br>*required*       | An array of one or more requests-per-window limits to apply. There must be a matching number of window limits and sizes specified.
`window_size`<br>*required* | An array of one or more window sizes to apply a limit to (defined in seconds). There must be a matching number of window limits and sizes specified.
`window_type`<br>*optional* | Set the time window type to either `sliding` (default) or `fixed`.
`retry_after_jitter_max`<br>*optional* | The upper bound of a jitter (random delay) in seconds to be added to the `Retry-After` header of denied requests (status = `429`) in order to prevent all the clients from coming back at the same time. The lower bound of the jitter is `0`; in this case, the `Retry-After` header is equal to the `RateLimit-Reset` header.

**Response**

```json
{
    "config": {
        "limit": [
            10
        ],
        "retry_after_jitter_max": 0,
        "window_size": [
            10
        ],
        "window_type": "sliding"
    },
    "group": "test-group",
    "plugin": "rate-limiting-advanced"
}
```
