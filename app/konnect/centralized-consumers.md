---
title: Centralized Consumers
alpha: true
---

A [Consumer](/gateway/latest/key-concepts/consumers/) is a {{site.base_gateway}} entity that consumes or uses the APIs managed by {{site.base_gateway}}. These can be things like applications, services, or users who interact with your APIs. Consumers can be scoped to a {{site.konnect_short_name}} region and managed centrally (centralized Consumers) or be scoped to a control plane in Gateway Manager.

Centralized Consumers provide the following benefits:
* The Consumer identity can be setup centrally instead of being defined across multiple control planes.
* Share Consumers across multiple control planes. Users don't need to replicate changes to Consumer identity in multiple control planes and Consumer configuration doesn't conflict.
* Reduces configuration sync issues between the control plane and the dataplane. Centralized Consumers aren't part of the configuration that is pushed down from the control plane to the dataplane, so it reduces config size and latency. 

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

1. Use the following custom {{site.base_gateway}} image:
   ```
   kong/kong-gateway-dev:ac1501420169b29ea38c03d747f9204826ec8ac8
   ```
1. Use the `/realms` endpoint to create a realm and optionally associate it with allowed Control Planes and time-to-live values:
   ```
   curl -X POST \
   https://{region}.api.konghq.com/v1/realms \
   -H "Content-Type: application/json" \
   -H "Authorization: Bearer TOKEN" \
   -d '{
        "name": "prod",
        "allowed_control_planes": [
            "497f6eca-6276-4993-bfeb-53cbbbba6f08"
        ],
        "ttl": 10,
        "negative_ttl": 10,
        "consumer_groups": [
            "gold"
        ]
    }'
   ```
1. Use the `/realms/{realmId}/consumers` endpoint to create a Consumer and optionally assign it to a Consumer Group:
   ```
   curl -X POST \
   https://{region}.api.konghq.com/v1/realms/{realmId}/consumers \
   -H "Content-Type: application/json" \
   -H "Authorization: Bearer TOKEN" \
   -d '{
         "username": "Alice",
         "consumer_groups": ["gold"]
       }'
   ```
1. Consumers require authentication. Configure authentication using the [Key Auth plugin](/hub/kong-inc/key-auth/#configure-realms-for-centralized-consumers-in-konnect).

{:.note}
> **Note:** If you are using KIC to manage your Data Plane nodes in {{site.konnect_short_name}}, ensure that you configure the `telemetry_endpoint` in the Data Plane. You can find the `telemetry_endpoint` in the {{site.konnect_short_name}} UI in [Gateway Manager]() in the Data Plane node instructions.

