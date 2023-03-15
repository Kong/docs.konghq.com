---
title: Back Up and Restore Konnect Configuration
content_type: how-to
---

You can use decK to back up and restore a subset or the entirety of
{{site.konnect_short_name}}'s runtime group configuration. 

{:.note}
> **Note:** You can't use this method to back up
Dev Portal configuration and objects, such as documents, specs, and applications.
There is currently no automated way to back up Dev Portal content.

## Back up a {{site.konnect_short_name}} runtime group

Use `deck dump` to back up your configuration:

```sh
deck dump \
--konnect-token <your-PAT> \
--konnect-runtime-group-name <group-name> \
--output-file /path/to/<my-backup.yaml>
```

We recommend using a personal access token to authenticate with the {{site.konnect_short_name}} org. 
You can also choose a [different form of authentication](/deck/latest/guides/konnect).

This command generates a state file for the runtime group's entity
configuration, for example:

```yaml
_format_version: "3.0"
_konnect:
    runtime_group_name: us-west
consumers:
- username: DianaPrince
- username: WallyWest
services:
- connect_timeout: 60000
    host: mockbin.org
    name: MyService
    tags:
    - _KonnectService:example_service
    ...
```

## Restore a {{site.konnect_short_name}} runtime group

You can restore entity configuration for a runtime group using a declarative configuration file.
Note that you must do this for one group at a time.

Assuming you have a backup file, for example, `my-backup.yaml`:

Run a diff between your backup file and the runtime group in {{site.konnect_short_name}} to 
make sure you're applying the configuration you want:

```sh
deck diff \
--konnect-token <your-PAT> \
--konnect-runtime-group-name <group-name> \
--output-file /path/to/<my-backup.yaml>
```

If you're satisfied with the diff result, run `deck sync` to sync your configuration to 
a runtime group:

```sh
deck sync \
--konnect-token <your-PAT> \
--konnect-runtime-group-name <group-name> \
--output-file /path/to/<my-backup.yaml>
```

Check your runtime group in {{site.konnect_short_name}} to make sure the sync worked. 
Open **Runtime Manager**, select your runtime group, and check through the configured entities.
