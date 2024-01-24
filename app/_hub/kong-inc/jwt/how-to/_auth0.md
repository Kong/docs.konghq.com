---
nav_title: Use the JWT plugin with Auth0
---

[Auth0](https://auth0.com/) is a popular solution for Authorization, and relies
heavily on JWTs. Auth0 relies on RS256, does not base64 encode, and publicly
hosts the public key certificate used to sign tokens. Account name is referred
to as `{COMPANYNAME}` for the sake of the following examples.

To get started, create a Service and a Route that uses that Service.

_Note: Auth0 does not use base64-encoded secrets._

Create a Service:

```bash
curl -i -f -X POST http://localhost:8001/services \
  --data "name=example-service" \
  --data "url=http://httpbin.org"
```

Then create a Route:

```bash
curl -i -f -X POST http://localhost:8001/routes \
  --data "service.id=<example-service-id>" \
  --data "paths[]=/example_path"
```

## Add the JWT plugin

Add the plugin to your Route:

```bash
curl -X POST http://localhost:8001/routes/<route-id>/plugins \
  --data "name=jwt"
```

Download your Auth0 account's X509 Certificate:

```bash
curl -o <COMPANYNAME>.pem https://<COMPANYNAME>.<REGION-ID>.auth0.com/pem
```

Extract the public key from the X509 Certificate:

```bash
openssl x509 -pubkey -noout -in <COMPANYNAME>.pem > pubkey.pem
```

Create a Consumer with the Auth0 public key:

```bash
curl -i -X POST http://localhost:8001/consumers \
  --data "username=<USERNAME>" \
  --data "custom_id=<CUSTOM_ID>"
curl -i -X POST http://localhost:8001/consumers/<consumer>/jwt \
  -F "algorithm=RS256" \
  -F "rsa_public_key=@./pubkey.pem" \
  -F "key=https://<COMPANYNAME>.auth0.com/" # the `iss` field
```

The JWT plugin by default validates the `key_claim_name` against the `iss`
field in the token. Keys issued by Auth0 have their `iss` field set to
`http://<COMPANYNAME>.auth0.com/`. You can use [jwt.io](https://jwt.io) to
validate the `iss` field for the `key` parameter when creating the
Consumer.

Send requests through. Only tokens signed by Auth0 will work:

```bash
curl -i http://localhost:8000 \
  -H "Host:example.com" \
  -H "Authorization:Bearer <TOKEN>"
```