---
title: Using custom data plane labels
content_type: how-to
---

You can set [labels](/konnect/reference/labels/) on each data plane node (data plane) to provide custom context information. 

Labels are commonly used for metadata information. Set anything that you need to identify your data plane nodes -- deployment type, region, size, the team that the instance belongs to, the purpose it serves, and much more. 

Using labels makes it easier to manage data plane nodes at scale since you're able to identify all of this information at a glance. For example, debugging and troubleshooting become much easier when you're able to attribute a data plane node to a specific region or team.

Any labels you set on a data plane node are visible from the control plane via the [`/nodes`](/konnect/api/runtime-groups-config/#nodes) {{site.konnect_short_name}} API endpoint.

## Set labels on a data plane node

{% navtabs %}
{% navtab kong.conf %}

1. Locate the [`konf.conf`](/gateway/latest/production/kong-conf/) file on a {{site.base_gateway}} data plane node. 
   
1. In `kong.conf`, configure the `cluster_dp_labels` parameter with a comma-separated list of labels for the instance. 

    Each label must be configured as a string in the format `key:value`.

    For example:

    ```
    cluster_dp_labels: "deployment:mycloud,region:us-east-1"
    ```

    For more information about label formatting, see the [Labels reference](/konnect/reference/labels/).

1. Reload {{site.base_gateway}}.

    ```
    kong reload
    ```

{% endnavtab %}
{% navtab Environment variables %}

1. On a {{site.base_gateway}} data plane node, configure the `KONG_CLUSTER_DP_LABELS` environment variable with 
a comma-separated list of labels for the instance. 

    Each label must be configured as a string in the format `key:value`.

    For example:

    ```
    KONG_CLUSTER_DP_LABELS = 'deployment:mycloud,region:us-east-1'
    ```

    For more information about label formatting, see the [Labels reference](/konnect/reference/labels/).

1. Reload {{site.base_gateway}}.

    ```
    kong reload
    ```

{% endnavtab %}
{% endnavtabs %}

## Validate

Check the `/nodes` endpoint to ensure that your labels have been applied, and that the control plane is able to see them:

```sh
curl -i -X GET 'https://{REGION}.api.konghq.com/v2/runtime-groups/{RUNTIME_GROUP_ID}/nodes' \
  --header 'Authorization: Bearer kpat_xgfT'
```

The response should look something like this, with an entry for `labels`:

```json
{
    "items": [
        {
            "compatibility_status": {
                "state": "COMPATIBILITY_STATE_FULLY_COMPATIBLE"
            },
            "config_hash": "ab5ff425e2518yh23ne23ea41a",
            "created_at": 1683841722,
            "data_plane_cert_id": "5773b391-8d17-4306-a205-5ed4837b1479",
            "hostname": "fb64faa80215",
            "id": "639fd146-6e08-4e1f-868d-b04ef41b4905",
            "labels": {
                "deployment": "mycloud",
                "region": "us-east-1"
            },
            "last_ping": 1683844593,
            "type": "kong-proxy",
            "updated_at": 1683844593,
            "version": "3.3.0.0"
        }
    ],
    "page": {
        "next_cursor": "fgkWXVVfGRZFABRcQA19QVtCMWYNDw5KAJLFGHGIYDQBdQFQ==",
        "total_count": 1
    }
}
```
