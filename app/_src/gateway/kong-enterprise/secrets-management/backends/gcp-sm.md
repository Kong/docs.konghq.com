---
title: GCP Secrets Manager
badge: enterprise
content-type: how-to
---

The current version of {{site.base_gateway}}'s implementation supports
configuring
[GCP Secrets Manager](https://cloud.google.com/secret-manager/) in two
ways:

* Environment variables
* Workload Identity

## Configure GCP Secrets Manager

To configure GCP Secrets Manager, the `GCP_SERVICE_ACCOUNT`
environment variable must be set to the JSON document referring to the
[credentials for your service account](https://cloud.google.com/iam/docs/creating-managing-service-account-keys):

```bash
export GCP_SERVICE_ACCOUNT=$(cat gcp-my-project-c61f2411f321.json)
```

{{site.base_gateway}} uses the key to automatically authenticate
with the GCP API and grant you access.

To use GCP Secrets Manager with
[Workload Identity](https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity)
on a GKE cluster, update your pod spec so that the service account is
attached to the pod. For configuration information, read the [Workload
Identity configuration
documentation](https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity#authenticating_to).

{:.note}
> With Workload Identity, setting the `GCP_SERVICE_ACCOUNT` isn't necessary.

### Examples

To use a GCP Secret Manager
[secret](https://cloud.google.com/secret-manager/docs/reference/rest/v1/projects.secrets)
with the name `my-secret-name`, create a JSON object in GCP that
contains one or more properties:

```json
{
  "foo": "bar",
  "snip": "snap"
}
```

You can now reference the secret's individual resources like this:

```bash
{vault://gcp/my-secret-name/foo?project_id=my_project_id}
{vault://gcp/my-secret-name/snip?project_id=my_project_id}
```

Note that both the provider (`gcp`) as well as the GCP project ID
(`my_project_id`) need to be specified. You can configure the project ID
with an environment variable before starting {{site.base_gateway}}:

```bash
export KONG_VAULT_GCP_PROJECT_ID=my_project_id
```

Then you don't need to repeat it in references:

```bash
{vault://gcp/my-secret-name/foo}
{vault://gcp/my-secret-name/snip}
```

## Configuration via vaults entity

Once the database is initialized, a Vault entity can be created
that encapsulates the provider and the GCP project ID:

{% navtabs %}
{% navtab Admin API %}

```bash
curl -i -X PUT http://HOSTNAME:8001/vaults/my-gcp-sm-vault \
  --data name=gcp \
  --data description="Storing secrets in GCP Secrets Manager" \
  --data config.project_id="my_project_id"
```

Result:

```json
{
    "config": {
        "project_id": "my_project_id"
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
{% endnavtab %}
{% navtab Declarative configuration %}

{:.note}
> Secrets management is supported in decK 1.16 and later.

Add the following snippet to your declarative configuration file:

```yaml
_format_version: "3.0"
vaults:
- config:
    project_id: my_project_id
  description: Storing secrets in GCP Secrets Manager
  name: gcp
  prefix: my-gcp-sm-vault
```

{% endnavtab %}
{% endnavtabs %}

With the Vault entity in place, you can reference the GCP secrets
through it:

```bash
{vault://my-gcp-sm-vault/my-secret-name/foo}
{vault://my-gcp-sm-vault/my-secret-name/snip}
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


Configuration options for a GCP Secrets Manager vault in {{site.base_gateway}}:

Parameter | Field name | Description
----------|------------|------------
`vaults.config.project_id` | **Google Project ID** | The project ID from your Google API Console. Visit your Google API Console and select **Manage all projects** in the projects list to see your project ID.
`vaults.config.ttl` | **TTL** | Time-to-live (in seconds) of a secret from the AWS vault when cached by this node.
`vaults.config.neg_ttl` | **Negative TTL** | Time-to-live (in seconds) of a AWS vault miss (no secret).
`vaults.config.resurrect_ttl` | **Resurrect TTL** | Time (in seconds) for which stale secrets from the AWS vault should be resurrected forwhen they cannot be refreshed (e.g., the GCP vault is unreachable).

Common options:

Parameter | Field name | Description
----------|------------|------------
`vaults.description` <br> *optional* | **Description** | An optional description for your vault.
`vaults.name` | **Name** | The type of vault. Accepts one of: `env`, `gcp`, `aws`, or `hcv`. Set `gcp` for GCP Secrets Manager.
`vaults.prefix` | **Prefix** | The reference prefix. You need this prefix to access secrets stored in this vault. For example, `{vault://my-gcp-sm-vault/<some-secret>}`.
