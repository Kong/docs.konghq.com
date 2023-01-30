---
name: Kong JWT Signer
publisher: Kong Inc.
desc: Verify and sign one or two tokens in a request
description: |
  The Kong JWT Signer plugin makes it possible to verify, sign, or re-sign
  one or two tokens in a request. With a two token request, one token
  is allocated to an end user and the other token to the client application,
  for example.

  The plugin refers to tokens as an _access token_
  and _channel token_. Tokens can be any valid verifiable tokens. The plugin
  supports both opaque tokens through introspection,
  and signed JWT tokens through signature verification. There are many
  configuration parameters available to accommodate your requirements.
enterprise: true
plus: true
type: plugin
categories:
  - authentication
kong_version_compatibility:
  community_edition:
    compatible: null
  enterprise_edition:
    compatible: true
---

## Manage key signing

If you specify `config.access_token_keyset` or `config.channel_token_keyset` with either an
`http://` or `https://` prefix, it means that token signing keys are externally managed by you.
In that case, the plugin loads the keys just like it does for `config.access_token_jwks_uri`
and `config.channel_token_jwks_uri`. If the prefix is not `http://` or `https://`
(such as `"my-company"` or `"kong"`), Kong autogenerates JWKS for supported algorithms.

External JWKS specified with `config.access_token_keyset` or
`config.channel_token_keyset` should also contain private keys with supported `alg`,
either `"RS256"` or `"RS512"` for now. External URLs that contain private keys should
be protected so that only Kong can access them. Currently, Kong doesn't add any authentication
headers when it loads the keys from an external endpoint, so you have to do it with network
level restrictions. If it is a common need to manage private keys externally
instead of allowing Kong to autogenerate them, we can add another parameter
for adding an authentication header (possibly similar to
`config.channel_token_introspection_authorization`).

The key size (the modulo) for RSA keys is currently hard-coded to 2048 bits.

## Consumer mapping

The following parameters let you provide consumer mapping:

- `config.access_token_consumer_claim`
- `config.access_token_introspection_consumer_claim`
- `config.channel_token_consumer_claim`
- `config.channel_token_introspection_consumer_claim`

You can map only once. The plugin applies mappings in the following order:

1. access token introspection results
2. access token jwt payload
3. access token introspection results
4. access token jwt payload

The mapping order depends on input (opaque or JWT).

When mapping is done, no other mappings are used. If access token already maps
to a Kong consumer, the plugin does not try to map a channel token to a consumer
anymore and does not even error in that case.

A general rule is to map either the access token or the channel token.

## Kong Admin API Endpoints

This plugin also provides a few Admin API endpoints, and some actions upon them.

### Cached JWKS Admin API Endpoint

The plugin caches JWKS specified with `config.access_token_jwks_uri` and
`config.channel_token_jwks_uri` to Kong database for quicker access to them. The plugin
further caches JWKS in Kong node's shared memory, and on process a level memory for
even quicker access. When the plugin is responsible for signing the tokens, it
also stores its own keys in the database.

Admin API endpoints never reveal private keys but do reveal public keys.
Private keys that the plugin autogenerates can only be accessed from database
directly (at least for now). Private parts in JWKS include
properties such as `d`, `p`, `q`, `dp`, `dq`, `qi`, and `oth`. For public keys
that are using a symmetric algorithm (such as `HS256`) and include `k` parameter,
that is not hidden from Admin API as that is practically used both to verify and
to sign. This makes it a bit problematic to use, and we strongly suggest using
asymmetric (or public key) algorithms. Doing so also makes rotating the keys
easier because the public keys can be shared between parties
and published without revealing their secrets.

View all of the public keys that Kong has loaded or generated:

```http
GET kong:8001/jwt-signer/jwks
```

Example:

```bash
curl -X GET http://<kong>:8001/jwt-signer/jwks
```
```json
{
    "data": [
        {
            "created_at": 1535560520731,
            "id": "c1d2d9b7-ac3a-4ca4-b595-453acd78925e",
            "keys": [
                {
                    "alg": "RS256",
                    "e": "AQAB",
                    "kid": "aXKFjIY80eM_H4rqhT6iaOfdL5iDHDHjag2BWLaxeJA",
                    "kty": "RSA",
                    "n": "qDjxLGSa4jI14ctmvjMDQzZDfZJcXS6G6-wcVxLsQgrIWc_JnZ44b1ApAokFwaZsig4oNFLQYAMdapZSORI2jNlZ9lsJ-b3VZUz0gB5jGaFAyx7G1Uh46w_-2JZKI4wW8KinJ8VZayobSYS3eg6p3f34t2mDv36Uwa4B8DZKo8cE0JE8T2ne2lyS18W9bJkpfIoctcDjzsvFTg4NbEF3Y61q5v_6icxyJkB9JtS2JE1RjJxmBDOb_ETCLyIiN0Wlb9OdLX_HSdY3DRfnYNl3XAaPdqr8QifqidfdWI4YnJiJ3mYAgI-E37waZ0-1-Ykt-mpvUX1l_UvAdxqetGuC5Q",
                    "use": "sig"
                },
                {
                    "alg": "RS512",
                    "e": "AQAB",
                    "kid": "xb_lFJbpaVuo7cWO7XADl0PsL4G97VFpFg3hIgRiJHQ",
                    "kty": "RSA",
                    "n": "vLY2u2q1gmzysPCbjq7mSDwh2oeRLZ3A047gn0-JsNWF2BZrgMUlB5cnKHOUPAD2ugHjUAOVMy_1d6FO2VBxV6i66KgWM_CMu0sqpmM-n7iUq8TCbpOX5mWczt3GutXPw960--LGyFTuuy2xi1wVYW1WbDIvb4oLo9b0G1eJIjvtSjmQ8tiBkiIxnRGKKxeZl0oTX99v6Z9X1aXoQ11y46l4_IGsN1b8ZWfBJ7Glyi80trWIs6z-EmZED6gdRushRT98GHofqTPRaaOnOJ1itHECj6U82ec6UU-IBtryGqUn_PQ9fUpI1Ru-0jGEcMY3aBZdZ4Uy_189ELK4jqn28w",
                    "use": "sig"
                }
            ],
            "name": "kong",
            "previous": [],
            "updated_at": 1535560520731
        },
        {
            "created_at": 1535560520379,
            "id": "d9d5b731-55fe-4cad-829f-6aba4b2d8823",
            "keys": [
                {
                    "alg": "RS256",
                    "e": "AQAB",
                    "kid": "b863b534069bfc0207197bcf831320d1cdc2cee2",
                    "kty": "RSA",
                    "n": "8h6tCwOYDPtzyFivNaIguQVc_yBO5eOA2kUu_MAN8s4VWn8tIfCbVvcAz3yNwQuGpkdNg8gTk9QmReXl4SE8m7aCa0iRcBBWLyPUt6TM1RkYE51rOGYhjWxo9V8ogMXSBclE6x0t8qFY00l5O34gjYzXtyvyBX7Sw5mGuNLVAzq2nsCTnIsHrIaBy70IKU3FLsJ_PRYyViXP1nfo9872q3mtn7bJ7_hqss0vDgUiNAqPztVIsrZinFbaTgXjLhBlUjFWgJx_g4p76CJkjQ3-puZRU5A0D04KvqQ_0AWcN1Q8pvwQ9V4uGHm6Bop9nUhIcZJYjjlTM9Pkx_JnVOfekw",
                    "use": "sig"
                },
                {
                    "alg": "RS256",
                    "e": "AQAB",
                    "kid": "55b854edf35f093b4708f72dec4f15149836e8ac",
                    "kty": "RSA",
                    "n": "xul55cFjIY7QFMhl79y_3MWK4rHDRqTu-C2VxaPqxbLUSW-LJp8hotDeIOdMEawi2WFNUUCrOpSl33CtX3oFeq7ytLS6y5aosoQMLlguGHnU7FBNvw9kNtR41ykvLphU5YGJVr_JVFAqJPcpB9cEo6f6Mo9i8_gfsXMhkyrm5eqXDFlgDfgfJ_oaMyfkBmhLO2sjgdLguy_x6jg1Ys3WK2DfsI0q7X_esbEStEiV9M9lHOYsmdikKO-CPK6_c5zzJgiIjoND47WEtWuuOp_izV6BeojK9JFPHxcOnX71__sTWYl2iv7cZUNQQeH3Kub6gfpfVjCExy_5qKvtdMnzrw",
                    "use": "sig"
                },
                {
                    "alg": "RS256",
                    "e": "AQAB",
                    "kid": "ba4aeae8b208ad9ae12b6610865f63961287b6d6",
                    "kty": "RSA",
                    "n": "1f7xnpGKS5pq7l2nE0iLQ1SYX3MVeOxFDdqzTLOzU_JCNrl_w0a3f1Ry0nRPGMjONaBodUAKKgVbTKT3v88Y8-8l4BAk7lnw0fjw404MfDCt2lHaLVY_WjCHfltsUbCklta_eSN92bYQX81wmlGhwWW5kAyagTkpsPGb04zZLWTPR5fYffdYfRY1r65VmzrZaniEq4HQUr49swKmH5yyqF_HrtkpXXAcqmPlsoh1rwm1G1fsDTiNgwhJD54oZ1z5h-_8S4a0XV5cfrAQw6zzRw2Yfe6_FSXVJdJjZ_qZmY_Eqay3Wv-FDr0mZGZg6RmTtDt5208lwUcB4j49kczUhw",
                    "use": "sig"
                }
            ],
            "name": "https://www.googleapis.com/oauth2/v3/certs",
            "previous": [],
            "updated_at": 1535560520379
        }
    ],
    "total": 2
}
```

### Cached JWKS Admin API Endpoint for a Key Set

A particular key set can be accessed in another endpoint:

```http
GET kong:8001/jwt-signer/jwks/<name-or-id>
```

Example:

```bash
curl -X GET http://<kong>:8001/jwt-signer/jwks/kong
```
```json
{
    "keys": [
        {
            "alg": "RS256",
            "e": "AQAB",
            "kid": "v6el8V8dbrKY5w2PInkM468aSuODrKcfbt-44xdDIjk",
            "kty": "RSA",
            "n": "uJzCU_TangWMFk25_JggtkVNjtFfaaz3jERYEYrsb92KFK4FpjfenYYeo8XCGLphn-NcYJroHy3aVznTvU3O8B-5z27uFgXUzk_m-fJ5C4cyqBaJS_myuMOnx0SBl-V6rIGmbdAd0rxsR9SK4JXaZ7xPnQKl8Z6N_Be2iWzf8RUzgM51x7RLQWr55DXBz5IS0O3uYi0z2_xaTyhvZ01aGMGO8Jom1QZkSf2SBGVvQiff464wB_R9Uw8bnbDw6SI0A7JbvSTj80dsoB5YJaR6OZ7XzJX53J1-efiEPc-JTXnqsN1xd-7DbrwpGSui7cGU79H7rG2o-DdVtz649JVXHw",
            "use": "sig"
        },
        {
            "alg": "RS512",
            "e": "AQAB",
            "kid": "SBFmMBtMQzjQEYPDQ_7H5emJzfjX4-FBVE22_SRy5oU",
            "kty": "RSA",
            "n": "rPcrSYQKnJNfMd0AF2t8JGSRdSSOeEPwSpPNyq6T13NXWLBDzzmZC8gNURFrsB8hkeY_KUNe3rVZz__6Vp7_h5PxWXKIUFJT18Gl8mSJ_4ohWUFziWdLV1rliZ671Uo5My2_McgRFI2DfHCWCe5XL5ApKPv9YFT684_FfKpnvTIn7_rVoyQYp3g9Ud_7X5hJGEuBa3HKSGPhn-zh1A0kxnLwNrLms4t3bQZMamuR0R3XYXr76OwU0xQMsqy3_DwV1DJ0z9o0gFV8GSkYWYllVNwfGPXiTSUvTKWIARGV60jUaoYB1sG5yXyhgBcWn-XX5wcOG--aGfdWwlnYF7p_ow",
            "use": "sig"
        }
    ],
    "previous": []
}
```

The `http://<kong>:8001/jwt-signer/jwks/kong` is the URL that you can give to your
upstream services for them to verify Kong-issued tokens. The response is a standard
JWKS endpoint response. The `kong` suffix in the URI is the one that you can specify
with `config.access_token_issuer` or `config.channel_token_issuer`.

You can also make a loopback to this endpoint by routing Kong proxy to this URL.
Then you can use an authentication plugin to protect access to this endpoint,
if that is needed.

You can also `DELETE` a key set by issuing following:

```http
DELETE kong:8001/jwt-signer/jwks/<name-or-id>
```

Example:

```bash
curl -X DELETE http://<kong>:8001/jwt-signer/jwks/kong
```

The plugin automatically reloads or regenerates missing JWKS if it cannot
find cached ones. The plugin also tries to reload JWKS if it cannot verify
the signature of original access token or channel token, such as when
the original issuer has rotated its keys and signed with the new one that is not
found in Kong cache.

### Cached JWKS Admin API Endpoint for a Key Set Rotation

Sometime you might want to rotate the keys Kong uses for signing tokens specified with
`config.access_token_keyset` and `config.channel_token_keyset`, or perhaps
reload tokens specified with `config.access_token_jwks_uri` and
`config.channel_token_jwks_uri`. Kong stores and uses at most two set of keys:
**current** and **previous**. If you want Kong to forget the previous keys, you need to
rotate keys **twice**, as it effectively replaces both current and previous key sets
with newly generated tokens or reloaded tokens if the keys were loaded from
an external URI.

To rotate keys, send a `POST` request:

```http
POST kong:8001/jwt-signer/jwks/<name-or-id>/rotate
```

Example:

```bash
curl -X POST http://<kong>:8001/jwt-signer/jwks/kong/rotate
```
Response:

```json
{
    "keys": [
        {
            "alg": "RS256",
            "e": "AQAB",
            "kid": "WL-MciVclsUiIOo1IFBozrFmCIGHcYieGGny3RiENbU",
            "kty": "RSA",
            "n": "sOIf20LLUMcwaScetGnnljjkla_uZ1xQbWOy5cUjiDqku1MqiRgSvI9lM0A6USa4xtqGEnAhE-wZG7fqdWIUPgm3gZxmB6JjIV3E32PjWUtiVAiJUId3dMaGn4FSzU-TTKFAIB-xfO_0qoccaGfjsh2E5qeBGK1IBznnaw3ShnqdB53kJkSS0xgZ3NyCwh4zfTb0XeJq0l8U9xS3IdaVMj5EBOFvo-DBMneyICgLQaLIEB2KQ64aN2al4sLhKCL_Ui02s1F0igLdUr0nyhe7iFK6YIyhERMviDmv_HW7CfFcNVvB-dbpIfW0Z9SX4CtkpaAHdY4HPZFneJ4VtqYQLQ",
            "use": "sig"
        },
        {
            "alg": "RS512",
            "e": "AQAB",
            "kid": "6EIBzS288AfTm1atFHICYZ4SvWY3X9jnZEYQT3uKfXw",
            "kty": "RSA",
            "n": "zpxT7SlEmnWxquVwELysCCmrAkAvJb8eYHk3DLKEvjDDUVjA8u6KFoCBL6ySRg59kZESZ_30A0Oi1wWO85kUySlL_rtn-1PYPCUX_Yhsdoq0dYmD388l5VxRDdwVQh6c4VnbTZbJGk7RDm-dBe2xNwdfNs_C5f4pf-nGMyk1kqfgVRoYkrXuMAwd4xbeb-gh7ZdBNQO-LkMlLVGKbFe5bsnvG2ht202qx_VdHjN-spxbRUANCDRpPTAM1uEdB15EijZDLnwXZCywUsb0WIKA0bxxEJtH6tO7g8EujYqZB3Z-TaCq-dtq8lKT2FoRNx6-Zc3zVsRHb5RWqV2pgrKWZQ",
            "use": "sig"
        }
    ],
    "previous": [
        {
            "alg": "RS256",
            "e": "AQAB",
            "kid": "v6el8V8dbrKY5w2PInkM468aSuODrKcfbt-44xdDIjk",
            "kty": "RSA",
            "n": "uJzCU_TangWMFk25_JggtkVNjtFfaaz3jERYEYrsb92KFK4FpjfenYYeo8XCGLphn-NcYJroHy3aVznTvU3O8B-5z27uFgXUzk_m-fJ5C4cyqBaJS_myuMOnx0SBl-V6rIGmbdAd0rxsR9SK4JXaZ7xPnQKl8Z6N_Be2iWzf8RUzgM51x7RLQWr55DXBz5IS0O3uYi0z2_xaTyhvZ01aGMGO8Jom1QZkSf2SBGVvQiff464wB_R9Uw8bnbDw6SI0A7JbvSTj80dsoB5YJaR6OZ7XzJX53J1-efiEPc-JTXnqsN1xd-7DbrwpGSui7cGU79H7rG2o-DdVtz649JVXHw",
            "use": "sig"
        },
        {
            "alg": "RS512",
            "e": "AQAB",
            "kid": "SBFmMBtMQzjQEYPDQ_7H5emJzfjX4-FBVE22_SRy5oU",
            "kty": "RSA",
            "n": "rPcrSYQKnJNfMd0AF2t8JGSRdSSOeEPwSpPNyq6T13NXWLBDzzmZC8gNURFrsB8hkeY_KUNe3rVZz__6Vp7_h5PxWXKIUFJT18Gl8mSJ_4ohWUFziWdLV1rliZ671Uo5My2_McgRFI2DfHCWCe5XL5ApKPv9YFT684_FfKpnvTIn7_rVoyQYp3g9Ud_7X5hJGEuBa3HKSGPhn-zh1A0kxnLwNrLms4t3bQZMamuR0R3XYXr76OwU0xQMsqy3_DwV1DJ0z9o0gFV8GSkYWYllVNwfGPXiTSUvTKWIARGV60jUaoYB1sG5yXyhgBcWn-XX5wcOG--aGfdWwlnYF7p_ow",
            "use": "sig"
        }
    ]
}
```

---

