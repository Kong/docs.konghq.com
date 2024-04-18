
In DB-less mode, each independent {{site.base_gateway}} node loads a copy of declarative {{site.base_gateway}} 
configuration data into memory without persistent database storage, so failure of some nodes doesn't spread to other nodes.

Deployments in this mode should use the [rolling upgrade](/gateway/{{include.release}}/upgrade/rolling-upgrade/) strategy. 
You could parse the validity of the declarative YAML contents with version Y, using the `deck validate` or the `kong config parse` command.

You must back up your current `kong.yaml` file before starting the upgrade.
