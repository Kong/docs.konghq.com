---
nav_title: Configure realms for consumers
title: Configure realms for consumers in {{site.konnect_short_name}}
minimum_version: 3.10.x
---

Starting in {{site.base_gateway}} 3.10.x, you can authenticate [consumers that are managed centrally](/konnect/centralized-consumer-management/) in {{site.konnect_short_name}} by configuring the `identity_realms` field in the Key Auth plugin. A data plane can only reach out to realms in the same region as they are deployed.

## Prerequisites

A realm configured with an associated control plane. You can do this with the [`/realms` endpoint](/konnect/api/consumers/latest/#/operations/create-realm).

## Enable authentication

Add the `identity_realms` field as shown below:

```bash
curl -X POST \
https://{region}.api.konghq.com/v2/control-planes/{controlPlaneId}/core-entities/plugins/ \
   --header "accept: application/json" \
   --header "Content-Type: application/json" \
   --header "Authorization: Bearer KONNECT_TOKEN" \
   --data '{
      "name": "key-auth",
      "config": {
         "key_names": ["apikey"],
         "identity_realms": [
            {
               "region": "$REGION",
               "id": "$REALM_ID",
               "scope": "realm"
            },
            {
               "scope": "cp"
            }
         ]
      }
   }'
```
Be sure to replace the following with your own values:
   * {region}: Region for your {{site.konnect_short_name}} instance.
   * {controlPlaneId}: ID of your control plane.
   * KONNECT_TOKEN: Replace with your {{site.konnect_short_name}} personal access token.
   * $REALM_ID: The ID of the realm you created previously. 
   * $REGION: Region for your {{site.konnect_short_name}} instance.

`identity_realms` are scoped to the control plane by default (`scope: cp`). The order in which you configure the `identity_realms` dictates the priority in which the data plane attempts to authenticate the provided API keys:

* **Realm is listed first:** The data plane will first reach out to the realm. If the API key is not found in the realm, the data plane will look for the API key in the control plane config. 
* **Control plane scope listed first:** The data plane will initially check the control plane configuration (LMDB) for the API key before looking up the API Key in the realm.
* **Realm only:** You can also configure a single `identity_realms` by omitting the `scope: cp` from the example. In this case, the data plane will only attempt to authenticate API keys against the realm. If the API key isn't found, the request will be blocked.
* **Control plane only:** You can configure a look up only in the control plane config by only specifying `scope: cp` for `identity_realms`. In this scenario, the data plane will only check the control plane configuration (LMDB) for API key authentication. If the API key isn't found, the request will be blocked.