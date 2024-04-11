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
export GCP_SERVICE_ACCOUNT=$(cat gcp-project-c61f2411f321.json)
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
> **Notes:**
> * With Workload Identity, setting the `GCP_SERVICE_ACCOUNT` isn't necessary.
> * When using GCP Vault as a backend, make sure you have configured `system` as part of the
> [`lua_ssl_trusted_certificate` configuration directive](/gateway/{{page.release}}/reference/configuration/#lua_ssl_trusted_certificate)
so that the SSL certificates used by the official GCP API can be trusted by Kong.

### Examples

To use a GCP Secret Manager
[secret](https://cloud.google.com/secret-manager/docs/reference/rest/v1/projects.secrets)
with the name `secret-name`, create a JSON object in GCP that
contains one or more properties:

```json
{
  "foo": "bar",
  "snip": "snap"
}
```

You can now reference the secret's individual resources like this:

```bash
{vault://gcp/secret-name/foo?project_id=project_id}
{vault://gcp/secret-name/snip?project_id=project_id}
```

Note that both the provider (`gcp`) as well as the GCP project ID
(`project_id`) need to be specified. You can configure the project ID
with an environment variable before starting {{site.base_gateway}}:

```bash
export KONG_VAULT_GCP_PROJECT_ID=project_id
```

Then you don't need to repeat it in references:

```bash
{vault://gcp/secret-name/foo}
{vault://gcp/secret-name/snip}
```

## Configuration via vaults entity

Once the database is initialized, a Vault entity can be created
that encapsulates the provider and the GCP project ID:

{% navtabs %}
{% navtab Admin API %}

```bash
curl -i -X PUT http://HOSTNAME:8001/vaults/gcp-sm-vault \
  --data name=gcp \
  --data description="Storing secrets in GCP Secrets Manager" \
  --data config.project_id="project_id"
```

Result:

```json
{
    "config": {
        "project_id": "project_id"
    },
    "created_at": 1657874961,
    "description": "Storing secrets in GCP Secrets Manager",
    "id": "90e200be-cf84-4ce9-a1d6-a41c75c79f31",
    "name": "gcp",
    "prefix": "gcp-sm-vault",
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
    project_id: project_id
  description: Storing secrets in GCP Secrets Manager
  name: gcp
  prefix: gcp-sm-vault
```

{% endnavtab %}
{% endnavtabs %}

With the Vault entity in place, you can reference the GCP secrets
through it:

```bash
{vault://gcp-sm-vault/secret-name/foo}
{vault://gcp-sm-vault/secret-name/snip}
```

## Vault entity configuration options

Use the following configuration options to configure the vaults entity through
any of the supported tools:
* Admin API
* Declarative configuration
{% if_version gte:3.1.x -%}
* Kong Manager
* {{site.konnect_short_name}}
{% endif_version %}


Configuration options for a GCP Secrets Manager vault in {{site.base_gateway}}:

Parameter | Field name | Description
----------|------------|------------
`vaults.config.project_id` | **Google Project ID** | The project ID from your Google API Console. Visit your Google API Console and select **Manage all projects** in the projects list to see your project ID.
`vaults.config.ttl` | **TTL** | Time-to-live (in seconds) of a secret from the vault when it's cached. The special value of 0 means "no rotation" and it's the default. When using non-zero values, it is recommended that they're at least 1 minute.
`vaults.config.neg_ttl` | **Negative TTL** | Time-to-live (in seconds) of a vault miss (no secret). Negatively cached secrets will remain valid until `neg_ttl` is reached, after which Kong will attempt to refresh the secret again. The default value for `neg_ttl` is 0, meaning no negative caching occurs.
`vaults.config.resurrect_ttl` | **Resurrect TTL** | Time (in seconds) for how long secrets will remain in use after they are expired (`config.ttl` is over). This is useful when a vault becomes unreachable, or when a secret is deleted from the Vault and isn't replaced immediately. On this both cases, the Gateway will keep trying to refresh the secret for `resurrect_ttl` seconds. After that, it will stop trying to refresh. We recommend assigning a sufficiently high value to this configuration option to ensure a seamless transition in case there are unexpected issues with the Vault. The default value for `resurrect_ttl` is 1e8 seconds, which is about 3 years.

Common options:

Parameter | Field name | Description
----------|------------|------------
`vaults.description` <br> *optional* | **Description** | An optional description for your vault.
`vaults.name` | **Name** | The type of vault. Accepts one of: `env`, `gcp`, `aws`, or `hcv`. Set `gcp` for GCP Secrets Manager.
`vaults.prefix` | **Prefix** | The reference prefix. You need this prefix to access secrets stored in this vault. For example, `{vault://gcp-sm-vault/<some-secret>}`.
