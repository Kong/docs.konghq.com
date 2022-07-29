---
title: GCP Secrets Manager
beta: true
badge: enterprise
---

## Configuration
The current version of {{site.base_gateway}}'s implementation supports configuring [GCP Secrets Manager](https://cloud.google.com/secret-manager/) in two ways: 

* Environment variables
* Workload Identity 

To configure using environment export the GCP service account variable: 

```bash
export GCP_SERVICE_ACCOUNT=SERVICE_ACCOUNT
```
{{site.base_gateway}} will automatically authenticate with the GCP API and grant you access. 

To use GCP Secrets Manager with [Workload Identity](https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity) on a GKE cluster, update your pod spec so that the service account is attached to the pod. For configuration information, read the Workload Identity configuration [documentation](https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity#authenticating_to).

{:.note}
> With Workload Identity, setting the `GCP_SERVICE_ACCOUNT` is not necessary. 

## Examples

To use a GCP Secret Manager [secret](https://cloud.google.com/secret-manager/docs/reference/rest/v1/projects.secrets) with the name `my-secret-name`. Create a JSON object in GCP that contains multiple key:value pairs:


```json
{
  "foo": "bar",
  "snip": "snap",
}
```

You can now reference the secret's individual resources like this: 

```bash
{vault://gcp/my-secret-name/foo}
{vault://gcp/my-secret-name/snap}
```

## Entity

The Vault entity can only be used once the database is initialized. Secrets for values that are used _before_ the database is initialized can't make use of the Vaults entity. You will need to provide {{site.base_gateway}} with the GCP Secrets Manager `project_id` in the request: 

{% navtabs codeblock %}
{% navtab cURL %}

```bash
curl -i -X PUT http://<hostname>:8001/vaultsa/my-gcp-sm-vault  \
  --data name=gcp \
  --data description="Storing secrets in GCP Secrets Manager" \
  --data config.project_id="my_project_id"
```

{% endnavtab %}
{% navtab HTTPie %}

```bash
http PUT :8001/vaults-beta/my-gcp-sm-vault name="gcp" \
  description="Storing secrets in GCP Secrets Manager" \
  config.project_id="my_project_id" \
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

