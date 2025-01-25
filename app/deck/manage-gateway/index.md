---
title: Managing Kong Gateway
---

decK can configure a running {{ site.base_gateway }} using the Admin API using the `deck gateway` command.

To learn about decK's APIOps capabilities, see [deck file](/deck/file).

decK provides the following `deck gateway` subcommands:

| Command  | Description |
|----------|-------------|
| ping     | Verify that decK can talk to the configured Admin API |
| [validate](/deck/manage-gateway/validate/) | Validate the data in the provided state file against a live Admin API |
| [diff]((/deck/manage-gateway/diff/))     | Diff the current state of {{ site.base_gateway }} against the provided configuration |
| [sync](/deck/manage-gateway/sync/)     | Update {{ site.base_gateway }} to match the state defined in the provided configuration |
| [apply]((/deck/manage-gateway/apply/))    | Apply configuration to Kong without deleting existing entities |
| [dump](/deck/manage-gateway/backup/)     | Export the current state of {{ site.base_gateway }} to a file |
| reset    | Delete all entities in {{ site.base_gateway }} |

All of these commands require access to a running {{ site.base_gateway }} to function. If your Admin API requires a token, see the [configuration](/deck/manage-gateway/configuration/) page.


