---
title: Konnect Config Store
---


You can store your sensitive data directly in {{site.konnect_short_name}} via the {{site.konnect_short_name}} Config Store. {{site.konnect_short_name}} Config Store is scoped to a control plane today and works directly with Gateway’s Vaults entity in Gateway Manager to easily manage security and governance policies. {{site.konnect_short_name}} Config Store is built with security in mind such that once a secret is stored in {{site.konnect_short_name}}, you cannot view the value again. This ensures that sensitive data is not visible in plain text anywhere. 

## Configure the {{site.konnect_short_name}} config store

Create a config store entity in {{site.konnect_short_name}} and save the `config_store_id` from the response body.
```sh 
curl -i -X POST http://{region}.api.konghq.com/v2/control-planes/{control-plane-id}/config-stores  \
--data name="Default-Config-Store"
```

> Creating a config store can only be accomplished using the [config-store](/konnect/api/control-planes/latest/#/Control%20Planes/config-store) endpoint.


## Connect the config store entity to the vault

{% navtabs %}
{% navtab API %}

Using the `config_store_id` create a `POST` request to associate the config store with the vault.
    
```sh
curl -i -X POST https://{region}.api.konghq.com/v2/control-planes/{control-plane-id}/core-entities/vaults/konnect-vault   \
  --data name=konnect \
  --data description="Storing secrets in Konnect Config Store" \
  --data config.config_store_id="ee62068e-1843-49f8-ac22-40293b0a949d"
```

{% endnavtab %}
{% navtab UI %}
1. In {% konnect_icon runtimes %} **Gateway Manager** select a control plane.
1. Click **New vault**.
1. Choose **Konnect**
1. Enter the configuration settings for your vault and **Save**.

{% endnavtab %}
{% navtab decK %}

Using the `config_store_id` create a `POST` request to associate the config store with the vault.

```yaml
_format_version: "3.0"
vaults:
- config:
    config_store_id: ee62068e-1843-49f8-ac22-40293b0a949d
  description: Storing secrets in Konnect
  name: konnect
  prefix: konnect-vault
```
{% endnavtab %}
{% endnavtabs %}

You can now store secrets in the {{site.konnect_short_name}} Config Store and reference them throughout the control plane. For instance, a secret in the {{site.konnect_short_name}} Config Store named `secret-name` can hold multiple key-value pairs:

```json
{
  "foo": "bar",
  "snip": "snap"
}
```

To make these secrets accessible to {{site.base_gateway}}, reference the environment variables using a specific URL format. For the example above, the references would be:

```sh
{vault://konnect/secret-name/foo}
{vault://konnect/secret-name/snip}
```

This allows {{site.base_gateway}} to recognize and retrieve the stored secrets.

## Supported fields

| Parameter           | Field Name        | Description                                                                                             |
|---------------------|-------------------|---------------------------------------------------------------------------------------------------------|
| `vaults.description`   | Description       | An optional description for your vault.                                                                 |
| `vaults.name`         | Name              | The type of vault. Accepts one of: `konnect`, `env`, `gcp`, `aws`, or `hcv`. |
| `vaults.prefix`       | Prefix            | The reference prefix. You need this prefix to access secrets stored in this vault. For example, `{vault://konnect-vault/<some-secret>}`. |
