---
title: Konnect Config Store
---

You can store your sensitive data directly in Konnect via the Konnect Config Store. Konnect Config Store is scoped to a control plane today and works directly with Gateway’s Vaults entity in Gateway Manager to easily manage security and governance policies. Konnect Config Store is built with security in mind such that once a secret is stored in Konnect, you cannot view the value again. This ensures that sensitive data is not visible in plain text anywhere. 


## Prerequisites

 
### Create a config store entity

To configure the vault backend with Konnect Config Store, you need to first create a config store entity in Konnect:


    curl -i -X POST http://us.api.konghq.com/v2/control-planes/51399011-aaa3-4530-9cf1-fc0039ae78e0/config-stores  \
    --data name="Default-Config-Store"

This action is not supported by deck or UI today. Since Konnect Config Store works with the vaults entity, you can simply select Konnect in Vaults entity under Gateway Manager.


### Connect the config store to vaults

{% navtabs %}
{% navtab API %}
```yaml
curl -i -X POST http://us.api.konghq.com/vaults/konnect-vault  \
  --data name=konnect \
  --data description="Storing secrets in Konnect Config Store" \
  --data config.config_store_id="ee62068e-1843-49f8-ac22-40293b0a949d"
```
{% endnavtab %}
{% navtab decK %}
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

You can now add secrets in the Config Store to be referenced elsewhere in the control plane. For example, a Konnect Config Store secret with the name `secret-name` may have multiple key=value pairs:

```
{
  "foo": "bar",
  "snip": "snap"
}
```


With the vault entity in place, you can now reference the secrets. 

```
{vault://konnect/secret-name/foo}
{vault://konnect/secret-name/snip}
```


| Parameter           | Field Name        | Description                                                                                             |
|---------------------|-------------------|---------------------------------------------------------------------------------------------------------|
| `vaults.description`   | Description       | An optional description for your vault.                                                                 |
| `vaults.name`         | Name              | The type of vault. Accepts one of: `konnect`, `env`, `gcp`, `aws`, or `hcv`. |
| `vaults.prefix`       | Prefix            | The reference prefix. You need this prefix to access secrets stored in this vault. For example, `{vault://konnect-vault/<some-secret>}`. |
