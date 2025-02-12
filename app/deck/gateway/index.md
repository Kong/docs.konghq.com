---
title: Managing Kong Gateway
---

decK can configure a running {{ site.base_gateway }} using the `deck gateway` command.

decK interacts with {{ site.base_gateway }} using the Kong Admin API. 
This means that decK can manage any {{ site.base_gateway }} instance running in hybrid or traditional mode, or in any {{site.konnect_short_name}} deployment. However, it can't manage Gateways running in DB-less mode.

To learn about decK's APIOps capabilities, see [deck file](/deck/file).

decK provides the following `deck gateway` subcommands:

| Command  | Description |
|----------|-------------|
| [ping](/deck/gateway/ping/)     | Verify that decK can talk to the configured Admin API. |
| [validate](/deck/gateway/validate/) | Validate the data in the provided state file against a live Admin API. |
| [diff](/deck/gateway/diff/)     | Diff the current state of {{ site.base_gateway }} against the provided configuration. |
| [sync](/deck/gateway/sync/)     | Update {{ site.base_gateway }} to match the state defined in the provided configuration. |
| [apply](/deck/gateway/apply/)    | Apply configuration to Kong without deleting existing entities. |
| [dump](/deck/gateway/dump/)     | Export the current state of {{ site.base_gateway }} to a file.|
| [reset](/deck/gateway/reset/)   | Delete all entities in {{ site.base_gateway }}. |

All of these commands require access to a running {{ site.base_gateway }} to function. If your Admin API requires a token, see the [configuration](/deck/gateway/configuration/) page.


