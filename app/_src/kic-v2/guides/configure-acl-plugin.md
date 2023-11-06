---
title: Configuring ACL Plugin
content_type: tutorial
---

Learn to configure the Kong ACL Plugin. To use the ACL Plugin you need at least one Authentication plugin. This example uses the JWT Auth Plugin.

{% include_cached /md/kic/prerequisites.md kong_version=page.kong_version disable_gateway_api=false%}

{% include_cached /md/kic/test-service-echo.md kong_version=page.kong_version %}

{% include_cached /md/kic/http-test-routing.md kong_version=page.kong_version path='/lemon' name='lemon' %}

After the first route is working, create a second pointing to the same Service:

{% include_cached /md/kic/http-test-routing-resource.md kong_version=include.kong_version path='/lime' name='lime' %}

## Add JWT authentication to the service

To add authentication in front of an API you just need to enable a plugin.
1. Create a KongPlugin resource.

    ```bash
    echo "
    apiVersion: configuration.konghq.com/v1
    kind: KongPlugin
    metadata:
      name: app-jwt
    plugin: jwt
    " | kubectl apply -f -
    ```
    The results should look like this:
    ```text
    kongplugin.configuration.konghq.com/app-jwt created
    ```
1. Associate the plugin to the Ingress rules.

    ```bash
    kubectl annotate service echo konghq.com/plugins=app-jwt
    ```
    The results should look like this:
    ```text
    service/echo annotated
    ```
    Any requests matching the proxying rules for `/lemon` and `/lime` now requires a valid JWT and the consumer for the JWT to be associate with the right ACL. Requests without credentials are rejected.
1. Send a request without the credentials.    

    ```bash
    curl -i -H 'Host:kong.example' $PROXY_IP/lemon
    ```
    The results should look like this:
    ```text
    HTTP/1.1 401 Unauthorized
    Date: Fri, 09 Dec 2022 23:51:35 GMT
    Content-Type: application/json; charset=utf-8
    Connection: keep-alive
    Content-Length: 26
    X-Kong-Response-Latency: 1
    Server: kong/3.0.1

    {"message":"Unauthorized"}
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
> **Warning:** These examples use a shared public key. Ensure you use your own public key in production.

{% capture public_key %}-----BEGIN PUBLIC KEY-----
MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAr6m2/8lMUCiBBgCXFf8B
DNBZ1Puk2JchjjrKQSiAbkhMgcBUzXqUaxZDc8S3s4/E1Y8HT5JMML1wF6h/AIVM
FjL1F+qDj0klAHae0tfAU3B2pvUpOSkWU1wWJxQDUH+CF2ihKdEhYMcQv1HGsyZM
FNuhYbzo9gjcTegQDHgJZd0BSoNxVBvSjE/adUU7kYuAomLDP7ETqlSSWlgIEUxL
FGhdch0x21J7OETlWJI3UbZxKyCOjWpqcuXYgTRnrHHD8Sy2LWs6hSIToO2ZwWHJ
HLcyt026eWtIhzu9NHfvU74QGLcAuDooRqtbG/u1pd8NFC7GwLqv6aIoSEvPJhbC
Br+HeihpCtWg4viM/uWG6La6h0aGpS5VLI/jjDfPN9yN5Yg57lHnipQNMeSisuAE
a10LKm5l4O6MC1VrFEqZWVGVZ/B+jEFlaqGPDSd3YvIaM7vk7S9TB4O5tEPaJ2XH
YQv5LtOyGxy0QpI3PyaD1Tks28wDotYcOsPMP59v7LlFewhmMw2eqzJ1lgQ3CuLr
p343+BMdTfLiw4Nv2h8EVFp3FLpr/xBbeM9ifkloTis+QJsxbnelGF0SzhBP5W4M
Fz/+NmBYpY72Q+XtoszN4E1QUsk1InJ3Wf6hZm3z/CKZLbKIn/UTYTjzKIBPQdLX
C6V0e/O3LEuJrP+XrEndtLsCAwEAAQ==
-----END PUBLIC KEY-----{% endcapture %}

1. Create secrets by replacing the RSA key strings with your own from jwt.io. The credentials are stored in Secrets with a `kongCredType` key whose value indicates the type of credential.

    ```bash
    kubectl create secret \
      generic admin-jwt  \
      --from-literal=kongCredType=jwt  \
      --from-literal=key="admin-issuer" \
      --from-literal=algorithm=RS256 \
      --from-literal=rsa_public_key="{{ public_key }}"
    
    kubectl create secret \
      generic user-jwt  \
      --from-literal=kongCredType=jwt  \
      --from-literal=key="user-issuer" \
      --from-literal=algorithm=RS256 \
      --from-literal=rsa_public_key="{{ public_key }}"
    ```

   The results should look like this:
    
    ```text
    secret/admin-jwt created
    secret/user-jwt created
    ```
   To associate the JWT Secrets with your consumers, you must add their name to the `credentials` array in the KongConsumers.

1. Assign the credentials `admin-jwt` to the `admin`.     

    ```bash
    kubectl patch --type json kongconsumer admin \
      -p='[{
        "op":"add",
        "path":"/credentials",
        "value":["admin-jwt"]
      }]'
    ```
    The results should look like this:
    ```text
    kongconsumer.configuration.konghq.com/admin patched
    ```
1. Assign the credentials `user-jwt` to the `user`. 
    ```bash
    kubectl patch --type json kongconsumer user \
      -p='[{
        "op":"add",
        "path":"/credentials",
        "value":["user-jwt"]
      }]'
    ```
    The results should look like this:
    ```text
    kongconsumer.configuration.konghq.com/user patched
    ```

### Send authenticated requests

To send an authenticated request, you must create signed JWTs for your
users. Here are the pre-populated examples for both the Admin and User JWTs:

* [Show Admin JWT](https://jwt.io/#debugger-io?token=eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJhZG1pbi1pc3N1ZXIifQ.di8D15Bzmyafu36vEb_qYk4q2zN821jgRRZXgXO847xFSHkSc35nfmSS5Db7pYSOZ_8rdS3LAlNLA7v4BA-JhZfB95WbGy_nlLXk2dqhoF5jzTmVgNVYRwwIgzYdhSZ3Ks8tiXj_rs-jyHG8K7YNp8moW-Oz5dxolA_a9wbY2cGCZj_defxDpsK_TpbHh_4heg9OLVMAlKp5frgnYlSoDD11TcmX7YhLleXHXmkVK2aeGWvK8ooh2OptBXyeg0M81oaTt47SnTMyMeXhM1DnTvEaaTquFjnA83U7luOB7Cs_xXnk80wTYaw6Ml9BU6fIu9R7mNTjupKFPOw8J7iWcPQNsYkqlJoLjv24xOknGRrPPSuW1DFVT5V2BKjliB72PgI4o91F9fqfn12pBVn-OHgcHSvUxTcGKTObzU3Gu1g5sMHsvgaeADA5_faTzMdMyO6nELnaLOBZwr8kfA-tYOHAid2JBqgRtd919oLvR-QTtGN4gQq1-UNe38vdXsvDClB4PU-qA000I8obJAG_vr5FBBOPbdk82zVGVJpeOjwlddl0OSzakwSzm3PhRrAnvetos6NEP5YISxJNwsWVF6Ng-LtnrOl3ONdiVBogqcq_AV8ssPqIUhm2pjOJOMdBQ3HwzlakWWiWLnI1g07aGDf60cUDVJrxPQMJ485MTNA&publicKey=-----BEGIN%20PUBLIC%20KEY-----%0AMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAr6m2%2F8lMUCiBBgCXFf8B%0ADNBZ1Puk2JchjjrKQSiAbkhMgcBUzXqUaxZDc8S3s4%2FE1Y8HT5JMML1wF6h%2FAIVM%0AFjL1F%2BqDj0klAHae0tfAU3B2pvUpOSkWU1wWJxQDUH%2BCF2ihKdEhYMcQv1HGsyZM%0AFNuhYbzo9gjcTegQDHgJZd0BSoNxVBvSjE%2FadUU7kYuAomLDP7ETqlSSWlgIEUxL%0AFGhdch0x21J7OETlWJI3UbZxKyCOjWpqcuXYgTRnrHHD8Sy2LWs6hSIToO2ZwWHJ%0AHLcyt026eWtIhzu9NHfvU74QGLcAuDooRqtbG%2Fu1pd8NFC7GwLqv6aIoSEvPJhbC%0ABr%2BHeihpCtWg4viM%2FuWG6La6h0aGpS5VLI%2FjjDfPN9yN5Yg57lHnipQNMeSisuAE%0Aa10LKm5l4O6MC1VrFEqZWVGVZ%2FB%2BjEFlaqGPDSd3YvIaM7vk7S9TB4O5tEPaJ2XH%0AYQv5LtOyGxy0QpI3PyaD1Tks28wDotYcOsPMP59v7LlFewhmMw2eqzJ1lgQ3CuLr%0Ap343%2BBMdTfLiw4Nv2h8EVFp3FLpr%2FxBbeM9ifkloTis%2BQJsxbnelGF0SzhBP5W4M%0AFz%2F%2BNmBYpY72Q%2BXtoszN4E1QUsk1InJ3Wf6hZm3z%2FCKZLbKIn%2FUTYTjzKIBPQdLX%0AC6V0e%2FO3LEuJrP%2BXrEndtLsCAwEAAQ%3D%3D%0A-----END%20PUBLIC%20KEY-----)
* [Show User JWT](https://jwt.io/#debugger-io?token=eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJ1c2VyLWlzc3VlciJ9.oKgeiPBow5GGcAN_ODRdON9Y4uKq8SxngbfikmomiG4XVI-IjTAslc0NWTvCiOyq7s1leL4kqeD8IeLvw0u2CnKUuSJigwiTRs2NXbpyNpmftnt00xUXC4xHzHI_Rk8_zUCmlCQsU_pb87gcxuKXb0VKuAsEIeTpeCAmwKNxrH67zxeoHPcKA4BCLN-CsIKZZ-ko4JKl_1_PlsuuCt76-5ljR_tb5h2oeZaUTrIENLqnlLRU-0hESow31ZgOHZ0ANDJ0pNm-IR1cBcM09aH2iDgdX3D_w8JqZLTVeLZNdWyQ91NYaD9_KteFqSP_5ru3a_O1pT9rqXP6mJh-J3q9wVH_DYZAtxMIAbY3u30sNF-1Cz_ulxtOlgRbvM9Sm9gMRmOS1C0zv6aXOjvLgE6cOQ0gwxYvvIJ-e9eb7bJiW2LPiZAVWQROOKjINEjlJFgUcpn9b-l83Xl_kq9Bhct_RQqPZZff5ZUfE3jUUrGQM05pa01VtX6iUX64IrqZCz3no0FPoz7nuOmBSmuwzYNI2w-N-WTXIG-wo-9oVooSXpJbr9fqTIuAm0IuwbFcdhN6eV6SehJkLKZChFUrlXmsRa0ZqarKiDYcSJLBx7pGQ789FcQmErh-QCiynfn2g0K8R0aJ7CGD3nmW1qoGsodnJ3uvR_-lLn1n4WZna0wjm0w&publicKey=-----BEGIN%20PUBLIC%20KEY-----%0AMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAr6m2%2F8lMUCiBBgCXFf8B%0ADNBZ1Puk2JchjjrKQSiAbkhMgcBUzXqUaxZDc8S3s4%2FE1Y8HT5JMML1wF6h%2FAIVM%0AFjL1F%2BqDj0klAHae0tfAU3B2pvUpOSkWU1wWJxQDUH%2BCF2ihKdEhYMcQv1HGsyZM%0AFNuhYbzo9gjcTegQDHgJZd0BSoNxVBvSjE%2FadUU7kYuAomLDP7ETqlSSWlgIEUxL%0AFGhdch0x21J7OETlWJI3UbZxKyCOjWpqcuXYgTRnrHHD8Sy2LWs6hSIToO2ZwWHJ%0AHLcyt026eWtIhzu9NHfvU74QGLcAuDooRqtbG%2Fu1pd8NFC7GwLqv6aIoSEvPJhbC%0ABr%2BHeihpCtWg4viM%2FuWG6La6h0aGpS5VLI%2FjjDfPN9yN5Yg57lHnipQNMeSisuAE%0Aa10LKm5l4O6MC1VrFEqZWVGVZ%2FB%2BjEFlaqGPDSd3YvIaM7vk7S9TB4O5tEPaJ2XH%0AYQv5LtOyGxy0QpI3PyaD1Tks28wDotYcOsPMP59v7LlFewhmMw2eqzJ1lgQ3CuLr%0Ap343%2BBMdTfLiw4Nv2h8EVFp3FLpr%2FxBbeM9ifkloTis%2BQJsxbnelGF0SzhBP5W4M%0AFz%2F%2BNmBYpY72Q%2BXtoszN4E1QUsk1InJ3Wf6hZm3z%2FCKZLbKIn%2FUTYTjzKIBPQdLX%0AC6V0e%2FO3LEuJrP%2BXrEndtLsCAwEAAQ%3D%3D%0A-----END%20PUBLIC%20KEY-----)

The `iss` field in the payload matches the value you provided in `--from-literal=key=` when creating the Kubernetes secret.

1. Copy the "Encoded" value and store it in an environment variable for both the `ADMIN_JWT` and `USER_JWT`:

    ```bash
    export ADMIN_JWT=eyJhbG...
    export USER_JWT=eyJhbG...
    ```

1. Send a request with the `Authorization` header.

    ```bash
    curl -I -H 'Host: kong.example' -H "Authorization: Bearer ${USER_JWT}" $PROXY_IP/lemon
    ```
    The results should look like this:
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

The JWT plugin and other Kong authentication plugins only provide
_authentication_, not _authorization_. They can identify a consumer, and reject any unidentified requests, but not restrict which consumers can access which protected URLs. Any consumer with a JWT credential can access any JWT-protected URL, even when the JWT plugins for those URLs are configured separately.

To provide _authorization_, or restrictions on which consumers can access which
URLs, you need to also add the ACL plugin, which can assign groups to consumers
and restrict access to URLs by group. Create two plugins, one which allows only
an `admin` group, and one which allows both `admin` and `user`:

1. Create an ACL plugin that allows only the `admin` group.
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
    The results should look like this:
    ```text
    kongplugin.configuration.konghq.com/admin-acl created
    ```
1. Create an ACL plugin that allows both the `admin` and `user` group.
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
    The results should look like this:
    ```text
    kongplugin.configuration.konghq.com/anyone-acl created
    ```
1. Add the plugins to the routing configuration you created.

 {% capture the_code %}
{% navtabs api %}
{% navtab Ingress %}
```bash
kubectl annotate ingress lemon konghq.com/plugins=admin-acl
kubectl annotate ingress lime konghq.com/plugins=anyone-acl
```
{% endnavtab %}
{% navtab Gateway API %}
```bash
kubectl annotate httproute lemon konghq.com/plugins=admin-acl
kubectl annotate httproute lime konghq.com/plugins=anyone-acl
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{{ the_code | indent }}

    The results should look like this:

    {% capture the_code %}
{% navtabs codeblock %}
{% navtab Ingress%}
```text
ingress.networking.k8s.io/lemon annotated
ingress.networking.k8s.io/lime annotated
```
{% endnavtab %}
{% navtab Gateway API %}
```text
httproute.gateway.networking.k8s.io/lemon annotated
httproute.gateway.networking.k8s.io/lime annotated
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{{ the_code | indent }}

1. Add consumers to groups through credentials.

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
    The results should look like this:
    ```text
    secret/admin-acl created
    secret/user-acl created
    ```

1. Associate the groups to their consumers through `credentials`.

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
    The results should look like this:
    ```text
    kongconsumer.configuration.konghq.com/admin patched
    kongconsumer.configuration.konghq.com/user patched
    ```

### Send authorized requests

1. Send a request as the `admin` consumer to both the URLS.

    ```bash
    curl -sI $PROXY_IP/lemon -H 'Host: kong.example' -H "Authorization: Bearer ${ADMIN_JWT}" | grep HTTP
     curl -sI $PROXY_IP/lime -H 'Host: kong.example' -H "Authorization: Bearer ${ADMIN_JWT}" | grep HTTP
    ```
    The results should look like this:
    ```text
    HTTP/1.1 200 OK
    HTTP/1.1 200 OK
    ```

1. Send a request as the`user` consumer.

    ```bash
    curl -sI $PROXY_IP/lemon -H 'Host: kong.example' -H "Authorization: Bearer ${USER_JWT}" | grep HTTP
    curl -sI $PROXY_IP/lime -H 'Host: kong.example' -H "Authorization: Bearer ${USER_JWT}" | grep HTTP
    ```
    The results should look like this:
    ```text
    HTTP/1.1 403 Forbidden
    HTTP/1.1 200 OK
    ```
