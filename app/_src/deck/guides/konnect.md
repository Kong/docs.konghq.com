---
title: Using decK with Kong Konnect
content_type: reference
---

You can manage {{site.base_gateway}} core entity configuration in your {{site.konnect_short_name}} organization using decK.

decK can only target one control plane at a time.

Managing multiple control planes requires a separate state file per control plane.

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

{% if_version lte:1.26.x %}
`--konnect-runtime-group-name`
:  {{site.konnect_short_name}} runtime group name.
{% endif_version %}

{% if_version gte:1.27.x %}
`--konnect-control-plane-name`
:  {{site.konnect_short_name}} control plane name.
{% endif_version %}

{% if_version gte:1.14.x lte:1.17.x %}
`--konnect-token`
:  Personal access token associated with your {{site.konnect_short_name}} account, this takes precedence over the `--konnect-token-file` flag.


`--konnect-token-file`
:  File containing the personal access token to your {{site.konnect_short_name}} account.
{% endif_version %}

{% if_version gte:1.18.x %}
`--konnect-token`
:  Personal access token associated with your {{site.konnect_short_name}} account (`kpat_*`), or with a system account (`spat_*`). This takes precedence over the `--konnect-token-file` flag.


`--konnect-token-file`
:  File containing the personal access token to your {{site.konnect_short_name}} account, or to a system account.
{% endif_version %}

{:.note}
> **Note:** Prior to decK 1.12, decK provided [`deck konnect`](/deck/1.11.x/reference/deck_konnect/) commands.
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

You can create the file at the default location, or set a custom filename and path with [`--config`](/deck/{{page.kong_version}}/reference/deck/).

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

Successfully Konnected to the Example-Name organization!
```
{% if_version gte:1.14.x %}
### Authenticate using a personal access token

You can generate a personal access token (PAT) in {{site.konnect_short_name}} for authentication with decK commands. This is more secure than basic authentication, and can be useful for organizations with CI pipelines that can't use the standard username and password authentication. 

{% if_version gte:1.18.x %}
There are two types of PATs available for {{site.konnect_short_name}}: 
* Personal access tokens associated with user accounts
* System account access tokens associated with system accounts

Learn more about system accounts in the [{{site.konnect_short_name}} System Accounts documentation](/konnect/org-management/system-accounts/).
{% endif_version %}

Before you generate a PAT, keep the following in mind:

* A PAT is granted all of the permissions that the user has access to via their most up-to-date role assignment.
* The PAT has a maximum duration of 12 months.
* There is a limit of 10 personal access tokens per user.
* Unused tokens are deleted and revoked after 12 months of inactivity.

{% if_version gte:1.18.x %}
{% navtabs %}
{% navtab User Account Token %}

To generate a PAT for a user account in {{site.konnect_short_name}}, select your user icon to open the context menu 
 and click **Personal access tokens**, then click **Generate token**. 

{% endnavtab %}
{% navtab System Account Token %}

[Create a system account token](/konnect/org-management/system-accounts/#generate-a-system-account-access-token) through the {{site.konnect_short_name}} API.

{% endnavtab %}
{% endnavtabs %}
{% endif_version %}

{% if_version lte:1.17.x %}

To generate a PAT for a user account in {{site.konnect_short_name}}, select your user icon to open the context menu 
 and click **Personal access tokens**, then click **Generate token**. 

{% endif_version %}

{:.important}
> **Important**: The access token is only displayed once, so make sure you save it securely. 

You can use the `--konnect-token` flag to pass the PAT directly in the command:

```sh
deck ping \
  --konnect-token YOUR_KONNECT_TOKEN
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

## Control planes

Each [state file](/deck/{{page.kong_version}}/terminology/#state-files) targets one control plane.
If you don't provide a control plane, decK targets the `default` control plane.

If you have a custom control plane, you can specify it in the state file,
or use a flag when running any decK command.

{% if_version lte:1.26.x %}
* Target a control plane in your state file with the `_konnect.runtime_group_name` parameter:

    ```yaml
    _format_version: "3.0"
    _konnect:
      runtime_group_name: staging
    ```

* Set a control plane using the `--konnect-runtime-group-name` flag:

    ```sh
    deck sync --konnect-runtime-group-name staging
    ```
{% endif_version %}

{% if_version gte:1.27.x %}
* Target a control plane in your state file with the `_konnect.control_plane_name` parameter:

    ```yaml
    _format_version: "3.0"
    _konnect:
      control_plane_name: staging
    ```

* Set a control plane using the `--konnect-control-plane-name` flag:

    ```sh
    deck sync --konnect-control-plane-name staging
    ```
{% endif_version %}

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

You can now sync the file as-is to apply it to the default control plane or add a key to apply the configuration to a specific control plane.

{% if_version lte:1.26.x %}
To apply the configuration to custom control planes, replace `_workspace` with `control_plane_name: ExampleName`.
{% endif_version %}

{% if_version gte:1.27.x %}
To apply the configuration to custom control planes, replace `_workspace` with `control_plane_name: ExampleName`.
{% endif_version %}

For example, to export the configuration from workspace `staging` to control plane `staging`, you would change:

```yaml
_workspace: staging
```

To:
{% if_version lte:1.26.x %}
```yaml
_konnect:
  runtime_group_name: staging
```
{% endif_version %}

{% if_version gte:1.27.x %}
```yaml
_konnect:
  control_plane_name: staging
```
{% endif_version %}

### ACL, Key Auth, or OpenID Connect plugins and app registration

You may encounter one of the following scenarios with the ACL, Key Authentication, or OpenID Connect (OIDC) plugins:
* The plugins are visible in the Gateway Manager, but don't appear in the output from a `deck dump` or `deck diff`.
* When trying to set up one of the plugins with app registration enabled, you see the following error:

    ```
    {Create} plugin key-auth for service example_service failed: HTTP status 400
    ```

This is intentional. When you have application registration enabled, decK doesn't manage these plugins, and doesn't let you create duplicates of the plugin entries.

When setting up app registration, {{site.konnect_short_name}} enables two plugins automatically: ACL, and either Key Authentication or OIDC, depending on your choice of authentication.
These plugins run in the background to support application registration for an API product.
They are managed entirely by {{site.konnect_short_name}}, so you can't manage these plugins directly.

Read [Manage application registration](/konnect/dev-portal/applications/enable-app-reg) for more information.

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

* [Import {{site.base_gateway}} entities into {{site.konnect_short_name}}](/konnect/getting-started/import/)
* [Manage control planes with decK](/konnect/gateway-manager/control-planes/declarative-config/)
