---
title: Using decK with Kong Konnect
content_type: reference
---

You can manage {{site.base_gateway}} core entity configuration in your {{site.konnect_short_name}} organization using decK.

decK can only target one runtime group at a time.
Managing multiple runtime groups requires a separate state file per group.

You _cannot_ use decK to publish content to the Dev Portal, manage application registration, or configure custom plugins.

## {{site.konnect_short_name}} flags

You can use `deck` commands such as `ping`, `diff`, or `sync` with `--konnect` flags to interact with {{site.konnect_short_name}}.

If you don't pass a {{site.konnect_short_name}} flag to decK, decK looks for a local {{site.base_gateway}} instance instead.

`--konnect-addr`
:  Address of the {{site.konnect_short_name}} endpoint. (Default: `"https://us.api.konghq.com"`)

`--konnect-email`
:  Email address associated with your {{site.konnect_short_name}} account.

`--konnect-password`
:  Password associated with your {{site.konnect_short_name}} account.
This takes precedence over the `--konnect-password-file` flag.

`--konnect-password-file`
:  File containing the password to your {{site.konnect_short_name}} account.

`--konnect-runtime-group-name`
:  {{site.konnect_short_name}} runtime group name.

{% if_version gte:1.14.x %}
`--konnect-token`
:  Personal access token associated with your {{site.konnect_short_name}} account, this takes precedence over the `--konnect-token-file` flag.


`--konnect-token-file`
:  File containing the personal access token to your {{site.konnect_short_name}} account.
{% endif_version %}

{:.note}
> **Note:** Prior to decK 1.12, decK provided [`deck konnect`](/deck/1.11.x/reference/deck_konnect) commands.
Those commands are deprecated and have been replaced with the flags in this guide.

## Authenticate with {{site.konnect_short_name}}

decK looks for {{site.konnect_short_name}} credentials in the following order of precedence:

{% if_version gte:1.14.x %}

1. Credentials set with a flag, either `--konnect-password` or `--konnect-token`
2. decK configuration file, if one exists (default lookup path: `$HOME/.deck.yaml`)
3. Credential file passed with a flag, either `--konnect-password-file` or `--konnect-token-file`

{% endif_version %}

{% if_version lte:1.13.x %}

1.  Password set with the `--konnect-password` flag
2. decK configuration file, if one exists (default lookup path: `$HOME/.deck.yaml`)
3. File passed with the `--konnect-password-file` flag

{% endif_version %}

For example, if you have both a decK config file and a {{site.konnect_short_name}} password file, decK uses the password in the config file.

### Authenticate using a plaintext password

You can use the `--konnect-password` flag to provide the password directly in the command:

```sh
deck ping \
  --konnect-email example@example.com \
  --konnect-password YOUR_PASSWORD
```

### Authenticate using a password file

You can save your {{site.konnect_short_name}}
password to a file, then pass the filename to decK with `--konnect-password-file`:

```sh
deck ping \
  --konnect-email example@example.com \
  --konnect-password-file /PATH/TO/FILE
```

### Authenticate using a decK config file

By default, decK looks for a configuration file named `.deck.yaml` in the `$HOME` directory.
This file lets you specify flags to include with every decK command.

You can create the file at the default location, or set a custom filename and path with [`--config`](/deck/{{page.kong_version}}/reference/deck).

If you store {{site.konnect_short_name}} credentials in the file, decK uses the credentials for every command.
Set either `konnect-password` or `konnect-password-file` in the decK config file.

* Use `konnect-password` to store {{site.konnect_short_name}} credentials directly in the configuration file:

    ```
    konnect-email: example@email.com
    konnect-password: YOUR_PASSWORD
    ```

* Store your password in a separate file, then specify the path to `konnect-password-file` instead of a literal password:

    ```
    konnect-email: example@example.com
    konnect-password-file: PATH/TO/FILENAME
    ```

decK automatically uses the credentials from `$HOME/.deck.yaml` in any subsequent calls:

```sh
deck ping

Successfully Konnected as MyName (Konnect Org)!
```
{% if_version gte:1.14.x %}
### Authenticate using a personal access token

{% include_cached /md/personal-access-token.md %}

You can use the `--konnect-token` flag to pass the PAT directly in the command:

```sh
deck ping \
  --konnect-token YOUR_PERSONAL_ACCESS_TOKEN
```

You can save your {{site.konnect_short_name}}
PAT to a file, then pass the filename to decK with `--konnect-token-file`:

```sh
deck ping \
  --konnect-token-file /PATH/TO/FILE
```
{% endif_version %}

## Target a {{site.konnect_short_name}} API

Use `--konnect-addr` to select the API to connect to.

The default API decK uses is `https://us.api.konghq.com`, which targets the `cloud.konghq.com` environment.

{% if_version gte:1.14.x %}

{{site.base_gateway}} supports US and EU geographic regions.
To target the EU region, set `konnect-addr` to `"https://eu.api.konghq.com"`.

{% endif_version %}

## Runtime groups

Each [state file](/deck/{{page.kong_version}}/terminology/#state-files) targets one runtime group.
If you don't provide a group, decK targets the `default` runtime group.

If you have a custom runtime group, you can specify the group in the state file,
or use a flag when running any decK command.

* Target a runtime group in your state file with the `konnect_runtime_group` parameter:

    ```yaml
    _format_version: "3.0"
    _konnect:
      runtime_group_name: staging
    ```

* Set a group using the `--konnect-runtime-group-name` flag:

    ```sh
    deck sync --konnect-runtime-group-name staging
    ```

## {{site.konnect_short_name}} service tags

In {{site.konnect_short_name}}, there are two types of services:
* Gateway services: Managed through Runtime Manager
* {{site.konnect_short_name}} services: Managed through Service Hub

Each {{site.konnect_short_name}} service may contain one or more service versions.
A service version represents an implementation of a Gateway service.

decK manages Gateway services, which contain configurations for the Gateway proxy.

Although decK doesn't _directly_ manage {{site.konnect_short_name}} services or service versions, you can use tags to associate a Gateway service to a service version in a {{site.konnect_short_name}} service:

```yaml
services:
- name: SERVICE_NAME
  tags:
  - _KonnectService:KONNECT_SERVICE_NAME
```

Where:

* `KONNECT_SERVICE_NAME`: Identifies which {{site.konnect_short_name}} _service_ to associate the Gateway service to.
* `SERVICE_NAME`: The name of the Gateway service. Identifies which {{site.konnect_short_name}} _service version_ to associate the Gateway service to.

If the {{site.konnect_short_name}} service doesn't exist, setting a `_Konnect` tag creates a {{site.konnect_short_name}} service.

For example, see the following configuration snippet, where the Gateway service named `example_service` is attached to the {{site.konnect_short_name}} service `example`:

```yaml
_format_version: "3.0"
_konnect:
  runtime_group_name: default
services:
- name: example_service
  host: mockbin.org
  tags:
  - _KonnectService:example
```

If the {{site.konnect_short_name}} service doesn't exist, this configuration snippet creates a {{site.konnect_short_name}} service named `example` with a version named `example_service` in the Service Hub.

## Troubleshoot

{% if_version gte:1.14.x %}
### Authentication with a {{site.konnect_short_name}} password or token file is not working

If you have verified that your password or token is correct but decK can't connect to your account, check for conflicts with the decK config file (`$HOME/.deck.yaml`) and the {{site.konnect_short_name}} password or token file.
A decK config file is likely conflicting with the password or token file and passing another set of credentials.

To resolve, remove one of the duplicate sets of credentials.

{% endif_version %}

{% if_version lte:1.13.x %}
### Authentication with a {{site.konnect_short_name}} password file is not working

If you have verified that your password is correct but decK can't connect to your account, check for conflicts with the decK config file (`$HOME/.deck.yaml`) and the {{site.konnect_short_name}} password file.
A decK config file is likely conflicting with the password or token file and passing another set of credentials.

To resolve, remove one of the duplicate sets of credentials.

{% endif_version %}

### Workspace connection refused

When migrating from {{site.base_gateway}} to {{site.konnect_short_name}}, make sure to remove any `_workspace` tags. If you leave `_workspace` in, you get the following error:

```
Error: checking if workspace exists
```

Remove the `_workspace` key to resolve this error.

You can now sync the file as-is to apply it to the default runtime group, or add a key to apply the configuration to a specific runtime group.

To apply the configuration to custom runtime groups, replace `_workspace` with `runtime_group_name: GroupName`.

For example, to export the configuration from workspace `staging` to runtime group `staging`, you would change:

```yaml
_workspace: staging
```

To:
```yaml
_konnect:
  runtime_group_name: staging
```

### ACL, Key Auth, or OpenID Connect plugins and app registration

You may encounter one of the following scenarios with the ACL, Key Authentication, or OpenID Connect (OIDC) plugins:
* The plugins are visible in the Service Hub UI, but don't appear in the output from a `deck dump` or `deck diff`.
* When trying to set up one of the plugins on a {{site.konnect_short_name}} service version with app registration enabled, you see the following error:

    ```
    {Create} plugin key-auth for service example_service failed: HTTP status 400
    ```

This is intentional. When you have application registration enabled, decK doesn't manage these plugins, and doesn't let you create duplicates of the plugin entries.

When setting up app registration, {{site.konnect_short_name}} enables two plugins automatically: ACL, and either Key Authentication or OIDC, depending on your choice of authentication.
These plugins run in the background to support application registration for the service version.
They are managed entirely by {{site.konnect_short_name}}, so you can't manage these plugins directly.

[Manage application registration](/konnect/dev-portal/applications/enable-app-reg) through the Service Hub to avoid any issues.

{% if_version gte:1.15 %}

### decK targets {{site.base_gateway}} instead of {{site.konnect_short_name}}

decK can run against {{site.base_gateway}} or {{site.konnect_short_name}}.
By default, it targets {{site.base_gateway}}, unless a setting tells decK to point to {{site.konnect_short_name}} instead.

decK determines the environment using the following order of precedence:

1. If the declarative configuration file contains the `_konnect` entry, decK runs
against {{site.konnect_short_name}}.

2. If the `--kong-addr` flag is set to a non-default value, decK runs against {{site.base_gateway}}.

3. If {{site.konnect_short_name}} credentials are set in any way (flag, file, or decK config), decK runs against {{site.konnect_short_name}}.

4. If none of the above are present, decK runs against {{site.base_gateway}}.

{% endif_version %}

## See also

* [Import {{site.base_gateway}} entities into {{site.konnect_short_name}}](/konnect/getting-started/import)
* [Manage runtime groups with decK](/konnect/runtime-manager/runtime-groups/declarative-config)
