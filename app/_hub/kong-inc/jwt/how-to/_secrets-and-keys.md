---
nav_title: Configure a JWT with secrets and public/private keys 
---

### (Optional) Base64-encoded secret

If your secret contains binary data, you can store them as base64 encoded in Kong.
Enable this option in the plugin's configuration.

You can patch an existing Route:

```bash
curl -X PATCH http://localhost:8001/routes/<route-id>/plugins/<jwt-plugin-id> \
  --data "config.secret_is_base64=true"
```

Then, base64 encode your Consumers' secrets:

```bash
# secret is: "blob data"
curl -X POST http://localhost:8001/consumers/<consumer>/jwt \
  --data "secret=YmxvYiBkYXRh"
```

And sign your JWT using the original secret ("blob data").

### Generate public/private keys

To create a brand new pair of public/private keys, run the following command:

```bash
openssl genrsa -out private.pem 2048
```

This private key must be kept secret. To generate a public key corresponding to the private key, execute:

```bash
openssl rsa -in private.pem -outform PEM -pubout -out public.pem
```

If you run the commands above, the public key is written to `public.pem`, whereas the
private key is written to `private.pem`.

### Craft a JWT with a secret (HS256)

Now that your Consumer has a credential, and assuming you want to sign it using `HS256`,
the JWT should be crafted as follows (according to [RFC 7519](https://tools.ietf.org/html/rfc7519)):

First, its header must be:

```json
{
    "typ": "JWT",
    "alg": "HS256"
}
```

Secondly, the claims **must** contain the secret's `key` in the configured claim (from `config.key_claim_name`).
That claim is `iss` (issuer field) by default. Set its value to our previously created credential's `key`.
The claims may contain other values. Since Kong `0.13.1`, the claim is searched in both the JWT payload and header,
in that order.

```json
{
    "iss": "YJdmaDvVTJxtcWRCvkMikc8oELgAVNcz"
}
```

Using the JWT debugger at https://jwt.io with the header (HS256), claims (`iss`, etc.),
and `secret` associated with this `key` `C50k0bcahDhLNhLKSUBSR1OMiFGzNZ7X`, you'll end up with a JWT token of:

```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJZSmRtYUR2VlRKeHRjV1JDdmtNaWtjOG9FTGdBVk5jeiIsImV4cCI6MTQ0MjQzMDA1NCwibmJmIjoxNDQyNDI2NDU0LCJpYXQiOjE0NDI0MjY0NTR9.WuLdHyvZGj2UAsnBl6YF9A4NqGQpaDftHjX18ooK8YY
```

### Craft a JWT with public/private keys (RS256 or ES256)

If you want to use RS256 or ES256 to verify your JWTs, then when creating a JWT credential,
select `RS256` or `ES256` as the `algorithm`, and explicitly upload the public key
in the `rsa_public_key` field (including for ES256 signed tokens). For example:

```bash
curl -X POST http://localhost:8001/consumers/<consumer>/jwt \
  -F "rsa_public_key=@/path/to/public_key.pem" \
```

Response:
```json
HTTP/1.1 201 Created
{
    "created_at": 1442426001000,
    "id": "bcbfb45d-e391-42bf-c2ed-94e32946753a",
    "key": "a36c3049b36249a3c9f8891cb127243c",
    "rsa_public_key": "-----BEGIN PUBLIC KEY----- ...",
    "consumer": {
      "id": "8a21c4fa-e65e-4258-8673-540e85e67b33"
    }
}
```

When creating the signature, make sure that the header is:

```json
{
    "typ": "JWT",
    "alg": "RS256"
}
```

Secondly, the claims **must** contain the secret's `key` field (this **isn't** your private key used to generate
the token, but just an identifier for this credential) in the configured claim (from `config.key_claim_name`).
That claim is `iss` (issuer field) by default. Set its value to our previously created credential's `key`.
The claims may contain other values. Since Kong version `0.13.1`, the claim is searched in both the JWT payload and header,
in that order.

```json
{
    "iss": "a36c3049b36249a3c9f8891cb127243c"
}
```

Then, create the signature using your private keys. Using the JWT debugger at
[https://jwt.io](https://jwt.io), set the right header (RS256), the claims (`iss`, etc.), and the
associated public key. Then, append the resulting value in the `Authorization` header, for example:

```bash
curl http://localhost:8000/<route-path> \
  -H 'Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiIxM2Q1ODE0NTcyZTc0YTIyYjFhOWEwMDJmMmQxN2MzNyJ9.uNPTnDZXVShFYUSiii78Q-IAfhnc2ExjarZr_WVhGrHHBLweOBJxGJlAKZQEKE4rVd7D6hCtWSkvAAOu7BU34OnlxtQqB8ArGX58xhpIqHtFUkj882JQ9QD6_v2S2Ad-EmEx5402ge71VWEJ0-jyH2WvfxZ_pD90n5AG5rAbYNAIlm2Ew78q4w4GVSivpletUhcv31-U3GROsa7dl8rYMqx6gyo9oIIDcGoMh3bu8su5kQc5SQBFp1CcA5H8sHGfYs-Et5rCU2A6yKbyXtpHrd1Y9oMrZpEfQdgpLae0AfWRf6JutA9SPhst9-5rn4o3cdUmto_TBGqHsFmVyob8VQ'
```