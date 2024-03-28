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
{% if_plugin_version gte:3.5.x %}
3. (Optional) Create another confidential client `cert-bound` with settings similar to the `service` client created previously.
   From the **Advanced** tab, enable the **OAuth 2.0 Mutual TLS Certificate Bound Access Tokens Enabled** toggle.
{% endif_plugin_version %}
{% if_plugin_version gte:3.6.x %}
4. (Optional, to test mTLS Client Authentication) Create another confidential client `client-tls-auth` with settings similar to the `service` client created above. 
   From the **Credentials** tab, select the **X509 Certificate** Client Authenticator and fill the Subject DN field so that it matches the Kong client certificate's, e.g.: `CN=JohnDoe, OU=IT`.
{% endif_plugin_version %}

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

{% if_plugin_version eq:3.5.x %}
{:.note}
> **Note:** The mTLS proof of possession feature that validates OAuth 2.0 Mutual TLS Certificate Bound Access Tokens requires configuring Keycloak to validate client certificates using mTLS with the `--https-client-auth=request` option. For more information, see the [Keycloak documentation](https://www.keycloak.org/server/enabletls).
{% endif_plugin_version %}

{% if_plugin_version gte:3.6.x %}
{:.note}
> **Note:** The mTLS Client Authentication, along with the proof of possession feature that validates OAuth 2.0 Mutual TLS Certificate Bound Access Tokens, both require configuring Keycloak to validate client certificates with mTLS using the `--https-client-auth=request` option, and to configure TLS appropriately, including adding the trusted client certificates to the truststore. For more information, refer to the [Keycloak documentation](https://www.keycloak.org/server/enabletls).
{% endif_plugin_version %}

[keycloak]: http://www.keycloak.org/

{% endcapture %}

{% capture prereqs_kong %}

1. Create a service:

    ```bash
    curl -i -X POST http://localhost:8001/services \
      --data "name=openid-connect" \
      --data "url=http://httpbin.org/anything"
    ```
    
1. Create a route:

    ```bash
    curl -i -X POST http://localhost:8001/services/openid-connect/routes \
      --data "name=openid-connect" \
      --data "paths[]=/"
    ```

{% endcapture %}

In most cases, the OpenID Connect plugin relies on a third party identity provider (IdP).
The examples in this guide use Keycloak as a sample IdP. 

Expand the following sections to configure Keycloak and {{site.base_gateway}}.

<details><summary>Configure Keycloak</summary>
{{ prereqs_keycloak | markdownify }}

</details>

<details><summary>Configure {{site.base_gateway}} </summary>
{{ prereqs_kong | markdownify }}

</details>