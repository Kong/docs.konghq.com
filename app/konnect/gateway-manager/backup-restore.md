---
title: Back Up and Restore Konnect Configuration
content_type: how-to
---

Use [decK](/deck/latest/installation/) to back up and restore 
{{site.konnect_short_name}}'s control plane configuration. 

With `deck dump`, decK generates state files for each control plane, which act 
as snapshots of the control plane's configuration at that point in time.
If a control plane's configuration is ever corrupted, you can then use these snapshots to 
restore your control plane, or bring up another control plane with the same configuration.

Review the list of [entities managed by decK](/deck/latest/reference/entities/) to see what can 
be backed up.

{:.note}
> **Note:** You can't use this method to back up
Dev Portal configuration and objects, such as documents, specs, and applications.
There is currently no automated way to back up Dev Portal content.

## Back up a {{site.konnect_short_name}} control plane

Use `deck dump` to back up your configuration:

```sh
deck dump \
--konnect-token <your-PAT> \
--konnect-control-plane-name <example-name> \
--output-file /path/to/<my-backup.yaml>
```

We recommend using a personal access token to authenticate with the {{site.konnect_short_name}} org. 
You can also choose a [different form of authentication](/deck/latest/guides/konnect).

This command generates a state file for the control plane's entity
configuration, for example:

```yaml
_format_version: "3.0"
_konnect:
    control_plane_name: us-west
consumers:
- username: example-user1
- username: example-user2
services:
- connect_timeout: 60000
    host: httpbin.org
    name: MyService
    tags:
    - _KonnectService:example_service
    ...
```

## Restore a {{site.konnect_short_name}} control plane

You can restore entity configuration for a control plane using a declarative configuration file.
Note that you must do this for one group at a time.

Assuming you have a backup file, for example, `my-backup.yaml`:

Run a diff between your backup file and the control plane in {{site.konnect_short_name}} to 
make sure you're applying the configuration you want:

```sh
deck diff \
--konnect-token <your-PAT> \
--konnect-control-plane-name <example-name> \
--output-file /path/to/<my-backup.yaml>
```

If you're satisfied with the diff result, run `deck sync` to sync your configuration to 
a control plane:

```sh
deck sync \
--konnect-token <your-PAT> \
--konnect-control-plane-name <example-name> \
--output-file /path/to/<my-backup.yaml>
```

Check your control plane in {{site.konnect_short_name}} to make sure the sync worked. 
Open **Gateway Manager**, select your control plane, and check through the configured entities.

## More information
* [Entities managed by decK](/deck/latest/reference/entities/)
* [Using tags to back up a subset of configuration](/deck/latest/guides/backup-restore/#manage-a-subset-of-configuration)