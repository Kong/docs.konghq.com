---
title: Verify audit log signatures
content_type: how-to
badge: enterprise
---

{{site.konnect_short_name}} uses an [ED25519 signature](https://ed25519.cr.yp.to/) on the audit logs it produces.

Audit logs can be exported in two different formats, CEF and JSON. 
Calculating the signature is slightly different for these formats.

## Verify a signature

1. Retrieve the public key from the audit log JWKS endpoint:

    ```sh
    curl -i -X GET https://us.api.konghq.com/v2/audit-log-webhook/jwks.json
    ```

    The response should look something like this, where the public key is 
    the value in the `x` attribute:

    ```json
    {
        "keys": [
            {
                "alg": "EdDSA",
                "crv": "Ed25519",
                "kid": "1d4608c22e448672d5386b4071b70442as45c58265",
                "kty": "OKP",
                "x": "aFNAu9QEQhiunrGuyS14ePHzoOb2vash783p1-_Nrc3M"
            }
        ]
    }
    ```

1. Extract the signature of the entry to calculate the signature to match. 

1. Both the signature and the public key are Base64 URL-encoded. Decode them into bytes.

1. Remove the signature value from the entry.

   The adjusted entry will look slightly different depending on the format that you're using. 
   See the [CEF verification payload](#cef-verification-payload) and 
   [JSON verification payload](#json-verification-payload) sections for examples.

1. Verify the ED25519 signature with the public key, signature-less audit log entry, and decoded signature.

## CEF verification payload

For a CEF entry, the signature is computed on the CEF value with the signature field, value, and 
preceding whitespace removed. 

For example, for the following CEF entry:

```
Apr 14 05:39:08 konghq.com CEF:0|KongInc|Konnect|1.0|konnect|Authz.usage|1|rt=1681450748406 src=127.0.0.6 action=retrieve granted=true org_id=b065b594-6afc-4658-9101-5d9cf3f36b7b principal_id=87655c36-8d63-48fe-9a1e-53b28dfbc19b trace_id=3895213347334635099 user_agent=grpc-node/1.24.11 grpc-c/8.0.0 (linux; chttp2; ganges) sig=fnjOUISTC2uLWTqCcmwUuOWa_daa4vEPxxUn2-QPVU1dmB-Ed2y2mwoB9dq94JJz2tF6Ok41Bci4FGwk4FhxAg
```

You would calculate the signature on this payload:

```
Apr 14 05:39:08 konghq.com CEF:0|KongInc|Konnect|1.0|konnect|Authz.usage|1|rt=1681450748406 src=127.0.0.6 action=retrieve granted=true org_id=b065b594-6afc-4658-9101-5d9cf3f36b7b principal_id=87655c36-8d63-48fe-9a1e-53b28dfbc19b trace_id=3895213347334635099 user_agent=grpc-node/1.24.11 grpc-c/8.0.0 (linux; chttp2; ganges)
```

## JSON verification payload

For a JSON entry, the `sig` field, value, and prepended comma is removed from the entry. 

For example, for the following JSON entry:

```json
{"action":"read","cef_version":"0","event_class_id":"identity","event_product":"Konnect","event_ts":"2023-04-28T20:52:09Z","event_vendor":"KongInc","event_version":"1.0","granted":true,"name":"Authz.identity-provider","org_id":"b065b594-6afc-4658-9101-5d9cf3f36b7b","principal_id":"87655c36-8d63-48fe-9a1e-53b28dfbc19b","rt":1682715129807,"severity":1,"src":"127.0.0.6","trace_id":3895213347334635099,"user_agent":"grpc-go/1.54.0","sig":"Jm73seSwAiacSBysDmgQ3D_R_1c39_T0Iuus9GqUEnAjCc-UnyKhFgS8jDx5UIl4J6PTCH5ouuPizwnjnMDECg"}
```

You would calculate the signature on this payload:

{:.note}
> **Note**: Don't add any extra whitespace or make any formatting changes to the JSON entries.

```json
{"action":"read","cef_version":"0","event_class_id":"identity","event_product":"Konnect","event_ts":"2023-04-28T20:52:09Z","event_vendor":"KongInc","event_version":"1.0","granted":true,"name":"Authz.identity-provider","org_id":"b065b594-6afc-4658-9101-5d9cf3f36b7b","principal_id":"87655c36-8d63-48fe-9a1e-53b28dfbc19b","rt":1682715129807,"severity":1,"src":"127.0.0.6","trace_id":3895213347334635099,"user_agent":"grpc-go/1.54.0"}
```
