---
title: AWS Secrets Manager
badge: enterprise
---

[AWS Secrets Manager](https://aws.amazon.com/secrets-manager/) can be configured in multiple ways.
The current version of {{site.base_gateway}}'s implementation only supports
configuring AWS Secrets Manager via environment variables.

You can further customize the vault object by configuring a
`vaults` entity in {{site.base_gateway}}.

## AWS Secrets Manager configuration

Configure the following environment variables on your {{site.base_gateway}} data plane:

```bash
export AWS_ACCESS_KEY_ID=<access_key_id>
export AWS_SECRET_ACCESS_KEY=<secrets_access_key>
export AWS_REGION=<aws-region>
export AWS_SESSION_TOKEN=<token>
```

The region used by default with references can also be specified with the
following environment variable on your control plane:

```bash
export KONG_VAULT_AWS_REGION=<aws-region>
```

### Examples

For example, let's use an AWS Secrets Manager Secret with the name `my-secret-name`.

In this object, you have multiple key=value pairs.

```json
{
  "foo": "bar",
  "snip": "snap"
}
```

Access these secrets from `my-secret-name` like this:

```bash
{vault://aws/my-secret-name/foo}
{vault://aws/my-secret-name/snip}
```

## Configuration via vaults entity

The Vault entity can only be used once the database is initialized. Secrets for values that are used _before_ the database is initialized can't make use of the Vaults entity.

{% navtabs %}
{% navtab Admin API %}

```bash
curl -i -X PUT http://HOSTNAME:8001/vaults/my-aws-sm-vault  \
  --data name=aws \
  --data description="Storing secrets in AWS Secrets Manager" \
  --data config.region="us-east-1"
```

Result:

```json
{
    "config": {
        "region": "us-east-1"
    },
    "created_at": 1644942689,
    "description": "Storing secrets in AWS Secrets Manager",
    "id": "2911e119-ee1f-42af-a114-67061c3831e5",
    "name": "aws",
    "prefix": "my-aws-sm-vault",
    "tags": null,
    "updated_at": 1644942689
}
```
{% endnavtab %}
{% navtab Declarative configuration %}

{:.note}
> Secrets management is supported in decK 1.16 and later.

Add the following snippet into your declarative configuration file:

```yaml
_format_version: "3.0"
vaults:
- config:
    region: us-east-1
  description: Storing secrets in AWS Secrets Manager
  name: aws
  prefix: my-aws-sm-vault
```

{% endnavtab %}
{% endnavtabs %}

With the Vault entity in place, you can now reference the secrets. This allows you to drop the `AWS_REGION`
environment variable.

```bash
{vault://my-aws-sm-vault/my-secret-name/foo}
{vault://my-aws-sm-vault/my-secret-name/snip}
```

## Secrets in different regions

You can create multiple entities, which lets you have secrets in different regions:

```bash
curl -X PUT http://HOSTNAME:8001/vaults/aws-eu-central-vault -d name=aws -d config.region="eu-central-1"
curl -X PUT http://HOSTNAME:8001/vaults/aws-us-west-vault -d name=aws -d config.region="us-west-1"
```

This lets you source secrets from different regions:

```bash
{vault://aws-eu-central-vault/my-secret-name/foo}
{vault://aws-us-west-vault/my-secret-name/snip}
```

## Vault configuration options

Use the following configuration options to configure the `vaults` entity through
any of the supported tools:
* Admin API
* Declarative configuration
{% if_version gte:3.1.x %}
* Kong Manager
* {{site.konnect_short_name}}
{% endif_version %}


Configuration options for an AWS Secrets Manager vault in {{site.base_gateway}}:

Parameter | Field name                     | Description
----------|--------------------------------|------------
`vaults.config.region` | **AWS region** | The AWS region your vault is located in.
`vaults.config.ttl` | **TTL** | Time-to-live (in seconds) of a secret from the AWS vault when cached.
`vaults.config.neg_ttl` | **Negative TTL** | Time-to-live (in seconds) of a AWS vault miss (no secret).
`vaults.config.resurrect_ttl` | **Resurrect TTL** | Time (in seconds) for which stale secrets from the AWS vault should be resurrected for when they cannot be refreshed (e.g., the AWS vault is unreachable).

Common options:

Parameter | Field name | Description
----------|---------------|------------
`vaults.description` <br> *optional* | **Description** | An optional description for your vault.
`vaults.name` | **Name** | The type of vault. Accepts one of: `env`, `gcp`, `aws`, or `hcv`. Set `aws` for AWS Secrets Manager.
`vaults.prefix` | **Prefix** | The reference prefix. You need this prefix to access secrets stored in this vault. For example, `{vault://my-aws-sm-vault/<some-secret>}`.
