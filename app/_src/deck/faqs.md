---
title: Frequently Asked Questions (FAQs)
content_type: reference
---

### I use Terraform to configure Kong, why should I care about decK?

If you are using Terraform and are happy with it, you should continue to use it.
decK covers all the problems that Terraform solves and goes beyond it:
- With Terraform, you have to track and maintain Terraform files (`*.tf`) and
  the Terraform state (likely using a cloud storage solution). With decK, the
  entire configuration is stored in the YAML/JSON file(s) only. There is no
  separate state that needs to be tracked.
- decK can export and back up your existing Kong's configuration, meaning,
  you can take an existing Kong installation, and have a backup, as well as a
  declarative configuration for it. With Terraform, you will have to import
  each and every entity in Kong into Terraform's state.
- decK can check if a configuration file is valid or not
  (validate sub-command).
- decK can quickly reset your Kong's configuration when needed.
- decK works out of the box with {{site.base_gateway}} features like
  Workspaces and RBAC.

### Can I run multiple decK processes at the same time?

NO! Please do not do this. The two processes will step on each other and
might corrupt Kong's configuration. You should ensure that there is only
one instance of decK running at any point in time.

### Kong already has built-in declarative configuration, do I still need decK?

Kong has an official declarative configuration format.

Kong can generate such a file with the `kong config db_export` command, which
dumps almost the entire database of Kong into a file.

You can use a file in this format to configure Kong when it is running in
a DB-less or in-memory mode. If you're using Kong in DB-less mode, you can't
use decK for any sync, dump, or similar operations, as they require write 
access to the Admin API.

If you are using Kong alongside a database, you need decK because:

- Kong's `kong config db_import` command is used to initialize a Kong database,
  but it is not recommended to use it if there are existing Kong nodes that
  are running, as the cache in these nodes will not be invalidated when entities
  are changed/added. You will need to manually restart all existing Kong nodes.
  decK performs all the changes via Kong's Admin API,
  meaning the changes are always propagated to all nodes.
- Kong's `kong config db_import` can only add and update entities in the
  database. It will not remove the entities that are present in the database but
  are not present in the configuration file.
- Kong's `kong config db_import` command needs direct access to Kong's
  database, which might or might not be possible in your production
  networking environment.
- decK can easily perform detect drifts in configuration. For example, it can
  verify if the configuration stored inside Kong's database and that inside
  the config file is the same. This feature is designed in decK to integrate decK
  with a CI system or a `cronjob` which periodically checks for drifts and alerts
  a team if needed.
- `decK dump` outputs a more human-readable configuration file compared
  to Kong's `db_import`.

However, decK has the following limitations which might or might not affect
your use case:

- If you have a very large installation, it can take some time for decK to
  sync up the configuration to Kong. This can be mitigated by adopting
  [distributed configuration](/deck/{{page.release}}/guides/distributed-configuration/) for your
  Kong installation and tweaking the `--parallelism` value.
  Kong's `db_import` will usually be faster by orders of magnitude.
- decK cannot export and re-import fields that are hashed in the database.
  This means fields like `password` of `basic-auth` credential cannot be
  correctly re-imported by decK. This happens because Kong's Admin API call
  to sync the configuration will re-hash the already hashed password.

### I'm a {{site.base_gateway}} customer, can I use decK?

Of course, decK is designed to be compatible with open-source and enterprise
versions of Kong.

### I'm a {{site.konnect_short_name}} user, can I use decK?

Yes, decK is compatible with {{site.konnect_short_name}}. We recommend
upgrading to decK 1.12 to take advantage of the new `--konnect` CLI flags.

### I use Cassandra as a data store for Kong, can I use decK?

As of {{site.base_gateway}} 3.4, you can't use Cassandra as a data store, 
as it is longer supported by Kong.

You can use decK with earlier versions of Kong backed by Cassandra.
However, if you observe errors during a sync process, you will have to
tweak decK's settings and make a few adjustments.

decK heavily parallelizes its operations, which can induce a lot of load
onto your Cassandra cluster.
You should consider:
- decK is read-intensive for most parts, meaning it will perform
  read-intensive queries on your Cassandra cluster, so make sure you tune
  your Cassandra cluster accordingly.
- decK talks to the same Kong node that talks to the same Cassandra node in your
  cluster.
- Use the `--parallelism 1` flag to ensure that there is only request being
  processed at a time. This will slow down sync process and should be used
  as a last resort.

### Why the name 'decK'?

It is simple, short, and easy to use in the terminal.
It is derived from the combination of words 'declarative' and 'Kong'.



### Is there a JSON Schema for decK? 

Yes. The decK team maintains a JSON schema that you can use to validate YAML files on [Github](https://github.com/Kong/go-database-reconciler/blob/main/pkg/file/kong_json_schema.json). You can use the schema with a text editor to provide JIT YAML validation. For example, to use the JSON schema with VS Code: 

1. Install the Red Hat YAML extension:
```console
code --install-extension redhat.vscode-yaml
```

1. Edit the plugin settings in VS Code:
```json
 "yaml.schemas": {
        "https://json.schemastore.org/kong_json_schema.json": [
            "kong.yml",
            "kong.yaml"
        ]
}
```

1. Verify that it works by opening your existing `kong.yml` or `kong.yaml` file. 
