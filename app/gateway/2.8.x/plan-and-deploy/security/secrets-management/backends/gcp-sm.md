---
title: GCP Secrets Manager
badge: enterprise
content-type: how-to
---

## Configuration

The current version of {{site.base_gateway}}'s implementation supports
configuring
[GCP Secrets Manager](https://cloud.google.com/secret-manager/) in two
ways:

* Environment variables
* Workload Identity

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

## Examples

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
(`my_project_id`) need to be specified.

## Entity

Once the database is initialized, a Vault entity can be created
that encapsulates the provider and the GCP project ID:

{:.important}
> **API Endpoint update**
>
> If you're using 2.8.2 or below, or have not set `vaults_use_new_style_api=on` in `kong.conf` you will need to replace `/vaults/` with `/vaults-beta/` in the examples below.

{% navtabs codeblock %}
{% navtab cURL %}

```bash
curl -i -X PUT http://HOSTNAME:8001/vaults/my-gcp-sm-vault \
  --data name=gcp \
  --data description="Storing secrets in GCP Secrets Manager" \
  --data config.project_id="my_project_id"
```

{% endnavtab %}
{% navtab HTTPie %}

```bash
http -f PUT http://HOSTNAME:8001/vaults/my-gcp-sm-vault \
  name="gcp" \
  description="Storing secrets in GCP Secrets Manager" \
  config.project_id="my_project_id"
```

{% endnavtab %}
{% endnavtabs %}

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

With the Vault entity in place, you can reference the GCP secrets
through it:

```bash
{vault://my-gcp-sm-vault/my-secret-name/foo}
{vault://my-gcp-sm-vault/my-secret-name/snip}
```

When you use the Vault entity, you no longer need to specify the GCP project ID to access the secrets.
