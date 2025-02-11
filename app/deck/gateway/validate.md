---
title: Validate configuration against the Admin API
---

The `deck gateway validate` command reads one or more declarative state files and ensures validity. It reports YAML/JSON parsing issues, checks for foreign relationships, and alerts if there are broken relationships or missing links present.

This command validates against the Kong API via communication with Kong. This increases the time for validation but catches significant errors. No resource is created in Kong. 

For offline validation, see [deck file validate](/deck/file/validate/).

## Validate specific entities

The `deck gateway validate` command may take a long time to check all entities if you have a large state file.

To reduce this time, you can provide the `--online-entities-list` flag and specify specific entities to validate.
For example:

```bash
deck gateway validata --online-entities-list Plugins kong.yaml
```