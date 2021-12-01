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
  "plugins": {
    "rate-limiting-advanced" : {
      "config": {
        "limit": 30
      }
    }
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
TBA
```

### List consumer groups for a consumer

**Endpoint**

<div class="endpoint get">/consumer/{CONSUMER_NAME|CONSUMER_ID}/consumer_groups</div>

Attribute                             | Description
---------:                            | --------  
`USERNAME|CONSUMER_ID`<br>*required*  | The name or UUID of the consumer.


## Create a consumer group

**Endpoint**

<div class="endpoint post">/consumer-groups</div>

**Request body**

Attribute                             | Description
---------:                            | --------
`GROUP_NAME|GROUP_ID`<br>*required*   | The name or UUID of the consumer group.                             |


**Response**

```json
HTTP 201 Created

{
  "created_at": 1557522650,
  "id": "fa6881b2-f49f-4007-9475-577cd21d34f4",
  "name": "my_group",
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
  "name": "my_group",
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
TBA
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
TBA
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
```json
TBA
```

### Remove a consumer from a specific group

**Consumer endpoint**
<div class="endpoint delete">/consumers/{USERNAME|CONSUMER_ID}/consumer_groups/{GROUP_NAME|GROUP_ID}</div>

Attribute                             | Description
---------:                            | --------  
`USERNAME|CONSUMER_ID`<br>*required*  | The name or UUID of the consumer to remove.
`GROUP_NAME|GROUP_ID`<br>*required*   | The name or UUID of the consumer group to remove the consumer from.

**Response**
```json
TBA
```

**Consumer groups endpoint**
<div class="endpoint delete">/consumer_groups/{GROUP_NAME|GROUP_ID}/consumers/{USERNAME|CONSUMER_ID}</div>

Attribute                             | Description
---------:                            | --------    
`GROUP_NAME|GROUP_ID`<br>*required*   | The name or UUID of the consumer group to remove the consumer from.
`USERNAME|CONSUMER_ID`<br>*required*  | The name or UUID of the consumer to remove.

**Response**
```json
TBA
```

## Configure rate limiting for a consumer group

<div class="endpoint put">/consumer_groups/{GROUP_NAME|GROUP_ID}/overrides/plugins/rate-limiting-advanced</div>

Attribute                             | Description
---------:                            | --------    
`GROUP_NAME|GROUP_ID`<br>*required*   | The name or UUID of the consumer group to configure.

**Request Body**

Attribute     | Description  
---------:    | --------
`limit`       |
`window_size` |
`window_type` |
`retry_after_jitter_max` |

[Q: Are the settings above the only possible settings? Are there less, more? Or can you set anything that the rate limiting advanced plugin has available?]

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
