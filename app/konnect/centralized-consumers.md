---
title: Centralized Consumers
---

A [Consumer](/gateway/latest/key-concepts/consumers/) is a {{site.base_gateway}} entity that consumes or uses the APIs managed by {{site.base_gateway}}. These can be things like applications, services, or users who interact with your APIs. Consumers can be scoped to a {{site.konnect_short_name}} region and managed centrally as Centralized Consumers, or be scoped to a control plane in Gateway Manager.

Centralized Consumers provide the following benefits:
* The Consumer identity can be set up centrally instead of being defined across multiple control planes.
* Share Consumers across multiple control planes. Users don't need to replicate changes to Consumer identity in multiple control planes and Consumer configuration doesn't conflict.
* Reduces configuration sync issues between the control plane and the data planes. Centralized Consumers aren't part of the configuration that is pushed down from the control plane to the data planes, so it reduces config size and latency. 

## How Centralized Consumers work

When you create a centralized Consumer, you must assign it to a realm. A realm groups centralized Consumers around an identity, defined by organizational boundaries, such as a production realm or a development realm. Realms are connected to a [geographic region](/konnect/geo/) in {{site.konnect_short_name}}.

The following diagram shows how you can configure centralized Consumers in realms as well as scope Consumers to a Control Plane:

<!--vale off -->
{% mermaid %}
flowchart TD
A(Consumer: Cruz<br>Consumer Groups: Gold for appointments, Silver for billing)
B(Consumer: Ira<br>Consumer Groups: Gold for appointments)
C(Route: /appointments)
D(Gold tier: 1000 req/60 sec)
E(Route: /dev)
F(Consumer: Izumi)
G(Consumer: Sasha)
H(Route: /billing)
I(Silver tier: 10 req/60 sec)


subgraph id1 [Prod realm]
direction LR
    A
    B
end
subgraph id2 [Dev realm]
direction LR
    G
end


id1 --> id3
id1 --> id4
id2 --> id5

subgraph id3 [Appointments Control Plane]
direction LR
C
D
end

subgraph id4 [Billing Control Plane]
direction LR
H
I
end

subgraph id5 [Dev Control Plane]
direction LR
F
E
end

style id1 stroke-dasharray:3,rx:10,ry:10
style id2 stroke-dasharray:3,rx:10,ry:10
style id3 stroke-dasharray:3,rx:10,ry:10
style id4 stroke-dasharray:3,rx:10,ry:10
style id5 stroke-dasharray:3,rx:10,ry:10
{% endmermaid %}
<!-- vale on-->

## Create centralized Consumers and Realms 

You can create centralized Consumers using the {{site.konnect_short_name}} API. Only Org Admins have CRUD permissions for centralized Consumers. 

{:.important}
> Centralized Consumers are available for {{site.base_gateway}} 3.10 data planes. Make sure your control plane uses 3.10 data planes at minimum when configuring centralized Consumers.

1. Use the `/realms` endpoint to create a realm and optionally associate it with allowed Control Planes and time-to-live values:
   ```
   curl -X POST \
   https://{region}.api.konghq.com/v1/realms \
   -H "Content-Type: application/json" \
   -H "Authorization: Bearer $KONNECT_TOKEN" \
   -d '{
        "name": "prod",
        "allowed_control_planes": [
            "$CONTROL_PLANE_UUID"
        ],
        "ttl": 10,
        "negative_ttl": 10,
        "consumer_groups": [
            "$CONSUMER_GROUP"
        ]
    }'
   ```
   Save the ID of the realm.

   Be sure to replace the following with your own values:
   * {region}: Region for your {{site.konnect_short_name}} instance.
   * $KONNECT_TOKEN: Replace with your {{site.konnect_short_name}} personal access token.
   * $CONTROL_PLANE_UUID: (Optional) Replace with your Control Plane UUID.
   * `ttl` and `negative_ttl`: (Optional) Time-to-live in minutes of the consumer or negative consumer for this realm in the {{site.base_gateway}} cache.
   * $CONSUMER_GROUP: (Optional) Replace with the name of the consumer groups you want to associate with the realm.
1. Use the `/realms/{realmId}/consumers` endpoint to create a Consumer and optionally assign it to a Consumer Group:
   ```
   curl -X POST \
   https://{region}.api.konghq.com/v1/realms/{realmId}/consumers \
   -H "Content-Type: application/json" \
   -H "Authorization: Bearer TOKEN" \
   -d '{
         "username": "$CONSUMER_NAME",
         "consumer_groups": ["$CONSUMER_GROUP"]
       }'
   ```
   Be sure to replace the following with your own values:
   * {region}: Region for your {{site.konnect_short_name}} instance.
   * $KONNECT_TOKEN: Replace with your {{site.konnect_short_name}} personal access token.
   * {realmId}: The ID of the realm you created previously. 
   * $CONSUMER_NAME: Replace with the name of the consumer.
   * $CONSUMER_GROUP: (Optional) Replace with the name of the consumer groups you want to associate with the consumer.
1. Consumers require authentication. Configure authentication using the [Key Auth plugin](/hub/kong-inc/key-auth/#configure-realms-for-centralized-consumers-in-konnect).

{:.note}
> **Note:** If you are using KIC to manage your Data Plane nodes in {{site.konnect_short_name}}, ensure that you configure the `telemetry_endpoint` in the Data Plane. You can find the `telemetry_endpoint` in the {{site.konnect_short_name}} UI in [Gateway Manager](https://cloud.konghq.com/gateway-manager/) in the Data Plane node instructions.

