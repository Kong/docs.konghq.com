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

2. Create a consumer, `DianaPrince`, by making the following HTTP request to your
instance of the Kong Admin API:

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

3. Add `DianaPrince` to the `JL` consumer group:

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
configuring some basic settings:
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
    > **Note:** In this example, we're configuring the plugin globally, so it will
    apply to all entities (Services, Routes, and Consumers) in the Kong instance.
    You can also apply it to a [specific Service or Route](/hub/kong-inc/rate-limiting-advanced)
    for more granular control.

2. The plugin you just set up applies to all consumers in the cluster. Let's
change the settings for the `JL` consumer group only:

{% capture override %}
{% navtabs codeblock %}
{% navtab cURL %}
```bash
curl -i -X PUT http://{HOSTNAME}:8001/consumer_groups/JL/overrides/plugins/  rate-limiting-advanced \
  --header 'Content-Type: application/json' \
  --data '{ "config": { "limit": [ 10 ], "retry_after_jitter_max": 1, "window_size": [ 10 ] } }'
```
{% endnavtab %}
{% navtab HTTPie %}
```bash
http PUT :8001/consumer_groups/JL/overrides/plugins/rate-limiting-advanced \
  config.limit:='[10]' \
  config.window_size:='[10]' \
  config.retry_after_jitter_max:=1
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

3. Check that it worked by looking at the `JL` consumer group object:

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

2. Using the username or ID of the consumer (`DianaPrince` in this example),
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

    If successful, you will see the following response:
    ```
    HTTP/1.1 204 No Content
    ```

3. To verify, check the consumer group configuration again:

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

2. Using the username or ID of the group (`JL` in this example),
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

    If successful, you will see the following response:
    ```
    HTTP/1.1 204 No Content
    ```

3. To verify, check the consumer object configuration:

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

    If successful, you will see the following response:
    ```
    HTTP/1.1 204 No Content
    ```

2. Check the list of consumer groups to verify that the `JL` group is gone:

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

3. Check a consumer that was in the group to make sure it still exists:

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
