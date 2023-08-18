---
nav_title: How to create rate limiting tiers
---



With consumer groups, you can define rate limiting tiers and apply them to subsets of application consumers.

You can define consumer groups as tiers, for example:

* A **gold tier** consumer group with 1000 requests per minute
* A **silver tier** consumer group with 10 requests per second
* A **bronze tier** consumer group with 6 requests per second


Consumers that are not in a consumer group default to the Rate Limiting advanced
plugin’s configuration, so you can define tier groups for some users and
have a default behavior for consumers without groups.


To use consumer groups for rate limiting, you need to:
* Create one or more consumer groups
* Create consumers
* Assign consumers to groups
{% if_plugin_version lte:3.3.x %}
* Configure the Rate Limiting Advanced plugin with the `enforce_consumer_groups`
and `consumer_groups` parameters, setting up the list of consumer groups that
the plugin accepts
* Configure rate limiting for each consumer group, overriding the plugin's
configuration
{% endif_plugin_version %}

## Create rate limiting tiers

1. Create a consumer group named `Gold`:

    ```bash
    curl -i -X POST http://localhost:8001/consumer_groups \
    --data name=Gold
    ```

    Response:

    ```json
    {
        "created_at": 1638915521,
        "id": "8a4bba3c-7f82-45f0-8121-ed4d2847c4a4",
        "name": "Gold",
        "tags": null
    }
    ```

1. Create a consumer, `Amal`:

    ```bash
    curl -i -X POST http://localhost:8001/consumers \
    --data username=Amal
    ```

    Response:

    ```json
    {
        "created_at": 1638915577,
        "custom_id": null,
        "id": "8089a0e6-1d31-4e00-bf51-5b902899b4cb",
        "tags": null,
        "type": 0,
        "username": "Amal",
        "username_lower": "amal"
    }
    ```

1. Add `Amal` to the `Gold` consumer group:

    ```bash
    curl -i -X POST http://localhost:8001/consumer_groups/Gold/consumers \
    --data consumer=Amal
    ```

    Response:

    ```json
    {
      "consumer_group": {
      "created_at": 1638915521,
      "id": "8a4bba3c-7f82-45f0-8121-ed4d2847c4a4",
      "name": "Gold",
      "tags": null
      },
      "consumers": [
        {
            "created_at": 1638915577,
            "id": "8089a0e6-1d31-4e00-bf51-5b902899b4cb",
            "type": 0,
            "username": "Amal",
            "username_lower": "amal"
        }
      ]
    }
    ```
{% if_plugin_version gte:3.4.x %}
1. Enable the plugin on the consumer group:

    ```bash
    curl -i -X POST http://localhost:8001/consumer_groups/gold/plugins/  \
    --data name=rate-limiting-advanced \
    --data config.limit=5 \
    --data config.window_size=30 \
    --data config.window_type=sliding \
    --data config.retry_after_jitter_max=0 \
    ```
This configuration sets the rate limit to five requests (`config.limit`) for every
30 seconds (`config.window_size`). 

{% endif_plugin_version %}

{% if_plugin_version lte:3.3.x %}
## Set up Rate Limiting Advanced config for consumer group

1. Enable the [Rate Limiting Advanced plugin](/hub/kong-inc/rate-limiting-advanced/),
setting the rate limit to five requests (`config.limit`) for every
30 seconds (`config.window_size`):



    ```bash
    curl -i -X POST http://localhost:8001/plugins/  \
    --data name=rate-limiting-advanced \
    --data config.limit=5 \
    --data config.window_size=30 \
    --data config.window_type=sliding \
    --data config.retry_after_jitter_max=0 \
    --data config.enforce_consumer_groups=true \
    --data config.consumer_groups=Gold
    ```

    For consumer groups, the following parameters are required:
    * `config.enforce_consumer_groups=true`: enables consumer groups for this plugin.
    * `config.consumer_groups=Gold`: specifies a list of groups that this plugin allows overrides for.


    {:.note}
    > **Note:** In this example, you're configuring the plugin globally, so it
    applies to all entities (services, routes, and consumers) in the
    {{site.base_gateway}} instance. You can also apply it to a
    [specific service or route](/hub/kong-inc/rate-limiting-advanced/how-to/basic-example/)
    for more granular control.

1. The plugin you just set up applies to all consumers in the cluster. Change
the rate limiting configuration for the `Gold` consumer group only, setting
the limit to ten requests for every ten seconds:

    ```bash
    curl -i -X PUT http://localhost:8001/consumer_groups/Gold/overrides/plugins/rate-limiting-advanced \
    --data config.limit=10 \
    --data config.window_size=10 \
    --data config.retry_after_jitter_max=1
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
      "consumer_group": "Gold",
      "plugin": "rate-limiting-advanced"
    }
    ```

1. Check that it worked by looking at the `Gold` consumer group object:

    ```bash
    curl -i -X GET http://localhost:8001/consumer_groups/Gold
    ```

    Notice the `plugins` object in the response, along with the parameters that you
    just set for the Rate Limiting Advanced plugin:

{% if_plugin_version lte:3.3.x %}

    ```json
    {
        "consumer_group": {
            "created_at": 1638915521,
            "id": "8a4bba3c-7f82-45f0-8121-ed4d2847c4a4",
            "name": "Gold",
            "tags": null
        },
        "consumers": [
            {
                "created_at": 1638915577,
                "id": "8089a0e6-1d31-4e00-bf51-5b902899b4cb",
                "type": 0,
                "username": "Amal",
                "username_lower": "amal"
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
{% endif_plugin_version %}
{% if_plugin_version gte:3.4.x %}

    ```json
    {
        "consumer_group": {
            "created_at": 1638915521,
            "id": "8a4bba3c-7f82-45f0-8121-ed4d2847c4a4",
            "name": "Gold",
            "tags": null
        },
        "consumers": [
            {
                "created_at": 1638915577,
                "id": "8089a0e6-1d31-4e00-bf51-5b902899b4cb",
                "type": 0,
                "username": "Amal",
                "username_lower": "amal"
            }
        ]
    }
    ```
{% endif_plugin_version %}

## Remove consumer from group - group view

You can remove a consumer from a group by accessing `/consumers` or
`/consumer_groups`. The following steps use `/consumer_groups`.

1. Check the `Gold` consumer group for the consumer name:

    ```bash
    curl -i -X GET http://localhost:8001/consumer_groups/Gold
    ```

    Response:

    ```json
    {
        "consumer_group": {
            "created_at": 1638915521,
            "id": "8a4bba3c-7f82-45f0-8121-ed4d2847c4a4",
            "name": "Gold",
            "tags": null
        },
        "consumers": [
            {
                "created_at": 1638915577,
                "id": "8089a0e6-1d31-4e00-bf51-5b902899b4cb",
                "type": 0,
                "username": "Amal",
                "username_lower": "amal"
            }
        ]
      }
    ```

1. Using the username or ID of the consumer (`Amal` in this example),
remove the consumer from the group:

    ```bash
    curl -i -X DELETE http://localhost:8001/consumer_groups/Gold/consumers/Amal
    ```

    If successful, you receive the following response:
    ```
    HTTP/1.1 204 No Content
    ```

1. To verify, check the consumer group configuration again:

    ```bash
    curl -i -X GET http://localhost:8001/consumer_groups/Gold
    ```

    Response, with no consumers assigned:

    ```json
    {
        "consumer_group": {
            "created_at": 1638917780,
            "id": "be4bcfca-b1df-4fac-83cc-5cf6774bf48e",
            "name": "Gold",
            "tags": null
        }
    }
    ```

## Remove consumer from group - consumer view

You can remove a consumer from a group by accessing `/consumers` or
`/consumer_groups`. The following steps use `/consumers`.

1. If you know the consumer name and not the consumer group name,
you can look up the group through the consumer:

    ```bash
    curl -i -X GET http://localhost:8001/consumers/Amal/consumer_groups
    ```

    Response:

    ```json
    {
        "consumer_groups": [
            {
                "created_at": 1638915521,
                "id": "8a4bba3c-7f82-45f0-8121-ed4d2847c4a4",
                "name": "Gold",
                "tags": null
            }
        ]
    }
    ```

1. Using the username or ID of the group (`Gold` in this example),
remove the consumer from the group:

    ```bash
    curl -i -X DELETE http://localhost:8001/consumers/Amal/consumer_groups/Gold
    ```

    If successful, you receive the following response:
    ```
    HTTP/1.1 204 No Content
    ```

1. To verify, check the consumer object configuration:

    ```bash
    curl -i -X GET http://localhost:8001/consumer_groups/Gold
    ```

    Response, with no consumers assigned:

    ```json
    {
        "consumer_group": {
            "created_at": 1638917780,
            "id": "be4bcfca-b1df-4fac-83cc-5cf6774bf48e",
            "name": "Gold",
            "tags": null
        }
    }
    ```

## Delete consumer group configurations

You can also clear the configuration of a consumer group without deleting the consumer group itself.

With this method, the consumers in the group aren't deleted and are still in the consumer group.

1. Delete the consumer group configuration using the following request:

    ```bash
    curl -i -X DELETE http://localhost:8001/consumer_groups/Gold/overrides/plugins/rate-limiting-advanced
    ```

    If successful, you receive see the following response:
    ```
    HTTP/1.1 204 No Content
    ```
    
1. To verify, check the consumer object configuration:

    ```bash
    curl -i -X GET http://localhost:8001/consumer_groups/Gold
    ```

    Response, without a `plugins` object:

    ```json
    {
        "consumer_group": {
            "created_at": 1638917780,
            "id": "be4bcfca-b1df-4fac-83cc-5cf6774bf48e",
            "name": "Gold",
            "tags": null
        }
    }
    ```


## Delete consumer group

If you don't need a consumer group anymore, you can delete it. This removes
all consumers from the group, and deletes the group itself. The consumers in
the group are not deleted.

1. Delete a consumer group using the following request:

    ```bash
    curl -i -X DELETE http://localhost:8001/consumer_groups/Gold
    ```

    If successful, you receive the following response:
    ```
    HTTP/1.1 204 No Content
    ```

1. Check the list of consumer groups to verify that the `Gold` group is gone:

    ```bash
    curl -i -X GET http://localhost:8001/consumer_groups
    ```

    Response:
    ```json
    {
    "data": [],
    "next": null
    }
    ```

1. Check a consumer that was in the group to make sure it still exists:

    ```bash
    curl -i -X GET http://localhost:8001/consumers/Amal
    ```

    An `HTTP/1.1 200 OK` response means the consumer exists.


## Manage multiple consumers

You can perform many `/consumer_groups` operations in bulk.

1. Assuming you deleted the group `Gold` in the previous section, create it again,
along with another group named `Silver`:

    ```bash
    curl -i -X POST http://localhost:8001/consumer_groups \
    --data name=Gold

    curl -i -X POST http://localhost:8001/consumer_groups \
    --data name=Speedsters
    ```

1. Create two consumers, `Alex` and `Charlie`:

    ```bash
    curl -i -X POST http://localhost:8001/consumers \
    --data username=Alex

    curl -i -X POST http://localhost:8001/consumers \
    --data username=Charlie
    ```

1. Add both consumers to the `Speedsters` group:

    ```bash
    curl -i -X POST http://localhost:8001/consumer_groups/Speedsters/consumers \
    --data consumer=Alex \
    --data consumer=Charlie
    ```

    {{site.base_gateway}} validates the provided list of consumers before assigning
    them to the consumer group. To pass validation, consumers must exist and must
    not be in the group already.

    If any consumer fails validation, no consumers are assigned to the group.

    Response, if everything is successful:

    ```json
    {
        "consumer_group": {
            "created_at": 1639432267,
            "id": "a905151a-5767-40e8-804e-50eec4d0235b",
            "name": "Speedsters",
            "tags": null
        },
        "consumers": [
            {
                "created_at": 1639432286,
                "id": "ea904e1d-1f0d-4d5a-8391-cae60cb21d61",
                "type": 0,
                "username": "Alex",
                "username_lower": "Alex"
            },
            {
                "created_at": 1639432288,
                "id": "065d8249-6fe6-4d80-a0ae-f159caef7af0",
                "type": 0,
                "username": "Charlie",
                "username_lower": "Charlie"
            }
        ]
    }
    ```

1. You can clear all consumers from a group with one request. This may be useful
if you need to cycle the group for a new batch of users.

    For example, delete all consumers from the `Speedsters` group:

    ```bash
    curl -i -X DELETE http://localhost:8001/consumer_groups/Speedsters/consumers
    ```

    Response:
    ```
    HTTP/1.1 204 No Content
    ```

1. You can also add a consumer to multiple groups:
    * If all groups are allowed by the Rate Limiting Advanced plugin,
    only the first group's settings apply.
    * Otherwise, whichever group is specified in the Rate Limiting Advanced
    plugin becomes active.

    Add `Alex` to two groups, `Gold` and `Speedsters`:

    ```bash
    curl -i -X POST http://localhost:8001/consumers/Alex/consumer_groups \
    --data group=Gold \
    --data group=Speedsters
    ```

    The response should look something like this:

    ```json
    {
      "consumer": {
          "created_at": 1639436091,
          "custom_id": null,
          "id": "6098d577-6741-4cf8-9c86-e68057b8f970",
          "tags": null,
          "type": 0,
          "username": "Alex",
          "username_lower": "Alex"
      },
      "consumer_groups": [
          {
              "created_at": 1639432267,
              "id": "a905151a-5767-40e8-804e-50eec4d0235b",
              "name": "Gold",
              "tags": null
          },
          {
              "created_at": 1639436107,
              "id": "2fd2bdd6-690c-4e49-8296-31f55015496d",
              "name": "Speedsters",
              "tags": null
          }
      ]
    }
    ```

1. Finally, you can also remove a consumer from all groups:

    ```bash
    curl -i -X DELETE http://localhost:8001/consumers/Alex/consumer_groups
    ```

    Response:
    ```
    HTTP/1.1 204 No Content
    ```

{% endif_plugin_version %}

## More Information

* [Consumer Groups API documentation](/gateway/latest/admin-api/consumer-groups/reference/).