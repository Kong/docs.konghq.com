---
title: Azure Key Vaults
badge: enterprise
content-type: how-to
---

The current version of {{site.base_gateway}}'s implementation supports
configuring
[Azure Key Vaults](https://azure.microsoft.com/en-us/products/key-vault) in two
ways:

* Environment variables
* Managed Identity Authentication

## Configure Azure Key Vaults

{{site.base_gateway}} uses the key to automatically authenticate
with the Azure Key Vaults API and grant you access.

{:.note}
> With `Instance Managed Identity Token`, setting the environment variables isn't necessary.


Note that Azure AD tenant ID, client ID, vault_uri and client secret need to be specified. You can configure these values with environment variables before starting {{site.base_gateway}}:

```bash
export KONG_VAULT_AZURE_VAULT_URI=https://my-vault.vault.azure.com
export AZURE_TENANT_ID=tenant_id
export AZURE_CLIENT_ID=client_id
export AZURE_CLIENT_SECRET=client_secret
```

Please note that `client_secret` can only be configured via environments variables.


### Examples

Note that Azure's Key Vault support three different secret types.

- Keys
- Secrets
- Certificates

For now, Kong only supports the `Secrets` type.

To use a [Secret](https://learn.microsoft.com/en-us/azure/key-vault/general/about-keys-secrets-certificates)
with the name `secret-name`, create a JSON object in Azure Key Vault that contains one or more properties:

```json
{
  "foo": "bar",
  "snip": "snap"
}
```

Note that Azure AD tenant ID, client ID, vault_uri and client secret need to be specified. You can configure these values with environment variables before starting {{site.base_gateway}}:

```bash
export KONG_VAULT_AZURE_VAULT_URI=https://my-vault.vault.azure.com
export AZURE_TENANT_ID=tenant_id
export AZURE_CLIENT_ID=client_id
export AZURE_CLIENT_SECRET=client_secret
```

```bash
{vault://azure/secret-name/foo}
{vault://azure/secret-name/snip}
```

alternatively, you can configure a vault via the `vaults entity`.

## Configuration via vaults entity

Once the database is initialized, a Vault entity can be created
that encapsulates the provider and the required Azure Key Vault informations:

{% navtabs %}
{% navtab Admin API %}

```bash
curl -i -X PUT http://HOSTNAME:8001/vaults/azure-key-vault \
  --data name=azure \
  --data description="Storing secrets in Azure Key Vault (Secrets)" \
  --data config.type="secrets" \
  --data config.location="us-east" \
  --data config.vault_uri="http://my-vault-uri.azure.com"
```

Result:

```json
{
    "config": {
        "client_id": null,
        "credentials_prefix": "AZURE",
        "vault_uri": "http://my-vault-uri.azure.com",
        "location": "us-east",
        "neg_ttl": null,
        "resurrect_ttl": null,
        "tenant_id": null,
        "ttl": null,
        "type": "secrets",
        "vault_uri": null
    },
    "created_at": 1696235611,
    "description": "Storing secrets in Azure Key Vault (Secrets)",
    "id": "7c9287c1-2cbc-406b-a013-843fe54dc0b6",
    "name": "azure",
    "prefix": "azure-key-vault",
    "tags": null,
    "updated_at": 1696235611
}
```

{% endnavtab %}
{% navtab Declarative configuration %}

{:.note}
> Secrets management is supported in decK 1.16 and later.

Add the following snippet to your declarative configuration file:

```yaml
_format_version: "3.0"
vaults:
- config:
    type: secrets
    vault_uri: http://my-vault-uri.azure.com
    location: us-east
  description: Storing secrets in Azure Key Vaults
  name: azure
  prefix: azure-key-vault
```

{% endnavtab %}
{% endnavtabs %}

With the Vault entity in place, you can reference the Azure secrets
through it:

```bash
{vault://azure-key-vault/secret-name/foo}
{vault://azure-key-vault/secret-name/snip}
```

## Vault entity configuration options

Use the following configuration options to configure the vaults entity through
any of the supported tools:
* Admin API
* Declarative configuration
{% if_version gte:3.1.x %}
* Kong Manager
* {{site.konnect_short_name}}
{% endif_version %}


Configuration options for a Azure Key Vault in {{site.base_gateway}}:

Parameter | Field name | Description
----------|------------|------------
`vaults.config.vault_uri` | **Vault URI** | The URI the vault is reachable from.. Visit your Azure Key Vault Dashboard and look for the Vault URI entry.
`vaults.config.client_id` | **Client ID** | The client ID from your registered Application. Visit your Azure Dashboard and select **App Registrations** to check your client ID.
`vaults.config.tenant_id ` | **Tenant ID** | The DirectoryId and TenantId both equate to the GUID representing the ActiveDirectory Tenant. Depending on context, either term may be used by Microsoft documentation and products, which can be confusing. In other words, the "Tenant ID" IS the "Directory ID"
`vaults.config.location` | **Location** | Each Azure geography contains one or more regions and meets specific data residency and compliance requirements.
`vaults.config.type` | **Type** | Azure Key Vault enables Microsoft Azure applications and users to store and use several types of secret/key data: keys, secrets, and certificates. Kong currently only supports the `Secrets`.
`vaults.config.ttl` | **TTL** | Time-to-live (in seconds) of a secret from the vault when it's cached. The special value of 0 means "no rotation" and it's the default. When using non-zero values, it is recommended that they're at least 1 minute.
`vaults.config.neg_ttl` | **Negative TTL** | Time-to-live (in seconds) of a vault miss (no secret). Negatively cached secrets will remain valid until `neg_ttl` is reached, after which Kong will attempt to refresh the secret again. The default value for `neg_ttl` is 0, meaning no negative caching occurs.
`vaults.config.resurrect_ttl` | **Resurrect TTL** | Time (in seconds) for how long secrets will remain in use after they are expired (`config.ttl` is over). This is useful when a vault becomes unreachable, or when a secret is deleted from the Vault and isn't replaced immediately. On this both cases, the Gateway will keep trying to refresh the secret for `resurrect_ttl` seconds. After that, it will stop trying to refresh. We recommend assigning a sufficiently high value to this configuration option to ensure a seamless transition in case there are unexpected issues with the Vault. The default value for `resurrect_ttl` is 1e8 seconds, which is about 3 years.

Common options:

Parameter | Field name | Description
----------|------------|------------
`vaults.description` <br> *optional* | **Description** | An optional description for your vault.
`vaults.name` | **Name** | The type of vault. Accepts one of: `env`, `gcp`, `azure`, `aws`, or `hcv`. Set `azure` for Azure Key Vaults
`vaults.prefix` | **Prefix** | The reference prefix. You need this prefix to access secrets stored in this vault. For example, `{vault://gcp-sm-vault/<some-secret>}`.
