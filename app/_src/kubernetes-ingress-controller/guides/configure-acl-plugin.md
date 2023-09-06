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

As valid JWTs are not easily constructed by hand, you can use the
[jwt.io](https://jwt.io) tool to generate cryptographic keys and sign your
JWTs. Select the `RS256` option from the Algorithm dropdown for this guide.

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
  MIIBIjA....
  -----END PUBLIC KEY-----"

kubectl create secret \
  generic user-jwt  \
  --from-literal=kongCredType=jwt  \
  --from-literal=key="user-issuer" \
  --from-literal=algorithm=RS256 \
  --from-literal=rsa_public_key="-----BEGIN PUBLIC KEY-----
  MIIBIjA....
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
users. On [jwt.io](https://jwt.io), add an issuer matching the `key` field from your Secrets to
the JWT payload (for example, `"iss":"admin-isuer",` for the `admin-jwt`
Secret). The "Encoded" output will update automatically. Copy the "Encoded"
value and store it in an environment variable:

```bash
export ADMIN_JWT=eyJhbG...
```

Do the same for `USER_JWT` for the `user-jwt` Secret.

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
