---
title: Konnect Config Store
---


You can store your sensitive data directly in {{site.konnect_short_name}} via the {{site.konnect_short_name}} Config Store. {{site.konnect_short_name}} Config Store is scoped to a control plane today and works directly with Gateway’s Vaults entity in Gateway Manager to easily manage security and governance policies. {{site.konnect_short_name}} Config Store is built with security in mind such that once a secret is stored in {{site.konnect_short_name}}, you cannot view the value again. This ensures that sensitive data is not visible in plain text anywhere. 


## Configure the {{site.konnect_short_name}} config store

{% navtabs %}
{% navtab API %}

Create a config store entity in {{site.konnect_short_name}} and save the `config_store_id` from the response body.

```sh 
curl -i -X POST https://{region}.api.konghq.com/v2/control-planes/{control-plane-id}/config-stores \
  --header 'Authorization: Bearer {kpat_token}' \
  --header 'Content-Type: application/json' \
  --data '{
	"name": "my-config-store"
}'
```

Using the `config_store_id` create a `POST` request to associate the config store with the vault.
    
```sh
curl -i -X POST https://{region}.api.konghq.com/v2/control-planes/{control-plane-id}/core-entities/vaults/  \
  --header 'Authorization: Bearer {kpat_token}' \
  --header 'Content-Type: application/json' \
  --data '{
	"config":{
		"config_store_id": "{my-config-store-id}"
	},
	"description": "Description of your vault",
	"name": "konnect",
	"prefix": "mysecretvault"
}'
```

{% endnavtab %}
{% navtab UI %}
1. In {% konnect_icon runtimes %} **Gateway Manager** select a control plane.
1. Click **New vault**.
1. Choose **Konnect**
1. Enter the configuration settings for your vault and **Save**.

{% endnavtab %}
{% navtab decK %}

decK doesn't support creating a {{site.konnect_short_name}} config store, but you can reference secrets stored in a config store with decK.

Using the Control Plane Config API, create a config store entity in {{site.konnect_short_name}} and save the `config_store_id` from the response body:

```sh 
curl -i -X POST https://{region}.api.konghq.com/v2/control-planes/{control-plane-id}/config-stores \
  --header 'Authorization: Bearer {kpat_token}' \
  --header 'Content-Type: application/json' \
  --data '{
	"name": "my-config-store"
}'
```

Using the generated `config_store_id`, send a `POST` request to associate the config store with the vault:
    
```sh
curl -i -X POST https://{region}.api.konghq.com/v2/control-planes/{control-plane-id}/core-entities/vaults/  \
  --header 'Authorization: Bearer {kpat_token}' \
  --header 'Content-Type: application/json' \
  --data '{
	"config":{
		"config_store_id": "{my-config-store-id}"
	},
	"description": "Description of your vault",
	"name": "konnect",
	"prefix": "mysecretvault"
}'
```

Reference the {{site.konnect_short_name}} config store in your decK file:

```yaml
_format_version: "3.0"
vaults:
- config:
    config_store_id: {my-config-store-id}
  description: Storing secrets in Konnect
  name: konnect
  prefix: mysecretvault
```
{% endnavtab %}
{% endnavtabs %}

## Reference {{site.konnect_short_name}} Config Store secrets

You can now store secrets in the {{site.konnect_short_name}} Config Store and reference them throughout the control plane. 

For instance, a secret named `secret-name` can be referenced using:

```sh
{vault://mysecretvault/secret-name}
```

This allows {{site.base_gateway}} to recognize and retrieve the stored secrets. Additionally, a secret can hold multiple key-value pairs if needed:

```json
{
  "foo": "bar",
  "snip": "snap"
}
```

To make these secrets accessible to {{site.base_gateway}}, reference the vault using a specific URL format. For the example above, the references would be:

```sh
{vault://mysecretvault/secret-name/foo}
{vault://mysecretvault/secret-name/snip}
```

{:.important}
> **Important:** The Konnect Config Store stores secrets at the Control Plane level, and secret references are resolved before sending the configuration to the Data Planes.
Because of this behavior, you can't use Konnect Config Store secrets directly in Lua code via the Kong PDK, for example.


## Supported fields

| Parameter           | Field Name        | Description                                                                                             |
|---------------------|-------------------|---------------------------------------------------------------------------------------------------------|
| `vaults.description`   | Description       | An optional description for your vault.                                                                 |
| `vaults.name`         | Name              | The type of vault. Accepts one of: `konnect`, `env`, `gcp`, `aws`, or `hcv`. |
| `vaults.prefix`       | Prefix            | The reference prefix. You need this prefix to access secrets stored in this vault. For example, `{vault://<vault-prefix>/<some-secret>}`. |
