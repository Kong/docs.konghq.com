---
title: Consumer Groups Examples
badge: enterprise
---

With consumer groups, you can define any number of rate limiting tiers and
apply them to subsets of consumers, instead of managing each consumer
individually.

For example, you could define three consumer groups:
* A "gold tier" with 1000 requests per minute
* A "silver tier" with 10 requests per second
* A "bronze tier" with 6 requests per second

The `consumer_groups` endpoint works together with the [Rate Limiting Advanced plugin](/hub/kong-inc/rate-limiting-advanced).

Consumers that are not in a consumer group default to the Rate Limiting advanced
plugin’s configuration, so you can define tier groups for some users and
have a default behavior for ungrouped consumers.

To use consumer groups for rate limiting, you need to:
* Create one or more consumer groups
* Create consumers
* Assign consumers to groups
* Configure the Rate Limiting Advanced plugin with the `enforce_consumer_groups`
and `consumer_groups` parameters, setting up the list of consumer groups that
the plugin accepts
* Configure rate limiting for each consumer group, overriding the plugin's
configuration

For all possible requests, see the
[Consumer Groups reference](/gateway/{{page.kong_version}}/admin-api/consumer-groups/reference).

{:.note}
> **Note:** Consumer groups are not supported in declarative configuration with
decK. If you have consumer groups in your configuration, decK will ignore them.

## Set up consumer group

1. Create a consumer group named `JL`:

{% capture create_consumer_group %}
{% navtabs codeblock %}
{% navtab cURL %}
```bash
curl -i -X POST http://{HOSTNAME}:8001/consumer_groups \
  --data name=JL
```
{% endnavtab %}
{% navtab HTTPie %}
```bash
http POST :8001/consumer_groups name=JL
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}

{{ create_consumer_group | indent | replace: " </code>", "</code>" }}

    Response:

    ```json
    {
        "created_at": 1638915521,
        "id": "8a4bba3c-7f82-45f0-8121-ed4d2847c4a4",
        "name": "JL"
    }
    ```

1. Create a consumer, `DianaPrince`:

{% capture create_consumer %}
{% navtabs codeblock %}
{% navtab cURL %}
```bash
curl -i -X POST http://{HOSTNAME}:8001/consumers \
  --data username=DianaPrince
```
{% endnavtab %}
{% navtab HTTPie %}
```bash
http POST :8001/consumers username=DianaPrince
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}

{{ create_consumer | indent | replace: " </code>", "</code>" }}

    Response:

    ```json
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

1. Add `DianaPrince` to the `JL` consumer group:

{% capture add_consumer %}
{% navtabs codeblock %}
{% navtab cURL %}
```bash
curl -i -X POST http://{HOSTNAME}:8001/consumer_groups/JL/consumers \
  --data consumer=DianaPrince
```
{% endnavtab %}
{% navtab HTTPie %}
```bash
http POST :8001/consumer_groups/JL/consumers consumer=DianaPrince
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}

{{ add_consumer | indent | replace: " </code>", "</code>" }}

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

## Set up Rate Limiting Advanced config for consumer group

1. Enable the [Rate Limiting Advanced plugin](/hub/kong-inc/rate-limiting-advanced),
setting the rate limit to five requests (`config.limit`) for every
30 seconds (`config.window_size`):

{% capture add_plugin %}
{% navtabs codeblock %}
{% navtab cURL %}
```bash
curl -i -X POST http://{HOSTNAME}:8001/plugins/  \
  --data name=rate-limiting-advanced \
  --data config.limit=5 \
  --data config.sync_rate=-1 \
  --data config.window_size=30 \
  --data config.window_type=sliding \
  --data config.retry_after_jitter_max=0 \
  --data config.enforce_consumer_groups=true \
  --data config.consumer_groups=JL
```
{% endnavtab %}
{% navtab HTTPie %}
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
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}

{{ add_plugin | indent | replace: " </code>", "</code>" }}

    For consumer groups, the following parameters are required:
    * `config.enforce_consumer_groups=true`: enables consumer groups for this plugin.
    * `config.consumer_groups=JL`: specifies a list of groups that this plugin allows overrides for.

    {:.note}
    > **Note:** In this example, you're configuring the plugin globally, so it
    applies to all entities (Services, Routes, and Consumers) in the
    {{site.base_gateway}} instance. You can also apply it to a
    [specific Service or Route](/hub/kong-inc/rate-limiting-advanced)
    for more granular control.

1. The plugin you just set up applies to all consumers in the cluster. Change
the rate limiting configuration for the `JL` consumer group only, setting
the limit to ten requests for every ten seconds:

{% capture override %}
{% navtabs codeblock %}
{% navtab cURL %}
```bash
curl -i -X PUT http://{HOSTNAME}:8001/consumer_groups/JL/overrides/plugins/rate-limiting-advanced \
  --data config.limit=10 \
  --data config.window_size=10 \
  --data config.retry_after_jitter_max=1
```
{% endnavtab %}
{% navtab HTTPie %}
```bash
http PUT :8001/consumer_groups/JL/overrides/plugins/rate-limiting-advanced \
  config.limit=10 \
  config.window_size=10 \
  config.retry_after_jitter_max=1
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}

{{ override | indent | replace: " </code>", "</code>" }}

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

1. Check that it worked by looking at the `JL` consumer group object:

{% capture check_group1 %}
{% navtabs codeblock %}
{% navtab cURL %}
```bash
curl -i -X GET http://{HOSTNAME}:8001/consumer_groups/JL
```
{% endnavtab %}
{% navtab HTTPie %}
```bash
http :8001/consumer_groups/JL
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}

{{ check_group1 | indent | replace: " </code>", "</code>" }}

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

## Remove consumer from group - group view

You can remove a consumer from a group by accessing `/consumers` or
`/consumer_groups`. The following steps use `/consumer_groups`.

1. Check the `JL` consumer group for the consumer name:

{{ check_group1 | indent | replace: " </code>", "</code>" }}

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

1. Using the username or ID of the consumer (`DianaPrince` in this example),
remove the consumer from the group:

{% capture delete_consumer1 %}
{% navtabs codeblock %}
{% navtab cURL %}
```bash
curl -i -X DELETE http://{HOSTNAME}:8001/consumer_groups/JL/consumers/DianaPrince
```
{% endnavtab %}
{% navtab HTTPie %}
```bash
http DELETE :8001/consumer_groups/JL/consumers/DianaPrince
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}

{{ delete_consumer1 | indent | replace: " </code>", "</code>" }}

    If successful, you receive the following response:
    ```
    HTTP/1.1 204 No Content
    ```

1. To verify, check the consumer group configuration again:

{{ check_group1 | indent | replace: " </code>", "</code>" }}

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

## Remove consumer from group - consumer view

You can remove a consumer from a group by accessing `/consumers` or
`/consumer_groups`. The following steps use `/consumers`.

1. If you know the consumer name and not the consumer group name,
you can look up the group through the consumer:

{% capture check_group2 %}
{% navtabs codeblock %}
{% navtab cURL %}
```bash
curl -i -X GET http://{HOSTNAME}:8001/consumers/DianaPrince/consumer_groups
```
{% endnavtab %}
{% navtab HTTPie %}
```bash
http :8001/consumers/DianaPrince/consumer_groups
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}

{{ check_group2 | indent | replace: " </code>", "</code>" }}

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

1. Using the username or ID of the group (`JL` in this example),
remove the consumer from the group:

{% capture delete_consumer2 %}
{% navtabs codeblock %}
{% navtab cURL %}
```bash
curl -i -X DELETE http://{HOSTNAME}:8001/consumers/DianaPrince/consumer_groups/JL
```
{% endnavtab %}
{% navtab HTTPie %}
```bash
http DELETE :8001/consumers/DianaPrince/consumer_groups/JL
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}

{{ delete_consumer2 | indent | replace: " </code>", "</code>" }}

    If successful, you receive the following response:
    ```
    HTTP/1.1 204 No Content
    ```

1. To verify, check the consumer object configuration:

{{ check_group1 | indent | replace: " </code>", "</code>" }}

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


## Delete consumer group

If you don't need a consumer group anymore, you can delete it. This removes
all consumers from the group, and deletes the group itself. The consumers in
the group are not deleted.

1. Delete a consumer group using the following request:

{% capture delete_consumer2 %}
{% navtabs codeblock %}
{% navtab cURL %}
```bash
curl -i -X DELETE http://{HOSTNAME}:8001/consumer_groups/JL
```
{% endnavtab %}
{% navtab HTTPie %}
```bash
http DELETE :8001/consumer_groups/JL
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}

{{ delete_consumer2 | indent | replace: " </code>", "</code>" }}

    If successful, you receive see the following response:
    ```
    HTTP/1.1 204 No Content
    ```

1. Check the list of consumer groups to verify that the `JL` group is gone:

{% capture check_all_groups %}
{% navtabs codeblock %}
{% navtab cURL %}
```bash
curl -i -X GET http://{HOSTNAME}:8001/consumer_groups
```
{% endnavtab %}
{% navtab HTTPie %}
```bash
http :8001/consumer_groups
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}

{{ check_all_groups | indent | replace: " </code>", "</code>" }}

    Response:
    ```json
    {
    "data": [],
    "next": null
    }
    ```

1. Check a consumer that was in the group to make sure it still exists:

{% capture check_consumer %}
{% navtabs codeblock %}
{% navtab cURL %}
```bash
curl -i -X GET http://{HOSTNAME}:8001/consumers/DianaPrince
```
{% endnavtab %}
{% navtab HTTPie %}
```bash
http :8001/consumers/DianaPrince
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}

{{ check_consumer | indent | replace: " </code>", "</code>" }}

    An `HTTP/1.1 200 OK` response means the consumer exists.


## Manage multiple consumers

You can perform many `/consumer_groups` operations in bulk.

1. Assuming you deleted the group `JL` in the previous section, create it again,
along with another group named `Speedsters`:

{% capture create_consumer_group2 %}
{% navtabs codeblock %}
{% navtab cURL %}
```bash
curl -i -X POST http://{HOSTNAME}:8001/consumer_groups \
  --data name=JL

curl -i -X POST http://{HOSTNAME}:8001/consumer_groups \
  --data name=Speedsters
```
{% endnavtab %}
{% navtab HTTPie %}
```bash
http POST :8001/consumer_groups name=JL

http POST :8001/consumer_groups name=Speedsters
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}

{{ create_consumer_group2 | indent | replace: " </code>", "</code>" }}

1. Create two consumers, `BarryAllen` and `WallyWest`:

{% capture create_two_consumers %}
{% navtabs codeblock %}
{% navtab cURL %}
```bash
curl -i -X POST http://{HOSTNAME}:8001/consumers \
  --data username=BarryAllen

curl -i -X POST http://{HOSTNAME}:8001/consumers \
  --data username=WallyWest
```
{% endnavtab %}
{% navtab HTTPie %}
```bash
http POST :8001/consumers username=BarryAllen

http POST :8001/consumers username=WallyWest
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}

{{ create_two_consumers | indent | replace: " </code>", "</code>" }}

1. Add both consumers to the `Speedsters` group:
{% capture add_two_consumers %}
{% navtabs codeblock %}
{% navtab cURL %}
```bash
curl -i -X POST http://{HOSTNAME}:8001/consumer_groups/Speedsters/consumers \
  --data consumer=BarryAllen \
  --data consumer=WallyWest
```
{% endnavtab %}
{% navtab HTTPie %}
```bash
http POST :8001/consumer_groups/Speedsters/consumers \
  consumer:='["BarryAllen", "WallyWest"]'
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}

{{ add_two_consumers | indent | replace: " </code>", "</code>" }}

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
            "name": "Speedsters"
        },
        "consumers": [
            {
                "created_at": 1639432286,
                "id": "ea904e1d-1f0d-4d5a-8391-cae60cb21d61",
                "type": 0,
                "username": "BarryAllen",
                "username_lower": "barryallen"
            },
            {
                "created_at": 1639432288,
                "id": "065d8249-6fe6-4d80-a0ae-f159caef7af0",
                "type": 0,
                "username": "WallyWest",
                "username_lower": "wallywest"
            }
        ]
    }
    ```

1. You can clear all consumers from a group with one request. This may be useful
if you need to cycle the group for a new batch of users.

    For example, delete all consumers from the `Speedsters` group:

{% capture delete_all_consumers %}
{% navtabs codeblock %}
{% navtab cURL %}
```bash
curl -i -X DELETE http://{HOSTNAME}:8001/consumer_groups/Speedsters/consumers
```
{% endnavtab %}
{% navtab HTTPie %}
```bash
http DELETE :8001/consumer_groups/Speedsters/consumers
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}

{{ delete_all_consumers | indent | replace: " </code>", "</code>" }}

    Response:
    ```
    HTTP/1.1 204 No Content
    ```

1. You can also add a consumer to multiple groups:
    * If all groups are allowed by the Rate Limiting Advanced plugin,
    only the first group's settings apply.
    * Otherwise, whichever group is specified in the Rate Limiting Advanced
    plugin becomes active.

    Add `BarryAllen` to two groups, `JL` and `Speedsters`:

{% capture add_consumer_many_groups %}
{% navtabs codeblock %}
{% navtab cURL %}
```bash
curl -i -X POST http://{HOSTNAME}:8001/consumers/BarryAllen/consumer_groups \
  --data group=JL \
  --data group=Speedsters
```
{% endnavtab %}
{% navtab HTTPie %}
```bash
http POST :8001/consumers/BarryAllen/consumer_groups \
  group:='["JL", "Speedsters"]'
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}

{{ add_consumer_many_groups | indent | replace: " </code>", "</code>" }}

    The response should look something like this:

    ```json
    {
      "consumer": {
          "created_at": 1639436091,
          "custom_id": null,
          "id": "6098d577-6741-4cf8-9c86-e68057b8f970",
          "tags": null,
          "type": 0,
          "username": "BarryAllen",
          "username_lower": "barryallen"
      },
      "consumer_groups": [
          {
              "created_at": 1639432267,
              "id": "a905151a-5767-40e8-804e-50eec4d0235b",
              "name": "JL"
          },
          {
              "created_at": 1639436107,
              "id": "2fd2bdd6-690c-4e49-8296-31f55015496d",
              "name": "Speedsters"
          }
      ]
    }
    ```

1. Finally, you can also remove a consumer from all groups:

{% capture add_consumer_many_groups %}
{% navtabs codeblock %}
{% navtab cURL %}
```bash
curl -i -X DELETE http://{HOSTNAME}:8001/consumers/BarryAllen/consumer_groups
```
{% endnavtab %}
{% navtab HTTPie %}
```bash
http DELETE :8001/consumers/BarryAllen/consumer_groups
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}

{{ add_consumer_many_groups | indent | replace: " </code>", "</code>" }}

    Response:
    ```
    HTTP/1.1 204 No Content
    ```
