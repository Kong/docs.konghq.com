---
title: Tags
---

Tags are at the core of [federated configuration management](/deck/apiops/federated-configuration/), which allows each team to manage their own config.

Using the `deck file` tag commands, you can add tags to identify configuration lineage automatically without depending on your application teams understanding the process and remembering to apply tags consistently.

## add-tags

The `add-tags` command can add tags to any entity. Here's an example that adds the `team-one` tag to all entities in the provided file:

```bash
deck file add-tags -s /path/to/config.yaml team-one 
```

This is useful to track entity ownership when using the [deck file merge](/deck/file/merge/) command to build a single configuration to sync.

To add tags to specific entities only, provide the `--selector` flag. The provided tags will be added only to entities that match the selector

You can add multiple tags at once by providing them as additional arguments e.g. `team-one another-tag and-another`

## remove-tags

The opposite of `add-tags`, `remove-tags` allows you delete tags from your configuration file. It will remove the provided tag only by default:

```bash
deck file remove-tags -s /path/to/config.yaml tag_to_remove
```

To keep specific tags and remove all others, pass the `--keep-only` flag:

```bash
deck file remove-tags -s /path/to/config.yaml --keep-only env-prod team-one
```

Finally, to remove tags from specific entities you can pass a `--selector`. This can be combined with `--keep-only` as needed:

```bash
deck file remove-tags -s /path/to/config.yaml --selector "$..services[*]" --keep-only env-prod team-one
```

## list-tags

The `list-tags` command outputs all tags found in the file. Any tag that is applied to at least one entity is returned.

```bash
deck file list-tags -s /path/to/config.yaml
```