---
title: Configuring ACL Plugin
content_type: tutorial
---

This guide walks through configuring the Kong ACL Plugin. The ACL Plugin
requires the use of at least one Authentication plugin. This example uses
the JWT Auth Plugin.

{% include_cached /md/kic/installation.md kong_version=page.kong_version %}

{% include_cached /md/kic/http-test-service.md kong_version=page.kong_version %}

{% include_cached /md/kic/class.md kong_version=page.kong_version %}

{% include_cached /md/kic/http-test-routing.md kong_version=page.kong_version path='/lemon' name='lemon' %}

Once the first route is working, create a second pointing to the same Service:

{% include_cached /md/kic/http-test-routing-resource.md kong_version=include.kong_version path='/lime' name='lime' %}

## Add JWT authentication to the service

With Kong, adding authentication in front of an API is as simple as
enabling a plugin. To start, create a KongPlugin resource:

```bash
echo "
apiVersion: configuration.konghq.com/v1
kind: KongPlugin
metadata:
  name: app-jwt
plugin: jwt
" | kubectl apply -f -
```
Response:
```text
kongplugin.configuration.konghq.com/app-jwt
```

Then, associate the plugin to the Ingress rules we created earlier:

```bash
kubectl annotate service echo konghq.com/plugins=app-jwt
```
Response:
```text
service.networking.k8s.io/echo annotated
```

Any requests matching the proxying rules for `demo-get` and `demo` post will
now require a valid JWT and the consumer for the JWT to be associate with the
right ACL.

Requests without credentials are now rejected:

```bash
curl -si http://kong.example/lemon --resolve kong.example:80:$PROXY_IP
```
Response:
```text
HTTP/1.1 401 Unauthorized
Date: Fri, 09 Dec 2022 23:51:35 GMT
Content-Type: application/json; charset=utf-8
Connection: keep-alive
Content-Length: 26
X-Kong-Response-Latency: 1
Server: kong/3.0.1

{"message":"Unauthorized"
```

## Provision consumers

To access the protected endpoints, create two consumers.

1. Create a consumer named `admin`:

{% include_cached /md/kic/consumer.md kong_version=page.kong_version name='admin' %}

1. Create a consumer named `user`:
{% include_cached /md/kic/consumer.md kong_version=page.kong_version name='user' %}

## Provision JWT credentials

JWT is a standard for tokens stored in JSON. They include a metadata section
about the algorithms used to construct the JWT, information ("claims") about
the token and its bearer, and a cryptographic signature that recipients can use
to verify the validity of the token.

When generating tokens ensure that the `payload` data contains a field named `iss` alongside `name` and `iat`. For the admin token you should set `"iss": "admin-issuer"` and for the user token you should set `"iss": "user-issuer"`.

As valid JWTs are not easily constructed by hand, you can use the
[jwt.io](https://jwt.io) tool to generate cryptographic keys and sign your
JWTs.

{:.warning}
> **Warning:** The following examples use a shared public key. Ensure you use your own public key in production.

### Create Secrets

Credentials are stored in Secrets with a `kongCredType` key whose value
indicates the type of credential:

```bash
kubectl create secret \
  generic admin-jwt  \
  --from-literal=kongCredType=jwt  \
  --from-literal=key="admin-issuer" \
  --from-literal=algorithm=RS256 \
  --from-literal=rsa_public_key="-----BEGIN PUBLIC KEY-----
MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAxgqQPxIHPeiVz2Rtq7fF
qria55PKorC6D3s0n3Di5Wp/8JtV9u+GzcAIviKZxo8urtyu1vBxmxwtDmDkynRS
7FpC28O3WqVblVYNEpAQpsTR0fiPnaSRLuJgqTZU3JkHdlkJISCISWjGfN2rqN4f
OwKGIiWU0JOWm5HiTG6Uf2S06Fv5OB0rhhlRT2W6hGC43JGnaQ/1Ek5zPgiuNfop
KjptNFAsgUjWneZFC0toI7ivKudCQWB6v/fBn/7Lycd/qT4DOaYJsE/up23qnsf+
U8y3emZ8F+s69T5k5aEzIxs89HD7zElKNHCSlUIl+Gar0h1HTN1QkzuGwppgGrYI
H1nkAGYMjhSJa8TvYDI/Eze4KhYwjfNEnRbuYB74LyGl5Z2imJYlOPb2bYTAtmw0
2GNDj27LGFbfhPA4rUE8EadIsE4i4AIdl8UH3OnAYsyj2/Ubr+Z7TtTZYsRlv4MR
FVKjO71wonAD3ssZXGz7DKleqvXedEPGXeLbz2BrDKsOGojawLA04yNY0xMT0slN
g/KPYWmuug0oONPZhKYsj/H0Jk1xiCyJK9B6ItfbAK021NWXrAPHbgUNEbNFy8yS
7cPgS3OgEoCMBITKVpJlxvEwuajrewBRUcgS9opz+J94dGd8bnmLRlXK6290Ni6S
hF9M5348YA/8VIjYq7XBw9sCAwEAAQ==
-----END PUBLIC KEY-----"

kubectl create secret \
  generic user-jwt  \
  --from-literal=kongCredType=jwt  \
  --from-literal=key="user-issuer" \
  --from-literal=algorithm=RS256 \
  --from-literal=rsa_public_key="-----BEGIN PUBLIC KEY-----
MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAxgqQPxIHPeiVz2Rtq7fF
qria55PKorC6D3s0n3Di5Wp/8JtV9u+GzcAIviKZxo8urtyu1vBxmxwtDmDkynRS
7FpC28O3WqVblVYNEpAQpsTR0fiPnaSRLuJgqTZU3JkHdlkJISCISWjGfN2rqN4f
OwKGIiWU0JOWm5HiTG6Uf2S06Fv5OB0rhhlRT2W6hGC43JGnaQ/1Ek5zPgiuNfop
KjptNFAsgUjWneZFC0toI7ivKudCQWB6v/fBn/7Lycd/qT4DOaYJsE/up23qnsf+
U8y3emZ8F+s69T5k5aEzIxs89HD7zElKNHCSlUIl+Gar0h1HTN1QkzuGwppgGrYI
H1nkAGYMjhSJa8TvYDI/Eze4KhYwjfNEnRbuYB74LyGl5Z2imJYlOPb2bYTAtmw0
2GNDj27LGFbfhPA4rUE8EadIsE4i4AIdl8UH3OnAYsyj2/Ubr+Z7TtTZYsRlv4MR
FVKjO71wonAD3ssZXGz7DKleqvXedEPGXeLbz2BrDKsOGojawLA04yNY0xMT0slN
g/KPYWmuug0oONPZhKYsj/H0Jk1xiCyJK9B6ItfbAK021NWXrAPHbgUNEbNFy8yS
7cPgS3OgEoCMBITKVpJlxvEwuajrewBRUcgS9opz+J94dGd8bnmLRlXK6290Ni6S
hF9M5348YA/8VIjYq7XBw9sCAwEAAQ==
-----END PUBLIC KEY-----"
```

Response:

```text
secret/admin-jwt created
secret/user-jwt created
```

Replace the RSA key strings with your own from jwt.io.

### Assign the credentials

To associate the JWT Secrets with your consumers, you must add their name to
the `credentials` array in the KongConsumers:

```bash
kubectl patch --type json kongconsumer admin \
  -p='[{
    "op":"add",
    "path":"/credentials",
    "value":["admin-jwt"]
  }]'
```
Response:
```text
kongconsumer.configuration.konghq.com/admin patched
```

```bash
kubectl patch --type json kongconsumer user \
  -p='[{
    "op":"add",
    "path":"/credentials",
    "value":["user-jwt"]
  }]'
```
Response:
```text
kongconsumer.configuration.konghq.com/user patched
```

### Send authenticated requests

To send an authenticated request, you must create signed JWTs for your
users. 

We have provided pre-populated examples for both the Admin and User JWTs:

* [Show Admin JWT](https://jwt.io/#debugger-io?token=eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJhZG1pbi1pc3N1ZXIifQ.kiHOLThl1SggXGxNhfDuSqP70uf4V80HUoeVBt7S-YqMz0DEL6IUeafMl_LzZyLYQO0qhhNzKL10tBN0krSe3IXsS9t4tlG9kWScDT7BavDyLRAffQ-ylT-PFNk0aXNtQ-0PEN4CVu71j7t7XZcV1USAFpLlr_QD3ruvlnOA2EP_5Cw7Ub9LnGOI_TYbkmYt-OsGXfFsuofytOYeG2_CDMCSNyJC5kNyehoDrFv8JZw4MLwPbOsCbvWo6y0TKN0ydVYyHCc5eu1eqOvdnQlBmL8uBmgBm_9MAyixhbNCum3nRoevb6ySGkCZGwpvEL7vomJcLOSM1naG8OhwNguHiBHt_WkS2FrlACd11xUkFkrtoH7UMpXIgiFOBihHWfEUBfzZcIcrgmsF0rtAo64JXs-km1gwKyIfwb29XQEEWd2-KzEDa2zS7IRQXD9i1U9tGpG7q3PJZLHFGkSuKs4i5mQ8gTPr-lB7X45Yp6g-xqLSA5EvgIo78AJ-G2gJW221VZM5gOvErEmLtDjT9Kk9Cqp-L4vXpWTpAo3sJN2kaQU24O6L8ujDn2XUnNkiU7QDPOQ9TPl5lDhw0VaFtMbGkBJORc2p-3-FTQfV80X6y9RHdyrb3UOhm1rjum2DsOUaacFJPhNcVsDYKTo1bhKoqVDtMYUvNjWP6hawb5H4jyg&publicKey=-----BEGIN%20PUBLIC%20KEY-----%0AMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAxgqQPxIHPeiVz2Rtq7fF%0Aqria55PKorC6D3s0n3Di5Wp%2F8JtV9u%2BGzcAIviKZxo8urtyu1vBxmxwtDmDkynRS%0A7FpC28O3WqVblVYNEpAQpsTR0fiPnaSRLuJgqTZU3JkHdlkJISCISWjGfN2rqN4f%0AOwKGIiWU0JOWm5HiTG6Uf2S06Fv5OB0rhhlRT2W6hGC43JGnaQ%2F1Ek5zPgiuNfop%0AKjptNFAsgUjWneZFC0toI7ivKudCQWB6v%2FfBn%2F7Lycd%2FqT4DOaYJsE%2Fup23qnsf%2B%0AU8y3emZ8F%2Bs69T5k5aEzIxs89HD7zElKNHCSlUIl%2BGar0h1HTN1QkzuGwppgGrYI%0AH1nkAGYMjhSJa8TvYDI%2FEze4KhYwjfNEnRbuYB74LyGl5Z2imJYlOPb2bYTAtmw0%0A2GNDj27LGFbfhPA4rUE8EadIsE4i4AIdl8UH3OnAYsyj2%2FUbr%2BZ7TtTZYsRlv4MR%0AFVKjO71wonAD3ssZXGz7DKleqvXedEPGXeLbz2BrDKsOGojawLA04yNY0xMT0slN%0Ag%2FKPYWmuug0oONPZhKYsj%2FH0Jk1xiCyJK9B6ItfbAK021NWXrAPHbgUNEbNFy8yS%0A7cPgS3OgEoCMBITKVpJlxvEwuajrewBRUcgS9opz%2BJ94dGd8bnmLRlXK6290Ni6S%0AhF9M5348YA%2F8VIjYq7XBw9sCAwEAAQ%3D%3D%0A-----END%20PUBLIC%20KEY-----%0A)
* [Show User JWT](https://jwt.io/#debugger-io?token=eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJ1c2VyLWlzc3VlciJ9.KrdGJ50DYHiElgDULXDl3ZapcHIyILELFoGTIdYB54JTOxIgsaVo6aei2QbYucLK0GCmPNx7ED9J9SfilK_6ZsR7wHq7f7kGozXwgWf3LG5gMak1mzoHnJPi9cwzbSpV-OhJ4q4LkFUi7sGxRPlvSiP2GnxU38rxTBOonJ_y_nkZLXnTlaXanMxCdW_sccP9Y6_Px3_NtoRpVwkf11vj0Dv_9NMqK7WXEj8VPafOMp7NXFSZ0Ebo6vJ89znsA3_XdUqL0_PPZXMZ3ehPVfgz766LTJ8rf1_sQ0W6wxPapXEyiid_eo7JgAtVG4jYHspzuobkmWnJR7lLJOKlm8tVlLQo0e8nOVqV3Ks5e-kqHCfPG-5lD81u5gprG9UB04M8vVw5VN5uT5yHvGWEN2YmA9QsvFjHqTKa7lr0gTXS7lNBCaDLrm2YBSrywZMqs_QOlUtZLTEQSr1B6-cpp_b8gNxNsxzUctca3zj93QJ593qC2ifKxw8XkMab-YhV_lJexjwf1SO_AOBALTIcficI_Z5BVfLWjnEFOl2mEDffDs36fLft-d82tTSYQ76iCgy3tYEqdb3mwPsamaHIcbSYs35xoOocv1kKq81Pq-h6l3aX3yvj9OPfbfO2eS-faC2R0rd6PcjTIzD1v4f48gatnqpp_cKmu0tPfZ3c3dQLP5I&publicKey=-----BEGIN%20PUBLIC%20KEY-----%0AMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAxgqQPxIHPeiVz2Rtq7fF%0Aqria55PKorC6D3s0n3Di5Wp%2F8JtV9u%2BGzcAIviKZxo8urtyu1vBxmxwtDmDkynRS%0A7FpC28O3WqVblVYNEpAQpsTR0fiPnaSRLuJgqTZU3JkHdlkJISCISWjGfN2rqN4f%0AOwKGIiWU0JOWm5HiTG6Uf2S06Fv5OB0rhhlRT2W6hGC43JGnaQ%2F1Ek5zPgiuNfop%0AKjptNFAsgUjWneZFC0toI7ivKudCQWB6v%2FfBn%2F7Lycd%2FqT4DOaYJsE%2Fup23qnsf%2B%0AU8y3emZ8F%2Bs69T5k5aEzIxs89HD7zElKNHCSlUIl%2BGar0h1HTN1QkzuGwppgGrYI%0AH1nkAGYMjhSJa8TvYDI%2FEze4KhYwjfNEnRbuYB74LyGl5Z2imJYlOPb2bYTAtmw0%0A2GNDj27LGFbfhPA4rUE8EadIsE4i4AIdl8UH3OnAYsyj2%2FUbr%2BZ7TtTZYsRlv4MR%0AFVKjO71wonAD3ssZXGz7DKleqvXedEPGXeLbz2BrDKsOGojawLA04yNY0xMT0slN%0Ag%2FKPYWmuug0oONPZhKYsj%2FH0Jk1xiCyJK9B6ItfbAK021NWXrAPHbgUNEbNFy8yS%0A7cPgS3OgEoCMBITKVpJlxvEwuajrewBRUcgS9opz%2BJ94dGd8bnmLRlXK6290Ni6S%0AhF9M5348YA%2F8VIjYq7XBw9sCAwEAAQ%3D%3D%0A-----END%20PUBLIC%20KEY-----%0A)

The `iss` field in the payload matches the value you provided in `--from-literal=key=` when creating the Kubernetes secret.

Copy the "Encoded" value and store it in an environment variable for both the `ADMIN_JWT` and `USER_JWT`:

```bash
export ADMIN_JWT=eyJhbG...
export USER_JWT=eyJhbG...
```

Once you have the JWTs stored, you can send them in an `Authorization` header:

```bash
curl -I -H "Authorization: Bearer ${USER_JWT}" http://kong.example/lemon --resolve kong.example:80:$PROXY_IP
```
Response:
```text
HTTP/1.1 200 OK
Content-Type: application/json
Content-Length: 947
Connection: keep-alive
Server: gunicorn/19.9.0
Date: Mon, 06 Apr 2020 06:45:45 GMT
Access-Control-Allow-Origin: *
Access-Control-Allow-Credentials: true
X-Kong-Upstream-Latency: 7
X-Kong-Proxy-Latency: 2
Via: kong/3.1.1
```

## Adding access control

The JWT plugin (and other Kong authentication plugins) only provide
_authentication_, not _authorization_. They can identify a consumer, and will
reject any unidentified requests, but will not restrict which consumers can
access which protected URLs. Any consumer with a JWT credential can access any
JWT-protected URL, even when the JWT plugins for those URLs are configured
separately.

### Create ACL plugins

To provide _authorization_, or restrictions on which consumers can access which
URLs, you need to also add the ACL plugin, which can assign groups to consumers
and restrict access to URLs by group. Create two plugins, one which allows only
an `admin` group, and one which allows both `admin` and `user`:

```bash
echo "
apiVersion: configuration.konghq.com/v1
kind: KongPlugin
metadata:
  name: admin-acl
plugin: acl
config:
  allow: ['admin']
" | kubectl apply -f -
```
Response:
```text
kongplugin.configuration.konghq.com/admin-acl created
```

```bash
echo "
apiVersion: configuration.konghq.com/v1
kind: KongPlugin
metadata:
  name: anyone-acl
plugin: acl
config:
  allow: ['admin','user']
" | kubectl apply -f -
```
Response:
```text
kongplugin.configuration.konghq.com/anyone-acl created
```

### Configure plugins on routing configuration

After creating plugins, add them to the routing configuration you created
earlier:

{% navtabs api %}
{% navtab Ingress %}
```bash
kubectl annotate ingress lemon konghq.com/plugins=admin-acl
kubectl annotate ingress lime konghq.com/plugins=anyone-acl
```
Response:
```text
ingress.networking.k8s.io/lemon annotated
ingress.networking.k8s.io/lime annotated
```
{% endnavtab %}
{% navtab Gateway APIs %}
```bash
kubectl annotate httproute lemon konghq.com/plugins=admin-acl
kubectl annotate httproute lime konghq.com/plugins=anyone-acl
```
Response:
```text
httproute.gateway.networking.k8s.io/lemon annotated
httproute.gateway.networking.k8s.io/lime annotated
```
{% endnavtab %}
{% endnavtabs %}

### Add consumers to groups

Group assignments are handled via credentials:

```bash
kubectl create secret \
  generic admin-acl \
  --from-literal=kongCredType=acl  \
  --from-literal=group=admin

kubectl create secret \
  generic user-acl \
  --from-literal=kongCredType=acl  \
  --from-literal=group=user
```
Response:
```text
secret/admin-acl created
secret/user-acl created
```

Like the authentication credentials, these need to be bound to their consumers
via their `credentials` array:

```bash
kubectl patch --type json kongconsumer admin \
  -p='[{
    "op":"add",
    "path":"/credentials/-",
    "value":"admin-acl" 
  }]'
kubectl patch --type json kongconsumer user \
  -p='[{
    "op":"add",
    "path":"/credentials/-",
    "value":"user-acl" 
  }]'
```
Response:
```text
kongconsumer.configuration.konghq.com/admin patched
kongconsumer.configuration.konghq.com/user patched
```

### Send authorized requests

The `admin` consumer can now access either URL:

```bash
curl -sI http://kong.example/lemon -H "Authorization: Bearer ${ADMIN_JWT}" --resolve kong.example:80:$PROXY_IP | grep HTTP
curl -sI http://kong.example/lime -H "Authorization: Bearer ${ADMIN_JWT}" --resolve kong.example:80:$PROXY_IP | grep HTTP
```
Response:
```text
HTTP/1.1 200 OK
HTTP/1.1 200 OK
```

`user`, however, can only access the URL that permits the `user` group:

```bash
curl -sI http://kong.example/lemon -H "Authorization: Bearer ${USER_JWT}" --resolve kong.example:80:$PROXY_IP | grep HTTP
curl -sI http://kong.example/lime -H "Authorization: Bearer ${USER_JWT}" --resolve kong.example:80:$PROXY_IP | grep HTTP
```
Response:
```text
HTTP/1.1 403 Forbidden
HTTP/1.1 200 OK
```
