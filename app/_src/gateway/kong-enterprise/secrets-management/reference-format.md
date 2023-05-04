---
title: Reference Format
---

We use the [URL syntax](https://en.wikipedia.org/wiki/URL) to describe references to a secret store.

{% if_version lte:3.2.x %}
```text
{vault://<vault-backend|entity>/<secret-id>[/<secret-key>][?query]}
```
{% endif_version %}

{% if_version gte:3.3.x %}
```text
{vault://<vault-backend|entity>/<secret-id>[:<secret-key>][?query]}
```
{% endif_version %}

### Protocol/Scheme

{% if_version lte:3.2.x %}
```text
{vault://<vault-backend|entity>/<secret-id>[/<secret-key>]}
 ^^^^^
```
{% endif_version %}

{% if_version gte:3.3.x %}
```text
{vault://<vault-backend|entity>/<secret-id>[:<secret-key>]}
 ^^^^^
```
{% endif_version %}

The `vault` in the URL is used as an identifier for Kong. We use this to reference a vault.

### Host/Path

{% if_version lte:3.2.x %}
```text
{vault://<vault-prefix>/<secret-id>[/<secret-key>]}
         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
```
{% endif_version %}

{% if_version gte:3.3.x %}
```text
{vault://<vault-prefix>/<secret-id>[:<secret-key>]}
         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
```
{% endif_version %}

The `host` and  `path` of the URL defines the following:

#### Vault Prefix

The prefix for a vault can be either the name of the backend or the name of vault entity that you created.

Examples:

{% if_version lte:3.2.x %}
```text
{vault://env/<secret-id>[/<secret-key>]}
         ^^^
```
or using a vault entity:

```text
{vault://my-env-vault/<secret-id>[/<secret-key>]}
         ^^^^^^^^^^^^
```
{% endif_version %}

{% if_version gte:3.3.x %}
```text
{vault://env/<secret-id>[:<secret-key>]}
         ^^^
```
or using a vault entity:

```text
{vault://my-env-vault/<secret-id>[:<secret-key>]}
         ^^^^^^^^^^^^
```
{% endif_version %}

#### Secret ID

The `secret-id` is used as an identifier for a secret stored in a vault. The vault
may return either a `string` value (a single secret) or multiple related secrets
like username and password as a secret `object`.

#### Secret Key

The `secret-key` is used to identify the secret within the `secret-id` object.

### Query

Query arguments are used to denote configuration options in a `key=value` format to the [Vault Prefix](/gateway/{{page.kong_version}}/kong-enterprise/secrets-management/reference-format/#vault-prefix)
