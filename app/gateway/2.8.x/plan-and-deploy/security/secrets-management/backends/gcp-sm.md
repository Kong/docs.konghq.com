---
title: GCP Secrets Manager
beta: true
badge: enterprise
---

## Configuration

[GCP Secrets Manager](https://cloud.google.com/secret-manager/) can be configured in multiple ways. The current version of Kong Gateway's implementation supports
configuring via environment variables. 

```bash
export GCP_SERVICE_ACCOUNT=<service_account>
```

{:.note}
> **Note**: This vault also works with [Workload Identity](https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity) on your GKE clusters. 
> For that the service account should be attached to pod,
> above environment variable ie. `GCP_SERVICE_ACCOUNT` does need in that case.


## Examples

For example, let's use an GCP Secrets Manager Secret with the name `my-secret-name`.

In this object, you have multiple key=value pairs.

```json
{
  "foo": "bar",
  "snip": "snap",
}
```

Access these secrets from `my-secret-name` like this:

```bash
{vault://gcp/my-secret-name/foo}
{vault://gcp/my-secret-name/snap}
```

## Entity

The Vault entity can only be used once the database is initialized. Secrets for values that are used _before_ the database is initialized can't make use of the Vaults entity.

{% navtabs codeblock %}
{% navtab cURL %}

```bash
curl -i -X PUT http://<hostname>:8001/vaults-beta/my-gcp-sm-vault  \
  --data name=gcp \
  --data description="Storing secrets in GCP Secrets Manager" \
  --data config.project_id="my_project_id"
```

{% endnavtab %}
{% navtab HTTPie %}

```bash
http PUT :8001/vaults-beta/my-gco-sm-vault name="gcp" \
  description="Storing secrets in GCP Secrets Manager" \
  config.region="my_project_id" \
  -f 
```

{% endnavtab %}
{% endnavtabs %}

Result:

```json

{
    "config": {
        "project_id": "project-last-hope"
    },
    "created_at": 1657874961,
    "description": "Storing secrets in GCP Secrets Manager",
    "id": "90e200be-cf84-4ce9-a1d6-a41c75c79f31",
    "name": "gcp",
    "prefix": "my-gcp-sm-vault",
    "tags": null,
    "updated_at": 1657874961
}
```

With the Vault entity in place, you can now reference the secrets. This allows you to drop the `KONG_VAULT_GCP_PROJECT_ID`
environment variable.

```bash
{vault://my-gcp-sm-vault/my-secret-name/foo}
{vault://my-gcp-sm-vault/my-secret-name/snap}
```
