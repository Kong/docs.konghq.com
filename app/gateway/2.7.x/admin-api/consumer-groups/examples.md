---
title: Consumer Groups Examples
badge: enterprise
---

You can use consumer groups to manage custom rate limiting configuration for
subsets of consumers.

The `consumer_groups` endpoint works together with the [Rate Limiting Advanced plugin](/hub/kong-inc/rate-limiting-advanced).
To use consumer groups for rate limiting, configure the plugin with the
`enforce_consumer_groups` and `consumer_groups` parameters, then use the
`/consumer_groups` endpoint to manage the groups.

## Set up a consumer group with consumers

1. Create a consumer group named `JL`:

    ```bash
    http POST :8001/consumer_groups name=JL
    ```

    Response:
    ```json
    HTTP/1.1 201 Created
    ...
    {
        "created_at": 1638915521,
        "id": "8a4bba3c-7f82-45f0-8121-ed4d2847c4a4",
        "name": "JL"
    }
    ```

2. Create a consumer, `DianaPrince`, by making the following HTTP request to your
instance of the Kong Admin API:

    ```bash
    http POST :8001/consumers username=DianaPrince
    ```

    Response:
    ```json
    HTTP/1.1 201 Created
    ...
    {
        "created_at": 1638915577,
        "custom_id": null,
        "id": "8089a0e6-1d31-4e00-bf51-5b902899b4cb",
        "tags": null,
        "type": 0,
        "username": "DianaPrince",
        "username_lower": "dianaprince"
    }
    ```

3. Add `DianaPrince` to the `JL` consumer group:

    ```bash
    http POST :8001/consumer_groups/JL/consumers consumer=DianaPrince
    ```

    Response:
    ```json
    HTTP/1.1 201 Created

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

## Set up the Rate Limiting Advanced plugin and an override

1. Enable the [Rate Limiting Advanced plugin](/hub/kong-inc/rate-limiting-advanced),
configuring some basic settings:

    ```bash
    http -f :8001/plugins/  \
      name=rate-limiting-advanced \
      config.limit=5 \
      config.sync_rate=-1 \
      config.window_size=30 \
      config.window_type=sliding \
      config.retry_after_jitter_max=0 \
      config.enforce_consumer_groups=true \
      config.consumer_groups=JL
    ```

    For consumer groups, the following parameters are required:
    * `config.enforce_consumer_groups=true`: enables consumer groups for this plugin.
    * `config.consumer_groups=JL`: specifies a list of groups that this plugin allows overrides for.

    {:.note}
    > **Note:** In this example, we're configuring the plugin globally, so it will
    apply to all entities (Services, Routes, and Consumers) in the Kong instance.
    You can also apply it to a [specific Service or Route](/hub/kong-inc/rate-limiting-advanced)
    for more granular control.

2. The plugin you just set up applies to all consumers in the cluster. Let's
change the settings for the `JL` consumer group only:

    ```bash
    http PUT :8001/consumer_groups/JL/overrides/plugins/rate-limiting-advanced \
      config.limit:='[10]' \
      config.window_size:='[10]' \
      config.retry_after_jitter_max:=1
    ```

    Response:
    ```json
    {
      "config": {
          "limit": [
              10
          ],
          "retry_after_jitter_max": 1,
          "window_size": [
              10
          ]
      },
      "consumer_group": "JL",
      "plugin": "rate-limiting-advanced"
    }
    ```

3. Now let's check that it worked by looking at the `JL` consumer group object:

    ```bash
    http :8001/consumer_groups/JL
    ```

    Notice the `plugins` object in the response, along with the parameters that you
    just set for the Rate Limiting Advanced plugin:

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
        ],
        "plugins": [
            {
                "config": {
                    "limit": [
                        10
                    ],
                    "retry_after_jitter_max": 1,
                    "window_size": [
                        10
                    ],
                    "window_type": "sliding"
                },
                "consumer_group": {
                    "id": "8a4bba3c-7f82-45f0-8121-ed4d2847c4a4"
                },
                "created_at": 1638916518,
                "id": "b7c426a2-6fcc-4bfd-9b7a-b66e8f1ad260",
                "name": "rate-limiting-advanced"
            }
        ]
    }
    ```

## Remove a consumer from a consumer group - group view

1. Check the `JL` consumer group for the consumer name:

    ```bash
    http :8001/consumer_groups/JL
    ```

    Response:
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

2. Using the username or ID of the consumer (`DianaPrince` in this example),
remove the consumer from the group:

    ```bash
    http DELETE :8001/consumer_groups/JL/consumers/DianaPrince
    ```

    If successful, you will see the following response:
    ```
    HTTP/1.1 204 No Content
    ```

3. To verify, check the consumer object configuration:

    ```bash
    http :8001/consumers_groups/JL
    ```

    Response, with no consumers assigned:
    ```json
    {
        "consumer_group": {
            "created_at": 1638917780,
            "id": "be4bcfca-b1df-4fac-83cc-5cf6774bf48e",
            "name": "JL"
        }
    }
    ```

## Remove a consumer from a group - consumer view

1. If you know the consumer name and not the consumer group name,
you can look up the group through the consumer:

    ```bash
    http :8001/consumers/DianaPrince/consumer_groups
    ```

    Response:
    ```json
    {
        "consumer_groups": [
            {
                "created_at": 1638915521,
                "id": "8a4bba3c-7f82-45f0-8121-ed4d2847c4a4",
                "name": "JL"
            }
        ]
    }
    ```

2. Using the username or ID of the group (`JL` in this example),
remove the consumer from the group:

    ```bash
    http DELETE :8001/consumers/DianaPrince/consumer_groups/JL
    ```

    If successful, you will see the following response:
    ```
    HTTP/1.1 204 No Content
    ```

3. To verify, check the consumer object configuration:

    ```bash
    http :8001/consumers_groups/JL
    ```

    Response, with no consumers assigned:
    ```json
    {
        "consumer_group": {
            "created_at": 1638917780,
            "id": "be4bcfca-b1df-4fac-83cc-5cf6774bf48e",
            "name": "JL"
        }
    }
    ```


## Delete a consumer group

If you don't need a consumer group anymore, you can delete it. This removes
all consumers from the group, and deletes the group itself. The consumers in
the group are not deleted.

1. Delete a consumer group using the following request:
    ```bash
    http DELETE :8001/consumer_groups/JL
    ```

    If successful, you will see the following response:
    ```
    HTTP/1.1 204 No Content
    ```

2. Check the list of consumer groups to verify that the `JL` group is gone:

    ```bash
    http :8001/consumer_groups
    ```

    Response:
    ```json
    {
    "data": [],
    "next": null
    }
    ```

3. Check a consumer that was in the group to make sure it still exists:

    ```bash
    http :8001/consumers/DianaPrince
    ```

    An `HTTP/1.1 200 OK` response means the consumer exists.
