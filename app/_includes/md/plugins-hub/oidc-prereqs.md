{% capture prereqs_keycloak %}

All the `*.test` domains in the following examples point to the `localhost` (`127.0.0.1` and/or `::1`).

We use [Keycloak][keycloak] as the identity provider in the following examples,
but the steps will be similar in other standard identity providers. If you encounter
difficulties during this phase, refer to the [Keycloak documentation](https://www.keycloak.org/documentation).

1. Create a confidential client `kong` with `private_key_jwt` authentication and configure
   Keycloak to download the public keys from [the OpenID Connect Plugin JWKS endpoint][json-web-key-set]:
   <br><br>
   <img src="/assets/images/products/plugins/openid-connect/keycloak-client-kong-settings.png">
   <br>
   <img src="/assets/images/products/plugins/openid-connect/keycloak-client-kong-auth.png">
   <br>
2. Create another confidential client `service` with `client_secret_basic` authentication.
   For this client, Keycloak will auto-generate a secret similar to the following: `cf4c655a-0622-4ce6-a0de-d3353ef0b714`.
   Enable the client credentials grant for the client:
   <br><br>
   <img src="/assets/images/products/plugins/openid-connect/keycloak-client-service-settings.png">
   <br>
   <img src="/assets/images/products/plugins/openid-connect/keycloak-client-service-auth.png">
   <br>
3. Create a verified user with the name: `john` and the non-temporary password: `doe` that can be used with the password grant:
   <br><br>
   <img src="/assets/images/products/plugins/openid-connect/keycloak-user-john.png">

Alternatively you can [download the exported Keycloak configuration](/assets/images/products/plugins/openid-connect/keycloak.json),
and use it to configure the Keycloak. Please refer to [Keycloak import documentation](https://www.keycloak.org/docs/latest/server_admin/#_export_import)
for more information.

You need to modify Keycloak `standalone.xml` configuration file, and change the socket binding from:

```xml
<socket-binding name="https" port="${jboss.https.port:8443}"/>
```

to

```xml
<socket-binding name="https" port="${jboss.https.port:8440}"/>
```

The Keycloak default `https` port conflicts with the default Kong TLS proxy port,
and that can be a problem if both are started on the same host.

[keycloak]: http://www.keycloak.org/

{% endcapture %}

{% capture prereqs_kong %}

1. Create a service:

    ```bash
    http -f put :8001/services/openid-connect url=http://httpbin.org/anything
    ```
    ```http
    HTTP/1.1 200 OK
    ```
    ```json
    {
        "id": "5fa9e468-0007-4d7e-9aeb-49ca9edd6ccd",
        "name": "openid-connect",
        "protocol": "http",
        "host": "httpbin.org",
        "port": 80,
        "path": "/anything"
    }
    ```

1. Create a route:

    ```bash
    http -f put :8001/services/openid-connect/routes/openid-connect paths=/
    ```
    ```http
    HTTP/1.1 200 OK
    ```
    ```json
    {
        "id": "ac1e86bd-4bce-4544-9b30-746667aaa74a",
        "name": "openid-connect",
        "paths": [ "/" ]
    }
    ```

1. Create a plugin:

    You may execute this before patching the plugin (as seen on following examples) to reset
    the plugin configuration.

    ```bash
    http -f put :8001/plugins/5f35b796-ced6-4c00-9b2a-90eef745f4f9 \
    name=openid-connect                                          \
    service.name=openid-connect                                  \
    config.issuer=http://keycloak.test:8080/auth/realms/master   \
    config.client_id=kong                                        \
    config.client_auth=private_key_jwt
    ```
    ```http
    HTTP/1.1 200 OK
    ```
    ```json
    {
        "id": "5f35b796-ced6-4c00-9b2a-90eef745f4f9",
        "name": "openid-connect",
        "service": {
            "id": "5fa9e468-0007-4d7e-9aeb-49ca9edd6ccd"
        },
        "config": {
            "issuer": "http://keycloak.test:8080/auth/realms/master",
            "client_id": [ "kong" ],
            "client_auth": [ "private_key_jwt" ]
        }
    }
    ```

1. Check the discovery cache: `http :8001/openid-connect/issuers`.

    It should contain Keycloak OpenID Connect discovery document and the keys.


At this point you have created a service, routed traffic to the service, and 
enabled OpenID Connect plugin on the service.

{% endcapture %}

In most cases, the OpenID Connect plugin relies on a third party identity provider (IdP).
The examples in this guide use Keycloak as a sample IdP. 

Expand the following sections to configure Keycloak and Kong Gateway.

<blockquote class="note no-icon"><details><summary>
    <strong>Configure Keycloak &nbsp;<i class="fas fa-arrow-right"></i> </strong>
  </summary>

<br>
{{ prereqs_keycloak | markdownify }}

</details>
</blockquote>

<blockquote class="note no-icon"><details><summary>
   <strong> Configure {{site.base_gateway}} &nbsp;<i class="fas fa-arrow-right"></i> </strong>
  </summary>

<br>
{{ prereqs_kong | markdownify }}

</details>
</blockquote>