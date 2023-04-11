## Kong Configuration

### Create an anonymous consumer

```bash
curl --request PUT \
  --url http://localhost:8001/consumers/anonymous
```

```json
{
    "created_at": 1667352450,
    "custom_id": null,
    "id": "bec9d588-073d-4491-b210-1d07099bfcde",
    "tags": null,
    "type": 0,
    "username": "anonymous",
    "username_lower": null
}
```

### Create a service

```bash
curl --request PUT \
  --url http://localhost:8001/services/saml-service \
  --data url=https://httpbin.org/anything
```

```json
{
    "id": "5fa9e468-0007-4d7e-9aeb-49ca9edd6ccd",
    "name": "saml-service",
    "protocol": "https",
    "host": "httpbin.org",
    "port": 443,
    "path": "/anything"
}
```

### Create a route

```bash
curl --request PUT \
  --url http://localhost:8001/services/saml-service/routes/saml-route \
  --data paths=/saml
```

```json
{
    "id": "ac1e86bd-4bce-4544-9b30-746667aaa74a",
    "name": "saml-route",
    "paths": [ "/saml" ]
}
```

### Set up Microsoft AzureAD

1. Create a SAML Enterprise Application. Refer to the [Microsoft AzureAD documentation](https://learn.microsoft.com/en-us/azure/active-directory/manage-apps/add-application-portal) for more information.
2. Note the identifier (entity ID) and sign on URL parameters.
3. Configure the reply URL (Assertion Consumer Service URL), for example, `https://kong-proxy:8443/saml/consume`.
4. Assign users to the SAML enterprise application.

### Create a plugin on a service

Validation of the SAML response assertion is disabled in the plugin configuration below. This configuration should not be used in a production environment.

Replace the `Azure_Identity_ID` value below, with the `identifier` value from the single sign-on - basic SAML configuration from the Manage section of the Microsoft AzureAD enterprise application:

<img src="/assets/images/docs/saml/azuread_basic_config.png">

Replace the `AzureAD_Sign_on_URL` value below, with the `Login URL` value from the single sign-on - Set up Service Provider section from the Manage section of the Microsoft AzureAD enterprise application:

<img src="/assets/images/docs/saml/azuread_sso_url.png">

```bash
curl --request POST \
  --url http://localhost:8001/services/saml-service/plugins \
  --header 'Content-Type: multipart/form-data' \
  --form name=saml \
  --form config.anonymous=anonymous \
  --form service.name=saml-service \
  --form config.issuer=AzureAD_Identity_ID \
  --form config.idp_sso_url=AzureAD_Sign_on_URL \
  --form config.assertion_consumer_path=/consume \
  --form config.validate_assertion_signature=false
```

```json
{
    "id": "a8655ba0-de99-48fc-b52f-d7ed030a755c",
    "name": "saml",
    "service": {
        "id": "5fa9e468-0007-4d7e-9aeb-49ca9edd6ccd"
    },
    "config": {
        "assertion_consumer_path": "/consume",
        "validate_assertion_signature": true,
        "idp_sso_url": "https://login.microsoftonline.com/f177c1d6-50cf-49e0-818a-a0585cbafd8d/saml2",
        "issuer": "https://samltoolkit.azurewebsites.net/kong_saml"
    }
}
```

### Test the SAML plugin

1. Using a browser, go to the URL (https://kong:8443/saml)
2. The browser is redirected to the AzureAD Sign in page. Enter the user credentials of a user configured in AzureAD
3. If user credentials are valid, the browser will be redirected to https://httpbin.org/anything
4. If the user credentials are invalid, a `401` unauthorized HTTP status code is returned

## Troubleshooting

### Certificate is valid, but isn't being accepted

**Problem:**
You have a valid certificate specified in the `idp_certificate` field, but you get the following error:

```
[saml] user is unauthorized with error: public key in saml response does not match
```

**Solution:**
If you provide a certificate through the `idp_certificate` field, the certificate must have the header and footer removed.

For example, a standard certificate might look like this, with a header and footer:

```
-----BEGIN CERTIFICATE-----
<certificate contents>
-----END CERTIFICATE-----
```

Remove the header and footer before including the certificate in the `idp_certificate` field:
```
<certificate contents>
```
