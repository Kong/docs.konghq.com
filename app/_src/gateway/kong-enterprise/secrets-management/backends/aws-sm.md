---
title: AWS Secrets Manager
badge: enterprise
---

[AWS Secrets Manager](https://aws.amazon.com/secrets-manager/) can be configured in multiple ways.

{% if_version gte:3.4.x %}
To access secrets stored in the AWS Secrets Manager, {{site.base_gateway}} needs to be configured with an IAM Role that has sufficient permissions to read the required secret values.

{{site.base_gateway}} can automatically fetch IAM role credentials based on your AWS environment, observing the following precedence order:
- Fetch from credentials defined in environment variables `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`.
- Fetch from profile and credential file, defined by `AWS_PROFILE` and `AWS_SHARED_CREDENTIALS_FILE`.
- Fetch from an ECS [container credential provider](https://docs.aws.amazon.com/sdkref/latest/guide/feature-container-credentials.html).
- Fetch from an EKS [IAM roles for service account](https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html).
- Fetch from EC2 IMDS metadata. Both v1 and v2 are supported

{{site.base_gateway}} also supports role assuming which allows you to use a different IAM role to fetch secrets from AWS Secrets Manager.  This is a common practice in permission division and governance and cross-AWS account management.
{% endif_version %}

You can customize the vault object by configuring a
`vaults` entity in {{site.base_gateway}}.

## AWS Secrets Manager configuration

To configure the vault backend with AWS Secrets Manager, you need to configure {{site.base_gateway}} to have the required IAM roles to access any relevant secrets.

For example, to use the secrets management with AWS environment variable credentials, configure the following environment variables on your {{site.base_gateway}} data plane:

```bash
export AWS_ACCESS_KEY_ID=<access_key_id>
export AWS_SECRET_ACCESS_KEY=<secrets_access_key>
export AWS_SESSION_TOKEN=<token>
export AWS_REGION=<aws-region>
```

The region used by default with references can also be specified with the
following environment variable on your control plane:

```bash
export KONG_VAULT_AWS_REGION=<aws-region>
```

{% if_version gte:3.4.x %}
Additionally, if you want to use [`assume_role`](https://docs.aws.amazon.com/STS/latest/APIReference/API_AssumeRole.html), make sure you have the following environment variables on your {{site.base_gateway}} data plane:

```bash
export KONG_VAULT_AWS_ASSUME_ROLE_ARN=<aws_iam_role_arn>
export KONG_VAULT_AWS_ROLE_SESSION_NAME=<aws_assume_role_session_name>
```

The vault backend configuration field can also be configured in the `kong.conf` file. See [Gateway Enterprise configuration reference](/gateway/latest/reference/configuration).
{% endif_version %}

{:.note}
> **Note:** When using AWS Vault as a backend, make sure you have configured `system` as part of the [`lua_ssl_trusted_certificate` configuration directive](/gateway/{{page.release}}/reference/configuration/#lua_ssl_trusted_certificate) so that the SSL certificates used by the official AWS API can be trusted by Kong.

### Examples

For example, an AWS Secrets Manager secret with the name `secret-name` may have multiple key=value pairs:

```json
{
  "foo": "bar",
  "snip": "snap"
}
```

Access these secrets from `secret-name` like this:

```bash
{vault://aws/secret-name/foo}
{vault://aws/secret-name/snip}
```

If you have an AWS Secrets Manager secret with multiple versions, you can access the current version or any previous version of the secret by specifying a version in the reference. 

In the following example, `AWSCURRENT` refers to the latest secret version and `AWSPREVIOUS` refers to an older version:

```bash
# For AWSCURRENT, not specifying version
{vault://aws/secret-name/foo}

# For AWSCURRENT, specifying version == 1
{vault://aws/secret-name/foo#1}

# For AWSPREVIOUS, specifying version == 2
{vault://aws/secret-name/foo#2}
```

## Configuration via vaults entity

The vault entity can only be used once the database is initialized. Secrets for values that are used _before_ the database is initialized can't make use of the vaults entity.

{% navtabs %}
{% navtab Admin API %}

```bash
curl -i -X PUT http://localhost:8001/vaults/aws-sm-vault  \
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
    "prefix": "aws-sm-vault",
    "tags": null,
    "updated_at": 1644942689
}
```

{% endnavtab %}
{% navtab Declarative configuration %}

{:.note}
> Secrets management support was added in decK 1.16.

Add the following snippet into your declarative configuration file:

```yaml
_format_version: "3.0"
vaults:
- config:
    region: us-east-1
  description: Storing secrets in AWS Secrets Manager
  name: aws
  prefix: aws-sm-vault
```

{% endnavtab %}
{% endnavtabs %}

With the vault entity in place, you can now reference the secrets. This allows you to drop the `AWS_REGION`
environment variable.

```bash
{vault://aws-sm-vault/secret-name/foo}
{vault://aws-sm-vault/secret-name/snip}
```

## Secrets in different regions

You can create multiple entities, which lets you have secrets in different regions:

```bash
curl -X PUT http://localhost:8001/vaults/aws-eu-central-vault -d name=aws -d config.region="eu-central-1"
```
``` bash
curl -X PUT http://localhost:8001/vaults/aws-us-west-vault -d name=aws -d config.region="us-west-1"
```
This lets you source secrets from different regions:

```bash
{vault://aws-eu-central-vault/secret-name/foo}
{vault://aws-us-west-vault/secret-name/snip}
```

## Vault configuration options

Use the following configuration options to configure the `vaults` entity through
any of the supported tools:
* Admin API
* Declarative configuration
{% if_version gte:3.1.x -%}
* Kong Manager
* {{site.konnect_short_name}}
{% endif_version %}


Configuration options for an AWS Secrets Manager vault in {{site.base_gateway}}:

Parameter | Field name                     | Description
----------|--------------------------------|------------
`vaults.config.region` | **AWS region** | The AWS region your vault is located in.
{% if_version gte:3.4.x -%}
`vaults.config.endpoint_url` | **AWS Secrets Manager Endpoint URL** | The endpoint URL of the AWS Secrets Manager service. If not specified, the value used by vault will be the official AWS Secrets Manager service url which is `https://secretsmanager.{region}.amazonaws.com`. You can specify a complete URL(including the `http/https` scheme) to override the endpoint.
`vaults.config.assume_role_arn` | **Assume AWS IAM role ARN** | The target IAM role ARN that will assume as the AWS Secrets Manager service. If specified, the vault backend will do additional role assuming based on your current runtime's IAM Role. If you are not using assume role, do not specify this value.
`vaults.config.role_session_name` | **Role Session Name** | The role session name used for role assuming. The default value is `KongVault`.
{% endif_version -%}

`vaults.config.ttl` | **TTL** | Time-to-live (in seconds) of a secret from the vault when it's cached. The special value of 0 means "no rotation" and it's the default. When using non-zero values, it is recommended that they're at least 1 minute.
`vaults.config.neg_ttl` | **Negative TTL** | Time-to-live (in seconds) of a vault miss (no secret). Negatively cached secrets will remain valid until `neg_ttl` is reached, after which Kong will attempt to refresh the secret again. The default value for `neg_ttl` is 0, meaning no negative caching occurs.
`vaults.config.resurrect_ttl` | **Resurrect TTL** | Time (in seconds) for how long secrets will remain in use after they are expired ( using `config.ttl` as the stopping point). This is useful when a vault becomes unreachable, or when a secret is deleted from the vault and isn't replaced immediately. In both cases, gateway will keep trying to refresh the secret for `resurrect_ttl` seconds. After that, it will stop trying to refresh. Assigning a sufficiently high value to this configuration option is recommended to ensure a seamless transition in case there are unexpected issues with the vault. The default value for `resurrect_ttl` is 1^e8 seconds, which is about 3 years.

Common options:

Parameter | Field name | Description
----------|---------------|------------
`vaults.description` <br> *optional* | **Description** | An optional description for your vault.
`vaults.name` | **Name** | The type of vault. Accepts one of: `env`, `gcp`, `aws`, or `hcv`. Set `aws` for AWS Secrets Manager.
`vaults.prefix` | **Prefix** | The reference prefix. You need this prefix to access secrets stored in this vault. For example, `{vault://aws-sm-vault/<some-secret>}`.
