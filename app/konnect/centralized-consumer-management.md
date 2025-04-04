---
title: Centralized consumer management
---

A [consumer](/gateway/latest/key-concepts/consumers/) is a {{site.base_gateway}} entity that consumes or uses the APIs managed by {{site.base_gateway}}. These can be things like applications, services, or users who interact with your APIs. Consumers can be scoped to a {{site.konnect_short_name}} region and managed centrally, or be scoped to a control plane in Gateway Manager.

Centralized consumer management provides the following benefits:
* Set up consumer identity centrally instead of defining it in multiple control planes.
* Share consumers across multiple control planes. Users don't need to replicate changes to consumer identity in multiple control planes and consumer configuration doesn't conflict.
* Reduce configuration sync issues between the control plane and the data planes. Consumers that are managed centrally aren't part of the configuration that is pushed down from the control plane to the data planes, so it reduces config size and latency. 

## How centralized consumer management works

When you create a consumer centrally, you must assign it to a realm. A realm groups consumers around an identity, defined by organizational boundaries, such as a production realm or a development realm. Realms are connected to a [geographic region](/konnect/geo/) in {{site.konnect_short_name}}. Centrally managed consumers exist outside of control planes, so they can be used across control planes.

## Create consumers and realms 

You can manage consumers centrally using the {{site.konnect_short_name}} API. Only Org Admins and Control Plane Admins have CRUD permissions for these consumers. 

{:.important}
> Centralized consumer management is only available for {{site.base_gateway}} 3.10 data planes. Make sure your control plane uses 3.10 data planes at minimum when configuring these consumers.

1. Use the [`/realms` endpoint](/konnect/api/consumers/latest/#/operations/create-realm) to create a realm and optionally associate it with allowed control planes and time-to-live values:
   ```
   curl -X POST \
   https://{region}.api.konghq.com/v1/realms \
   -H "Content-Type: application/json" \
   -H "Authorization: Bearer $KONNECT_TOKEN" \
   -d '{
        "name": "prod",
        "allowed_control_planes": [
            "$CONTROL_PLANE_ID"
        ],
        "ttl": 10,
        "negative_ttl": 10,
        "consumer_groups": [
            "$CONSUMER_GROUP_NAME"
        ]
    }'
   ```
   Save the ID of the realm.

   Be sure to replace the following with your own values:
   * `{region}`: Region for your {{site.konnect_short_name}} instance. Data planes can only reach out to realms in the same region as the data plane.
   * `$KONNECT_TOKEN`: Replace with your {{site.konnect_short_name}} personal access token.
   * `$CONTROL_PLANE_ID`: (Optional) Replace with your control plane ID. If you don't specify a control plane, this means that no control plane can access the consumers in the realm. This value is used later when we configure consumer authentication. You can always add one later using the [Update a realm](/konnect/api/consumers/latest/#/operations/update-realm) endpoint.
   * `ttl`: (Optional) 'ttl' is the time-to-live (TTL) in minutes of the consumer for this realm in the {{site.base_gateway}} cache.
   * `negative_ttl`: (Optional) Represents the TTL of a bad login cache entry.
   * `$CONSUMER_GROUP_NAME`: (Optional) Replace with the name of the consumer groups you want to associate with the realm. When you assign consumers to the realm, this will also associate them with the consumer groups you list here. Consumer groups set here are additive. This means that if you configure the realm with consumer groups A and B, and then configure the consumer with consumer group C, the authenticated consumer will be assigned to consumer groups A, B, and C.
1. Use the [create a consumer](/konnect/api/consumers/latest/#/operations/create-consumer) endpoint to create a centrally managed consumer and optionally assign it to a consumer group:
   ```sh
   curl -X POST \
   https://{region}.api.konghq.com/v1/realms/{realmId}/consumers \
   -H "Content-Type: application/json" \
   -H "Authorization: Bearer $KONNECT_TOKEN" \
   -d '{
         "username": "$CONSUMER_NAME",
         "consumer_groups": ["$CONSUMER_GROUP_NAME"]
       }'
   ```
   Save the ID of the consumer.

   Be sure to replace the following with your own values:
   * `{region}`: Region for your {{site.konnect_short_name}} instance. Data planes can only reach out to realms in the same region as the data plane.
   * `$KONNECT_TOKEN`: Replace with your {{site.konnect_short_name}} personal access token.
   * `{realmId}`: The ID of the realm you created previously. 
   * `$CONSUMER_NAME`: Replace with the name of the consumer.
   * `$CONSUMER_GROUP_NAME`: (Optional) Replace with the name of the consumer groups you want to associate with the consumer. Consumer groups set here are additive. This means that if you configure the realm with consumer groups A and B, and then configure the consumer with consumer group C, the authenticated consumer will be assigned to consumer groups A, B, and C.
1. Configure authentication keys for consumers using the [Create a key](/konnect/api/consumers/latest/#/operations/create-consumer-key) endpoint:
   ```sh
   curl -X POST \
   https://{region}.api.konghq.com/v1/realms/{realmId}/consumers/{consumerId}/keys \
   -H "Content-Type: application/json" \
   -H "Authorization: Bearer KONNECT_TOKEN" \
   -d '{
        "type": "new"
       }'
   ```
   Be sure to replace the following with your own values:
   * `{region}`: Region for your {{site.konnect_short_name}} instance. Data planes can only reach out to realms in the same region as the data plane.
   * `KONNECT_TOKEN`: Replace with your {{site.konnect_short_name}} personal access token.
   * `{realmId}`: The ID of the realm you created previously.
   * `{consumerId}`: The ID of the consumer you created previously.

1. Consumers require authentication. Configure authentication using the [Key Auth plugin](/hub/kong-inc/key-auth/how-to/).

   `identity_realms` are scoped to the control plane by default (`scope: cp`). The order in which you configure the `identity_realms` dictates the priority in which the data plane attempts to authenticate the provided API keys:

    * **Realm is listed first:** The data plane will first reach out to the realm. If the API key is not found in the realm, the data plane will look for the API key in the control plane config. 
    * **Control plane scope listed first:** The data plane will initially check the control plane configuration (LMDB) for the API key before looking up the API Key in the realm.
    * **Realm only:** You can also configure a single `identity_realms` by omitting the `scope: cp` from the example. In this case, the data plane will only attempt to authenticate API keys against the realm. If the API key isn't found, the request will be blocked.
    * **Control plane only:** You can configure a look up only in the control plane config by only specifying `scope: cp` for `identity_realms`. In this scenario, the data plane will only check the control plane configuration (LMDB) for API key authentication. If the API key isn't found, the request will be blocked.

{:.note}
> **Note:** If you are using KIC to manage your data plane nodes in {{site.konnect_short_name}}, ensure that you configure the `telemetry_endpoint` in the data plane. You can find the `telemetry_endpoint` in the {{site.konnect_short_name}} UI in [Gateway Manager](https://cloud.konghq.com/gateway-manager/) in the data plane node instructions.


