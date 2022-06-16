---
title: Using decK with Kong Konnect
---

You can manage {{site.base_gateway}} core entity configuration in your
{{site.konnect_short_name}} organization using decK.

Similar to Gateway workspaces, decK can only target one runtime group at a
time. Managing multiple runtime groups requires a separate state file per group.

Use any `--konnect`-prefixed CLI flag to target `https://cloud.konghq.com` by
default, or save {{site.konnect_short_name}} credentials to a decK config file.
If you don't pass any {{site.konnect_short_name}} parameters
to decK, decK looks for a local {{site.base_gateway}} instance instead.

You _cannot_ use decK to publish content to the Dev Portal, manage application
registration, or configure custom plugins.

This guide targets the `cloud.konghq.com` environment. For
`konnect.konghq.com`, see [`deck konnect` commands](/deck/1.11.x/reference/deck_konnect/)
 in decK 1.11 or earlier.

## {{site.konnect_short_name}} flags

You can use any regular `deck` commands (such as `ping`, `diff`, or `sync`)
with `--konnect` flags to target {{site.konnect_short_name}}
instead of a self-managed {{site.base_gateway}} control plane.

{:.note}
> Prior to decK 1.12, decK provided `deck konnect` commands. These commands are
deprecated and have been replaced with flags.

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

## Authenticate with {{site.konnect_short_name}}

decK looks for {{site.konnect_short_name}} credentials in the following order
of precedence:

1. Password set with the `--konnect-password` flag
2. decK configuration file (default: `~/.deck.yaml`)
3. File passed with the `--konnect-password-file` flag

For example, if you have both a decK config file and a {{site.konnect_short_name}}
 password file, decK uses the password in the config file.

### Authenticate with CLI flags

There are two ways to authenticate through CLI flags: by passing the password in
`--konnect-password` directly, or by saving it to a file and passing the filename
to decK with `--konnect-password-file`.

With `konnect-password`:

```sh
deck ping \
  --konnect-email YOUR_EMAIL \
  --konnect-password YOUR_PASSWORD
```

Save your {{site.konnect_short_name}} password to a file, then pass the file
using the `--konnect-password-file` flag:

```sh
deck ping \
  --konnect-email YOUR_EMAIL \
  --konnect-password-file /PATH/TO/FILE
```

### Authenticate with a decK config file

The default decK configuration file is `~/.deck.yaml`. You can store {{site.konnect_short_name}}
credentials in this file to pass them more securely. For example:

```
konnect-email: example@email.com
konnect-password: MyPass
```

Alternatively, you can save your password in a separate file, then
specify the password file instead of a password:

```
konnect-email: example@email.com
konnect-password-file: path/to/filename
```

decK automatically uses the credentials in `~/.deck.yaml` in any subsequent
calls:

```
deck ping

Successfully Konnected as MyName (Konnect Org)!
```

## Runtime groups

Target runtime groups in your state file with the `konnect_runtime_group`
parameter:

```yaml
_format_version: "1.1"
_konnect:
  runtime_group_name: staging
```

A state file can only target one runtime group.

If you leave this empty or don't include a `_konnect` section at all, decK
targets the `default` runtime group. You can see this by pushing a simple
config file to {{site.konnect_short_name}} with `deck sync`:

```yaml
_format_version: "1.1"
services:
- name: example_service
  host: mockbin.org
```

Then pull down the configuration with `deck dump` to see the newly added
`_konnect` section:

```yaml
_format_version: "1.1"
_konnect:
  runtime_group_name: default
services:
- name: example_service
  host: mockbin.org
```

## {{site.konnect_short_name}} service tags

In {{site.konnect_short_name}}, there are two types of services:
* Gateway services: Managed through Runtime Manager
* {{site.konnect_short_name}} services: Managed through Service Hub

decK manages Gateway services, which contain configurations for the Gateway
proxy.

Although decK doesn't _directly_ manage {{site.konnect_short_name}} services,
you can use tags to associate a Gateway service to a {{site.konnect_short_name}}
service:

```yaml
tags:
- _KonnectService:example
```
If the {{site.konnect_short_name}} service doesn't exist, setting this tag
creates a {{site.konnect_short_name}} service.

For example, see the following configuration snippet, where the Gateway service
named `MyService` is attached to the {{site.konnect_short_name}} service `example`:

```yaml
_format_version: "1.1"
_konnect:
  runtime_group_name: default
services:
- name: example_service
  host: mockbin.org
  tags:
  - _KonnectService:example
```

If the {{site.konnect_short_name}} service doesn't exist, this configuration
snippet creates a {{site.konnect_short_name}}
service named `example` with a version named `MyService` in the Service Hub.

## Troubleshoot

### Authentication with a {{site.konnect_short_name}} password file is not working

Check that there are no conflicts with settings in the decK config file
(`~/.deck.yaml`) and the {{site.konnect_short_name}} password file. There is
likely an old decK config file conflicting with the password file.

To resolve, remove one of the duplicate sets of credentials.

### Workspace connection refused

When migrating from {{site.base_gateway}} to {{site.konnect_short_name}},
make sure to remove any `_workspace`tags. If you leave `_workspace` in, you
will see the error:

```
Error: checking if workspace exists
```

A file with no workspace or runtime group tags gets synced to the `default`
runtime group.

To apply configuration to custom runtime groups, replace `_workspace`
with `runtime_group_name: GroupName`.

For example, to export the configuration from workspace `staging` to
runtime group `staging`, you would change:

```
_workspace: staging
```

Into:
```
_konnect:
  runtime_group_name: staging
```
